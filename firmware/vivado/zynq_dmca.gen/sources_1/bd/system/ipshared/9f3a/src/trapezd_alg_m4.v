`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/02/17
// Design Name: 
// Module Name: trapezd_alg_m4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: v0.1.0
// Revision 0.01 - File Created
// Additional Comments:
//
//                      v4[n] = v3[n] + v3[n - na];
//
//////////////////////////////////////////////////////////////////////////////////

module trapezd_alg_m4
#(
    parameter   REG_GLOBAL_LIMIT = 300
)
(
input                       sys_clk, sys_rstn,
input       signed  [47:0]  trapezd_alg_m3_datain,
input               [9:0]   na,

output  reg signed  [16:0]  trapezd_alg_m4_dataout
);

reg         signed  [47:0]  delay_temp[REG_GLOBAL_LIMIT-1:0]; 
reg                 [8:0]   i; //9bits
reg         signed  [47:0]  trapezd_alg_temp;

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_alg_temp <= 48'd0;
        for(i=0; i<REG_GLOBAL_LIMIT; i=i+1) begin
            delay_temp[i] <= 48'd0;
        end
    end
    else begin
        delay_temp[0] <= trapezd_alg_m3_datain;
        for(i=0; i<REG_GLOBAL_LIMIT-1; i=i+1) begin
            delay_temp[i+1] <= delay_temp[i];
        end
        trapezd_alg_temp <=  trapezd_alg_m3_datain - delay_temp[na-1];
    end
end

wire        signed  [31:0]  trapezd_alg_truncated;
wire        carry_bit;

assign  carry_bit = trapezd_alg_temp[47] ? (trapezd_alg_temp[15] & (|trapezd_alg_temp[14:0])) : trapezd_alg_temp[15];
assign  trapezd_alg_truncated = trapezd_alg_temp[47:16] + carry_bit;

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_alg_m4_dataout <= 17'd0;
    end
    else if(trapezd_alg_truncated > 65535) begin
        trapezd_alg_m4_dataout <= 65535;
    end
    else if(trapezd_alg_truncated < -65536) begin
        trapezd_alg_m4_dataout <= -65536;
    end
    else trapezd_alg_m4_dataout <= trapezd_alg_truncated[16:0];
end

endmodule
