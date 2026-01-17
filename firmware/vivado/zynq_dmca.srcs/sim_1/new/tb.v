`timescale 1ns/1ps

module tb();

parameter   ADC_BIT = 14;

reg         sys_clk, sys_rstn, axis_rstn;

reg  [9:0]  addra;    
reg  [7:0]  rand_num; 
wire signed [ADC_BIT-1:0] adc_data;

reg [9:0] coe_data [1023:0];
integer i, file, status;
reg [31:0] value = 32'd0;

initial begin
    sys_clk = 0;
    forever #10 sys_clk = ~sys_clk;
end


initial begin
    sys_rstn = 0;
    axis_rstn = 0;
    m_axis_tready = 0;
    addra = 10'd512;
    
    #200; 
    sys_rstn = 1;
    axis_rstn = 1;
    
    #329090;
    axis_rstn = 0;
    #329190;
    axis_rstn = 1;             
    #330010;
    @(posedge sys_clk);
    trigger_single_read();
    
/*    
    #100;
    sys_rstn = 0;
    #100;
    sys_rstn = 1;
    
    #3010;
    @(posedge sys_clk);
    trigger_single_read();
    */
end

always @(posedge sys_clk) begin
    if (!sys_rstn) begin
        addra <= 10'd0;
        rand_num <= 8'd0;
    end else begin
        addra <= (addra == 10'd256) ? 10'd0 : addra + 1'b1;  //
        rand_num = $urandom % 60;
    end
end

initial begin
    file = $fopen("zaosheng.coe", "r");
    if (!file) begin
        $display("Error: Could not open COE file!");
        $finish;
    end

    i = 0;
    while (i < 1024 && !$feof(file)) begin
        status = $fscanf(file, "%h,", value);

        coe_data[i] = value[9:0];
        i = i + 1;
    end
    
    $fclose(file);
    $display("Loaded %0d values from COE file", i);
end

reg         m_axis_tready;
wire        m_axis_tvalid;
wire [31:0] m_axis_tdata;
wire        m_axis_tlast;

task trigger_single_read;
    begin
        wait(m_axis_tvalid == 1'b1);
        
        while (1) begin
       
            // 5% set tready to low
            if ($urandom_range(0, 19) == 0) begin
                m_axis_tready = 1'b0;            
                $display("[%t] set: TREADY=0", $time);
                #($urandom_range(1, 5) * 10);
            end 
            else begin
                m_axis_tready = 1'b1;           
            end

            //m_axis_tready = 1'b1;   
            @(posedge sys_clk);
            
            if (m_axis_tvalid && m_axis_tready && m_axis_tlast) begin
                $display("[%t] finished: TLAST checked", $time);
                m_axis_tready = 1'b0;
                disable trigger_single_read;
            end
        end
    end
endtask

assign adc_data = {4'b0, coe_data[addra]} * 10 - (1<<ADC_BIT-1);
//assign adc_data = 0;
wire    [ADC_BIT-1:0] fir_data_return;

dmca_top
#(
    .REG_GLOBAL_LIMIT(300),
    .ADC_BIT(ADC_BIT)
) dut1
(
    .sys_clk            (sys_clk),
    .sys_rstn           (sys_rstn),
    .adc_datain         (adc_data),
    .adc_dataout        (fir_data_return),
    .adc_fir_datain     (fir_data_return),
    .trapezd_data       (),
    .triangle_data      (),
                        
    .M_AXIS_TVALID      (m_axis_tvalid),
    .M_AXIS_TDATA       (m_axis_tdata),
    .M_AXIS_TLAST       (m_axis_tlast),
    .M_AXIS_TREADY      (m_axis_tready),
    .M_AXIS_ARESETN     (axis_rstn),
                        
    .na                 (20), 
    .nb                 (60),
    .na_1               (3277), 
    .d_na               (3117),
    .peak_thd           (1000),
    .peak_thd_count     (8),
    .peak_top_delay     (8)
);


endmodule