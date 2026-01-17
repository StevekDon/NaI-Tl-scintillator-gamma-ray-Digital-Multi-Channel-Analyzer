#include "serial.h"
#include "timer.h"
#include "axi_dma.h"
#include "xadcps.h"
#include "md5.h"
#include "file.h"
#include "gpio.h"
#include "main.h"

//能谱存储区 16384 * 4 = 65536Bytes
volatile uint8_t spectrum_array[65536];  //__attribute__ ((section(".custom_section")));
volatile uint8_t merged_spectrum_array[8192]; //合并能谱

// 声明外设实例和中断控制器实例
XUartPs Uart0_Ps;
XUartLite Uart1_Lite;
XScuTimer timerInstPtr;
XScuGic IntcGic;
XAxiDma axiDma;
XAdcPs xadc_inst; //XADC 驱动实例
XGpioPs gpiops_inst;

//成形参数的存储
unsigned int alg_na = 50, alg_nb = 150, alg_d = 77;
float		 alg_na_1 = 0.0, alg_d_na = 0.0;
unsigned int alg_peak_thd = 600, alg_peak_cnt = 8;
unsigned int alg_top_delay = 8;
unsigned int pl_ms_timer = 0;
uint8_t		 connect_mode = 0; //连接模式，串口（0）或wifi/BL(1)
extern char  file_tcp_ip[128];

//串口相关缓冲区及标志位
uint8_t uart0_tx_flag = 0; //中断标志位
uint8_t uart1_tx_flag = 0;
extern uint8_t serialRecData_Uart0[SERIAL_RX_BUF_SIZE];	//接收缓冲区
extern uint8_t serialRecData_Uart1[SERIAL_RX_BUF_SIZE];
extern int serialRxCount_Uart0;	//接受数目记录
extern int serialRxCount_Uart1;
extern uint8_t serial1_rx_count_flag;	//uart1不定长数据定时标志
extern uint32_t serial1_rx_count;	//定时长度

uint8_t bl_connect_flag = 0;	//bluetooth连接标志位
uint8_t axi_dma_flag = 0;	//dma正在搬运标志位

//测量过程标志位（开始、结束、上位机读取）
uint8_t ms_start_flag = 0, ms_stop_flag = 0, ms_read_flag = 0;

extern uint32_t ms_timer_count; //用于测量过程的计时（测量活时间）

