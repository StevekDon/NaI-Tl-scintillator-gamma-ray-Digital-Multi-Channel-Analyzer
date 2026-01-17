`timescale 1ns/1ps

module tb_spectrum2axis();

reg             sys_clk, sys_rstn;
reg             peak_ok;
reg     [13:0]  peak_value;
reg             M_AXIS_TREADY;

spectrum2axis db0
(
    .sys_clk        (sys_clk),
    .M_AXIS_ARESETN (sys_rstn),
    .sys_rstn       (sys_rstn),  
    .peak_value_ok  (peak_ok),
    .peak_value     (peak_value),
    .M_AXIS_TVALID  (),
    .M_AXIS_TDATA   (),
    .M_AXIS_TLAST   (),
    .M_AXIS_TREADY  ()
);

initial begin
    sys_clk = 0;
    forever #10 sys_clk = ~sys_clk;
end

initial begin
    sys_rstn = 0;
    M_AXIS_TREADY = 0;
    
    #100; 
    sys_rstn = 1;
    
    #10000000    
    M_AXIS_TREADY = 1;
end

initial begin
    peak_ok = 0;
    peak_value = 14'd0;
    
    wait(sys_rstn == 1);
    
    #500000
    forever begin
        #10000;            // 10000ns
        @(posedge sys_clk);
        peak_ok <= 1; 
        @(posedge sys_clk);
        peak_ok <= 0; 
        #100 peak_value <= peak_value + 1'b1;
    end
end

endmodule