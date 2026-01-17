`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/05/06 16:41:09
// Design Name: 
// Module Name: dmca_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dmca_top
#(
    // for axi-lite register controller port
    parameter   AXILITE_ADDR_W      = 5,
    parameter   AXILITE_DATA_W      = 32,
    // for axi-dma port
    parameter   AXISTREAM_DATA_W    = 32,
    //for algorithm parameters
    parameter   REG_GLOBAL_LIMIT    = 300,
    parameter   ADC_BIT             = 14
)
(
    input                               sys_clk, sys_rstn,
    input       signed  [ADC_BIT-1:0]   adc_datain,
    output              [ADC_BIT-1:0]   adc_dataout,
    input               [ADC_BIT-1:0]   adc_fir_datain,
    output      signed  [16:0]          trapezd_data,
    output      signed  [16:0]          triangle_data,
    //AXI4S DMA S2MM PORT
    output  wire                                M_AXIS_TVALID,
    output  wire        [AXISTREAM_DATA_W-1:0]  M_AXIS_TDATA ,
    output  wire                                M_AXIS_TLAST ,
    input   wire                                M_AXIS_TREADY,
    //AXI - DMA  s2mm_prmry_reset_out_n
    input   wire                                M_AXIS_ARESETN,
    
    input               [9:0]   na, nb,
	input               [15:0]  na_1, d_na,
	input               [15:0]  peak_thd,
	input               [7:0]   peak_thd_count,
	input               [7:0]   peak_top_delay
);

wire                            peak_value_ok;
wire             [ADC_BIT-1:0]  peak_value;

adc_sample 
#(
    .ADC_BIT(ADC_BIT)
) m0
(
    .sys_clk        (sys_clk), 
    .sys_rstn       (sys_rstn),
    .adc_datain     (adc_datain),

    .adc_dataout    (adc_dataout)
);

dmca_algorithm_top 
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT),
    .ADC_BIT(ADC_BIT)
)m1
(
    .sys_clk                (sys_clk), 
    .sys_rstn               (sys_rstn),
    
    .adc_datain             (adc_fir_datain),
    
    .peak_threshold         (peak_thd),
    .peak_threshold_count   (peak_thd_count),
    .na                     (na), 
    .nb                     (nb),
    .na_1                   (na_1), 
    .d_na                   (d_na),
    .peakext_delay_time     (peak_top_delay),
    
    .peak_value_ok          (peak_value_ok),
    .peak_value             (peak_value),
    .trapezd_data           (trapezd_data),
    .triangle_data          (triangle_data)
);

spectrum2axis 
#(
    .DEPTH      (1<<ADC_BIT),
    .WIDTH      (AXISTREAM_DATA_W),
    .ADDR_W     (ADC_BIT)
)m2
(
    .sys_clk            (sys_clk),
    .M_AXIS_ARESETN     (M_AXIS_ARESETN),
    .sys_rstn           (sys_rstn),
    .peak_value_ok      (peak_value_ok),
    .peak_value         (peak_value),
    
    .M_AXIS_TVALID      (M_AXIS_TVALID),
    .M_AXIS_TDATA       (M_AXIS_TDATA),
    .M_AXIS_TLAST       (M_AXIS_TLAST),
    .M_AXIS_TREADY      (M_AXIS_TREADY)
);

endmodule
