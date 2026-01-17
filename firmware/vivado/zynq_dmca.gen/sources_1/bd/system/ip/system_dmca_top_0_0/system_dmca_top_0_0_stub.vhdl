-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
-- Date        : Fri Jun  6 17:18:49 2025
-- Host        : Steve running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/Steve/Desktop/zynq7020/vivado_prj/zynq_dmca/zynq_dmca/zynq_dmca.gen/sources_1/bd/system/ip/system_dmca_top_0_0/system_dmca_top_0_0_stub.vhdl
-- Design      : system_dmca_top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity system_dmca_top_0_0 is
  Port ( 
    sys_clk : in STD_LOGIC;
    sys_rstn : in STD_LOGIC;
    adc_datain : in STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_dataout : out STD_LOGIC_VECTOR ( 13 downto 0 );
    adc_fir_datain : in STD_LOGIC_VECTOR ( 13 downto 0 );
    trapezd_data : out STD_LOGIC_VECTOR ( 16 downto 0 );
    triangle_data : out STD_LOGIC_VECTOR ( 16 downto 0 );
    M_AXIS_TVALID : out STD_LOGIC;
    M_AXIS_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXIS_TLAST : out STD_LOGIC;
    M_AXIS_TREADY : in STD_LOGIC;
    M_AXIS_ARESETN : in STD_LOGIC;
    ms_en : in STD_LOGIC;
    na : in STD_LOGIC_VECTOR ( 9 downto 0 );
    nb : in STD_LOGIC_VECTOR ( 9 downto 0 );
    na_1 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    d_na : in STD_LOGIC_VECTOR ( 15 downto 0 );
    peak_thd : in STD_LOGIC_VECTOR ( 15 downto 0 );
    peak_thd_count : in STD_LOGIC_VECTOR ( 7 downto 0 );
    peak_top_delay : in STD_LOGIC_VECTOR ( 7 downto 0 );
    timer_counter : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end system_dmca_top_0_0;

architecture stub of system_dmca_top_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sys_clk,sys_rstn,adc_datain[13:0],adc_dataout[13:0],adc_fir_datain[13:0],trapezd_data[16:0],triangle_data[16:0],M_AXIS_TVALID,M_AXIS_TDATA[31:0],M_AXIS_TLAST,M_AXIS_TREADY,M_AXIS_ARESETN,ms_en,na[9:0],nb[9:0],na_1[15:0],d_na[15:0],peak_thd[15:0],peak_thd_count[7:0],peak_top_delay[7:0],timer_counter[31:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "dmca_top,Vivado 2022.2";
begin
end;
