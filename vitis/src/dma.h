
#ifndef _DMA_DEFINED
#define _DMA_DEFINED

#include "stdint.h"
#include "xaxidma.h"

#define DMA_DEV_ID		    XPAR_AXIDMA_0_DEVICE_ID
#define DMA_WIDTH_DATA      0x10                           // Bytes
#define DMA_MAX_DATA_SIZE   0x40000 * DMA_WIDTH_DATA


#define DMA_STATUS_RUN_MASK          0x1
#define DMA_STATUS_COMPLETE_MASK     0x2
#define DMA_STATUS_NEXTBUF_MASK      0x4
#define DMA_STATUS_RX_ERROR_MASK     0x16



/* Timeout loop counter for reset
 */
#define RESET_TIMEOUT_COUNTER	10000

struct dmaiovec {
    void   *iov_base;  /* Starting address */
    size_t  iov_len;   /* Size of the memory pointed to by iov_base. */
};

int AxiDMAInit(u16 DeviceId, XAxiDma *AxiDma);
void dmaDeinit(void);

int AxiDMAStart(void);
void AxiDMAStop(void);

u32 AxiDMAGetStatus(void);
int AxiDMAGetComplete(void);
int AxiDMAGetRun(void);
int AxiDMAGetError(void);

struct dmaiovec AxiDMASetNext(struct dmaiovec newbuf);
void AxiDMARstComplete(void);
void AxiDMARstError(void);

#endif
