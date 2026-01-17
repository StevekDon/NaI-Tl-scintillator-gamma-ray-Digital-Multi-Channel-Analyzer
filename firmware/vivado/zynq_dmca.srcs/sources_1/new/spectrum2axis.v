`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINAP / SARI
// Engineer: Steve
// 
// Create Date: 2025/05/15 11:00:24
// Design Name: 
// Module Name: spectrum2axis
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


module spectrum2axis
#(
    parameter   DEPTH           = 16384,
    parameter   WIDTH           = 32,
    parameter   ADDR_W          = 14,
    parameter   CLK_FREQ_MHZ    = 80
)
(
    //GLOBAL CLK & RSTN
    input                           sys_clk,
    input                           M_AXIS_ARESETN,
    //Peak information input
    input                           sys_rstn,
    input                           peak_value_ok,
    input           [ADDR_W-1:0]    peak_value,
    //S2MM PORT
    output                          M_AXIS_TVALID,
    output          [WIDTH-1:0]     M_AXIS_TDATA ,
    output                          M_AXIS_TLAST ,
    input                           M_AXIS_TREADY,
    
    output          [31:0]          timer_counter
);

localparam                  IDLE  = 5'b00001,
                            READ0 = 5'b00010,
                            READ1 = 5'b00100,
                            READ2 = 5'b01000,
                            WRITE = 5'b10000;
reg             [4:0]       current_state, next_state;
                                                                                 
reg             [WIDTH - 1:0]   dia, dib;
reg             [ADDR_W - 1:0]  addra, addrb;
reg                             ena, enb;
reg                             wea, web;

wire            [WIDTH - 1:0]   doa, dob;
wire            [ADDR_W - 1:0]  read_pointer, addrb_comb;

assign addrb_comb = (ram_reset_flag) ? addrb : read_pointer;

dual_port_ram 
#(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH),
    .ADDR_W(ADDR_W)
) spectrum_ram
(
    .sys_clk    (sys_clk),
    .ena        (ena),
    .wea        (wea),
    .enb        (enb), 
    .web        (web),
    .addra      (addra), 
    .addrb      (addrb_comb),
    .dia        (dia), 
    .dib        (dib),
    .doa        (doa), 
    .dob        (dob)
);
/*
ram2axis #(
    .C_M_AXIS_TDATA_WIDTH   (WIDTH),
    .C_M_START_COUNT        (32),
    .NUMBER_OF_OUTPUT_WORDS (DEPTH)
) u1
(
    .M_AXIS_ACLK        (sys_clk),
    .M_AXIS_ARESETN     (M_AXIS_ARESETN),
    .M_AXIS_TVALID      (M_AXIS_TVALID),
    .M_AXIS_TDATA       (M_AXIS_TDATA),
    .M_AXIS_TLAST       (M_AXIS_TLAST),
    .M_AXIS_TREADY      (M_AXIS_TREADY),
    .ram_addr           (read_pointer),
	.ram_data           (dob)
);
*/
ram2axis_skid
#(
    .DEPTH      (DEPTH),
    .DATA_WIDTH (WIDTH),
    .ADDR_W     (ADDR_W)
) u1
(
    .sys_clk        (sys_clk),
    .sys_rstn       (M_AXIS_ARESETN),

    .m_axis_tdata   (M_AXIS_TDATA),
    .m_axis_tvalid  (M_AXIS_TVALID),
    .m_axis_tready  (M_AXIS_TREADY),
    .m_axis_tlast   (M_AXIS_TLAST),

    .read_pointer   (read_pointer),
    .ram_data       (dob)
);

timer
#(
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
) ms_timer
(
    .sys_clk            (sys_clk),
    .sys_rstn           (sys_rstn),
    .ram_reset_flag     (ram_reset_flag),
    .timer_counter      (timer_counter) 
);

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
always @(*) begin
    next_state = current_state;
    case (current_state)
        IDLE: begin 
            if(peak_value_ok && (!ram_reset_flag)) next_state = READ0; // Detected effective amplitude data input, enable & set addra
            else next_state = IDLE;
        end
        READ0: next_state = READ1;  // RAM porta is enabled and read addra
        READ1: next_state = READ2;  // RAM porta gives a effective data
        READ2: next_state = IDLE;   // write done
        default: next_state = IDLE;
    endcase
end

//FSM main logic
always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        ena <= 1'b0;
        wea <= 1'b0;
        addra <= {ADDR_W{1'b0}};
        dia <= {WIDTH{1'b0}};
    end
    else begin
        case (current_state)
            IDLE: begin
                ena <= 1'b0;
                wea <= 1'b0;
                addra <= {ADDR_W{1'b0}};
            end 
            READ0:begin         //start to read, enable
                ena <= 1'b1;
                wea <= 1'b0;
                addra <= peak_value;
            end
            READ1: begin
                ena <= 1'b1;
                wea <= 1'b0;
                addra <= peak_value;
            end
            READ2: begin        //read data
                dia <= doa + 1'b1;
                wea <= 1'b1;
            end
            default: begin
                ena <= 1'b0;
                wea <= 1'b0;
                addra <= {ADDR_W{1'b0}};
                dia <= {WIDTH{1'b0}};
            end
        endcase
    end
end

//Reset RAM in batches through global reset
reg                             ram_reset_flag;

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        ram_reset_flag <= 1'b1;
    end
    else if(addrb == DEPTH - 1'b1) begin
        ram_reset_flag <= 1'b0;
    end
    else begin
        ram_reset_flag <= ram_reset_flag;
    end
end

always@(posedge sys_clk)
begin
    if(!sys_rstn) begin
        web <= 1'b1;
        enb <= 1'b1;
        dib <= {WIDTH{1'b0}};
        addrb <=  {ADDR_W{1'b0}};
    end
    else if(ram_reset_flag) begin
        if(addrb < DEPTH - 1'b1) begin
            addrb <= addrb + 1'b1;
            dib <= dib + 1'b1;
        end
        else begin
            addrb <= DEPTH - 1'b1;
        end
    end
    else begin
        web <= 1'b0;
        addrb <= {ADDR_W{1'b0}};
    end
end


endmodule
