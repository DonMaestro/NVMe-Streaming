
#include "xparameters.h"
#include "xil_types.h"


#define COUNTS_PER_SECOND XPAR_TMRCTR_0_CLOCK_FREQ_HZ


typedef u64 XTime;

void XTime_StartTimer(void);

//void XTime_SetTime(XTime Xtime_Global);
void XTime_GetTime(XTime *Xtime_Global);

