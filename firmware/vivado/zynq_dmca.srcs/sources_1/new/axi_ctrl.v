`timescale 1 ns / 1 ps

	module axi_ctrl #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,
		
		input wire [31:0] timer_counter,
		
		output wire [15:0]  na, nb,
	    output wire [15:0]  na_1, d_na,
	    output wire [15:0]  peak_thd,
	    output wire [7:0]   peak_thd_count,
	    output wire [7:0]   peak_top_delay,
	    output wire         adc_pwr_en,
	    output wire         ms_en
	);
	
	wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg0;
	wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg1;
	wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg2;
	wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg3;
	wire           [C_S00_AXI_DATA_WIDTH-1 : 0] op_reg4;
	

	
	assign adc_pwr_en = op_reg0[0];
	assign ms_en = op_reg0[1];
	
	assign na = op_reg1[15:0];
	assign nb = op_reg1[C_S00_AXI_DATA_WIDTH-1:16];
	assign na_1 = op_reg2[15:0];
	assign d_na = op_reg2[C_S00_AXI_DATA_WIDTH-1:16];
	assign peak_thd = op_reg3[15:0];
	assign peak_thd_count = op_reg3[C_S00_AXI_DATA_WIDTH-1:16];
	assign peak_top_delay = op_reg4[15:0];
	
	
// Instantiation of Axi Bus Interface S00_AXI
	axi_ctrl_axilite # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axi_ctrl_AXIlite_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
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

	// Add user logic here

	// User logic ends

	endmodule
