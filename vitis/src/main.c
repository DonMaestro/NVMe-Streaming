/*
NVMe SSD Test Application Main
*/
#include "platform.h"
#include "pcie.h"
#include "dma.h"
#include "nvme.h"
#include "ff.h"
#include "diskio.h"
#include "xtime_l.h"
#include "xil_printf.h"
#include "xil_cache.h"
//#include "xgpiops.h"
//#include "xuartps.h"
#include "sleep.h"
#include <stdio.h>

#define SHOW_ONESEC_PROGRESS
#define DMA_BLOCKS      64

// Test Configuration
#define TRIM_FIRST          0           // 0: Don't TRIM, 1: TRIM before test
#define TRIM_DELAY          10          // Extra wait time after TRIM in [min]. 0 = Wait for keypress.
#define USE_FS              1           // 0: Raw Disk Test, 1: File System Test
#define TEST_READ           1           // 0: Write, 1: Read (Raw Disk Test Only)
#define TOTAL_WRITE         200         // Total write size in [GB].
#define TARGET_WRITE_RATE   4000        // Target write speed in [MB/s].
#define TOTAL_READ          200         // Total read size in [GB]. (Raw Disk Test Only)
#define TARGET_READ_RATE    4000        // Target read speed in [MB/s]. (Raw Disk Test Only)
#define BLOCK_SIZE          (1 << 18)   // Block size in [B] as a power of 2.
#define BLOCKS_PER_FILE     (1 << 14)   // Blocks written per file in FS mode. (File System Test Only)
#define FS_AU_SIZE          (1 << 18)   // File system AU size in [B] as a power of 2. (File System Test Only)
#define NVME_SLIP_ALLOWED   16          // Amount of NVMe commands allowed to be in flight.

void trimWait(u32 waitMin);
void diskWriteTest();
void timeWriteTest();
void diskReadTest();
void fsWriteTest();

// Large data buffer in RAM for write source and read destination.
u8 *data = (u8 *) 0xA0000000;


int main()
{
	XAxiDma AxiDma;

	int Status;
    // Init
	init_platform();
    Xil_DCacheDisable();
    xil_printf("NVMe SSD test application started.\r\n");
    xil_printf("Initializing PCIe and NVMe driver...\r\n");

    XTime tStart, tNow;
    XTime_StartTimer();

    for (register int i = 0; i < BLOCK_SIZE; i++) {
    	data[i] = 0;
    }

    XTime_GetTime(&tStart);
    // Wait 100ms then initialize PCIe.
    usleep(100000);
    pcieInit();
    usleep(10000);

    XTime_GetTime(&tNow);
    xil_printf("Time %ld %ld %ld\r\n", tStart, tNow, (tNow - tStart) / COUNTS_PER_SECOND);

    // Start NVMe Driver
	char strResult[128];
	Status = nvmeInit();
    if (Status == NVME_OK)
    {
    	xil_printf("NVMe initialization successful. PCIe link is Gen3 x4.\r\n");
    }
    else
    {
    	sprintf(strResult, "NVMe driver failed to initialize. Error Code: %8x\r\n", Status);
    	xil_printf(strResult);
    	if(Status == NVME_ERROR_PHY) {
   			xil_printf("PCIe link must be Gen3 x4 for this example.\r\n");
   		}
   		return 0;
   	}

	Status = AxiDMAInit(DMA_DEV_ID, &AxiDma);

    usleep(10000);
//    goto deinit;

    // TRIM if indicated.
    if (TRIM_FIRST)
    {
    	trimWait(TRIM_DELAY);
    }

    // Select and run test.
    if (USE_FS)
    {
    	fsWriteTest();
    }
    else if (TEST_READ)
    {
    	diskReadTest();
    }
    else
    {
    	//timeWriteTest(32);
    	diskWriteTest();
    	diskReadTest();
    }

    // Deinit
//deinit:

    dmaDeinit();
    pcieDeinit();
    xil_printf("NVMe SSD test application finished.\r\n");
    cleanup_platform();
    return 0;
}

