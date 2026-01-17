#ifndef _AXI_DMA_H_
#define	_AXI_DMA_H_

#include "stdio.h"
#include "xscugic.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xil_cache.h"
#include "xil_io.h"
#include "xil_printf.h"
#include "xaxidma.h"

/*** DMA基地址 ***/
#define DMA_CTRL_BASEADDR	XPAR_AXI_DMA_0_BASEADDR
#define DMA_DEV_ID          XPAR_AXIDMA_0_DEVICE_ID
#define S2MM_INTR_ID        XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define INTC_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID
/*** DMA MM2S通道控制寄存器偏移值 ***/
#define MM2S_DMACR	0x00
#define MM2S_DMASR	0x04
#define MM2S_SA		0x18
#define MM2S_LENGTH 0x28
/*** DMA S2MM通道控制寄存器偏移值 ***/
#define S2MM_DMACR	0x30
#define S2MM_DMASR	0x34
#define S2MM_DA		0x48
#define S2MM_LENGTH 0x58

void Axi_DMA_Init(uint32_t moveLength, XScuGic *intcGic, XAxiDma *axiDma);
void Axi_DMA_Intr_Init(XScuGic *intcGic, XAxiDma *axiDma);
//void S2MM_Intr_Handler(void *callback);
void Disable_DMA_Intr(XScuGic *intc);

#endif
