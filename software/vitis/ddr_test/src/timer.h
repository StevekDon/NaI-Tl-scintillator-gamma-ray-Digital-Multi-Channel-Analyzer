#ifndef _TIMER_H
#define _TIMER_H

#include "xparameters.h"
#include "xscugic.h"
#include "xscutimer.h"
#include "xgpiops.h"
#include "stdbool.h"

#define TIMER_DEVICE_ID		XPAR_PS7_SCUTIMER_0_DEVICE_ID
#define TIMER_IRPT_INTR 	XPAR_SCUTIMER_INTR

int ScuTimer_Intr_Init(XScuGic *IntcInstancePtr, XScuTimer * TimerInstancePtr,
		uint16_t GicDeviceId, uint16_t TimerDeviceId, uint16_t TimerIntrId);

#endif
