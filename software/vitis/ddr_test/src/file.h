#ifndef FILE_H
#define FILE_H

#include "xil_printf.h"
#include "xparameters.h"
#include "xsdps.h"
#include "ff.h"
#include <string.h>
#include <stdio.h>

int init_sd_card();
int write_spectrum_to_csv(const char* filename, volatile uint8_t* spectrum_array_t, int ms_live_time_t);
int read_config_file(const char* filename);

#endif
