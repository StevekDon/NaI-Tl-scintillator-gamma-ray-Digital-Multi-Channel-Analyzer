#include "main.h"
#include "serial.h"

// 声明两个UART实例和中断控制器实例
extern XUartPs Uart0_Ps;
extern XUartLite Uart1_Lite;
extern XScuGic IntcGic;

// 定义两个接收缓冲区
uint8_t serialRecData_Uart0[SERIAL_RX_BUF_SIZE];
uint8_t serialRecData_Uart1[SERIAL_RX_BUF_SIZE];
int serialRxCount_Uart0 = 0;
int serialRxCount_Uart1 = 0;

uint8_t serial1_rx_count_flag = 0;
extern uint8_t uart0_tx_flag;
extern uint8_t bl_connect_flag;
extern uint32_t serial1_rx_count;

extern char  file_tcp_ip[128];

/* UART0初始化函数 */
int Uart0_Init(XUartPs *Uart_Ps, uint16_t DeviceID)
{
	int status;
	XUartPs_Config *uart_cfg;

	uart_cfg = XUartPs_LookupConfig(DeviceID);
	if (NULL == uart_cfg)
		return XST_FAILURE;

	status = XUartPs_CfgInitialize(Uart_Ps, uart_cfg, uart_cfg->BaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	status = XUartPs_SelfTest(Uart_Ps);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	XUartPs_SetOperMode(Uart_Ps, XUARTPS_OPER_MODE_NORMAL);
	XUartPs_SetBaudRate(Uart_Ps, UART0_BPS);
	XUartPs_SetFifoThreshold(Uart_Ps, 1);

	return XST_SUCCESS;
}

/* UARTLite初始化函数 */
int Uart1_Lite_Init(XUartLite *xUartLite_Ptr, XScuGic *intcGic)
{
	uint32_t Status;

	Status = XUartLite_Initialize(xUartLite_Ptr, UARTLITE_DEVICE_ID);

	Status = XUartLite_SelfTest(xUartLite_Ptr);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	XScuGic_Config *intc_cfg;
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

	XScuGic_SetPriorityTriggerType(intcGic, UARTLITE_INTR_IRQ_ID, 48, 0x3);

	Status = XScuGic_Connect(intcGic, UARTLITE_INTR_IRQ_ID, (Xil_ExceptionHandler)Uart1_Intr_Handler,
			(void *)xUartLite_Ptr);
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	XScuGic_Enable(intcGic, UARTLITE_INTR_IRQ_ID);

	XUartLite_EnableInterrupt(xUartLite_Ptr);

	return XST_SUCCESS;
}

/* 中断初始化函数 */
int Uart0_Intr_Init(XUartPs *Uart_Ps, XScuGic *intcGic, uint16_t DeviceID)
{
	int status;

	XScuGic_Config *intc_cfg;
	intc_cfg = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == intc_cfg)
		return XST_FAILURE;
	status = XScuGic_CfgInitialize(intcGic, intc_cfg, intc_cfg->CpuBaseAddress);
	if (status != XST_SUCCESS)
		return XST_FAILURE;

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			(void *)intcGic);
	Xil_ExceptionEnable();

	XScuGic_SetPriorityTriggerType(intcGic, DeviceID, 40, 0x3);

	XScuGic_Connect(intcGic, UART0_INT_IRQ_ID,
			(Xil_ExceptionHandler) Uart0_Intr_Handler,(void *) Uart_Ps);
	XUartPs_SetInterruptMask(Uart_Ps, XUARTPS_IXR_RXOVR);
	XScuGic_Enable(intcGic, UART0_INT_IRQ_ID);

	return XST_SUCCESS;
}

/* UART0中断服务函数 */
void Uart0_Intr_Handler(void *call_back_ref)
{
	XUartPs *uart_instance_ptr = (XUartPs *) call_back_ref;
	uint32_t isrStatus = XUartPs_ReadReg(uart_instance_ptr->Config.BaseAddress, XUARTPS_IMR_OFFSET);
	isrStatus &= XUartPs_ReadReg(uart_instance_ptr->Config.BaseAddress, XUARTPS_ISR_OFFSET);
	// 清除所有中断标志
	XUartPs_WriteReg(uart_instance_ptr->Config.BaseAddress, XUARTPS_ISR_OFFSET, XUARTPS_IXR_RXOVR);

	if (isrStatus & (uint32_t)XUARTPS_IXR_RXOVR)
	{
		serialRecData_Uart0[serialRxCount_Uart0++] =
				XUartPs_RecvByte(uart_instance_ptr->Config.BaseAddress);

		if(serialRxCount_Uart0 == 8) //每接收8byte数据触发一次
		{
			uart0_tx_flag = 1;
			serialRxCount_Uart0 = 0;
		}
	}
}

