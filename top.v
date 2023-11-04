/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 

// Top level of our high frequency trader
module hft #(
	parameter AXI_DATA_W  = 64,
	parameter AXI_KEEP_W  = 8,
	parameter SID_W       = 80,
	parameter SEQ_NUM_W   = 64,
	`ifdef DEBUG_ID
	parameter DEBUG_ID_W  = SID_W + SEQ_NUM_W,
	`endif
	parameter ML_W        = 16, // Mold length field width in bits
	parameter EOS_MSG_CNT = {ML_W{1'b1}},// end-of-session msg cnt value

	// overlap fields
	parameter OV_DATA_W  = 64-ML_W,//48
	parameter OV_KEEP_W  = (OV_DATA_W/8),//6
	parameter OV_KEEP_LW = 3, //$clog2(OV_KEEP_W+1),
	
	parameter KEEP_LW     = $clog2(AXI_KEEP_W)+1,

	// itch data
	parameter LEN       = 8,
	parameter MSG_MAX_N = 50*LEN,// maximum length an itch message ( net order imbalance ) 
	parameter MSG_MAX_W =$clog2(MSG_MAX_N+1), 
	parameter CNT_MAX   = 7,// $ceil(MSG_MAX_W / AXI_DATA_W) // maxium number of payloads that need to be received for the longest itch message 
	parameter CNT_MAX_W = $clog2(CNT_MAX)
)(
	input clk,
	input nreset,

	// axis input
	input                  udp_axis_tvalid_i,
	input [AXI_KEEP_W-1:0] udp_axis_tkeep_i,
	input [AXI_DATA_W-1:0] udp_axis_tdata_i,
	input                  udp_axis_tlast_i,
	input                  udp_axis_tuser_i,
	
	output                 udp_axis_tready_o,	
	
	// itch decoder output
	`include "gen/port_list.v"
);

// UDP -> AXIS -> MOLD
logic                  udp_mold_axis_tvalid;
logic [AXI_KEEP_W-1:0] udp_mold_axis_tkeep;
logic [AXI_DATA_W-1:0] udp_mold_axis_tdata;
logic                  udp_mold_axis_tlast;
logic                  udp_mold_axis_tuser;
// MOLD -> AXIS -> UDP
logic                  mold_udp_axis_tready;

// MOLD -> ITCH
logic                  mold_itch_msg_v;
logic                  mold_itch_msg_start;
logic [KEEP_LW-1:0] mold_itch_msg_len;
logic [AXI_DATA_W-1:0] mold_itch_msg_data;
logic                  mold_itch_msg_ov_v;
logic [OV_KEEP_LW-1:0] mold_itch_msg_ov_len;
logic [OV_DATA_W-1:0]  mold_itch_msg_ov_data;

`ifdef MOLD_MSG_IDS	
logic [SID_W-1:0]      mold_msg_sid;
logic [SEQ_NUM_W-1:0]  mold_msg_seq;
`endif
`ifdef DEBUG_ID
logic [DEBUG_ID_W-1:0] mold_itch_msg_debug_id;
`endif

// ITCH -> ?
`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]     itch_msg_sid;
logic [SEQ_NUM_W-1:0] itch_msg_seq_num;
`endif
`ifdef DEBUG_ID
logic [DEBUG_ID_W-1:0] itch_debug_id;
`endif

// mold
moldudp64 #(
`ifdef DEBUG_ID
	.DEBUG_ID_W(DEBUG_ID_W),
`endif
	.AXI_DATA_W(AXI_DATA_W),
	.AXI_KEEP_W(AXI_KEEP_W),
	.SID_W(SID_W),
	.SEQ_NUM_W(SEQ_NUM_W),
	.ML_W(ML_W),
	.EOS_MSG_CNT(16'hffff),
	.OV_DATA_W(OV_DATA_W),
	.OV_KEEP_W(OV_KEEP_W),
	.OV_KEEP_LW(OV_KEEP_LW)
) m_moldudp64(
	.clk(clk),
	.nreset(nreset),
	
	.udp_axis_tvalid_i(udp_axis_tvalid_i),
	.udp_axis_tkeep_i (udp_axis_tkeep_i ),
	.udp_axis_tdata_i (udp_axis_tdata_i ),
	.udp_axis_tlast_i (udp_axis_tlast_i ),
	.udp_axis_tuser_i (udp_axis_tuser_i ),
	.udp_axis_tready_o(udp_axis_tready_o),
	
	`ifdef MOLD_MSG_IDS
	.mold_msg_sid_o    (mold_msg_sid ),
	.mold_msg_seq_num_o(mold_msg_seq ),
	`endif

	`ifdef DEBUG_ID
	.mold_msg_debug_id_o (mold_itch_msg_debug_id),
	`endif
	
	.mold_msg_v_o    (mold_itch_msg_v     ),
	.mold_msg_start_o(mold_itch_msg_start ),
	.mold_msg_len_o  (mold_itch_msg_len   ),
	.mold_msg_data_o (mold_itch_msg_data  ),

	.mold_msg_ov_v_o   (mold_itch_msg_ov_v   ),
	.mold_msg_ov_len_o (mold_itch_msg_ov_len ),
	.mold_msg_ov_data_o(mold_itch_msg_ov_data)
);
// itch
tv_itch5 #( .LEN(LEN),
`ifdef DEBUG_ID
	.DEBUG_ID_W(DEBUG_ID_W),
`endif
	.AXI_DATA_W(AXI_DATA_W), .AXI_KEEP_W(AXI_KEEP_W),
	.MSG_MAX_N(MSG_MAX_N), .MSG_MAX_W(MSG_MAX_W),

	.OV_DATA_W(OV_DATA_W),.OV_KEEP_W(OV_KEEP_W),.OV_KEEP_LW(OV_KEEP_LW)
)
m_itch(
	.clk(clk),
	.nreset(nreset),

	.valid_i(mold_itch_msg_v    ),
	.start_i(mold_itch_msg_start),
	.len_i  (mold_itch_msg_len  ),
	.data_i (mold_itch_msg_data ),

	.ov_valid_i(mold_itch_msg_ov_v    ),
	.ov_len_i  (mold_itch_msg_ov_len  ),
	.ov_data_i (mold_itch_msg_ov_data ),

	`ifdef DEBUG_ID
	.debug_id_i    (mold_itch_msg_debug_id ),    
	.debug_id_o    (itch_debug_id          ),
	`endif
	
	`include "gen/tb_port_list.v"
);



`ifdef FORMAL
`endif
endmodule
