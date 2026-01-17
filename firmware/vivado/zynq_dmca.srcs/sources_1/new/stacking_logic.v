`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve
// 
// Create Date: 2025/05/14
// Design Name: 
// Module Name: stacking_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: v0.1.1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stacking_logic
(
    input                       sys_clk, sys_rstn,
    input                       peak_start_flag,
    output  reg                 stacking_flag,
    //Parameter input
    input               [9:0]   nb
);

reg                 [9:0]   interval_count;  // Delay point counter
/*The minimum peak stacking interval, which is the minimum interval between two pulses 
that can be distinguished in trapezoidal forming*/

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        interval_count <= nb;
    end
    else if(peak_start_flag) begin
        interval_count <= 10'd0;
    end
    else if(interval_count >= nb) begin
        interval_count <= nb;
    end
    else begin
        interval_count <= interval_count + 1'b1;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        stacking_flag <= 1'b0;
    end
    else if((interval_count < nb - 1'b1) & peak_start_flag) begin
        stacking_flag <= 1'b1;
    end
    else begin
        stacking_flag <= 1'b0;
    end
end

endmodule
