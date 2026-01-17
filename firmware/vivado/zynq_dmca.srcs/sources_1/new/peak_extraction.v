`timescale 1ns / 1ps
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve
// 
// Create Date: 2025/02/17
// Design Name: 
// Module Name: peak_extraction
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
//////////////////////////////////////////////////////////////////////////////////


module peak_extraction
(
    input                       sys_clk, sys_rstn,
    input       signed  [16:0]  trapezd_alg_datain,
    input       signed  [16:0]  trapezd_baseline,
    input                       peak_start_flag,
    input                       stacking_flag,
    
    output  reg                 peak_value_ok,
    output              [13:0]  peak_true_value,
    //parameter input
    //Calculate the delay before taking the mean of the flat top to ensure stable flat top:
    input               [7:0]   peakext_delay_time
);

parameter                   PEAK_AVR_POINT = 32;//Cannot be changed in real-time
parameter                   OTR_DELAY = 60;

localparam integer          divide = clogb2(PEAK_AVR_POINT - 1); //function

//FSM
parameter                   WAIT = 3'd0,
                            DELAY = 3'd1,
                            ACC = 3'd2,
                            BASELINE = 3'd3,
                            PILE_UP = 3'd4;
                            
reg                 [7:0]   status; // FSM State transition register
reg                         stacking_flag_front; //The stacking situation of the previous pulse
reg         signed  [16:0]  peak_value_front, true_value_front;
reg                 [9:0]   delay_count;
reg         signed  [63:0]  flat_sum; // Sum of flat top points
reg                         peak_start_flag_delay;
reg         signed  [14:0]  peak_value;
reg                 [7:0]   i;

assign peak_true_value = peak_value[13:0];

// The starting signal of the peak is delayed by one cycle 
//  and aligned with the stacked signal
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        peak_start_flag_delay <= 1'b0;
    end
    else begin
        peak_start_flag_delay <= peak_start_flag;
    end
end

//FSM
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        status <= 8'd0;
        peak_value_ok <= 1'b0;
        stacking_flag_front <= 1'b0;
        peak_value <= 15'd0;
        delay_count <= 10'd0;
        flat_sum <= 64'd0;
        peak_value_front <= 17'd0;
        true_value_front <= 17'd0;
    end
    else begin
        case (status)
            WAIT: begin
                if(peak_start_flag_delay&(~stacking_flag)&(~stacking_flag_front)) begin
                    status <= DELAY;                //The previous & current signal is not stacked
                    peak_value_ok <= 1'b1;
                    peak_value <= true_value_front[14:0]; //The previous signal can be output
                    stacking_flag_front <= stacking_flag;
                end
                else if(peak_start_flag_delay&(~stacking_flag)&stacking_flag_front) begin
                    status <= DELAY;                //The current signal is not stacked, but not the previous
                    peak_value_ok <= 1'b0;
                    peak_value <= 15'd0;            //The previous signal can not be output
                    true_value_front <= 17'd0;
                    stacking_flag_front <= stacking_flag;
                end
                else if(peak_start_flag_delay&stacking_flag) begin
                    status <= WAIT;                 //The current signal is stacked with the previous signal
                    peak_value_ok <= 1'b0;
                    peak_value_front <= 17'd0;
                    peak_value <= 15'd0; 
                    true_value_front <= 17'd0;
                    stacking_flag_front <= stacking_flag;
                end
            end
            DELAY: begin
                peak_value_ok <= 1'b0;
                if(peak_start_flag_delay&stacking_flag) begin //At any time, once stacking occurs, it needs to be dealt with as soon as possible
                    status <= PILE_UP;
                    stacking_flag_front <= stacking_flag;
                end
                else if(delay_count==peakext_delay_time) begin   //Waiting for the trapezoid to reach a stable flat top
                    delay_count <= 10'd0;
                    status <= ACC;
                end
                else begin
                    delay_count <= delay_count + 1'b1;
                end
            end
            ACC: begin
                if(peak_start_flag_delay&stacking_flag) begin //Highest priority
                    status <= PILE_UP;
                    stacking_flag_front <= stacking_flag;
                end
                else if(delay_count==PEAK_AVR_POINT) begin
                    peak_value_front <= flat_sum >> divide;
                    flat_sum <= 64'd0;
                    status <= BASELINE;
                    delay_count <= 10'd0;
                end
                else begin
                    flat_sum <= flat_sum + trapezd_alg_datain;
                    delay_count <= delay_count + 1'b1;
                end
            end
            BASELINE: begin
                if(peak_start_flag_delay&stacking_flag) begin //Highest priority
                    status <= PILE_UP;
                    stacking_flag_front <= stacking_flag;
                end
                else if(peak_value_front < trapezd_baseline) begin      //Determine whether the peak has overflowed
                    true_value_front <= 262143 + peak_value_front - trapezd_baseline;
                    status <= WAIT;
                end 
                else begin
                    true_value_front <= peak_value_front - trapezd_baseline;
                    status <= WAIT;
                end
            end
            PILE_UP: begin
                status <= WAIT;
                peak_value_ok <= 1'b0;
                peak_value <= 15'd0;
                delay_count <= 10'd0;
                flat_sum <= 64'd0;
                peak_value_front <= 17'd0;
                true_value_front <= 17'd0;
            end
            default: begin
                status <= 8'd0;
                peak_value_ok <= 1'b0;
                stacking_flag_front <= 1'b0;
                peak_value <= 15'd0;
                delay_count <= 10'd0;
                flat_sum <= 64'd0;
                peak_value_front <= 17'd0;
                true_value_front <= 17'd0;
            end
        endcase
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
