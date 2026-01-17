`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/05/14
// Design Name: 
// Module Name: peak_logic
// Project Name: 
// Target Devices: zynq7020, zynq7010
// Tool Versions: vivado 2022.2
// Description: Find the peak value of the triangulation algorithm, where the median of the three values is 
//              greater than the values on both sides, and increase the threshold judgement to avoid 
//              the influence of noise.
// Dependencies: 
// 
// Revision: v0.1.1
// Revision 1.0 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////


module peak_logic
(
    input                       sys_clk, sys_rstn,
    input       signed  [16:0]  triangle_alg_data,
    output  reg                 peak_start_flag,
    //Peak finding threshold
    input               [9:0]   na,
    input       signed  [15:0]  peak_threshold,
    input               [7:0]   peak_threshold_count  
);

reg         signed  [16:0]  triangle_data_temp[2:0];
reg                 [9:0]   interval_count;
reg                 [9:0]   threshold_count;

//Record consecutive counts greater than the threshold
//The counter will only accumulate when the data is continuously greater than the set value
always@(posedge sys_clk) begin  
    if(!sys_rstn) begin
        threshold_count <= 10'd0;
    end
    else if(triangle_alg_data >= peak_threshold) begin
        if(threshold_count >= 11'd1023) begin       //Prevent overflow
            threshold_count <= threshold_count;
        end
        else begin
            threshold_count <= threshold_count + 1'b1;
        end
    end
    else begin
        threshold_count <= 10'd0;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        triangle_data_temp[0] <= 17'd0;
        triangle_data_temp[1] <= 17'd0;
        triangle_data_temp[2] <= 17'd0;
    end
    else begin
        triangle_data_temp[0] <= triangle_alg_data;
        triangle_data_temp[1] <= triangle_data_temp[0];
        triangle_data_temp[2] <= triangle_data_temp[1];
    end
end

//Pulse start position judgment logic
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        peak_start_flag <= 1'd0;
        interval_count <= 9'd0;
    end
    //Continuous multiple points must meet threshold requirements to avoid noise triggering errors
    else if((triangle_data_temp[1] >= triangle_data_temp[0])&
            (triangle_data_temp[1] >= triangle_data_temp[2])& // determine the nearest maximum point
            (triangle_data_temp[1] >= peak_threshold)&  //greater than the set threshold
            (threshold_count >= peak_threshold_count)& //greater than the set continuous count value
            (interval_count >= na))begin
        peak_start_flag <= 1'd1;
        interval_count <= 9'd0;
    end
    else begin
        peak_start_flag <= 1'd0;
        //Eliminate multiple triggers that may occur in a short period of time
        if(interval_count >= na) interval_count <= na;
        else interval_count <= interval_count + 1'b1;
    end
end

endmodule
