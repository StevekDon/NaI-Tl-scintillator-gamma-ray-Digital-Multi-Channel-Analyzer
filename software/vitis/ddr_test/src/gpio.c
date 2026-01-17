#include "gpio.h"

//extern XGpioPs gpiops_inst;

void Gpio_Intr_Handler(void *call_back_ref)
{
	XGpioPs *gpio = (XGpioPs *) call_back_ref;

	if (XGpioPs_IntrGetStatusPin(gpio, GPIO_KEY0) == TRUE)
	{
		xil_printf("This is GPIO_KEY0 Interrupt!\r\n");
		XGpioPs_IntrClearPin(gpio, GPIO_KEY0);
	}
}

int gpio_init(XGpioPs *gpiops_instptr, XScuGic *intcGic)
{
	uint32_t Status;
	XScuGic_Config *intc_cfg;
	XGpioPs_Config *gpiops_cfg_ptr;

	//根据器件ID查找配置信息
	gpiops_cfg_ptr = XGpioPs_LookupConfig(GPIOPS_ID);
	if (NULL == gpiops_cfg_ptr)
		return XST_FAILURE;

	Status = XGpioPs_CfgInitialize(gpiops_instptr, gpiops_cfg_ptr, gpiops_cfg_ptr->BaseAddr);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	//配置EMIO方向
	XGpioPs_SetDirectionPin(gpiops_instptr, GPIO_KEY0, 0);
	XGpioPs_SetDirectionPin(gpiops_instptr, GPIO_KEY1, 0);
	XGpioPs_SetDirectionPin(gpiops_instptr, GPIO_LED0, 1);
	XGpioPs_SetDirectionPin(gpiops_instptr, GPIO_LED1, 1);

	//使能LED
	XGpioPs_SetOutputEnable(gpiops_instptr, EMIO_BANK, 0x3);

	//闭灯
	XGpioPs_WritePin(gpiops_instptr, GPIO_LED0, 0x00);
	XGpioPs_WritePin(gpiops_instptr, GPIO_LED1, 0x00);

	//初始化GIC
	intc_cfg = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == intc_cfg)
		return XST_FAILURE;
	Status = XScuGic_CfgInitialize(intcGic, intc_cfg, intc_cfg->CpuBaseAddress);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	//打开中断异常处理
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler, intcGic);
	Xil_ExceptionEnable();

	Status = XScuGic_Connect(intcGic, GPIO_INTERRUPT_ID, (Xil_ExceptionHandler)Gpio_Intr_Handler,
			(void *)gpiops_instptr);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	XScuGic_Enable(intcGic, GPIO_INTERRUPT_ID); //开启GPIO中断

	XGpioPs_SetIntrTypePin(gpiops_instptr, GPIO_KEY0, XGPIOPS_IRQ_TYPE_EDGE_FALLING);  // 下降沿触发

	XGpioPs_IntrClearPin(gpiops_instptr, GPIO_KEY0);
	XGpioPs_IntrEnablePin(gpiops_instptr, GPIO_KEY0);

	return XST_SUCCESS;
}


