`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/01/20 17:25:28
// Design Name:
// Module Name: spectrum_ram
// Project Name:
// Target Devices:
// Tool Versions:
// Description: The main function of the BRAM module is to form an energy spectrum by adding 1 to the corresponding peak channel address,
//              and the data reading logic is provided by external modules (interface reserved)
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module spectrum
(
    //GLOBAL CLK & RSTN
    input                       M_AXIS_ACLK,
    input                       M_AXIS_ARESETN,
    //Peak information input
    input                       sys_rstn,
    input                       spaxis_en,
    input                       peak_value_ok,
    input               [13:0]  peak_value,
    //S2MM PORT
    output  wire                M_AXIS_TVALID,
    output  wire        [31:0]  M_AXIS_TDATA ,
    output  wire                M_AXIS_TLAST ,
    input   wire                M_AXIS_TREADY
);

wire                [31:0]  dataouta;
wire                [31:0]  read_data;
wire                [13:0]  read_pointer;

reg                 [15:0]  clear_count;
reg                 [1:0]   clear_state;
reg                         ena, wea;
reg                 [13:0]  peak_addr;
reg                 [31:0]  dataina;
reg                 [2:0]   state; //FSM state transition register

localparam                  IDLE = 3'd0,
                            DELAY1 = 3'd1,
                            DELAY2 = 3'd2,
                            RW = 3'd3,
                            RST = 3'd4;


blk_mem_gen_1 spectrum_bram  //32bit width - 16384 depth
(
  //PORT A RW
  .clka(M_AXIS_ACLK),            // input wire clka
  .ena(ena),              // input wire ena
  .wea(wea),              // input wire [0 : 0] wea
  .addra(peak_addr),          // input wire [13 : 0] addra
  .dina(dataina),            // input wire [31 : 0] dina
  .douta(dataouta),          // output wire [31 : 0] douta
  //PORT B RO
  .clkb(M_AXIS_ACLK),            // input wire clkb
  .enb(1'b1),              // input wire enb
  .web(1'b0),              // input wire [0 : 0] web
  .addrb(read_pointer),          // input wire [13 : 0] addrb
  .dinb(32'b0),            // input wire [31 : 0] dinb
  .doutb(read_data)          // output wire [31 : 0] doutb
);

bram2axis #
(
    .C_M_AXIS_TDATA_WIDTH(32),
    .C_M_START_COUNT(64),
    .NUMBER_OF_OUTPUT_WORDS(16384)
)   axi4stream_dma_read
(
    .M_AXIS_ACLK        (M_AXIS_ACLK),
    .M_AXIS_ARESETN     (M_AXIS_ARESETN),
    .M_AXIS_TVALID      (M_AXIS_TVALID),
    .M_AXIS_TDATA       (M_AXIS_TDATA),
    .M_AXIS_TLAST       (M_AXIS_TLAST),
    .M_AXIS_TREADY      (M_AXIS_TREADY),
    .read_pointer       (read_pointer),
    .read_data          (read_data)
);

//Forming energy spectrum in BRAM based on input peak information
always@(posedge M_AXIS_ACLK)
begin
    if(!sys_rstn) begin //Power on reset only
        state <= 3'd0;
        ena <= 1'b0;                //PORT A ENALBE
        wea <= 1'b0;                //PORT A W/R Mode
        peak_addr <= 14'd0;         //addra 0~16383 2^14
        dataina <= 14'd0;
        //bram reset
        clear_count <= 16'd0;
        clear_state <= 2'd0;
    end
    else if(!spaxis_en) begin   //Overwrite BRAM value at the end of measurement, reset
        case (clear_state)
        2'd0: begin                 //Enable PORT A with a delay of one cycle
            clear_state <= 2'd1;
            ena <= 1'b1;
            wea <= 1'b1;
            dataina <= 14'd0;
            peak_addr <= 14'd0;
        end
        2'd1: begin
            if(clear_count==16383) begin
                clear_count <= 16'd0;
                clear_state <= 2'd2;
            end
            else begin
                clear_count <= clear_count + 1'b1;
                peak_addr <= clear_count;
            end
        end
        2'd2, 2'd3: begin
            clear_state <= clear_state; //Perform zero setting only once, wait here after completion
            //Disabled PORT A
            ena <= 1'b0;
            wea <= 1'b0;
            dataina <= 14'd0;
            peak_addr <= 14'd0;
        end
        endcase
    end
    else begin
        case (state)
            IDLE: begin
                clear_state <= 2'd0;
                if(peak_value_ok) begin
                    state <= DELAY1;
                    peak_addr <= peak_value;        //cache the peak_value
                    dataina <= 32'd0;               // rst the writing data
                    ena <= 1'b1;            //start up the bram port A
                    wea <= 1'b0;            //Read Mode 1st;
                end
                else begin
                    state <= state;
                end
            end
            DELAY1: begin                    //Delay by one clock cycle and wait for BRAM to read the data
                state <= DELAY2;
            end
            DELAY2: begin                    //Delay by one clock cycle and wait for BRAM to read the data
                state <= RW;
            end
            RW: begin
                dataina <= dataouta + 1'b1;
                wea <= 1'b1;
                state <= RST;
            end
            RST: begin
                ena <= 1'b0;
                wea <= 1'b0;
                peak_addr <= 14'd0;
                dataina <= 32'd0;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
                ena <= 1'b0;                //PORT A ENALBE
                wea <= 1'b0;                //PORT A W/R Mode
                peak_addr <= 14'd0;         //addra 0~16383 2^14
                dataina <= 32'd0;
            end
        endcase
    end
end

endmodule
