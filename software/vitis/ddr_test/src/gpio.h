#ifndef GPIO_H
#define GPIO_H

#include "xgpiops.h"
#include "xscugic.h"

#define GPIOPS_ID 			XPAR_XGPIOPS_0_DEVICE_ID
#define INTC_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID
#define GPIO_INTERRUPT_ID   XPAR_XGPIOPS_0_INTR
#define	GPIO_KEY0	57
#define	GPIO_KEY1	56
#define	GPIO_LED0	55
#define	GPIO_LED1	54
#define EMIO_BANK	2

int gpio_init(XGpioPs *gpiops_instptr, XScuGic *intcGic);

#endif
