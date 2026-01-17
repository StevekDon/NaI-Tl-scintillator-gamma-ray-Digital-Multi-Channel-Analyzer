`timescale 1ns / 1ps

module tb_se();

reg x, y, z;
reg [15:0] reg_a, reg_b;
integer count;

initial
begin
    x = 0; y = 1; z = 1;
    count = 0;
    reg_a = 16'b0; reg_b = reg_a;
    
    reg_a[2] <= #15 1'b1;
    reg_b[15:13] <= #10 {x, y, z};
    count <= count + 1'b1;
end

/*
// ----------------------------------------------------------------------------
// 参数定义
// ----------------------------------------------------------------------------
parameter CLK_PERIOD = 10;      // 100MHz 时钟
parameter DEPTH = 16384;        // BRAM 深度

// ----------------------------------------------------------------------------
// 信号声明
// ----------------------------------------------------------------------------
reg         M_AXIS_ACLK;
reg         M_AXIS_ARESETN;
reg         sys_rstn;
reg         spaxis_en;
reg         peak_value_ok;
reg  [13:0] peak_value;
wire        M_AXIS_TVALID;
wire [31:0] M_AXIS_TDATA;
wire        M_AXIS_TLAST;
reg         M_AXIS_TREADY;

// 测试控制信号
reg  [15:0] write_counter;      // 写入地址计数器
reg  [15:0] read_counter;       // 读取数据计数器
reg         test_fail;          // 测试失败标志

// ----------------------------------------------------------------------------
// 实例化被测模块 (DUT)
// ----------------------------------------------------------------------------
spectrum dut (
    .M_AXIS_ACLK     (M_AXIS_ACLK),
    .M_AXIS_ARESETN  (M_AXIS_ARESETN),
    .sys_rstn        (sys_rstn),
    .spaxis_en       (spaxis_en),
    .peak_value_ok   (peak_value_ok),
    .peak_value      (peak_value),
    .M_AXIS_TVALID   (M_AXIS_TVALID),
    .M_AXIS_TDATA    (M_AXIS_TDATA),
    .M_AXIS_TLAST    (M_AXIS_TLAST),
    .M_AXIS_TREADY   (M_AXIS_TREADY)
);

// ----------------------------------------------------------------------------
// 时钟生成
// ----------------------------------------------------------------------------
initial begin
    M_AXIS_ACLK = 1'b0;
    forever #(CLK_PERIOD/2) M_AXIS_ACLK = ~M_AXIS_ACLK;
end

// ----------------------------------------------------------------------------
// 主测试逻辑
// ----------------------------------------------------------------------------
initial begin
    // 初始化信号
    sys_rstn = 0;
    M_AXIS_ARESETN = 0;
    spaxis_en = 0;
    peak_value_ok = 0;
    peak_value = 0;
    M_AXIS_TREADY = 0;
    write_counter = 0;
    read_counter = 0;
    test_fail = 0;

    // 复位释放
    #100;
    sys_rstn = 1;
    M_AXIS_ARESETN = 1;

    // ----------------------------
    // 阶段1: 依次对 0~16383 地址+1
    // ----------------------------
    $display("[INFO] 开始写入测试: 0~16383 地址依次加1");
    spaxis_en = 1;  // 启用模块

    for (write_counter = 0; write_counter < DEPTH; write_counter = write_counter + 1) begin
        // 生成 peak_value_ok 脉冲
        peak_value = write_counter[13:0];
        peak_value_ok = 1;
        #CLK_PERIOD;
        peak_value_ok = 0;

        // 等待状态机完成当前地址操作 (约4周期)
        #(4*CLK_PERIOD);
    end

    // ----------------------------
    // 阶段2: 停止写入，启动AXI读取
    // ----------------------------
    $display("[INFO] 写入完成，启动AXI读取");
    spaxis_en = 1;          // 停止写入
    M_AXIS_TREADY = 1;      // 允许AXI传输

    // 等待传输完成 (检测TLAST)
    wait (M_AXIS_TLAST == 1);
    #CLK_PERIOD;
    M_AXIS_TREADY = 0;

    // ----------------------------
    // 结果检查
    // ----------------------------
    if (test_fail)
        $display("[ERROR] 测试失败！");
    else
        $display("[PASS] 测试通过！");
    $finish;
end

// ----------------------------------------------------------------------------
// AXI数据接收与验证
// ----------------------------------------------------------------------------
always @(posedge M_AXIS_ACLK) begin
    if (M_AXIS_ARESETN && M_AXIS_TVALID && M_AXIS_TREADY) begin
        // 检查数据是否为1（每个地址+1后的值）
        if (M_AXIS_TDATA !== (read_counter + 1)) begin
            $display("[ERROR] 地址 %0d: 期望值=1, 实际值=%0d", read_counter, M_AXIS_TDATA);
            test_fail = 1;
        end

        // 检查TLAST信号
        if ((read_counter == DEPTH-1) && !M_AXIS_TLAST) begin
            $display("[ERROR] TLAST未在最后一个数据置位！");
            test_fail = 1;
        end

        read_counter <= read_counter + 1;
    end
end
*/
endmodule