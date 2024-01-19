/***************************** Include Files *********************************/
#include "dma.h"
#include "xil_exception.h"
#include "xil_util.h"
#include "xparameters.h"


/************************** Constant Definitions *****************************/

/*
 * Device hardware build related constants.
 */

#define __intr __attribute__((optimize("Os")))

#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
#else
 #include "xscugic.h"
#endif


#ifdef XPAR_INTC_0_DEVICE_ID
 #define INTC		XIntc
 #define INTC_HANDLER	XIntc_InterruptHandler
#else
 #define INTC		XScuGic
 #define INTC_HANDLER	XScuGic_InterruptHandler
#endif


#ifdef XPAR_INTC_0_DEVICE_ID
#define RX_INTR_ID		XPAR_INTC_0_AXIDMA_0_S2MM_INTROUT_VEC_ID
#define TX_INTR_ID		XPAR_INTC_0_AXIDMA_0_MM2S_INTROUT_VEC_ID
#else
#define RX_INTR_ID		XPAR_FABRIC_AXIDMA_0_S2MM_INTROUT_VEC_ID
#define TX_INTR_ID		XPAR_FABRIC_AXIDMA_0_MM2S_INTROUT_VEC_ID
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_INTC_0_DEVICE_ID
#else
#define INTC_DEVICE_ID          XPAR_SCUGIC_SINGLE_DEVICE_ID
#endif


#define TEST_START_VALUE	0xC
/*
 * Buffer and Buffer Descriptor related constant definition
 */
#define MAX_PKT_LEN		0x100

#define POLL_TIMEOUT_COUNTER    1000000U
#define NUMBER_OF_EVENTS	1


/************************** Function Prototypes ******************************/

static int SetupIntrSystem(INTC * IntcInstancePtr,
				XAxiDma * AxiDmaPtr, u16 TxIntrId, void *TxIntrHandler, u16 RxIntrId, void *RxIntrHandler);
static void TxIntrHandler(void *Callback);
static void RxIntrHandler(void *Callback);

/************************** Variable Definitions *****************************/

/*
 * Flags interrupt handlers use to notify the application context the events.
 */
static XAxiDma *PriAxiDma;
static volatile u32 status;
static struct dmaiovec nextbuf, workbuf;

static u32 conf_start;
static u32 rxoffset;

static volatile u32 TxDone;
static volatile u32 Error;

/*
 * Device instance definitions
 */
static INTC Intc;	/* Instance of the Interrupt Controller */

/*****************************************************************************/
/**
* This function performance a reset of the DMA device and checks the device is
* coming out of reset or not.
*
* @param	DeviceId is the DMA device id.
*
* @return
*		- XST_SUCCESS if channel reset is successful
*		- XST_FAILURE if channel reset fails.
*
* @note		None.
*
******************************************************************************/
int AxiDMAInit(u16 DeviceId, XAxiDma *AxiDma)
{
	XAxiDma_Config *CfgPtr;
	int Status = XST_SUCCESS;

	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Set up Interrupt system
	Status = SetupIntrSystem(&Intc, AxiDma, TX_INTR_ID, &TxIntrHandler, RX_INTR_ID, &RxIntrHandler);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed intr setup\r\n");
		return XST_FAILURE;
	}

	//Disable all interrupts before setup

	XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);

	XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK,
				XAXIDMA_DEVICE_TO_DMA);

	// Enable all interrupts
	XAxiDma_IntrEnable(AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DMA_TO_DEVICE);


	XAxiDma_IntrEnable(AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DEVICE_TO_DMA);

	//Initialize flags before start transfer test
	TxDone = 0;
	Error = 0;

	conf_start = 0;
	status = 0;
	PriAxiDma = AxiDma;

	return Status;
}

/*****************************************************************************/
/**
*
* This function disables the interrupts for DMA engine.
*
* @param	IntcInstancePtr is the pointer to the INTC component instance
* @param	TxIntrId is interrupt ID associated w/ DMA TX channel
* @param	RxIntrId is interrupt ID associated w/ DMA RX channel
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
//void dmaDeinit(INTC * IntcInstancePtr,
//					u16 TxIntrId, u16 RxIntrId)
void dmaDeinit(void)
{
//	TX_INTR_ID
//	RX_INTR_ID
#ifdef XPAR_INTC_0_DEVICE_ID
	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(&Intc, TX_INTR_ID);
	XIntc_Disconnect(&Intc, RX_INTR_ID);
#else
	XScuGic_Disconnect(&Intc, TX_INTR_ID);
	XScuGic_Disconnect(&Intc, RX_INTR_ID);
#endif
}


int AxiDMAStart(void)
{
	if ((status & DMA_STATUS_NEXTBUF_MASK) && (status & DMA_STATUS_RUN_MASK))
		return -1;

	conf_start = 1;

	status = status | DMA_STATUS_RUN_MASK;
	status = status & ~DMA_STATUS_NEXTBUF_MASK;

	workbuf.iov_base = nextbuf.iov_base;
	workbuf.iov_len = nextbuf.iov_len;

	rxoffset = DMA_MAX_DATA_SIZE > workbuf.iov_len ? workbuf.iov_len : DMA_MAX_DATA_SIZE;

	if (XAxiDma_SimpleTransfer(PriAxiDma, (UINTPTR)workbuf.iov_base, rxoffset, XAXIDMA_DEVICE_TO_DMA) != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return 0;
}


void AxiDMAStop(void)
{
	conf_start = 0;
	while(status & DMA_STATUS_RUN_MASK);
}


u32 AxiDMAGetStatus(void)
{
	return status;
}


int AxiDMAGetComplete(void)
{
	return status & DMA_STATUS_COMPLETE_MASK;
}


int AxiDMAGetRun(void)
{
	return status & DMA_STATUS_RUN_MASK;
}


int AxiDMAGetError(void)
{
	return status & DMA_STATUS_RX_ERROR_MASK;
}


struct dmaiovec AxiDMASetNext(struct dmaiovec newbuf)
{
	struct dmaiovec compbuf;
	compbuf.iov_base = nextbuf.iov_base;
	compbuf.iov_len = nextbuf.iov_len;
	nextbuf.iov_base = newbuf.iov_base;
	nextbuf.iov_len = newbuf.iov_len;

	status = status | DMA_STATUS_NEXTBUF_MASK;
	return compbuf;
}


void AxiDMARstComplete(void)
{
	status = status & ~DMA_STATUS_COMPLETE_MASK;
}


void AxiDMARstError(void)
{
	status = status & ~DMA_STATUS_RX_ERROR_MASK;
}

/* Private */