int main()
{
	uint32_t ms_live_time = 0;
	int index_i = 0, index_j = 0;
	uint32_t spectrum_temp = 0;
	uint8_t md5_result[16];

	Xil_DCacheDisable(); //关闭DCache

	memset(spectrum_array, 0x00, sizeof(spectrum_array)); //能谱数组清零

	// 初始化UART
	Uart0_Init(&Uart0_Ps, UART0_DEVICE_ID);
	Uart0_Intr_Init(&Uart0_Ps, &IntcGic, UART0_DEVICE_ID);

	Uart1_Lite_Init(&Uart1_Lite, &IntcGic);

	//初始化PL DMA中断
	Axi_DMA_Intr_Init(&IntcGic, &axiDma);

	ScuTimer_Intr_Init(&IntcGic, &timerInstPtr, INTC_DEVICE_ID,
			TIMER_DEVICE_ID, TIMER_IRPT_INTR);	//初始化cpu0私有定时器Timer

	//ps内部xadc初始化
	xadc_init();

	//gpio中断初始化
	gpio_init(&gpiops_inst, &IntcGic);

	//初始化SD卡,读取参数
	init_sd_card();
	//read_config_file("0:/param_cfg.txt");

	while(1)
	{
		//if(connect_mode) bluetooth_connect(); //直到蓝牙连接后退出

		//uart0命令接受，解码
		if(uart0_tx_flag)
		{
			uart0_tx_flag = 0;
			command_decode(serialRecData_Uart0);
			//XUartPs_Send(&Uart0_Ps, "GET", 3);
		}

		//uart1命令解码及bt状态判断
		if((serial1_rx_count_flag == 1) & (serial1_rx_count > UART1_RX_TIMEOUT) & connect_mode)	//串口接收数据定时超时判断（超过则认为接受结束）
		{
			serial1_rx_count_flag = 0;
			serial1_rx_count = 0;

			uart1_tx_flag = 1;
			uart1_decode();
		}

		if(ms_read_flag == 1)	//上传数据, 在DMA中断中处理
		{
			ms_read_flag = 0;
			//配置DMA，开始搬运
			Axi_DMA_Init(sizeof(spectrum_array) / 4, &IntcGic, &axiDma); //当搬运完成后进入s2mm通道中断进行传输
			//sprintf(str, "%f", get_xadc_temp());
		}

		if((ms_stop_flag == 1) && (ms_start_flag == 0))
		{
			ms_live_time = ms_timer_count;
			ms_timer_count = 0;//清除计数器
			ms_stop_flag = 0;

			pl_ms_timer = Xil_In32(AXI_PL_TIMER); //获取PL端测量活时间
			//停止后触发一次传输，上传最终谱
			//if(axi_dma_flag == 0) Axi_DMA_Init(sizeof(spectrum_array) / 4, &IntcGic, &axiDma);
			//write_spectrum_to_csv("0:/spectrums/s0.csv", spectrum_array, ms_live_time);
		}

		// 强制转换为volatile uint32_t指针，确保按4字节对齐访问
		volatile uint32_t* sp_src = (volatile uint32_t*)spectrum_array;
		volatile uint32_t* sp_dest = (volatile uint32_t*)merged_spectrum_array;
		if(axi_dma_flag & ms_start_flag) //AXI DMA中断标志位，向外传输数据
		{
			axi_dma_flag = 0;

			if(1) { //串口连接模式，发送完整能谱 16384 * 4Bytes
				// 计算MD5
				md5_hash(spectrum_array, sizeof(spectrum_array), md5_result);

				XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, 0xa5); //帧头
				for(index_i = 0; index_i < sizeof(spectrum_array) + sizeof(md5_result); index_i++)
				{
					if(index_i < sizeof(spectrum_array)) XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, spectrum_array[index_i]);
					else XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, md5_result[index_i - sizeof(spectrum_array)]);
				}
				XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, 0x5a); //帧尾
			}
			else { //蓝牙模式，发送合并能谱数据 2048 * 4Bytes
				// 合并能谱数据
				for(index_i = 0; index_i < 2048; index_i++)
					for(index_j = 0; index_j < 8; index_j++)
						sp_dest[index_i] += sp_src[index_i * 8 + index_j];

				//计算MD5值
				md5_hash(merged_spectrum_array, sizeof(merged_spectrum_array), md5_result);

				for(index_i = 0; index_i < sizeof(merged_spectrum_array) + sizeof(md5_result); index_i++)
				{
					if(index_i < sizeof(merged_spectrum_array)) XUartLite_SendByte(XPAR_AXI_UARTLITE_0_BASEADDR, merged_spectrum_array[index_i]);
					else XUartLite_SendByte(XPAR_AXI_UARTLITE_0_BASEADDR, md5_result[index_i - sizeof(merged_spectrum_array)]);
				}
			}
		}
	}

	return 0;
}

void uart1_decode(void)
{
	if(uart1_tx_flag == 1)
	{
		uart1_tx_flag = 0;

		if(strstr(serialRecData_Uart1, "DISC:SUCCESS") != NULL) //蓝牙意外断连，尝试重连
		{
			bluetooth_connect();
		}

		if(serialRecData_Uart1[0] == 0x00 && serialRecData_Uart1[1] == 0x00) //蓝牙下传命令
		{
			command_decode(&serialRecData_Uart1[0]); //解码
			//xil_printf("%d\n", alg_nb);
		}
		serialRxCount_Uart1 = 0;
		memset(serialRecData_Uart1, 0x00, SERIAL_RX_BUF_SIZE); //清空UART1接收内容
	}
}

//用于成形参数计算及传递
void parameter_calc(void)
{
	unsigned int alg_d_na_temp = 0;
	unsigned int alg_1_na_temp = 0;

	memset(spectrum_array, 0x00, sizeof(spectrum_array));	//复位能谱数组
	//PLSoftwareReset(); //启动前复位整个PL端

	Xil_Out32(AXI_CTRL_EN, MASK_AXI_CTRL_PWR_EN);// 启动ADC电源
	usleep(100*1000);	// delay 保证电源稳定后

	//成形参数Na、Nb的传输
	Xil_Out32(AXI_CTRL_NANB, ((alg_nb & 0xFFFF)<<16) | (alg_na & 0xFFFF));
	//成形参数：  1/na 、 d/na 传递
	alg_na_1 = 1.0 / alg_na;
	alg_d_na = exp(-1.00 / alg_d) / (float)alg_na;
	alg_d_na_temp = (unsigned int)round(alg_d_na * 65536.0);
	alg_1_na_temp = (unsigned int)round(alg_na_1 * 65536.0);
	Xil_Out32(AXI_CTRL_DNA, ((alg_d_na_temp & 0xFFFF)<<16) | (alg_1_na_temp & 0xFFFF));
	Xil_Out32(AXI_CTRL_PEAK, ((alg_peak_cnt & 0xFFFF)<<16) | (alg_peak_thd & 0xFFFF));
	Xil_Out32(AXI_CTRL_DELAY, alg_top_delay & 0xFFFF);

	Xil_Out32(AXI_CTRL_EN, MASK_AXI_CTRL_PWR_EN | MASK_AXI_CTRL_MS_EN | MASK_AXI_CTRL_RST_DIS);// 启动PL端计时器（ms）、取消算法逻辑复位
}

