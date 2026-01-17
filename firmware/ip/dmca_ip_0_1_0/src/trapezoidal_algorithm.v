`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/02/17
// Design Name: Trapezoidal Shaping Algorithm
// Module Name: trapezoidal_algorithm
// Project Name: 
// Target Devices: zynq 7020, zynq 7010
// Tool Versions: vivado 2022.2
// Dependencies: There are no IP cores in these codes
// 
// Revision: Ver0.1.0
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trapezoidal_algorithm
#(
    parameter   REG_GLOBAL_LIMIT = 300,
    parameter   ADC_BIT          = 14
)
(
    //SYSTEM PORT
    input                       sys_clk, sys_rstn,
    //ADC DATA IN
    input               [ADC_BIT-1:0]  adc_datain,
    //Parameter adjustment input
    input               [9:0]   na, nb,
    input       signed  [15:0]  na_1, d_na,
    //TRAPZD OUT
    output      signed  [16:0]  trapezd_alg_dataout
);

wire        signed  [ADC_BIT:0]  data_temp1;
wire        signed  [47:0]  data_temp2, data_temp3;

trapezd_alg_m1 
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT),
    .ADC_BIT(ADC_BIT)
) m1
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .adc_datain             (adc_datain),
    .nb                     (nb),
    .trapezd_alg_m1_dataout (data_temp1)
);

trapezd_alg_m2 
#(
    .ADC_BIT(ADC_BIT)
) m2
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .trapezd_alg_m1_datain  (data_temp1),
    .na_1                   (na_1),
    .d_na                   (d_na),
    .trapezd_alg_m2_dataout (data_temp2)
);

trapezd_alg_m3 m3
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .trapezd_alg_m2_datain  (data_temp2),
    .trapezd_alg_m3_dataout (data_temp3)
);

trapezd_alg_m4 
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT)
)
m4
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .trapezd_alg_m3_datain  (data_temp3),
    .na                     (na),
    .trapezd_alg_m4_dataout (trapezd_alg_dataout)
);

endmodule