// TRIM and Wait for Garbage Collection
void trimWait(u32 trimDelay)
{
	char strWorking[128];

	xil_printf("Deallocating SSD (TRIM)...\r\n");
	u32 nLBATrimmed = 0;
	u32 nLBAToTrim = nvmeGetLBACount();	// Trim the entire drive...
	u32 nLBAPerTrim = (1 << 17);		// ...in these increments.

	XTime tStart, tNow;
	u32 sElapsed = 0;
	float progress = 0.0f;

	XTime_GetTime(&tStart);

	// TRIM loop.
	while(nLBATrimmed < nLBAToTrim)
	{
		if((nLBAToTrim - nLBATrimmed) >= nLBAPerTrim)
		{
			nvmeTrim(nLBATrimmed, nLBAPerTrim);
			while(nvmeGetIOSlip() > 0)
			{ nvmeServiceIOCompletions(16); }
			nLBATrimmed += nLBAPerTrim;
		}
		else
		{
			// Finishing pass, if nLBAToTrim is not a multiple of nLBAPerTrim.
			nvmeTrim(nLBATrimmed, (nLBAToTrim - nLBATrimmed));
			while(nvmeGetIOSlip() > 0)
			{ nvmeServiceIOCompletions(16); }
			nLBATrimmed = nLBAToTrim;
		}

		// 1Hz progress update.
		XTime_GetTime(&tNow);
		if((tNow - tStart) / COUNTS_PER_SECOND > sElapsed)
		{
			sElapsed = (tNow - tStart) / COUNTS_PER_SECOND;

			progress = (float)nLBATrimmed / (float)nLBAToTrim * 100.0f;

			sprintf(strWorking, "TRIM Progress: %3.0f percent...\r\n", progress);
			xil_printf(strWorking);
		}
	}

	xil_printf("Finished deallocating SSD.\r\n");
/*
	if(trimDelay == 0)
	{
		xil_printf("Enter S to start test...\r\n");
		do
		{
			while(!XUartPs_IsReceiveData(XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID)->BaseAddress));
		} while (XUartPs_RecvByte(XUartPs_LookupConfig(XPAR_XUARTPS_0_DEVICE_ID)->BaseAddress) != 'S');
	}
*/
	while(trimDelay)
	{
		sprintf(strWorking, "Waiting after TRIM, %ld minutes remaining...\r\n", trimDelay);
		xil_printf(strWorking);

		trimDelay--;
		usleep(60000000);
	}
}

