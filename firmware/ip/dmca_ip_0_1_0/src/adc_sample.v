`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Steve Don
// 
// Create Date: 2025/02/17 11:35:16
// Design Name: data sample for 14bit adc
// Module Name: adc_sample
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//        A high-speed ADC sampling frontend module for 14 bit, complement form output
// Dependencies: 
// 
// Revision: ver0.1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adc_sample
#(
    parameter   ADC_BIT = 14
)
(
    input                              sys_clk, sys_rstn,
    input       signed  [ADC_BIT-1:0]  adc_datain,
    
    output  reg         [ADC_BIT-1:0]  adc_dataout
);

reg                     [ADC_BIT-1:0]  adc_data_temp[1:0]; 

always @(posedge sys_clk) begin
    if (!sys_rstn) begin
        adc_data_temp[0] <= {ADC_BIT{1'b0}};
        adc_data_temp[1] <= {ADC_BIT{1'b0}};
        adc_dataout <= {ADC_BIT{1'b0}};
    end 
    else begin
        adc_data_temp[0] <= adc_datain  + (1 << (ADC_BIT - 1));
        adc_data_temp[1] <= adc_data_temp[0];
        adc_dataout <= adc_data_temp[1];
    end
end

endmodule

