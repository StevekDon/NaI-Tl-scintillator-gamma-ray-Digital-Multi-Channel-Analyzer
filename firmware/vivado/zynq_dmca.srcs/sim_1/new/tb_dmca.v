`timescale 1ns/1ps

module tb_dmca();

reg sys_clk, sys_rstn;

initial begin
    sys_clk = 0;
    sys_rstn = 0;
    
    #100;
    sys_rstn = 1;
end

always #(10) sys_clk = ~sys_clk;

wire            M_AXIS_TLAST, M_AXIS_TVALID;
wire    [31:0]  M_AXIS_TDATA;
reg             M_AXIS_TREADY;

spectrum2axis
#(
    .DEPTH           (16384),
    .WIDTH           (32),
    .ADDR_W          (14),
    .CLK_FREQ_MHZ    (80)
) dut0
(
    .sys_clk        (sys_clk),
    .M_AXIS_ARESETN (sys_rstn),

    .sys_rstn       (sys_rstn),
    .peak_value_ok  (0),
    .peak_value     (0),

    .M_AXIS_TVALID  (M_AXIS_TVALID),
    .M_AXIS_TDATA   (M_AXIS_TDATA),
    .M_AXIS_TLAST   (M_AXIS_TLAST),
    .M_AXIS_TREADY  (M_AXIS_TREADY),

    .timer_counter  ()
);

/*
wire    [13:0]  read_pointer;
wire    [31:0]  dob;

ram2axis_skid
#(
    // Width of AXI stream interfaces in bits
    .DATA_WIDTH (32),
    .ADDR_W     (14)
) dut0
(
    .sys_clk            (sys_clk),
    .sys_rstn           (sys_rstn),

    .m_axis_tdata       (M_AXIS_TDATA),
    .m_axis_tvalid      (M_AXIS_TVALID),
    .m_axis_tready      (M_AXIS_TREADY),
    .m_axis_tlast       (M_AXIS_TLAST),

    .read_pointer       (read_pointer),
    .ram_data           (dob)
);

dual_port_ram
#(
    .DEPTH (16384),
    .WIDTH (32),
    .ADDR_W (14)
) m0
(
    .sys_clk    (sys_clk),
    .ena        (0), 
    .wea        (0),
    .enb        (1), 
    .web        (0),
    .addra      (0), 
    .addrb      (read_pointer),
    .dia        (0), 
    .dib        (0),

    .doa        (), 
    .dob        (dob)
);
*/
initial
begin
    M_AXIS_TREADY = 0;
    
    #500;
    @(posedge sys_clk);
    M_AXIS_TREADY = 1;
    
    #50020;
    @(posedge sys_clk);
    M_AXIS_TREADY = 0;
    
    #100;
    @(posedge sys_clk);
    M_AXIS_TREADY = 1;
    
end

endmodule