// Raw Disk Write Test
// __attribute__((optimize("Os")))
void diskWriteTest()
{
	char strWorking[128];

	xil_printf("Raw disk write test started.\r\n");

	// Setup for write test.
	u64 bytesToWrite = (u64)TOTAL_WRITE * 1073741824ULL;
	u32 blocksToWrite = bytesToWrite / BLOCK_SIZE;
	u32 blocksWritten = 0;
	u32 blocksWrittenPrev = 0;
	u32 blocksWrittenPrevSync = 0;
	u32 lbaPerBlock = BLOCK_SIZE / 512;
	u32 lbaDest = 0;
	u64 countsPerBlock = (u64)BLOCK_SIZE * (u64)COUNTS_PER_SECOND / (u64)(TARGET_WRITE_RATE * 1000000ULL);

	XTime tStart_test, tNow_test;
	XTime tStart, tPrev, tNow;
	u32 sElapsed = 0;
	float rate = 0.0f;
	float totalWrittenGB = 0.0f;
	int status;

	int localtail;
	int complete;
	struct dmaiovec comvec;

#ifdef SHOW_ONESEC_PROGRESS
	xil_printf("Time [s], Rate [MB/s], Total [GB]\r\n");
#endif

	if (nvmeGetIOSQTail() != 0)
		xil_printf("ERROR: tail not set 0\r\n");
	if (DMA_MAX_DATA_SIZE > DMA_BLOCKS * BLOCK_SIZE)
		xil_printf("ERROR: iov_len small\r\n");
	localtail = 0;
	register struct dmaiovec newvec;
	newvec.iov_base = data + localtail * BLOCK_SIZE;
	newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
	AxiDMASetNext(newvec);
	AxiDMAStart();

	while(!AxiDMAGetComplete());
	AxiDMARstComplete();
	complete = 0;

	localtail = (localtail + DMA_BLOCKS) & nvmeGetIOSQSize();
	newvec.iov_base = data + localtail * BLOCK_SIZE;
	newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
	comvec = AxiDMASetNext(newvec);
	AxiDMAStart();

	XTime_GetTime(&tStart);
	tPrev = tStart;
	tStart_test = tStart;

	// Block writing loop.
	while(blocksWritten < blocksToWrite)
	{
		// Target data rate limiter.
		XTime_GetTime(&tNow);
		do { XTime_GetTime(&tNow); }
		while (tNow - tPrev < countsPerBlock);
		tPrev = tNow;

		// 1Hz progress update.
#ifdef SHOW_ONESEC_PROGRESS
		if((tNow - tStart) / (COUNTS_PER_SECOND) > sElapsed)
		{
			sElapsed = (tNow - tStart) / (COUNTS_PER_SECOND);

			rate = (float)((blocksWritten - blocksWrittenPrev) * BLOCK_SIZE) * 1e-6f;
			blocksWrittenPrev = blocksWritten;

			totalWrittenGB = (float)((u64)blocksWritten * (u64)BLOCK_SIZE) * 1e-9f;

			sprintf(strWorking, "%8ld,%12.3f,%11.3f\r\n", sElapsed, rate, totalWrittenGB);
			xil_printf(strWorking);
		}
#endif

		// Add marker to data.
		//*(u32 *) data = blocksWritten;
		if (AxiDMAGetComplete() && complete) {
			AxiDMARstComplete();
			complete = 0;

			localtail = (localtail + DMA_BLOCKS) & nvmeGetIOSQSize();
			register struct dmaiovec newvec;
			newvec.iov_base = data + localtail * BLOCK_SIZE;
			newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
			comvec = AxiDMASetNext(newvec);
			AxiDMAStart();
		}

		if (nvmeGetIOSQTail() != localtail) {
			while (nvmeGetIOSQE()) {
				nvmeServiceIOCompletions(nvmeGetIOSQSize());
			}

			// Write block.
			status = nvmeWriteAsync((const u8 *)comvec.iov_base
							+ (nvmeGetIOSQTail() & (DMA_BLOCKS - 1)) * BLOCK_SIZE,
							(u64) lbaDest, lbaPerBlock);
//			status = nvmeWrite(data, (u64) lbaDest, lbaPerBlock);
			if (!status) {
				blocksWritten++;
				lbaDest += lbaPerBlock;
			}/* else {
				xil_printf("ERROR: %li\r\n", status);
			}*/
		} else
			complete = 1;

		//if ((blocksWritten - blocksWrittenPrevSync) > 15 || ((tNow - tStart) >> 20)) {
		if ((blocksWritten - blocksWrittenPrevSync) > DMA_BLOCKS / 2 - 1) {
			nvmeSubmitSync();
			blocksWrittenPrevSync = blocksWritten;
		}

		if (nvmeGetIOSlip() > DMA_BLOCKS / 4 - 1) {
			//xil_printf("Complit %d\r\n", nvmeServiceIOCompletions(16));
			nvmeServiceIOCompletions(nvmeGetIOSQSize());
		}

	}
	XTime_GetTime(&tNow_test);
	AxiDMAStop();

	while (nvmeGetIOSlip()) {
		nvmeServiceIOCompletions(nvmeGetIOSQSize());
	}

	xil_printf("Raw disk write test finished.\r\n");
	xil_printf("Total write %ld [GB].\r\n", TOTAL_WRITE);
	xil_printf("Time %ld [ms].\r\n", (tNow_test - tStart_test) / (COUNTS_PER_SECOND / 1000));
}

void timeWriteTest(unsigned int inum)
{

	xil_printf("Raw disk write test started.\r\n");

	int i;
	// Setup for write test.
	u32 blocksWritten = 0;
	u32 lbaPerBlock = BLOCK_SIZE / 512;
	u32 lbaDest = 0;

	XTime tp1, tp2;

	XTime_GetTime(&tp1);

	// Block writing loop.
	// Target data rate limiter.
	// Add marker to data.
	*(u32 *) data = blocksWritten;

	// Write block.
	i = 0;
	XTime_GetTime(&tp1);
	while (i < inum) {
		if (!nvmeWriteAsync(data, (u64) lbaDest, lbaPerBlock)) {
			i++;
			blocksWritten++;
			lbaDest += lbaPerBlock;
		} else {
			xil_printf("The queue is too short\r\n");
			while (nvmeGetIOSlip()) {
 				nvmeServiceIOCompletions(inum);
			}
			break;
		}
	}

	XTime_GetTime(&tp2);
	xil_printf("Write 32 instruction %d points\r\n", (tp2 - tp1));
	i = 0;
	nvmeSubmitSync();
	XTime_GetTime(&tp1);
	while (1) {
		i += nvmeServiceIOCompletions(32);
		if (!nvmeGetIOSlip())
			break;
	}
	XTime_GetTime(&tp2);
	xil_printf("32 instructions completed %d\r\n", (tp2 - tp1));
}

