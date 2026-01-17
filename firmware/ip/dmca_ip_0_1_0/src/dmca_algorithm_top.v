`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
//
// **   This is the top-level design of the entire DMCA digital algorithm section   **
//
// Create Date: 2025/05/20
// Design Name: 
// Module Name: dmca_algorithm
// Project Name: digital multi-channel analyser algorithm
// Target Devices: zynq7020, zynq7010
// Tool Versions: vivado2022.2
// Description: 
//
//          This DMCA digital algorithm design includes: 
//              1. trapezoidal shaping algorithm derived from z-transform method, 
//              2. pulse start judgment, 
//              3. baseline estimation, 
//              4. stacking judgment logic, 
//              5. peak extraction logic,  
//
// Dependencies: xilinx mmcm ip core must be needed
// 
// Revision: ver0.1.2   Modified on 25/05/20
// Revision: 
//
// Additional Comments:
//          *Prohibited for commercial, scientific research, and closed source projects*
//////////////////////////////////////////////////////////////////////////////////


module dmca_algorithm_top
#(
    //TRAPEZOIDAL SHAPING ALGORITHM                     
    parameter   REG_GLOBAL_LIMIT = 300,
    parameter   ADC_BIT          = 14
)
(
    //SYSTEM CLOCK & RESET SIGNAL
    input                       sys_clk, sys_rstn,
    //ADC data in
    input               [ADC_BIT-1:0]  adc_datain,
    //-----------Shaping parameter input---------------//
    input               [15:0]  peak_threshold,
    input               [7:0]   peak_threshold_count,
    input               [9:0]   na, nb,
    input       signed  [15:0]  na_1, d_na,
    input               [7:0]   peakext_delay_time,
    //------------------------------------------------//
    //DATA OUT to AXI4-Full or AXI4-Stream Bus Convertor
    output                              peak_value_ok,
    output              [ADC_BIT-1:0]   peak_value,
    
    output      signed  [16:0]  trapezd_data,
    output      signed  [16:0]  triangle_data
);

wire                        peak_start_flag, stacking_flag;
wire        signed  [16:0]  trapezd_alg_data, trapezd_baseline;
wire        signed  [16:0]  triangle_alg_data;

assign trapezd_data = trapezd_alg_data;
assign triangle_data = triangle_alg_data;

//Performing trapezoidal shaping on sampled signals for subsequent spectral generation
trapezoidal_algorithm
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT),
    .ADC_BIT(ADC_BIT)
) m1
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .adc_datain             (adc_datain),
    .na                     (na),
    .nb                     (nb),
    .na_1                   (na_1),
    .d_na                   (d_na),
    .trapezd_alg_dataout    (trapezd_alg_data)
);

/*Triangle forming module, used to determine the -
starting position of the peak and trigger subsequent logic
*/
trapezoidal_algorithm
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT/2),
    .ADC_BIT(ADC_BIT)
) m2
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .adc_datain             (adc_datain),
    .na                     (na),
    .nb                     (na),
    .na_1                   (na_1),
    .d_na                   (d_na),
    .trapezd_alg_dataout    (triangle_alg_data)
);

//Determine the starting time (position) of the pulse based on triangle forming for subsequent logic use
peak_logic m3
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .triangle_alg_data      (triangle_alg_data),
    .peak_start_flag        (peak_start_flag),
    .na                     (na),
    .peak_threshold         (peak_threshold),
    .peak_threshold_count   (peak_threshold_count)
);

//Solve the mean value of trapezoidal forming before the arrival of pulses
baseline_estimation 
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT)
) m4
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .peak_start_flag        (peak_start_flag),
    .trapezd_alg_datain     (trapezd_alg_data),
    .trapezd_baseline       (trapezd_baseline),
    //Shaping parameter input
    .na                      (na),
    .nb                      (nb)
);

//Pulse stacking judgment logic
stacking_logic  m5
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .peak_start_flag        (peak_start_flag),
    .stacking_flag          (stacking_flag),
    //Shaping parameter input
    .nb                     (nb)
);

//Extract the flat top mean of trapezoidal forming and solve for pulse amplitude
peak_calculation 
#(
    .ADC_BIT(ADC_BIT)
) m6
(
    .sys_clk                (sys_clk),
    .sys_rstn               (sys_rstn),
    .trapezd_alg_datain     (trapezd_alg_data),
    .trapezd_baseline       (trapezd_baseline),
    .peak_start_flag        (peak_start_flag),
    .stacking_flag          (stacking_flag),
    .peak_value_ok          (peak_value_ok),
    .peak_value             (peak_value),
    //parameter input
    .peakext_delay_time     (peakext_delay_time)
);

endmodule
