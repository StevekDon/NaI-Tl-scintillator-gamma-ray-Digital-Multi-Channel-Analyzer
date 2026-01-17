`timescale 1ns / 1ps

module tb_axis;

    parameter CLK_PERIOD = 10;   // 100MHz ±÷”
    parameter C_M_START_COUNT = 16;
    parameter NUM_WORDS = 256;

    reg  M_AXIS_ACLK;
    reg  M_AXIS_ARESETN;
    wire M_AXIS_TVALID;
    wire [31:0] M_AXIS_TDATA;
    wire M_AXIS_TLAST;
    reg  M_AXIS_TREADY;
    
    integer start_delay_count;

    wire   [7:0] ram_addr;
    reg     [31:0] ram_data;
    /*
    ram2axis #(
        .C_M_START_COUNT(C_M_START_COUNT),
        .NUMBER_OF_OUTPUT_WORDS(NUM_WORDS)
    ) uut (
        .M_AXIS_ACLK(M_AXIS_ACLK),
        .M_AXIS_ARESETN(M_AXIS_ARESETN),
        .M_AXIS_TVALID(M_AXIS_TVALID),
        .M_AXIS_TDATA(M_AXIS_TDATA),
        .M_AXIS_TLAST(M_AXIS_TLAST),
        .M_AXIS_TREADY(M_AXIS_TREADY),
        .ram_addr(ram_addr),
		.ram_data(ram_data)
    );
*/
spectrum2axis 
#(
    .DEPTH(16384),
    .WIDTH(32),
    .ADDR_W(14)
) dut
(
    .sys_clk            (M_AXIS_ACLK),
    .M_AXIS_ARESETN     (M_AXIS_ARESETN),
                        
    .sys_rstn           (M_AXIS_ARESETN),
    .peak_value_ok      (),
    .peak_value         (),
                        
    .M_AXIS_TVALID      (M_AXIS_TVALID),
    .M_AXIS_TDATA       (M_AXIS_TDATA),
    .M_AXIS_TLAST       (M_AXIS_TLAST),
    .M_AXIS_TREADY      (M_AXIS_TREADY)
);

    initial begin
        M_AXIS_ACLK = 0;
        forever #(CLK_PERIOD/2) M_AXIS_ACLK = ~M_AXIS_ACLK;
    end

    initial begin
        M_AXIS_ARESETN = 0;
        M_AXIS_TREADY = 0;
        start_delay_count = 0;

        #(CLK_PERIOD*2);
        M_AXIS_ARESETN = 1;
        #(CLK_PERIOD*2);

        //M_AXIS_TREADY = 1;
        #200005 M_AXIS_TREADY = 1;
        //#1100 M_AXIS_TREADY = 1;
    end

endmodule