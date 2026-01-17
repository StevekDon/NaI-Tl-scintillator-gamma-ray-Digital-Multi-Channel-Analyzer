#ifndef _SERIAL_H_
#define	_SERIAL_H_

#include "xparameters.h"
#include "xil_printf.h"
#include "xuartps.h"
#include "xscugic.h"
#include "xtime_l.h"
#include "xuartlite.h"
#include "xuartlite_l.h"
#include "stdio.h"
#include "sleep.h"

// 定义两个UART设备ID和中断ID
#define UART0_DEVICE_ID       	XPAR_PS7_UART_0_DEVICE_ID
#define UARTLITE_DEVICE_ID		XPAR_AXI_UARTLITE_0_DEVICE_ID
#define INTC_DEVICE_ID       	XPAR_SCUGIC_SINGLE_DEVICE_ID
#define UART0_INT_IRQ_ID      	XPAR_XUARTPS_0_INTR
#define UARTLITE_INTR_IRQ_ID    XPAR_FABRIC_UARTLITE_0_VEC_ID
#define UART0_BPS              	460800//921600
//#define UART1_BPS              	128000
/*
// ESP01S AT 指令定义
static const char* AT_CMD = "ATE0\r\n";	//回复 ATE0\n OK
static const char* AT_CWMODE = "AT+CWMODE=1\r\n";	//回复 \nOK
static const char* AT_CWJAP = "AT+CWJAP=\"zynq\",\"12345abcd\"\r\n";	//回复 \nOK
static const char* AT_CWJAP_S = "AT+CWJAP?\r\n"; //查询WIFI连接状态
static const char* AT_CIPMUX = "AT+CIPMUX=0\r\n";	//回复 \nOK
static const char* AT_CIPSTART = "AT+CIPSTART=\"TCP\",\"192.168.31.208\",8080\r\n";	//回复 \nOK
static const char* AT_CIPCLOSE = "AT+CIPCLOSE\r\n";
static const char* AT_CIPMODE = "AT+CIPMODE=1\r\n";	//回复 \nOK
static const char* AT_CIPSEND = "AT+CIPSEND\r\n";
static const char* AT_CIPSEND_EXIT = "+++";
*/
// 声明两个独立的中断服务函数
void Uart0_Intr_Handler(void *call_back_ref);
void Uart1_Intr_Handler(void *call_back_ref);

int Uart0_Init(XUartPs *Uart_Ps, uint16_t DeviceID);
int Uart1_Lite_Init(XUartLite *xUartLite_Ptr, XScuGic *intcGic);
int Uart0_Intr_Init(XUartPs *Uart_Ps, XScuGic *intcGic, uint16_t DeviceID);
//int esp01s_init(void);
void bluetooth_connect();

#endif
