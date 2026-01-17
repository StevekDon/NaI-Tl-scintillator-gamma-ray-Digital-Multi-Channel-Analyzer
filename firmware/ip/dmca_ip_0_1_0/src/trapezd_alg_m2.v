`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve
// 
// Create Date: 2025/02/17
// Design Name: 
// Module Name: trapezd_alg_m2
// Project Name: 
// Target Devices: zynq7020, zynq7010
// Tool Versions: vivado2022.2
// Description: 
// 
// Dependencies: 
// 
// Revision: v0.1.0
// Revision 0.01 - File Created
// Additional Comments:
//
//                  v2[n] = 1 / na * v1[n] - d / na * v1[n-1] + v2[n-1];

//                  *The algorithm uses fixed-point decimals for operation,
//                  *format: Q32.16
//
//////////////////////////////////////////////////////////////////////////////////


module trapezd_alg_m2
#(
    parameter   ADC_BIT = 14
)
(
input                           sys_clk, sys_rstn,
//data input from module 1 output
input       signed  [ADC_BIT:0] trapezd_alg_m1_datain,
//na_1 represents the value 1/na, and d_na represents d/na, which are calculated from the PS end and transmitted
input       signed  [15:0]      na_1, d_na,

output reg  signed  [47:0]      trapezd_alg_m2_dataout
);

reg         signed  [ADC_BIT:0]  vi_delay1;
reg         signed  [47:0]  mult1_reg, mult2_reg;

always @(posedge sys_clk)
begin
    if(!sys_rstn) begin
        mult1_reg <= 48'd0;
        mult2_reg <= 48'd0;
    end
    else begin
        mult1_reg <= trapezd_alg_m1_datain * na_1;
        mult2_reg <= vi_delay1 * d_na;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_alg_m2_dataout <= 48'd0;
        vi_delay1 <= {(ADC_BIT+1){1'b0}};
    end
    else begin
        vi_delay1 <= trapezd_alg_m1_datain;
        trapezd_alg_m2_dataout <= trapezd_alg_m2_dataout + (mult1_reg - mult2_reg);
    end
end

endmodule