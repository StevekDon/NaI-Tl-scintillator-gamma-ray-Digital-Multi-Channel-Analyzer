// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Wed Jun  4 20:28:50 2025
// Host        : Steve running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/Steve/Desktop/zynq7020/vivado_prj/zynq_dmca/zynq_dmca/zynq_dmca.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [9:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [9:0]douta;
  wire ena;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [9:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.229999 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "10" *) 
  (* C_READ_WIDTH_B = "10" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "10" *) 
  (* C_WRITE_WIDTH_B = "10" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[9:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[9:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VHPlDkoDlWlBfBMvPBmGYmaek3s9hXXhjF28kllYPnaNm3TSnzzpXHWHc8Ye9/2L2yiQfJ1hTWou
Ia/zeQ8h9/dtr6QB5YkyW4wlb/LbMgXb+DGIXPSllNl0IMsRQIcQDbcQm1bO/nlhb+2pjxiuaQrl
DbvxoDwPs7z3LunRxsg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lmIhoX8hXuc7tNV1sXY1K2/gXL7Y7Hq73qQF7+x03UWWTRd3uhGmVQtOMVbhIW+66UkWUHiD26zL
fzqGor8bgSNGpSFyS11k4TwLQT4OfAMGO8C9Qmmh4+VENBnpS9TW+wHzCv8oUwht7xYtYRZvOvYK
F3fMppz2sBkUd1lciw98ZE/UmNkhqBuMfIYF43j45DEJ55PBhOZNg91Ls4v3qBHyBAaYPFFoMry3
d5Fw1PZyFQSEOSSpwgyds2aN0g6oIwl7zm0LJrM9VDAOxBUE50hk+oHr4jj8J8UhHQJnlEHm1Idm
rvxKygNKRvfSpa90NYxZJFYgqnrMYg+19+9aZA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
VkyCjO2onoeZWEoYQ/4ue7X5mkHyTYVW9xjdoTsGS4GdP/Q64VaCZL/jr6R8DVDXPMnH7tRMrDpo
jpYBnyzSgOkfgqM+96ioC2fDyAaG4gYgGLmrBR6qK3/mxXwAZZX+GJ9R/eWXkc9h8xN+gsSSX6/M
jIQCgeT6q7PB4dWT6KY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Iub91V+TnhVlZCSLu6iKmFjix71y6/l83OPTs8uewWvkE7WcqYxEKi9fonXEkzAtWzuKwEUqnOlN
VBsNJqPUdKcd22q523mrdt89mpdosWD+hvZdO7ELhJniY5u9h49FFkubpN2JiUTcIcKEYxVNlds4
wyvaYUqbPVH5v2ooJwDdimS4GVn9HerCOgPwfshvQDNlMTxLcYju4v8BHMc5Rub9Q/ihvpQU74v2
ouZ9XIwA+C6pBLwvaqS8jE7HXOokgqJilaX/W/t+KEgiFry/txRTMU9WMD7tCN7lcfjCydmS3Lq+
3u6Hsr0S8BwNjcaDpZDnBTygUJd4JSqREnk33w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
U46EWFmKmpZGaWfyL+dokyQtJtaOYsa7HCW/+fdtw9/yHKTWFpmqKBZngBj5rPkNhtTDDCJkqsYj
tUXg1j4tgIBaCQn9B0q/aG+B3gPLrudp9hLL25mVbsfiTzdekiV2hJMmhuMoavKKPJHC6zyW7kZi
80er82OQy8h+Df/fe6TRjH9xEt3/b80tRKUMbxkLfnnkAyyf1KfOhB6/uyI4mwXuQR+DsAbzybKR
YtXpOiW72tGrXTFlzcwbHamWZefqsilVpBw6V5dh33vYKGx50xwWpj76maAkpQrOpB7zufeldJe4
W1UOEN84AZdRTLkVSxamWo/wp8nP9fiGS/ItRw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qczgIJYpE/SzErzK7eWJBGcDFEzDLm8cKbwJbPXuM6YnJxx44W+E60R3war7K2QGFAkOoCDUtDC7
SghJGF32btaDLzeKm0tQ669sBtQmMIaBrlt7I9QBkNM8zN9GL92qxNC9o3UVWMOYy5BmH8nUPgcE
O6lRubeltlrTuDe7UJQ2nEPHcXjpUJJ8dxktyW+LovBy1OxW8g4GRAsmEJsoOEg0HuDdWcc4IshJ
PvwPJ7LblELAKsdkSt65y9VaklaEm7MlH4ImlgIa74TgRmutLUbWxM1QYhGE5rAzFhGU5i3RJOdx
L3N7GGGvLMW2z9NSHbIFX+/eNII9fNJ9nZbgLA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ti1NUgDv8YPk90APMwfu/mRr38QYwAxZfv0T6zQ89YS55t2EquEGVqrEafYX6rTydLOw8le1Oucv
f2oERpSSSTih/ScZneSZmuPE/Zh2BU1Ajv0j+/+0uEWXU+5lLPbDJjnapTmJXih1MYPf0SHpZZmE
BKj2IEBI9MPZlh6bxpa5BWJnyPdAvHf+UNaMXU9+pmbtrzUVebql4mFJu45Z3+ehmFY4FBW3zXMF
44C4TlHACLwL3vHVMCVfeKhgdVDbpE+/IFhTStz7mZ9h9RKGanQcs6YDVM1R+2RKA1QT1fX4FiQc
1V+FGmrm1ujxmFGXwpfNKByVlfCY0oWhRJCYYQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
HuEXFK0NXt09xU2yxxjng1OLsT+ZEM4EhqBgpr9D2ljw2vDaMBrqEsRQTc2B9soDq3ewDduHJXBd
OGYxkPnoN6LhjULtB2nTgjcH6NxA4puZ1ZNcndDndVBo8rTW5W1OqHq6InAG0CqPpTIkuqz3ECPl
EysI++MCDfH6tIzlekxJFIJ1McJsTq5rFuLzMMcrmkBxgcayDpOcCFuzZzCczxmt/cCCIKmDybwT
OQXmOcLJoYLP4sFu6R9c6xO8i6p++crv2N3eIxZHKbek9xBBZqQM9EYuEtsbkqAs9XZpa16i5njR
BDFxTKcP6r7JgFALJE89AZhBbate5JXWp0v4ECZD18aEL17CipwcWPutNMdG1apzSPP5y59n7rMG
yxBPz1gKHc3Emkl4WcO0hjICxqmO6dMXoY8JvBSf6ry2l0sH9Ihr3Bq5WWmlhPHnoaNr5jl//vNe
KfToWtn97eoVSt1LnmXXnSpdigbHr0UIg8AdkpdkuNRaWdVicDdgSo49

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mokwst2bn6UxD6V9UdIgCIG1QQ/d0FiJqYGOTI2eHPV6YElaLjnJ8DnQmZnGS95o3x93FDOoa58C
RwYsX1fVoVtXkj1LuZq0k7q9vEe4T8xMjpkeYtIHY9k0Xhy1Lq/xRlfzGAf9fvf9e+f4r7aR/Sb/
uCZxxugG5niTwLENY1n3NthYL0jvo8Fmdw4Qg0nTCGWlVCws+09K0g9/lx6I9EcuHHemcHO3fOZG
lMc4NaPNozKwnyDMoWUkwiVxyFEPFaQLNYqzjvR+CqrWfhFLo96JWhL+eaDoNuZoBVYQtNH5ZwBL
BoO27Pw10lgcReGlZBz3BLO7T4ddynCx0+eSnw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PiP7AjOQqqouyQMoBQqgWIDhUSViq94rIvGiIJ/UKMDspM/yXw1caE8AhWHTjYckC4yLpPAz5P6s
1Z6flzDPrzVwg4e59X2cc4IMCHhedna0rDO804njcc6amRDTeLsMLTkWfvomB4xwszm2AgT+PRnB
WHd09ZUDVFjiBXT+Oa9AicgGJHrX3w823yBPuAa704kje/SzgtiDpcTU1eLmLhLW7LpEd9KIHd9s
ER7Uk9Orws0Kq9PMTqMX4hMn5K5mFakOeOURiEbUjdv5RiIJ2g/PlQXSItM8fHsBTQa6fOaJwQTI
vHwK3a8ZBHpfT1YH+n7wNiNUZwD4SFXm1QVx4g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ul5ZfTHJwMctaNhYRortUZizYMPYRef7uYqPSuMkxsArnxI/cjGh+KRMwzV86hyp/6TXSJIjm5ec
2wX2UONdPN+DOJ84jYC4JbgJQrPnTj7ioD8uLX/WlyPcQzyF5keqFgj5eR5s13FskVWCuAWf5m9w
mhFEKFjVXDAr7gVgAJh/hL8P6Psrnf+LGfiM8JhnDepsHEYykGlpD3fzru2BGgqHWqPqFMcnyVGl
vysaIXiJz/eYKvO8RGcgd3DJAM/wPm9A0m/DWcmSnczOgTjoqkHcBg2H5uJMLvufzmjImi6LYEqq
v04ESDEN31cSUzqUYcayvMFOnI/WNsWbFIa5+Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18576)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
