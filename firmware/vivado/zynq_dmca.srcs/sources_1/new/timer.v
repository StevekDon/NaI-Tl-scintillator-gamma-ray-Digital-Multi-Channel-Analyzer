`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/05/30 13:03:09
// Design Name: 
// Module Name: timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timer
#(
    parameter   CLK_FREQ_MHZ  = 80
)
(
    //GLOBAL CLK & RSTN
    input                       sys_clk,
    input                       sys_rstn,
    input                       ram_reset_flag,
    
    output  reg         [31:0]  timer_counter 
);

localparam CNT_MAX = (CLK_FREQ_MHZ * 1000) - 1;
localparam CNT_WIDTH = clogb2(CNT_MAX);

reg     [CNT_WIDTH-1:0] div_counter;

//ms pulse generator
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        div_counter <= {CNT_WIDTH{1'b0}};
    end
    else if (div_counter == CNT_MAX) begin
        div_counter <= {CNT_WIDTH{1'b0}};
    end
    else if(!ram_reset_flag) begin
        div_counter <= div_counter + 1'b1;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        timer_counter <= 32'd0;
    end
    else if(div_counter == CNT_MAX) begin
        timer_counter <= timer_counter + 1'b1;
    end
end

function integer clogb2 (input integer bit_depth);
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction 

endmodule