// 串口命令解码
void command_decode(uint8_t *cmd)
{
	switch(cmd[3])
	{
	case CMD_MS_START:
		parameter_calc(); //先传递参数，结束后启动测量
		ms_start_flag = 1;
		break;
	case CMD_MS_STOP:
		ms_start_flag = 0, ms_stop_flag = 1;
		Xil_Out32(AXI_CTRL_EN, MASK_AXI_CTRL_RST_DIS); //关闭ADC电源、停止PL计数器、但不能复位PL！！
		usleep(10*1000);
		break;
	case CMD_MS_READ:
		ms_read_flag = 1;
		break;
	case CMD_TM_READ:
		Xil_Out32(AXI_CTRL_EN, 0x00000000); //PL保持复位状态
		XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, (pl_ms_timer >> 0)  & 0xFF);  // LSB
		XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, (pl_ms_timer >> 8)  & 0xFF);
		XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, (pl_ms_timer >> 16) & 0xFF);
		XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, (pl_ms_timer >> 24) & 0xFF);  // MSB
		ms_start_flag = 0;
		break;
	case CMD_ZYNQ_RESET:
		PsSoftwareReset();
		break;
	case CMD_PARAM_NA:
		alg_na = combine_bytes_to_int(&cmd[4]);
		break;
	case CMD_PARAM_NB:
		alg_nb = combine_bytes_to_int(&cmd[4]);
		break;
	case CMD_PARAM_D:
		alg_d = combine_bytes_to_int(&cmd[4]);
		break;
	case CMD_PARAM_PEAK_THD:
		alg_peak_thd = combine_bytes_to_int(&cmd[4]);
		break;
	case CMD_PARAM_PEAK_THD_CNT:
		alg_peak_cnt = combine_bytes_to_int(&cmd[4]);
		break;
	case CMD_PARAM_PEAK_TOP_DLY:
		alg_top_delay = combine_bytes_to_int(&cmd[4]);
		break;
	default:
		serialRxCount_Uart0 = 0;
		return; // 无效命令
	}
}

uint32_t combine_bytes_to_int(uint8_t *bytes) //大端模式
{
	return (bytes[0] << 24) |
			(bytes[1] << 16)|
			(bytes[2] << 8) |
			(bytes[3] << 0);
}

//cpu的软复位
void PsSoftwareReset(void)
{
	Xil_Out32(XSLCR_UNLOCK_ADDR, XSLCR_UNLOCK_CODE); //写使能
	Xil_Out32(PSS_RST_CTRL_REG, 0x01); //复位
}

void PLSoftwareReset(void)
{
	//解锁SLCR寄存器
	Xil_Out32(XSLCR_UNLOCK_ADDR, XSLCR_UNLOCK_CODE);

	//触发PL复位
	Xil_Out32(XSLCR_FPGA_RST_CTRL_ADDR, 0x1);

	usleep(10); //delay 10us

	//释放PL复位
	Xil_Out32(XSLCR_FPGA_RST_CTRL_ADDR, 0x0);

	//重新锁定SLCR寄存器
	Xil_Out32(XSLCR_LOCK_ADDR, XSLCR_LOCK_CODE);
}

//ps内部xadc初始化
int xadc_init()
{
	XAdcPs_Config *ConfigPtr; //XADC 配置指针

	//查询配置XADC
	ConfigPtr = XAdcPs_LookupConfig(XPAR_XADCPS_0_DEVICE_ID);
	XAdcPs_CfgInitialize(&xadc_inst, ConfigPtr, ConfigPtr->BaseAddress);
	//设置XADC操作模式为“默认安全模式”
	//XAdcPs_SetSequencerMode(&xadc_inst, XADCPS_SEQ_MODE_SAFE);
	//使能的相应的通道
	XAdcPs_SetSeqChEnables(&xadc_inst, XADCPS_SEQ_CH_TEMP | XADCPS_SEQ_CH_VPVN);
	//设置为循环模式
	XAdcPs_SetSequencerMode(&xadc_inst, XADCPS_SEQ_MODE_CONTINPASS);

	return XST_SUCCESS;
}

//xadc获取内部温度
float get_xadc_temp()
{
	uint32_t temp_rawdata; //温度 原始数据

	temp_rawdata = XAdcPs_GetAdcData(&xadc_inst, XADCPS_CH_TEMP);
	return XAdcPs_RawToTemperature(temp_rawdata); //将原始数据转换成浮点型
}
