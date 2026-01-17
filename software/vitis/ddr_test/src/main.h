#ifndef MAIN_H
#define MAIN_H

#include <stdio.h>
#include <math.h>
#include "stdint.h"

#define AXI_CTRL_BASEADDR	XPAR_DMCA_IP_0_S00_AXI_BASEADDR
#define AXI_CTRL_EN			AXI_CTRL_BASEADDR
#define AXI_CTRL_NANB		AXI_CTRL_BASEADDR + 0x04
#define AXI_CTRL_DNA		AXI_CTRL_BASEADDR + 0x08
#define AXI_CTRL_PEAK		AXI_CTRL_BASEADDR + 0x0c
#define AXI_CTRL_DELAY		AXI_CTRL_BASEADDR + 0x10
#define AXI_PL_TIMER		AXI_CTRL_BASEADDR + 0x14

#define	MASK_AXI_CTRL_PWR_EN	0x01
#define	MASK_AXI_CTRL_MS_EN		0x02
#define	MASK_AXI_CTRL_RST_DIS	0x04

#define	CMD_MS_START				0x000000f0
#define	CMD_MS_STOP					0x000000f1
#define	CMD_MS_READ					0x000000f2
#define	CMD_TM_READ					0x000000f3
#define	CMD_ZYNQ_RESET				0x000000e0
#define	CMD_PARAM_NA				0x000000d0
#define	CMD_PARAM_NB				0x000000d1
#define	CMD_PARAM_D					0x000000d2
#define	CMD_PARAM_PEAK_THD			0x000000d3
#define	CMD_PARAM_PEAK_THD_CNT		0x000000d4
#define	CMD_PARAM_PEAK_TOP_DLY		0x000000d5

#define	UART1_RX_TIMEOUT			0x00000005 // 5ms
#define SERIAL_RX_BUF_SIZE 			256

#define PSS_RST_CTRL_REG 	0xF8000200 //PSS_RST_CTRL¼Ä´æÆ÷
#define XSLCR_LOCK_ADDR		0xF8000004
#define XSLCR_UNLOCK_ADDR	0xF8000008
#define XSLCR_LOCK_CODE		0x0000767BU
#define XSLCR_UNLOCK_CODE	0x0000DF0DU
#define XSLCR_FPGA_RST_CTRL_ADDR	0xF8000240U

void parameter_calc(void);
void command_decode(uint8_t *cmd);
void PsSoftwareReset(void);
uint32_t combine_bytes_to_int(uint8_t *bytes);
float get_xadc_temp();
int xadc_init();
void uart1_decode(void);
void PLSoftwareReset(void);


#endif
