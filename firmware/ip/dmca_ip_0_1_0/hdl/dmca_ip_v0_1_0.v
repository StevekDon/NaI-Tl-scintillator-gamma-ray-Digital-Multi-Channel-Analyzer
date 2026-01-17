`timescale 1 ns / 1 ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  SINAP / SARI
// Engineer: Steve Don
// 
// Create Date: 2025/06/04
// Design Name: 
// Module Name: dmca_top
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

module dmca_ip_v0_1_0 #
(
    // for axi-lite register ctrl
	parameter integer C_S00_AXI_DATA_WIDTH	= 32,
	parameter integer C_S00_AXI_ADDR_WIDTH	= 5,
	// for axi-dma port
    parameter   AXISTREAM_DATA_W    = 32,
    //for algorithm parameters
    parameter   REG_GLOBAL_LIMIT    = 300,
    parameter   ADC_BIT             = 14,
    parameter   CLK_FREQ_MHZ        = 80
)
(
    input                               sys_clk, sys_rstn,
    input       signed  [ADC_BIT-1:0]   adc_datain,
	output              [ADC_BIT-1:0]   adc_dataout,
	input               [ADC_BIT-1:0]   adc_fir_datain,
	output      signed  [16:0]          trapezd_data,
	output      signed  [16:0]          triangle_data,
	output                              adc_pwr_en,
    //AXI4Lite Slave Bus interface Register Ctrl
	input  wire         [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input  wire         [2 : 0] s00_axi_awprot,
	input  wire                        s00_axi_awvalid,
	output wire                        s00_axi_awready,
	input  wire         [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input  wire         [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input  wire                        s00_axi_wvalid,
	output wire                        s00_axi_wready,
	output wire         [1 : 0]        s00_axi_bresp,
	output wire                        s00_axi_bvalid,
	input  wire                        s00_axi_bready,
	input  wire         [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input  wire         [2 : 0]        s00_axi_arprot,
	input  wire                        s00_axi_arvalid,
	output wire                        s00_axi_arready,
	output wire         [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire         [1 : 0]        s00_axi_rresp,
	output wire                        s00_axi_rvalid,
	input  wire                        s00_axi_rready,
	//AXI4Sream Master Bus interface DMA S2MM PORT
	output  wire                                M_AXIS_TVALID,
	output  wire        [AXISTREAM_DATA_W-1:0]  M_AXIS_TDATA ,
	output  wire                                M_AXIS_TLAST ,
	input   wire                                M_AXIS_TREADY,
	//AXI - DMA  s2mm_prmry_reset_out_n
	input   wire                                M_AXIS_ARESETN
);

wire                           peak_value_ok;
wire            [ADC_BIT-1:0]  peak_value;
wire            [31:0]         timer_counter;
//register ctrl signals
wire            [15:0]         na, nb;
wire            [15:0]         na_1, d_na;
wire            [15:0]         peak_thd;
wire            [7:0]          peak_thd_count;
wire            [7:0]          peak_top_delay;
wire                           ms_en, alg_en;

wire global_rstn = sys_rstn & alg_en;

adc_sample 
#(
    .ADC_BIT(ADC_BIT)
) m0
(
    .sys_clk        (sys_clk), 
    .sys_rstn       (global_rstn),
    .adc_datain     (adc_datain),

    .adc_dataout    (adc_dataout)
);

dmca_algorithm_top 
#(
    .REG_GLOBAL_LIMIT(REG_GLOBAL_LIMIT),
    .ADC_BIT(ADC_BIT)
)m1
(
    .sys_clk                (sys_clk), 
    .sys_rstn               (global_rstn),
    
    .adc_datain             (adc_fir_datain),
    
    .peak_threshold         (peak_thd),
    .peak_threshold_count   (peak_thd_count),
    .na                     (na), 
    .nb                     (nb),
    .na_1                   (na_1), 
    .d_na                   (d_na),
    .peakext_delay_time     (peak_top_delay),
    
    .peak_value_ok          (peak_value_ok),
    .peak_value             (peak_value),
    .trapezd_data           (trapezd_data),
    .triangle_data          (triangle_data)
);

spectrum2axis 
#(
    .DEPTH      (1<<ADC_BIT),
    .WIDTH      (AXISTREAM_DATA_W),
    .ADDR_W     (ADC_BIT),
    .CLK_FREQ_MHZ(CLK_FREQ_MHZ)
)m2
(
    .sys_clk            (sys_clk),
    .M_AXIS_ARESETN     (M_AXIS_ARESETN),
    .sys_rstn           (global_rstn),
    .peak_value_ok      (peak_value_ok),
    .peak_value         (peak_value),
    
    .M_AXIS_TVALID      (M_AXIS_TVALID),
    .M_AXIS_TDATA       (M_AXIS_TDATA),
    .M_AXIS_TLAST       (M_AXIS_TLAST),
    .M_AXIS_TREADY      (M_AXIS_TREADY),
    
    .timer_counter      (timer_counter),
    .ms_en              (ms_en)
);

wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg0;
wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg1;
wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg2;
wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg3;
wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg4;

assign adc_pwr_en = op_reg0[0];
assign ms_en = op_reg0[1];
assign alg_en = op_reg0[2];

assign na = op_reg1[15:0];
assign nb = op_reg1[C_S00_AXI_DATA_WIDTH-1:16];
assign na_1 = op_reg2[15:0];
assign d_na = op_reg2[C_S00_AXI_DATA_WIDTH-1:16];
assign peak_thd = op_reg3[15:0];
assign peak_thd_count = op_reg3[C_S00_AXI_DATA_WIDTH-1:16];
assign peak_top_delay = op_reg4[15:0];

dmca_ip_v0_1_0_S00_AXI # ( 
	.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
) m3 
(
	.S_AXI_ACLK(sys_clk),
	.S_AXI_ARESETN(sys_rstn),
	.S_AXI_AWADDR(s00_axi_awaddr),
	.S_AXI_AWPROT(s00_axi_awprot),
	.S_AXI_AWVALID(s00_axi_awvalid),
	.S_AXI_AWREADY(s00_axi_awready),
	.S_AXI_WDATA(s00_axi_wdata),
	.S_AXI_WSTRB(s00_axi_wstrb),
	.S_AXI_WVALID(s00_axi_wvalid),
	.S_AXI_WREADY(s00_axi_wready),
	.S_AXI_BRESP(s00_axi_bresp),
	.S_AXI_BVALID(s00_axi_bvalid),
	.S_AXI_BREADY(s00_axi_bready),
	.S_AXI_ARADDR(s00_axi_araddr),
	.S_AXI_ARPROT(s00_axi_arprot),
	.S_AXI_ARVALID(s00_axi_arvalid),
	.S_AXI_ARREADY(s00_axi_arready),
	.S_AXI_RDATA(s00_axi_rdata),
	.S_AXI_RRESP(s00_axi_rresp),
	.S_AXI_RVALID(s00_axi_rvalid),
	.S_AXI_RREADY(s00_axi_rready),
	
	.timer_counter(timer_counter),
	.op_reg0(op_reg0),
	.op_reg1(op_reg1),
	.op_reg2(op_reg2),
	.op_reg3(op_reg3),
	.op_reg4(op_reg4)
);

endmodule