// Raw Disk Read Test
void diskReadTest()
{
	char strWorking[128];

	xil_printf("Raw disk I/O read test started.\r\n");

	// Setup for read test.
	u64 bytesToRead = (u64)TOTAL_READ * 1073741824ULL;
	u32 blocksToRead = bytesToRead / BLOCK_SIZE;
	u32 blocksRead = 0;
	u32 blocksReadPrev = 0;
	u32 lbaPerBlock = BLOCK_SIZE / 512;
	u32 lbaSrc = 0;
	u64 countsPerBlock = (u64)BLOCK_SIZE * (u64)COUNTS_PER_SECOND / (u64)(TARGET_READ_RATE * 1000000ULL);

	XTime tStart_test, tNow_test;
	XTime tStart, tPrev, tNow;
	u32 sElapsed = 0;
	float rate = 0.0f;
	float totalReadGB = 0.0f;

#ifdef SHOW_ONESEC_PROGRESS
	xil_printf("Time [s], Rate [MB/s], Total [GB]\r\n");
#endif

	XTime_GetTime(&tStart);
	tPrev = tStart;
	tStart_test = tStart;

	// Block reading loop.
	while(blocksRead < blocksToRead)
	{
		// Target data rate limiter.
		do { XTime_GetTime(&tNow); }
		while (tNow - tPrev < countsPerBlock);
		tPrev = tNow;

#ifdef SHOW_ONESEC_PROGRESS
		// 1Hz progress update.
		if((tNow - tStart) / COUNTS_PER_SECOND > sElapsed)
		{
			sElapsed = (tNow - tStart) / COUNTS_PER_SECOND;

			rate = (float)((blocksRead - blocksReadPrev) * BLOCK_SIZE) * 1e-6f;
			blocksReadPrev = blocksRead;

			totalReadGB = (float)((u64)blocksRead * (u64)BLOCK_SIZE) * 1e-9f;

			sprintf(strWorking, "%8ld,%12.3f,%11.3f\r\n", sElapsed, rate, totalReadGB);
			xil_printf(strWorking);
		}
#endif

		// Read block.
		nvmeRead(data, (u64) lbaSrc, lbaPerBlock);
		while(nvmeGetIOSlip() > NVME_SLIP_ALLOWED)
		{ nvmeServiceIOCompletions(16); }
		blocksRead++;
		lbaSrc += lbaPerBlock;
	}
	XTime_GetTime(&tNow_test);

	xil_printf("Raw disk I/O read test finished.\r\n");
	xil_printf("Total write %ld [GB].\r\n", TOTAL_WRITE);
	xil_printf("Time %ld [ms].\r\n", (tNow_test - tStart_test) / (COUNTS_PER_SECOND / 1000));
}

