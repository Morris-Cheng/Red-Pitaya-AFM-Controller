// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Jul 14 10:41:11 2026
// Host        : LAPTOP-DSFFK1DP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/RedPitaya-FPGA-master/RedPitaya-FPGA-master/prj/V0.94/project/redpitaya.srcs/sources_1/ip/mult_gen_0/mult_gen_0_stub.v
// Design      : mult_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_16,Vivado 2020.1" *)
module mult_gen_0(CLK, A, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[54:0],P[61:0]" */;
  input CLK;
  input [54:0]A;
  output [61:0]P;
endmodule
