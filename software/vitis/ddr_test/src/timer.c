#include "timer.h"

uint32_t ms_timer_count = 0; //用于测量过程的计时
uint32_t ms_read_count = 0; //计时1s上传一次能谱数据
uint32_t serial1_rx_count = 0;

extern uint8_t ms_start_flag, ms_stop_flag, ms_read_flag;
extern uint8_t serial1_rx_count_flag;

void TimerIntrHandler(void *CallBackRef)
{
	if(ms_start_flag == 1) //测量过程中计时，用于计算活时间（真实测量时间）
	{
		ms_timer_count++;
		ms_read_count++;

		if(ms_read_count == 2000) //每2s读一次
		{
			ms_read_count = 0;
			ms_read_flag = 1;
		}
	}

	if(serial1_rx_count_flag)
	{
		serial1_rx_count++;
	}
}

int ScuTimer_Intr_Init(XScuGic *IntcInstancePtr, XScuTimer * TimerInstancePtr,
		uint16_t GicDeviceId, uint16_t TimerDeviceId, uint16_t TimerIntrId)
{
	XScuTimer_Config *TimerConfigPtr;
	XScuGic_Config *IntcConfigPtr;

	TimerConfigPtr = XScuTimer_LookupConfig(TimerDeviceId);
	XScuTimer_CfgInitialize(TimerInstancePtr, TimerConfigPtr,
			TimerConfigPtr->BaseAddr);

	XScuTimer_SelfTest(TimerInstancePtr);

	XScuTimer_SetPrescaler(TimerInstancePtr, 0x00);

	XScuTimer_EnableAutoReload(TimerInstancePtr);

	XScuTimer_LoadTimer(TimerInstancePtr, XPAR_PS7_CORTEXA9_0_CPU_CLK_FREQ_HZ / 2 / 1000); //1ms

	XScuTimer_Start(TimerInstancePtr);
	//XScuTimer_Stop(TimerInstancePtr);

	//TimerDisableIntrSystem(IntcInstancePtr, TimerIntrId);

	/////////////////////////////////////////////////////////////////
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			IntcInstancePtr);
	Xil_ExceptionEnable();
	/////////////////////////////////////////////////////////////////
	IntcConfigPtr = XScuGic_LookupConfig(GicDeviceId);
	XScuGic_CfgInitialize(IntcInstancePtr, IntcConfigPtr,
			IntcConfigPtr->CpuBaseAddress);

	XScuGic_Connect(IntcInstancePtr, TimerIntrId,
			(Xil_ExceptionHandler)TimerIntrHandler,
			(void *)TimerInstancePtr);

	//XScuGic_InterruptMaptoCpu(IntcInstancePtr, 0x01, TimerIntrId);

	XScuGic_Enable(IntcInstancePtr, TimerIntrId);
	//XScuGic_Disconnect(IntcInstancePtr, TimerIntrId);

	XScuTimer_EnableInterrupt(TimerInstancePtr);
	//XScuTimer_DisableInterrupt(TimerInstancePtr);
	return XST_SUCCESS;
}

