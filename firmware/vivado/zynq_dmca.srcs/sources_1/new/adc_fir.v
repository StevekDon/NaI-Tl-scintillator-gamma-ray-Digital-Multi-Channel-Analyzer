`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Steve Don
// 
// Create Date: 2025/05/06
// Design Name: 
// Module Name: adc_fir
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adc_fir
(
    input               sys_clk, sys_rstn,
    
    input       [13:0]  adc_datain,
    
    output      [13:0]  adc_fir_dataout
);

wire            [39:0]  adc_fir_raw;

assign adc_fir_dataout = adc_fir_raw[15] ? (adc_fir_raw[30:17] + 1'b1) : adc_fir_raw[30:17];

fir_compiler_0 m0 
(
  .aclk(sys_clk),                               // input wire aclk
  .aresetn(sys_rstn),    
  .s_axis_data_tvalid(1'b1),                    // input wire s_axis_data_tvalid
  .s_axis_data_tready(),                        // output wire s_axis_data_tready
  .s_axis_data_tdata({2'd0, adc_datain}),       // input wire [15 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(),                        // output wire m_axis_data_tvalid
  .m_axis_data_tdata(adc_fir_raw)               // output wire [39 : 0] m_axis_data_tdata
);

endmodule