// File System Write Test
void fsWriteTest()
{
	char strWorking[128];
	//char *strWorking = (char *)0xa0001000;

	// Set up the file system and format the drive.
	FATFS fs;
	FIL fil;
	FRESULT res;
	UINT bw;
	BYTE work[FF_MAX_SS];

	MKFS_PARM opt;
	opt.fmt = FM_EXFAT;
	opt.au_size = FS_AU_SIZE;
	opt.align = 1;
	opt.n_fat = 1;
	opt.n_root = 512;

	xil_printf("File system write test started.\r\n");
	xil_printf("Formatting disk...\r\n");

	//res = f_mkfs("", &opt, work, sizeof work);
	res = f_mkfs("", &opt, work, FF_MAX_SS);
	if(res)
	{
		xil_printf("Failed to create file system on disk.\r\n");
		return;
	}

	// Mount the drive.
	res = f_mount(&fs, "", 0);
	if(res)
	{
		xil_printf("Failed to mount disk.\r\n");
		return;
	}
	xil_printf("Disk formatted and mounted successfully.\r\n");

	// Create first file.
	u32 nFile = 0;
	sprintf(strWorking, "f%06ld.bin\n", nFile);
	res = f_open(&fil, strWorking, FA_CREATE_NEW | FA_WRITE);
	if (FR_OK != res) {
		xil_printf("ERROR: cannot open file. %d\r\n",fil);
		goto unmount;
	}

	// Setup for write test.
	u64 bytesToWrite = (u64)TOTAL_WRITE * 1073741824ULL;
	u32 blocksToWrite = bytesToWrite / BLOCK_SIZE;
	u32 blocksWritten = 0;
	u32 blocksWrittenPrev = 0;
	u32 lbaPerBlock = BLOCK_SIZE / 512;
	u32 lbaDest = 0;
	u64 countsPerBlock = (u64)BLOCK_SIZE * (u64)COUNTS_PER_SECOND / (u64)(TARGET_WRITE_RATE * 1000000ULL);

	XTime tStart_test, tNow_test;
	XTime tStart, tPrev, tNow;
	u32 sElapsed = 0;
	float rate = 0.0f;
	float totalWrittenGB = 0.0f;

	int localtail;
	int complete;
	struct dmaiovec comvec;

#ifdef SHOW_ONESEC_PROGRESS
	xil_printf("Time [s], Rate [MB/s], Total [GB]\r\n");
#endif

	if (DMA_MAX_DATA_SIZE > DMA_BLOCKS * BLOCK_SIZE)
		xil_printf("ERROR: iov_len small\r\n");
	localtail = nvmeGetIOSQTail() & ~(DMA_BLOCKS - 1);
	register struct dmaiovec newvec;
	newvec.iov_base = data + localtail * BLOCK_SIZE;
	newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
	AxiDMASetNext(newvec);
	AxiDMAStart();

	while(!AxiDMAGetComplete());
	AxiDMARstComplete();
	complete = 0;

	localtail = (localtail + DMA_BLOCKS) & nvmeGetIOSQSize();
	newvec.iov_base = data + localtail * BLOCK_SIZE;
	newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
	comvec = AxiDMASetNext(newvec);
	AxiDMAStart();


	XTime_GetTime(&tStart);
	tPrev = tStart;
	tStart_test = tStart;


	// Block writing loop.
	while(blocksWritten < blocksToWrite)
	{
		// Target data rate limiter.
		do { XTime_GetTime(&tNow); }
		while (tNow - tPrev < countsPerBlock);
		tPrev = tNow;

#ifdef SHOW_ONESEC_PROGRESS
		// 1Hz progress update.
		if((tNow - tStart) / COUNTS_PER_SECOND > sElapsed)
		{
			sElapsed = (tNow - tStart) / COUNTS_PER_SECOND;

			rate = (float)((blocksWritten - blocksWrittenPrev) * BLOCK_SIZE) * 1e-6f;
			blocksWrittenPrev = blocksWritten;

			totalWrittenGB = (float)((u64)blocksWritten * (u64)BLOCK_SIZE) * 1e-9f;

			sprintf(strWorking, "%8ld,%12.3f,%11.3f\r\n", sElapsed, rate, totalWrittenGB);
			xil_printf(strWorking);
		}
#endif

		// Add marker to data.
		//*(u32 *) data = blocksWritten;
		if (AxiDMAGetComplete() && complete) {
			AxiDMARstComplete();
			complete = 0;

			localtail = (localtail + DMA_BLOCKS) & nvmeGetIOSQSize();
			register struct dmaiovec newvec;
			newvec.iov_base = data + localtail * BLOCK_SIZE;
			newvec.iov_len = DMA_BLOCKS * BLOCK_SIZE;
			comvec = AxiDMASetNext(newvec);
			AxiDMAStart();
		}

		if (nvmeGetIOSQTail() != localtail) {
			// Write block.
			res = f_write(&fil, (const u8 *)comvec.iov_base
					+ (nvmeGetIOSQTail() & (DMA_BLOCKS - 1)) * BLOCK_SIZE, BLOCK_SIZE, &bw);
			blocksWritten++;
			lbaDest += lbaPerBlock;
		} else
			complete = 1;

		// Create new files as-needed.
		if((blocksWritten % BLOCKS_PER_FILE) == 0)
		{
			f_close(&fil);
			nFile++;
			sprintf(strWorking, "f%06ld.bin\n", nFile);
			res = f_open(&fil, strWorking, FA_CREATE_NEW | FA_WRITE);
			if (FR_OK != res) {
				xil_printf("ERROR: cannot open file. %d\r\n",fil);
				goto unmount;
			}
		}
	}

	// Clean up file system.
	f_close(&fil);
unmount:
	XTime_GetTime(&tNow_test);
	f_mount(0, "", 0);

	xil_printf("File system write test finished.\r\n");
	xil_printf("Total write %ld [GB].\r\n", TOTAL_WRITE);
	xil_printf("Time %ld [ms].\r\n", (tNow_test - tStart_test) / (COUNTS_PER_SECOND / 1000));
}
