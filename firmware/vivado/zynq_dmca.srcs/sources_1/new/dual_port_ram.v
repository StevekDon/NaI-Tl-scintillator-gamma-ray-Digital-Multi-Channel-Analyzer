`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SINP / SARI
// Engineer: Steve
// 
// Create Date: 2025/05/15 10:36:55
// Design Name: 
// Module Name: dual_port_ram
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


module dual_port_ram
#(
    parameter DEPTH = 16384,
    parameter WIDTH = 32,
    parameter ADDR_W  = 14
)
(
    input                           sys_clk,
    input                           ena, wea,
    input                           enb, web,
    input           [ADDR_W - 1:0]  addra, addrb,
    input           [WIDTH - 1:0]   dia, dib,
    
    output  reg     [WIDTH - 1:0]   doa, dob
);

(* ram_style = "block" *) reg   [31:0]  ram[DEPTH - 1:0];

always@(posedge sys_clk)
begin
    if(ena) begin
        if(wea) ram[addra] <= dia;
        else doa <= ram[addra];
    end
end

always@(posedge sys_clk)
begin
    if(enb) begin
        if(web) ram[addrb] <= dib;
        else dob <= ram[addrb];
    end
end

endmodule
