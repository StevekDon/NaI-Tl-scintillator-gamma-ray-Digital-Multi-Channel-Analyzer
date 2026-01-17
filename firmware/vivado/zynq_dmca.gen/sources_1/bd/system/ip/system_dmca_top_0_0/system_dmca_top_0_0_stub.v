// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Fri Jun  6 17:18:49 2025
// Host        : Steve running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Steve/Desktop/zynq7020/vivado_prj/zynq_dmca/zynq_dmca/zynq_dmca.gen/sources_1/bd/system/ip/system_dmca_top_0_0/system_dmca_top_0_0_stub.v
// Design      : system_dmca_top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "dmca_top,Vivado 2022.2" *)
module system_dmca_top_0_0(sys_clk, sys_rstn, adc_datain, adc_dataout, 
  adc_fir_datain, trapezd_data, triangle_data, M_AXIS_TVALID, M_AXIS_TDATA, M_AXIS_TLAST, 
  M_AXIS_TREADY, M_AXIS_ARESETN, ms_en, na, nb, na_1, d_na, peak_thd, peak_thd_count, peak_top_delay, 
  timer_counter)
/* synthesis syn_black_box black_box_pad_pin="sys_clk,sys_rstn,adc_datain[13:0],adc_dataout[13:0],adc_fir_datain[13:0],trapezd_data[16:0],triangle_data[16:0],M_AXIS_TVALID,M_AXIS_TDATA[31:0],M_AXIS_TLAST,M_AXIS_TREADY,M_AXIS_ARESETN,ms_en,na[9:0],nb[9:0],na_1[15:0],d_na[15:0],peak_thd[15:0],peak_thd_count[7:0],peak_top_delay[7:0],timer_counter[31:0]" */;
  input sys_clk;
  input sys_rstn;
  input [13:0]adc_datain;
  output [13:0]adc_dataout;
  input [13:0]adc_fir_datain;
  output [16:0]trapezd_data;
  output [16:0]triangle_data;
  output M_AXIS_TVALID;
  output [31:0]M_AXIS_TDATA;
  output M_AXIS_TLAST;
  input M_AXIS_TREADY;
  input M_AXIS_ARESETN;
  input ms_en;
  input [9:0]na;
  input [9:0]nb;
  input [15:0]na_1;
  input [15:0]d_na;
  input [15:0]peak_thd;
  input [7:0]peak_thd_count;
  input [7:0]peak_top_delay;
  output [31:0]timer_counter;
endmodule