/* UART1中断服务函数 */
void Uart1_Intr_Handler(void *call_back_ref)
{
	uint32_t isrStatus = XUartLite_ReadReg(Uart1_Lite.RegBaseAddress, XUL_STATUS_REG_OFFSET);

	if ((isrStatus & (XUL_SR_RX_FIFO_FULL | XUL_SR_RX_FIFO_VALID_DATA)) != 0)
	{
		serialRecData_Uart1[serialRxCount_Uart1++] =
				XUartLite_RecvByte(XPAR_AXI_UARTLITE_0_BASEADDR);
		if(serialRxCount_Uart1 >= SERIAL_RX_BUF_SIZE) serialRxCount_Uart1 = 0; //避免越界

		if(bl_connect_flag)	//定时处理不定长串口数据, 需要无线连接后
		{
			serial1_rx_count_flag = 1; //开始定时
			//xil_printf("%x\n", serialRecData_Uart1[serialRxCount_Uart1]);
			//xil_printf("%s\n", serialRecData_Uart1);
		}
	}
}

//等待蓝牙 定时中断循环调用直至手机连接，模块请使用uart模块设置好后再连接（128000bps、名字及pin的设置）
void bluetooth_connect()
{
	while(!bl_connect_flag)
	{
		if(strstr(serialRecData_Uart1, "CONNECTED") != NULL) {//判断是否包含指定字符串
			serialRxCount_Uart1 = 0;
			memset(serialRecData_Uart1, 0x00, sizeof(serialRecData_Uart1)); //清空UART1接收内容
			bl_connect_flag = 1;
			xil_printf("bl connected!\n");
			break;
		}
		usleep(10 * 1000); //delay 10ms
	}
}

//esp01s 操作函数，弃用：
/*
// 发送指令并检查响应
int send_at_command(const char* cmd, const char* expected_response, int timeout_ms)
{
	uint8_t length = 0;
	int index_i = 0;

	serialRxCount_Uart1 = 0;
	// 发送指令
	for(index_i = 0; index_i < strlen(cmd); index_i++)
	{
		XUartLite_SendByte(XPAR_AXI_UARTLITE_0_BASEADDR, cmd[index_i]);
	}
	usleep(timeout_ms * 1000); //等待串口完全接收数据，阻塞延时
	//xil_printf("%s", serialRecData_Uart1);
	if(strstr(serialRecData_Uart1, expected_response) != NULL) //判断是否包含指定字符串
	{
		//xil_printf("%s", serialRecData_Uart1);
		serialRxCount_Uart1 = 0;
		memset(serialRecData_Uart1, 0x00, SERIAL_RX_BUF_SIZE); //清空UART1接收内容
		return XST_SUCCESS;
	}

	return XST_FAILURE;
}

int esp01s_init(void)
{
	wifi_connect_flag = 0;

	serialRxCount_Uart1 = 0;
	memset(serialRecData_Uart1, 0x00, sizeof(serialRecData_Uart1)); //清空UART1接收内容

	while(1)
	{
		if(send_at_command(AT_CWJAP_S, "+CWJAP", 500) == XST_SUCCESS) {
			xil_printf("ESP-01S WIFI Connected!\n");
			break;
		}
		usleep(100 * 1000); //100ms
	}

	// 发送 AT 指令序列
	if (send_at_command(AT_CMD, "OK", 500) != XST_SUCCESS) {
		xil_printf("ESP-01S no response\n");
		return XST_FAILURE;
	}
	if (send_at_command(AT_CWMODE, "OK", 500) != XST_SUCCESS) {
		xil_printf("Failed to set WiFi mode\n");
		return XST_FAILURE;
	}
	if (send_at_command(AT_CIPMUX, "OK", 500) != XST_SUCCESS) {
		xil_printf("Enabling multiple connections failed\n");
		return XST_FAILURE;
	}
	if (send_at_command(file_tcp_ip, "CONNECT", 1000) != XST_SUCCESS) { //重复连接断开，避免连接不稳定
		xil_printf("Failed to connect TCP Server!\n");
		return XST_FAILURE;
	}
	if (send_at_command(AT_CIPCLOSE, "OK", 500) != XST_SUCCESS) {
		xil_printf("Failed to connect TCP Server!\n");
		return XST_FAILURE;
	}
	if (send_at_command(file_tcp_ip, "CONNECT", 1000) != XST_SUCCESS) {
		xil_printf("Failed to connect TCP Server!\n");
		return XST_FAILURE;
	}
	if (send_at_command(AT_CIPMODE, "OK", 500) != XST_SUCCESS) {
		xil_printf("Failed to set TC mode\n");
		return XST_FAILURE;
	}

	xil_printf("ESP-01S Setting Finished!\n");
	wifi_connect_flag = 1;
	return XST_SUCCESS;

}
 */
