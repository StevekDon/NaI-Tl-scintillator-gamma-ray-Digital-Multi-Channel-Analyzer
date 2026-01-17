#include "file.h"

static FATFS fatfs;

//成形参数的存储
extern unsigned int		alg_na, alg_nb, alg_d;
extern unsigned int		alg_peak_thd, alg_peak_cnt;
extern unsigned int		alg_top_delay;
extern uint8_t		 	connect_mode;

char file_tcp_ip[128] = {0};

//初始化挂载SD卡
int init_sd_card()
{
	// 挂载文件系统
	FRESULT res = f_mount(&fatfs, "0:/", 1); // "0:/" 表示第一个驱动器
	if (res != FR_OK) return XST_FAILURE;

	return XST_SUCCESS;
}

/**
 * 将 spectrum_array 数据以 CSV 格式写入 SD 卡，并在最后一行添加 ms_live_time
 * @param filename   文件名（如 "0:/data.csv"）
 * @param spectrum_array_t  数据源数组（需确保大小为 65536 字节）
 * @param ms_live_time_t    最后一行的时间值（单位：毫秒）
 * @return FRESULT      文件操作结果（FR_OK 表示成功）
 */

int write_spectrum_to_csv(const char* filename, volatile uint8_t* spectrum_array_t, int ms_live_time_t)
{
	FIL file;
	DIR dir;
	FRESULT result;
	UINT BytesWr;
	uint32_t index_i = 0;
	uint32_t specData_temp = 0;

	char ms_live_time_c[64] = "";
	char sp_order_c[64] = "";
	char sp_count_c[64] = "";

	sprintf(ms_live_time_c, "Live Time: %u ms \n\r\n", ms_live_time_t);	//活时间字符串

	result = f_opendir(&dir, "spectrums");
	if (result != FR_OK) f_mkdir("spectrums");  //若文件夹不存在则创建

	result = f_open(&file, filename, FA_CREATE_ALWAYS | FA_WRITE);//打开或者创建一个文件

	result = f_lseek(&file, 0);//相当于将鼠标放在文件的第0个位置。

	//写csv文件头内容
	result = f_write(&file, ms_live_time_c, strlen(ms_live_time_c), &BytesWr);

	//写能谱数据
	for(index_i = 0; index_i < 16384; index_i++)
	{
		specData_temp = Xil_In32((uintptr_t)(spectrum_array_t + index_i * 4));

		sprintf(sp_count_c, "%u", specData_temp); //转字符串，道计数
		sprintf(sp_order_c, "%u", index_i); //转字符串, 道址序号

		strcat(sp_order_c, ",");
		strcat(sp_order_c, sp_count_c);
		strcat(sp_order_c, "\n");

		f_lseek(&file, f_size(&file)); //定位到文件末尾位置
		f_write(&file, sp_order_c, strlen(sp_order_c), &BytesWr); //写入当前行的谱数据
	}

	result = f_close(&file);	//关闭文件

	return XST_SUCCESS;
}

int read_config_file(const char* filename)
{
	FIL file;
	FRESULT res;
	UINT bytes_read;
	char buffer[512];
	char *line, *context = NULL;

	char tcp_ip_t[16] = {0};  // IPv4最大15字符
	char tcp_port[6] = {0};   // 端口最大5位
	int param_index = 0;

	/* 打开配置文件 */
	if ((res = f_open(&file, filename, FA_READ)) != FR_OK) {
		xil_printf("Error opening config file: %d\n", res);
		return XST_FAILURE;
	}

	/* 读取文件内容 */
	memset(buffer, 0, sizeof(buffer));
	if ((res = f_read(&file, buffer, sizeof(buffer)-1, &bytes_read)) != FR_OK) {
		f_close(&file);
		xil_printf("Read error: %d\n", res);
		return XST_FAILURE;
	}
	buffer[bytes_read] = '\0'; // 确保字符串终止

	/* 逐行解析 */
	line = strtok_r(buffer, "\r\n", &context);
	while (line != NULL) {
		/* 跳过注释行和空行 */
		if (line[0] == '/' || line[0] == '\0') {
			line = strtok_r(NULL, "\r\n", &context);
			continue;
		}

		/* 根据参数位置处理 */
		switch(param_index) {
		case 0:  // [MS Time] 可忽略或存储到变量
			break;
		case 1:  // na
			alg_na = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 2:  // nb
			alg_nb = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 3:  // D
			alg_d = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 4:  // THD
			alg_peak_thd = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 5:  // THD_CNT
			alg_peak_cnt = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 6:  // DLY
			alg_top_delay = (unsigned int)strtoul(line, NULL, 10);
			break;
		case 7:  // TCP IP
			strncpy(tcp_ip_t, line, sizeof(tcp_ip_t)-1);
			tcp_ip_t[sizeof(tcp_ip_t)-1] = '\0';
			break;
		case 8:  // Server Port
			strncpy(tcp_port, line, sizeof(tcp_port)-1);
			tcp_port[sizeof(tcp_port)-1] = '\0';
			break;
		case 9:  // Mode
			connect_mode = (uint8_t)strtoul(line, NULL, 10);
			break;
		default: // 忽略多余参数
			break;
		}
		param_index++;
		line = strtok_r(NULL, "\r\n", &context);
	}

	/* 构建AT指令字符串 */
	snprintf(file_tcp_ip, sizeof(file_tcp_ip),
			"AT+CIPSTART=\"TCP\",\"%s\",%s\r\n",
			tcp_ip_t, tcp_port);

	f_close(&file);
	return XST_SUCCESS;
}