/*****************************************************************************/
/*
*
* This function setups the interrupt system so interrupts can occur for the
* DMA, it assumes INTC component exists in the hardware system.
*
* @param	IntcInstancePtr is a pointer to the instance of the INTC.
* @param	AxiDmaPtr is a pointer to the instance of the DMA engine
* @param	TxIntrId is the TX channel Interrupt ID.
* @param	RxIntrId is the RX channel Interrupt ID.
*
* @return
*		- XST_SUCCESS if successful,
*		- XST_FAILURE.if not successful
*
* @note		None.
*
******************************************************************************/
static int SetupIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 TxIntrId, void *TxIntrHandler, u16 RxIntrId, void *RxIntrHandler)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

	/* Initialize the interrupt controller and connect the ISRs */
	Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed init intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, TxIntrId,
			       (XInterruptHandler) TxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed tx connect intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
			       (XInterruptHandler) RxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed rx connect intc\r\n");
		return XST_FAILURE;
	}

	/* Start the interrupt controller */
	Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed to start intc\r\n");
		return XST_FAILURE;
	}

	XIntc_Enable(IntcInstancePtr, TxIntrId);
	XIntc_Enable(IntcInstancePtr, RxIntrId);

#else

	XScuGic_Config *IntcConfig;


	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
					IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,
				(Xil_InterruptHandler)TxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(IntcInstancePtr, TxIntrId);
	XScuGic_Enable(IntcInstancePtr, RxIntrId);


#endif

	/* Enable interrupts from the hardware */

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)INTC_HANDLER,
			(void *)IntcInstancePtr);

	Xil_ExceptionEnable();

	return XST_SUCCESS;
}


/*****************************************************************************/
/*
*
* This is the DMA TX Interrupt handler function.
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* is present, then sets the TxDone.flag
*
* @param	Callback is a pointer to TX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void __intr TxIntrHandler(void *Callback)
{

	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);

	/* Acknowledge pending interrupts */

	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);

	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {

		return;
	}

	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {

		//Error = 1;
		xil_printf("ERROR: RxIntrHandler\r\n");

		/*
		 * Reset should never fail for transmit channel
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if (XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If Completion interrupt is asserted, then set the TxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
		xil_printf("Successfully XAXIDMA_DMA_TO_DEVICE TxIntrHandler\r\n");
		//TxDone = 1;
	}
}

/*****************************************************************************/
/*
*
* This is the DMA RX interrupt handler function
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* is present, then it resets the DMA_STATUS_COMPLETE flag.
*
* @param	Callback is a pointer to RX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void __intr RxIntrHandler(void *Callback)
{
	u32 Status;
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);

	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}

	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {
		xil_printf("ERROR: RxIntrHandler\r\n");
		status = status | DMA_STATUS_RX_ERROR_MASK;

		/* Reset could fail and hang
		 * NEED a way to handle this or do not call it??
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If completion interrupt is asserted
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {

		if (rxoffset >= workbuf.iov_len) {
			rxoffset = 0;
			status = status | DMA_STATUS_COMPLETE_MASK;

			if (!conf_start) {
				status = status & ~DMA_STATUS_RUN_MASK;
				return;
			}

			if (!(status & DMA_STATUS_NEXTBUF_MASK)) {
				status = status & ~DMA_STATUS_RUN_MASK;
				return;
			}

			status = status & ~DMA_STATUS_NEXTBUF_MASK;
			workbuf.iov_base = nextbuf.iov_base;
			workbuf.iov_len = nextbuf.iov_len;
		}

		register size_t len = DMA_MAX_DATA_SIZE > workbuf.iov_len - rxoffset
							? workbuf.iov_len - rxoffset : DMA_MAX_DATA_SIZE;
		Status = XAxiDma_SimpleTransfer(AxiDmaInst, (UINTPTR)workbuf.iov_base + rxoffset, len, XAXIDMA_DEVICE_TO_DMA); //XAXIDMA_DEVICE_TO_DMA
		if (Status != XST_SUCCESS) {
			status = status | DMA_STATUS_RX_ERROR_MASK;
		}
		rxoffset += len;
	}
}

