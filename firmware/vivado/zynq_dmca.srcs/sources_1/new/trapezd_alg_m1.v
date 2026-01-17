`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/02/17
// Module Name: trapezd_alg_m1
// Project Name: Trapezoidal Algorithm
// Target Devices: zynq 7020, zynq 7010
// Tool Versions: vivado 2022.2
// Description: 
// 
// Dependencies: 
// 
// Revision: ver0.1.0
// Revision 0.01 - File Created
// Additional Comments: 
//                 1.This forming algorithm is developed 
//                  with the goal of 14 bit ADC and is backward compatible
//                 2.The algorithm uses fixed-point decimals for operation,
//                  *format: Q16
//
//                  v1[n] = vi[n] - vi[n-nb];
//
//////////////////////////////////////////////////////////////////////////////////

module trapezd_alg_m1
#(
    parameter   REG_GLOBAL_LIMIT = 300,
    parameter   ADC_BIT          = 14
)
(
    input                               sys_clk, sys_rstn,
    input               [ADC_BIT-1:0]   adc_datain,
    input               [9:0]           nb,
    
    output  reg signed  [ADC_BIT:0]     trapezd_alg_m1_dataout
);

reg                 [ADC_BIT-1:0]  delay_temp[REG_GLOBAL_LIMIT-1:0];
reg                 [8:0]   i; //9bits

//Data delay module, delay time: REG_GLOBAL_LIMIT
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        for (i = 0; i < REG_GLOBAL_LIMIT; i = i+1'b1) begin
            delay_temp[i] <= {ADC_BIT{1'b0}};
        end
    end
    else begin
        delay_temp[0] <= {1'b0, adc_datain};
        for (i = 0; i < REG_GLOBAL_LIMIT-1'b1; i = i+1'b1) begin
            delay_temp[i+1] <= delay_temp[i];
        end
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_alg_m1_dataout <= {(ADC_BIT+1){1'b0}};
    end
    else begin
        trapezd_alg_m1_dataout <= adc_datain - delay_temp[nb-1];
    end
end

endmodule
