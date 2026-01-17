`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/30 11:02:35
// Design Name: 
// Module Name: tb_test
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


module tb_test();

reg         sys_clk, sys_rstn;
reg [13:0]  data;

trapezd_alg_m1
#(
    .REG_GLOBAL_LIMIT(400),
    .ADC_BIT(14)
) dut0
(
    .sys_clk                (sys_clk), 
    .sys_rstn               (sys_rstn),
    .adc_datain             (data),
    .nb                     (50),
    .trapezd_alg_m1_dataout ()
);

initial begin
    sys_clk = 0;
    forever #10 sys_clk = ~sys_clk;
end

initial begin
    sys_rstn = 0;
    data = 14'd16383;
    
    #100; 
    sys_rstn = 1;
    
    #2000;
    data = 14'd0;               
end

endmodule
