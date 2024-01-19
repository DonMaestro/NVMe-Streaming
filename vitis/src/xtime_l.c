
#include "xtime_l.h"
#include "xtmrctr.h"
#include "xintc.h"

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are only defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define TMRCTR_DEVICE_ID	XPAR_TMRCTR_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_INTC_0_DEVICE_ID
#define TMRCTR_INTERRUPT_ID	XPAR_INTC_0_TMRCTR_0_VEC_ID

/*
 * The following constant determines which timer counter of the device that is
 * used for this example, there are currently 2 timer counters in a device
 * and this example uses the first one, 0, the timer numbers are 0 based
 */
#define TIMER_CNTR_0	 0
#define TIMER_CNTR_1	 1

/*
 * The following constants are used to set the reset value of the timer counter,
 * making this number larger reduces the amount of time this example consumes
 * because it is the value the timer counter is loaded with when it is started
 */
#define RESET_VALUE_CNTR_0	 0x00000000
#define RESET_VALUE_CNTR_1	 0x00000000


//static XIntc InterruptController;  /* The instance of the Interrupt Controller */
static XTmrCtr TimerCounterInst;   /* The instance of the Timer Counter */

/*
 * The following variables are shared between non-interrupt processing and
 * interrupt processing such that they must be global.
 */
static volatile int TimerExpired;



void XTime_StartTimer(void)
{
	int Status;

	//XIntc *IntcInstancePtr = &InterruptController;  /* The instance of the Interrupt Controller */
	XTmrCtr *TmrCtrInstancePtr = &TimerCounterInst;   /* The instance of the Timer Counter */

	u16 DeviceId = TMRCTR_DEVICE_ID;
	//u16 IntrId = TMRCTR_INTERRUPT_ID;

	/*
	 * Initialize the timer counter so that it's ready to use,
	 * specify the device ID that is generated in xparameters.h
	 */
	Status = XTmrCtr_Initialize(TmrCtrInstancePtr, DeviceId);
	if (Status != XST_SUCCESS) {
		return;
	}


	/*
	 * Set a reset value for the timer counter such that it will expire
	 * eariler than letting it roll over from 0, the reset value is loaded
	 * into the timer counter when it is started
	 */
	XTmrCtr_SetResetValue(TmrCtrInstancePtr, TIMER_CNTR_0,
				RESET_VALUE_CNTR_0);
	XTmrCtr_SetResetValue(TmrCtrInstancePtr, TIMER_CNTR_1,
				RESET_VALUE_CNTR_1);


	/*
	 * Enable the interrupt of the timer counter so interrupts will occur
	 * and use auto reload mode such that the timer counter will reload
	 * itself automatically and continue repeatedly, without this option
	 * it would expire once only and set the Cascade mode.
	 */
	XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_CNTR_0,
				XTC_AUTO_RELOAD_OPTION |
				XTC_CASCADE_MODE_OPTION);

	/*
	 * Reset the timer counters such that it's incrementing by default
	 */
	 XTmrCtr_Reset(TmrCtrInstancePtr, TIMER_CNTR_0);
	 XTmrCtr_Reset(TmrCtrInstancePtr, TIMER_CNTR_1);

	/*
	 * Start the timer counter 0 such that it's incrementing by default,
	 * then wait for it to timeout a number of times.
	 */
	XTmrCtr_Start(TmrCtrInstancePtr, TIMER_CNTR_0);
}

void XTime_StopTimer(void)
{
	XTmrCtr_Stop(&TimerCounterInst, TIMER_CNTR_0);
}

/*
void XTime_SetTime(XTime Xtime_Global)
{

}
*/

void XTime_GetTime(XTime *Xtime_Global)
{
	*Xtime_Global = (u64)XTmrCtr_GetValue(&TimerCounterInst, XTC_TIMER_1) << 32;
	*Xtime_Global += XTmrCtr_GetValue(&TimerCounterInst, XTC_TIMER_0);
}

