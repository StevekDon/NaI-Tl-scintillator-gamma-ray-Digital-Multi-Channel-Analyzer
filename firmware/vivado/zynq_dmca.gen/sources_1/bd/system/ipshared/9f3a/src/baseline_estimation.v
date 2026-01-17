`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  SINAP / SARI
// Engineer: Steve Don
// 
// Create Date:  2025/05/14
// Design Name: 
// Module Name: baseline_estimation
// Project Name: 
// Target Devices: 
// Tool Versions:  v0.1.2
// Description: 
// 
// Dependencies: 
// 
// Revision: 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module baseline_estimation
(
    input                       sys_clk, sys_rstn,
    input                       peak_start_flag,
    input       signed  [16:0]  trapezd_alg_datain,
    output  reg signed  [16:0]  trapezd_baseline,
    //parameter input
    input               [9:0]   na, nb
);

parameter                   REG_GLOBAL_LIMIT = 300;

 //Finding the number of digits that need to be shifted right for the average (division) 
localparam                  BASELINE_AVR_POINT = 8; // Baseline average points
localparam integer          divide = clogb2(BASELINE_AVR_POINT - 1); //function
localparam integer          EXTRA_CONS = 8;

reg                 [9:0]   i; //for Loop index
reg         signed  [16:0]  delay_temp_trapezd[REG_GLOBAL_LIMIT + BASELINE_AVR_POINT + EXTRA_CONS - 1:0]; //416 regs MAX
reg                 [9:0]   interval_count;
reg                 [31:0]  trapezd_baseline_reg;
reg                 [9:0]   interval_time_reg;

wire                        trig_flag;
wire                [9:0]   interval_time; //Peak spacing, distance from peak tail to peak head
wire        signed  [31:0]  add_temp_trapezd;

assign interval_time = nb + na + BASELINE_AVR_POINT + EXTRA_CONS;

//Perform a shift delay because the trapezoidal formation has already occurred simultaneously when the 
//system conveys the peak start signal, and it is necessary to delay it to obtain the baseline mean 
//before the trapezoidal formation begins

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        for(i=0; i<(REG_GLOBAL_LIMIT + BASELINE_AVR_POINT + EXTRA_CONS - 1'b1); i=i+1'b1) begin
            delay_temp_trapezd[i] <= 17'd0;
        end
    end
    else begin
        delay_temp_trapezd[0] <= trapezd_alg_datain;
        for(i=0; i<(REG_GLOBAL_LIMIT + BASELINE_AVR_POINT + EXTRA_CONS - 1'b1); i=i+1'b1) begin //Perform data shift
            delay_temp_trapezd[i+1] <= delay_temp_trapezd[i];
        end
    end
end

assign add_temp_trapezd = delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 0] + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 1]
                        + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 2] + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 3]
                        + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 4] + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 5]
                        + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 6] + delay_temp_trapezd[na + EXTRA_CONS + BASELINE_AVR_POINT - 7];

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_baseline_reg <= 32'd0;
        interval_time_reg <= 10'd0;
    end
    else begin
        trapezd_baseline_reg <= add_temp_trapezd;
        interval_time_reg <= interval_time;
    end
end

// When the distance between the two trapezoidal pulses is insufficient to extract the baseline, maintain it        
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        trapezd_baseline <= 17'd0;
    end
    else if(peak_start_flag & (interval_count >= interval_time_reg)) begin
        trapezd_baseline <= trapezd_baseline_reg >> divide;
    end
    else if(peak_start_flag & (interval_count < interval_time_reg)) begin
        trapezd_baseline <= trapezd_baseline;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        interval_count <= 10'd0;
    end
    else if(peak_start_flag) begin
        interval_count <= 10'd0;
    end
    else if(interval_count >= interval_time_reg) begin
        interval_count <= interval_time_reg;
    end
    else begin
        interval_count <= interval_count + 1'b1;
    end
end

// function called clogb2 that returns an integer which has the 
// value of the ceiling of the log base 2.                      
function integer clogb2 (input integer bit_depth);              
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction 

endmodule