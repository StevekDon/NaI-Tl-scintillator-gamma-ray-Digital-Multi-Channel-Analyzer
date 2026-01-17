#include "axi_dma.h"
#include "md5.h"

extern uint8_t axi_dma_flag;
extern volatile uint8_t spectrum_array[65536];

//DMA初始化
void Axi_DMA_Init(uint32_t moveLength, XScuGic *intcGic, XAxiDma *axiDma)
{
	Xil_Out32((DMA_CTRL_BASEADDR + S2MM_DMACR),0x1004);
	Xil_Out32((DMA_CTRL_BASEADDR + S2MM_DA), spectrum_array);	//数据搬运基地址，存入DDR

	Xil_Out32((DMA_CTRL_BASEADDR + S2MM_DMACR), 0x1001);
	Xil_Out32((DMA_CTRL_BASEADDR + S2MM_LENGTH), moveLength * 4); //设置数据长度

}

//S2MM通道中断函数
void S2MM_Intr_Handler(void *callback)
{
	uint32_t irq_status;
	XAxiDma *axidma_inst = (XAxiDma *) callback;

	axi_dma_flag = 1;

	irq_status = XAxiDma_IntrGetIrq(axidma_inst, XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrAckIrq(axidma_inst, irq_status, XAXIDMA_DEVICE_TO_DMA);

	if ((irq_status & XAXIDMA_IRQ_ERROR_MASK)) {//DMA搬运错误处理
		//XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, 0xEE);
	}
}

//DMA中断初始化函数
void Axi_DMA_Intr_Init(XScuGic *intcGic, XAxiDma *axiDma)
{
	XAxiDma_Config *dma_config;
	XScuGic_Config *intc_config;

	dma_config = XAxiDma_LookupConfig(DMA_DEV_ID);
	XAxiDma_CfgInitialize(axiDma, dma_config);

	intc_config = XScuGic_LookupConfig(INTC_DEVICE_ID);
	XScuGic_CfgInitialize(intcGic, intc_config, intc_config->CpuBaseAddress);

	XScuGic_SetPriorityTriggerType(intcGic, S2MM_INTR_ID, 16, 0x3);//Rising edge sensitive

	XScuGic_Connect(intcGic, S2MM_INTR_ID,
			(Xil_InterruptHandler) S2MM_Intr_Handler, axiDma);

	XScuGic_Enable(intcGic, S2MM_INTR_ID);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler, (void *) intcGic);
	Xil_ExceptionEnable();

	XAxiDma_IntrEnable(axiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
	//XAxiDma_IntrEnable(&axidma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);
}

//关闭DMA中断
void Disable_DMA_Intr(XScuGic *intc)
{
	XScuGic_Disconnect(intc, S2MM_INTR_ID);
}

