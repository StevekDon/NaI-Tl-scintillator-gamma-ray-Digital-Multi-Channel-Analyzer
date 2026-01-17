`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve
// 
// Create Date: 2025/05/15 16:52:12
// Design Name: 
// Module Name: peak_calculation
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


module peak_calculation
#(
    parameter   ADC_BIT          = 14
)
(
    input                       sys_clk, sys_rstn,
    input       signed  [16:0]  trapezd_alg_datain,
    input       signed  [16:0]  trapezd_baseline,
    input                       peak_start_flag,
    input                       stacking_flag,
    
    output  reg                         peak_value_ok,
    output  reg         [ADC_BIT-1:0]   peak_value,
    //parameter input
    //Calculate the delay before taking the mean of the flat top to ensure stable flat top:
    input               [7:0]   peakext_delay_time
);

localparam              PEAK_AVR_POINT = 16;
localparam              DIVIDE = clogb2(PEAK_AVR_POINT - 1);
parameter               IDLE        = 6'b000001,
                        OUT         = 6'b000010,
                        DELAY       = 6'b000100,
                        ACC         = 6'b001000,
                        CALC        = 6'b010000,
                        PILE_UP     = 6'b100000;
reg             [5:0]   current_state, next_state;      

reg                     stacking_flag_front;
reg     signed  [16:0]  peak_value_front;
reg             [7:0]   delay_count;
reg             [5:0]   acc_count;
reg     signed  [63:0]  peak_sum;

//FSM state transfer
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

//FSM state transfer logic
always@(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: begin 
            if(peak_start_flag) next_state = OUT;
            else next_state = IDLE;
        end
        OUT: begin
            if(stacking_flag) next_state = IDLE;
            else next_state = DELAY;
        end
        DELAY: begin
            if(stacking_flag)  next_state = PILE_UP;
            else if(delay_count == peakext_delay_time) next_state = ACC;
            else next_state = DELAY;
        end
        ACC: begin
            if(stacking_flag)  next_state = PILE_UP;
            else if(acc_count == PEAK_AVR_POINT) next_state = CALC;
            else next_state = ACC;
        end
        CALC: begin
            if(stacking_flag)  next_state = PILE_UP;
            else next_state = IDLE;
        end
        PILE_UP: begin
            next_state = IDLE;
        end
        default: next_state = IDLE;
    endcase
end

//FSM main logic
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        peak_value_ok <= 1'b0;
        peak_value <= {ADC_BIT{1'b0}};
        peak_value_front <= 17'd0;
        stacking_flag_front <= 1'b0;
        delay_count <= 8'd0;
        acc_count <= 6'd0;
        peak_sum <= 64'd0;
    end
    else begin
        case (current_state)
            IDLE: begin
                peak_value_ok <= 1'b0;
                peak_sum <= 64'd0;
                acc_count <= 6'd0;
                delay_count <= 8'd0;
            end
            OUT: begin
                if(stacking_flag) begin // Stacking currently occurs, and the previous value is not output
                    peak_value <= {ADC_BIT{1'b0}};
                    peak_value_front <= 17'd0;
                    peak_value_ok <= 1'b0;
                end
                else if(stacking_flag_front) begin // The previous value is stacked, and the previous value is not output
                    peak_value <= {ADC_BIT{1'b0}};
                    peak_value_front <= 17'd0;
                    peak_value_ok <= 1'b0;
                end
                else begin // No stacking status, output the previous value
                    peak_value_ok <= 1'b1;
                    peak_value <= peak_value_front[ADC_BIT-1:0];
                end
                stacking_flag_front <= stacking_flag;
            end 
            DELAY: begin
                peak_value_ok <= 1'b0;
                delay_count <= delay_count + 1'b1;
                stacking_flag_front <= stacking_flag;
            end
            ACC: begin
                if(acc_count == PEAK_AVR_POINT) begin
                    peak_value_front <= peak_sum >> DIVIDE;
                end
                else begin
                    peak_sum <= peak_sum + trapezd_alg_datain;
                    acc_count <= acc_count + 1'b1;
                end
                stacking_flag_front <= stacking_flag;
            end
            CALC: begin
                /*
                if(peak_value_front < trapezd_baseline) begin      //Determine whether the peak has overflowed
                    peak_value_front <= 262143 + peak_value_front - trapezd_baseline;
                end 
                else begin
                    peak_value_front <= peak_value_front - trapezd_baseline;
                end
                */
                peak_value_front <= peak_value_front - trapezd_baseline;
                stacking_flag_front <= stacking_flag;
            end
            PILE_UP: begin
                stacking_flag_front <= stacking_flag;
                peak_value_ok <= 1'b0;
                peak_value <= {ADC_BIT{1'b0}};
                delay_count <= 10'd0;
                peak_sum <= 64'd0;
                acc_count <= 6'd0;
                peak_value_front <= 17'd0;
            end
        default: begin
            peak_value_ok <= 1'b0;
            peak_value <= {ADC_BIT{1'b0}};
            peak_value_front <= 17'd0;
            stacking_flag_front <= 1'b0;
            delay_count <= 8'd0;
            acc_count <= 6'd0;
            peak_sum <= 64'd0;
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
