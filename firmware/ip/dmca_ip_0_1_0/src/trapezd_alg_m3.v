`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: 
// 
// Create Date: 2025/02/17
// Design Name: 
// Module Name: trapezd_alg_m3
// Project Name: 
// Target Devices: zynq 7020, zynq7010
// Tool Versions: vivado 2022.2
// Description: 
// 
// Dependencies: 
// 
// Revision: v0.1.0
// Revision 0.01 - File Created
// Additional Comments: Q32.16 format
//
//                      v3[n] = v3[n-1] + v2[n-1];
//
//////////////////////////////////////////////////////////////////////////////////


module trapezd_alg_m3
(
input                       sys_clk, sys_rstn,

input       signed  [47:0]  trapezd_alg_m2_datain,
output  reg signed  [47:0]  trapezd_alg_m3_dataout
);

reg         signed  [47:0]  vi_delay1;

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_alg_m3_dataout <= 48'd0;
        vi_delay1 <= 48'd0;
    end
    else begin
        vi_delay1 <= trapezd_alg_m2_datain;
        trapezd_alg_m3_dataout <= trapezd_alg_m3_dataout + vi_delay1;
    end
end

endmodule
