`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/28 14:36:15
// Design Name: 
// Module Name: ram2axis_skid
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


module ram2axis_skid
#(
    // Width of AXI stream interfaces in bits
    parameter DEPTH      = 16384,
    parameter DATA_WIDTH = 32,
    parameter ADDR_W     = 14
)
(
    input                     sys_clk,
    input                     sys_rstn,

    /*
     * Simple AXI Stream output
     */
    output  [DATA_WIDTH-1:0]    m_axis_tdata,
    output                      m_axis_tvalid,
    input                       m_axis_tready,
    output                      m_axis_tlast,
    
    output  [ADDR_W-1:0]        read_pointer,
    input   [DATA_WIDTH-1:0]    ram_data
);

// skid buffer, no bubble cycles
// datapath registers
reg [ADDR_W-1:0]     s_read_pointer, s_read_pointer_d0, s_read_pointer_d1;

reg [DATA_WIDTH-1:0] m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
reg                  m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
reg                  m_axis_tlast_reg  = 1'b0;

reg [DATA_WIDTH-1:0] temp_m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
reg                  temp_m_axis_tvalid_reg = 1'b0, temp_m_axis_tvalid_next;
reg                  temp_m_axis_tlast_reg  = 1'b0;

// datapath control
reg store_axis_input_to_output;
reg store_axis_input_to_temp;
reg store_axis_temp_to_output;

assign m_axis_tdata  = m_axis_tdata_reg;
assign m_axis_tvalid = m_axis_tvalid_reg;
assign m_axis_tlast  = m_axis_tlast_reg;
assign read_pointer = s_read_pointer;

wire tx_en = m_axis_tready || (!temp_m_axis_tvalid_reg && !m_axis_tvalid_reg);

always @(posedge sys_clk) begin
    if (!sys_rstn) begin
        s_read_pointer <= 0;
        s_read_pointer_d0 <= 0;
        s_read_pointer_d1 <= 0;
    end
    else if(tx_en && (s_read_pointer < DEPTH - 1)) begin
        s_read_pointer <= s_read_pointer + 1;
        s_read_pointer_d0 <= s_read_pointer;
        s_read_pointer_d1 <= s_read_pointer_d0;
    end
    else if(s_read_pointer == DEPTH - 1) begin
        s_read_pointer <= s_read_pointer;
        s_read_pointer_d0 <= s_read_pointer;
        s_read_pointer_d1 <= s_read_pointer_d0;
    end
end

reg             tx_en_delay;

always @(posedge sys_clk) begin
    if (!sys_rstn) begin
        m_axis_tvalid_reg <= 1'b0;
        temp_m_axis_tvalid_reg <= 1'b0;
        tx_en_delay <= 0;
    end else begin
        m_axis_tvalid_reg <= m_axis_tvalid_next;
        temp_m_axis_tvalid_reg <= temp_m_axis_tvalid_next;
        tx_en_delay <= tx_en;
    end
    // datapath
    if (store_axis_input_to_output) begin
        m_axis_tdata_reg <= ram_data;
        m_axis_tlast_reg <= (s_read_pointer_d0 == DEPTH - 1);
    end else if (store_axis_temp_to_output) begin
        m_axis_tdata_reg <= temp_m_axis_tdata_reg;
        m_axis_tlast_reg <= temp_m_axis_tlast_reg;
    end
    else begin
        m_axis_tlast_reg <= 0;
    end

    if (store_axis_input_to_temp) begin
        temp_m_axis_tdata_reg <= ram_data;
        temp_m_axis_tlast_reg <= (s_read_pointer_d0 == DEPTH - 1);
    end
end

always @* begin
    // transfer sink ready state to source
    m_axis_tvalid_next = m_axis_tvalid_reg;
    temp_m_axis_tvalid_next = temp_m_axis_tvalid_reg;

    store_axis_input_to_output = 1'b0;
    store_axis_input_to_temp = 1'b0;
    store_axis_temp_to_output = 1'b0;

    if ((s_read_pointer_d1 < DEPTH - 1) && tx_en_delay) begin
        // input is ready
        if (m_axis_tready || !m_axis_tvalid_reg) begin
            // output is ready or currently not valid, transfer data to output
            m_axis_tvalid_next = 1'b1;
            store_axis_input_to_output = 1'b1;
        end else begin
            // output is not ready, store input in temp
            temp_m_axis_tvalid_next = 1'b1;
            store_axis_input_to_temp = 1'b1;
        end
    end else if ((s_read_pointer_d1 < DEPTH - 1) && m_axis_tready) begin
        // input is not ready, but output is ready
        m_axis_tvalid_next = temp_m_axis_tvalid_reg;
        temp_m_axis_tvalid_next = 1'b0;
        store_axis_temp_to_output = 1'b1;
    end
    else if(s_read_pointer_d1 == DEPTH - 1) m_axis_tvalid_next = 0;
end

endmodule
