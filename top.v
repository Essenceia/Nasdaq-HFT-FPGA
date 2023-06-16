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
	`ifdef DEBUG
	parameter DEBUG_ID_W  = SID_W + SEQ_NUM_W,
	`endif
	parameter ML_W        = 16, // Mold length field width in bits
	parameter EOS_MSG_CNT = {ML_W{1'b1}},// end-of-session msg cnt value

	// itch data
	parameter LEN       = 8,
	parameter MSG_MAX_W = 50*LEN,// maximum length an itch message ( net order imbalance ) 
	parameter CNT_MAX   = 7,// $ceil(MSG_MAX_W / AXI_DATA_W) // maxium number of payloads that need to be received for the longest itch message 
	parameter CNT_MAX_W = $clog2(CNT_MAX)
)(
	input clk,
	input nreset

	// eth

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
logic [AXI_KEEP_W-1:0] mold_itch_msg_mask;
logic [AXI_DATA_W-1:0] mold_itch_msg_data;
`ifdef MOLD_MSG_IDS	
logic [SID_W-1:0]      mold_msg_sid;
logic [SEQ_NUM_W-1:0]  mold_msg_seq;
`endif
`ifdef DEBUG
logic [DEBUG_ID_W-1:0] mold_itch_msg_debug_id;
`endif

// ITCH -> ?
`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]     itch_msg_sid;
logic [SEQ_NUM_W-1:0] itch_msg_seq_num;
`endif
`ifdef DEBUG
logic [DEBUG_ID_W-1:0] itch_debug_id;
`endif

logic itch_system_event_v;
logic [2*LEN-1:0] itch_system_event_stock_locate;
logic [2*LEN-1:0] itch_system_event_tracking_number;
logic [6*LEN-1:0] itch_system_event_timestamp;
logic [1*LEN-1:0] itch_system_event_event_code;

logic itch_stock_directory_v;
logic [2*LEN-1:0] itch_stock_directory_stock_locate;
logic [2*LEN-1:0] itch_stock_directory_tracking_number;
logic [6*LEN-1:0] itch_stock_directory_timestamp;
logic [8*LEN-1:0] itch_stock_directory_stock;
logic [1*LEN-1:0] itch_stock_directory_market_category;
logic [1*LEN-1:0] itch_stock_directory_financial_status_indicator;
logic [4*LEN-1:0] itch_stock_directory_round_lot_size;
logic [1*LEN-1:0] itch_stock_directory_round_lots_only;
logic [1*LEN-1:0] itch_stock_directory_issue_classification;
logic [2*LEN-1:0] itch_stock_directory_issue_sub_type;
logic [1*LEN-1:0] itch_stock_directory_authenticity;
logic [1*LEN-1:0] itch_stock_directory_short_sale_threshold_indicator;
logic [1*LEN-1:0] itch_stock_directory_ipo_flag;
logic [1*LEN-1:0] itch_stock_directory_luld_reference_price_tier;
logic [1*LEN-1:0] itch_stock_directory_etp_flag;
logic [4*LEN-1:0] itch_stock_directory_etp_leverage_factor;
logic [1*LEN-1:0] itch_stock_directory_inverse_indicator;

logic itch_stock_trading_action_v;
logic [2*LEN-1:0] itch_stock_trading_action_stock_locate;
logic [2*LEN-1:0] itch_stock_trading_action_tracking_number;
logic [6*LEN-1:0] itch_stock_trading_action_timestamp;
logic [8*LEN-1:0] itch_stock_trading_action_stock;
logic [1*LEN-1:0] itch_stock_trading_action_trading_state;
logic [1*LEN-1:0] itch_stock_trading_action_reserved;
logic [4*LEN-1:0] itch_stock_trading_action_reason;

logic itch_reg_sho_restriction_v;
logic [2*LEN-1:0] itch_reg_sho_restriction_stock_locate;
logic [2*LEN-1:0] itch_reg_sho_restriction_tracking_number;
logic [6*LEN-1:0] itch_reg_sho_restriction_timestamp;
logic [8*LEN-1:0] itch_reg_sho_restriction_stock;
logic [1*LEN-1:0] itch_reg_sho_restriction_reg_sho_action;

logic itch_market_participant_position_v;
logic [2*LEN-1:0] itch_market_participant_position_stock_locate;
logic [2*LEN-1:0] itch_market_participant_position_tracking_number;
logic [6*LEN-1:0] itch_market_participant_position_timestamp;
logic [4*LEN-1:0] itch_market_participant_position_mpid;
logic [8*LEN-1:0] itch_market_participant_position_stock;
logic [1*LEN-1:0] itch_market_participant_position_primary_market_maker;
logic [1*LEN-1:0] itch_market_participant_position_market_maker_mode;
logic [1*LEN-1:0] itch_market_participant_position_market_participant_state;

logic itch_mwcb_decline_level_v;
logic [2*LEN-1:0] itch_mwcb_decline_level_stock_locate;
logic [2*LEN-1:0] itch_mwcb_decline_level_tracking_number;
logic [6*LEN-1:0] itch_mwcb_decline_level_timestamp;
logic [8*LEN-1:0] itch_mwcb_decline_level_level_1;
logic [8*LEN-1:0] itch_mwcb_decline_level_level_2;
logic [8*LEN-1:0] itch_mwcb_decline_level_level_3;

logic itch_mwcb_status_v;
logic [2*LEN-1:0] itch_mwcb_status_stock_locate;
logic [2*LEN-1:0] itch_mwcb_status_tracking_number;
logic [6*LEN-1:0] itch_mwcb_status_timestamp;
logic [1*LEN-1:0] itch_mwcb_status_breached_level;

logic itch_ipo_quoting_period_update_v;
logic [2*LEN-1:0] itch_ipo_quoting_period_update_stock_locate;
logic [2*LEN-1:0] itch_ipo_quoting_period_update_tracking_number;
logic [6*LEN-1:0] itch_ipo_quoting_period_update_timestamp;
logic [8*LEN-1:0] itch_ipo_quoting_period_update_stock;
logic [4*LEN-1:0] itch_ipo_quoting_period_update_ipo_quotation_release_time;
logic [1*LEN-1:0] itch_ipo_quoting_period_update_ipo_quotation_release_qualifier;
logic [4*LEN-1:0] itch_ipo_quoting_period_update_ipo_price;

logic itch_luld_auction_collar_v;
logic [2*LEN-1:0] itch_luld_auction_collar_stock_locate;
logic [2*LEN-1:0] itch_luld_auction_collar_tracking_number;
logic [6*LEN-1:0] itch_luld_auction_collar_timestamp;
logic [8*LEN-1:0] itch_luld_auction_collar_stock;
logic [4*LEN-1:0] itch_luld_auction_collar_auction_collar_reference_price;
logic [4*LEN-1:0] itch_luld_auction_collar_upper_auction_collar_price;
logic [4*LEN-1:0] itch_luld_auction_collar_lower_auction_collar_price;
logic [4*LEN-1:0] itch_luld_auction_collar_auction_collar_extension;

logic itch_operational_halt_v;
logic [2*LEN-1:0] itch_operational_halt_stock_locate;
logic [2*LEN-1:0] itch_operational_halt_tracking_number;
logic [6*LEN-1:0] itch_operational_halt_timestamp;
logic [8*LEN-1:0] itch_operational_halt_stock;
logic [1*LEN-1:0] itch_operational_halt_market_code;
logic [1*LEN-1:0] itch_operational_halt_operational_halt_action;

logic itch_add_order_v;
logic [2*LEN-1:0] itch_add_order_stock_locate;
logic [2*LEN-1:0] itch_add_order_tracking_number;
logic [6*LEN-1:0] itch_add_order_timestamp;
logic [8*LEN-1:0] itch_add_order_order_reference_number;
logic [1*LEN-1:0] itch_add_order_buy_sell_indicator;
logic [4*LEN-1:0] itch_add_order_shares;
logic [8*LEN-1:0] itch_add_order_stock;
logic [4*LEN-1:0] itch_add_order_price;

logic itch_add_order_with_mpid_v;
logic [2*LEN-1:0] itch_add_order_with_mpid_stock_locate;
logic [2*LEN-1:0] itch_add_order_with_mpid_tracking_number;
logic [6*LEN-1:0] itch_add_order_with_mpid_timestamp;
logic [8*LEN-1:0] itch_add_order_with_mpid_order_reference_number;
logic [1*LEN-1:0] itch_add_order_with_mpid_buy_sell_indicator;
logic [4*LEN-1:0] itch_add_order_with_mpid_shares;
logic [8*LEN-1:0] itch_add_order_with_mpid_stock;
logic [4*LEN-1:0] itch_add_order_with_mpid_price;
logic [4*LEN-1:0] itch_add_order_with_mpid_attribution;

logic itch_order_executed_v;
logic [2*LEN-1:0] itch_order_executed_stock_locate;
logic [2*LEN-1:0] itch_order_executed_tracking_number;
logic [6*LEN-1:0] itch_order_executed_timestamp;
logic [8*LEN-1:0] itch_order_executed_order_reference_number;
logic [4*LEN-1:0] itch_order_executed_executed_shares;
logic [8*LEN-1:0] itch_order_executed_match_number;

logic itch_order_executed_with_price_v;
logic [2*LEN-1:0] itch_order_executed_with_price_stock_locate;
logic [2*LEN-1:0] itch_order_executed_with_price_tracking_number;
logic [6*LEN-1:0] itch_order_executed_with_price_timestamp;
logic [8*LEN-1:0] itch_order_executed_with_price_order_reference_number;
logic [4*LEN-1:0] itch_order_executed_with_price_executed_shares;
logic [8*LEN-1:0] itch_order_executed_with_price_match_number;
logic [1*LEN-1:0] itch_order_executed_with_price_printable;
logic [4*LEN-1:0] itch_order_executed_with_price_execution_price;

logic itch_order_cancel_v;
logic [2*LEN-1:0] itch_order_cancel_stock_locate;
logic [2*LEN-1:0] itch_order_cancel_tracking_number;
logic [6*LEN-1:0] itch_order_cancel_timestamp;
logic [8*LEN-1:0] itch_order_cancel_order_reference_number;
logic [4*LEN-1:0] itch_order_cancel_cancelled_shares;

logic itch_order_delete_v;
logic [2*LEN-1:0] itch_order_delete_stock_locate;
logic [2*LEN-1:0] itch_order_delete_tracking_number;
logic [6*LEN-1:0] itch_order_delete_timestamp;
logic [8*LEN-1:0] itch_order_delete_order_reference_number;

logic itch_order_replace_v;
logic [2*LEN-1:0] itch_order_replace_stock_locate;
logic [2*LEN-1:0] itch_order_replace_tracking_number;
logic [6*LEN-1:0] itch_order_replace_timestamp;
logic [8*LEN-1:0] itch_order_replace_original_order_reference_number;
logic [8*LEN-1:0] itch_order_replace_new_order_reference_number;
logic [4*LEN-1:0] itch_order_replace_shares;
logic [4*LEN-1:0] itch_order_replace_price;

logic itch_trade_v;
logic [2*LEN-1:0] itch_trade_stock_locate;
logic [2*LEN-1:0] itch_trade_tracking_number;
logic [6*LEN-1:0] itch_trade_timestamp;
logic [8*LEN-1:0] itch_trade_order_reference_number;
logic [1*LEN-1:0] itch_trade_buy_sell_indicator;
logic [4*LEN-1:0] itch_trade_shares;
logic [8*LEN-1:0] itch_trade_stock;
logic [4*LEN-1:0] itch_trade_price;
logic [8*LEN-1:0] itch_trade_match_number;

logic itch_cross_trade_v;
logic [2*LEN-1:0] itch_cross_trade_stock_locate;
logic [2*LEN-1:0] itch_cross_trade_tracking_number;
logic [6*LEN-1:0] itch_cross_trade_timestamp;
logic [8*LEN-1:0] itch_cross_trade_shares;
logic [8*LEN-1:0] itch_cross_trade_stock;
logic [4*LEN-1:0] itch_cross_trade_cross_price;
logic [8*LEN-1:0] itch_cross_trade_match_number;
logic [1*LEN-1:0] itch_cross_trade_cross_type;

logic itch_broken_trade_v;
logic [2*LEN-1:0] itch_broken_trade_stock_locate;
logic [2*LEN-1:0] itch_broken_trade_tracking_number;
logic [6*LEN-1:0] itch_broken_trade_timestamp;
logic [8*LEN-1:0] itch_broken_trade_match_number;

logic itch_net_order_imbalance_indicator_v;
logic [2*LEN-1:0] itch_net_order_imbalance_indicator_stock_locate;
logic [2*LEN-1:0] itch_net_order_imbalance_indicator_tracking_number;
logic [6*LEN-1:0] itch_net_order_imbalance_indicator_timestamp;
logic [8*LEN-1:0] itch_net_order_imbalance_indicator_paired_shares;
logic [8*LEN-1:0] itch_net_order_imbalance_indicator_imbalance_shares;
logic [1*LEN-1:0] itch_net_order_imbalance_indicator_imbalance_direction;
logic [8*LEN-1:0] itch_net_order_imbalance_indicator_stock;
logic [4*LEN-1:0] itch_net_order_imbalance_indicator_far_price;
logic [4*LEN-1:0] itch_net_order_imbalance_indicator_near_price;
logic [4*LEN-1:0] itch_net_order_imbalance_indicator_current_reference_price;
logic [1*LEN-1:0] itch_net_order_imbalance_indicator_cross_type;
logic [1*LEN-1:0] itch_net_order_imbalance_indicator_price_variation_indicator;

logic itch_retail_price_improvement_indicator_v;
logic [2*LEN-1:0] itch_retail_price_improvement_indicator_stock_locate;
logic [2*LEN-1:0] itch_retail_price_improvement_indicator_tracking_number;
logic [6*LEN-1:0] itch_retail_price_improvement_indicator_timestamp;
logic [8*LEN-1:0] itch_retail_price_improvement_indicator_stock;
logic [1*LEN-1:0] itch_retail_price_improvement_indicator_interest_flag;

// mold
moldudp64 #(
	.AXI_DATA_W(AXI_DATA_W),
	.AXI_KEEP_W(AXI_KEEP_W),
	.SID_W(SID_W),
	.SEQ_NUM_W(SEQ_NUM_W),
	.ML_W(ML_W),
	.EOS_MSG_CNT(16'hffff)
) m_moldudp64(
	.clk(clk),
	.nreset(nreset),
	
	.udp_axis_tvalid_i(udp_mold_axis_tvalid),
	.udp_axis_tkeep_i (udp_mold_axis_tkeep ),
	.udp_axis_tdata_i (udp_mold_axis_tdata ),
	.udp_axis_tlast_i (udp_mold_axis_tlast ),
	.udp_axis_tuser_i (udp_mold_axis_tuser ),
	.udp_axis_tready_o(mold_udp_axis_tready),
	
	`ifdef MOLD_MSG_IDS
	.mold_msg_sid_o    (mold_msg_sid ),
	.mold_msg_seq_num_o(mold_msg_seq ),
	`endif

	`ifdef DEBUG
	.mold_debug_id_o (mold_itch_msg_debug_id),
	`endif
	
	.mold_msg_v_o    (mold_itch_msg_v     ),
	.mold_msg_start_o(mold_itch_msg_start ),
	.mold_msg_mask_o (mold_itch_msg_mask  ),
	.mold_msg_data_o (mold_itch_msg_data  )
);
// itch
tv_itch5 #( .LEN(LEN),
`ifdef MOLD_MSG_IDS
	.SID_W(SID_W), .SEQ_NUM_W(SEQ_NUM_W),
`endif
	.AXI_DATA_W(AXI_DATA_W), .AXI_KEEP_W(AXI_KEEP_W),
	.MSG_MAX_W(MSG_MAX_W), .CNT_MAX(CNT_MAX), .CNT_MAX_W(CNT_MAX_W) 
)
m_itch(
	.clk(clk),
	.nreset(nreset),

	.valid_i(mold_itch_msg_v),
	.start_i(mold_itch_msg_start),
	.data_i (mold_itch_msg_data),

	`ifdef DEBUG
	.debug_id_i    (mold_itch_msg_debug_id ),    
	.debug_id_o    (itch_debug_id          ),
	`endif

	.itch_system_event_v_o(itch_system_event_v),
	.itch_system_event_stock_locate_o(itch_system_event_stock_locate),
	.itch_system_event_tracking_number_o(itch_system_event_tracking_number),
	.itch_system_event_timestamp_o(itch_system_event_timestamp),
	.itch_system_event_event_code_o(itch_system_event_event_code),
	.itch_stock_directory_v_o(itch_stock_directory_v),
	.itch_stock_directory_stock_locate_o(itch_stock_directory_stock_locate),
	.itch_stock_directory_tracking_number_o(itch_stock_directory_tracking_number),
	.itch_stock_directory_timestamp_o(itch_stock_directory_timestamp),
	.itch_stock_directory_stock_o(itch_stock_directory_stock),
	.itch_stock_directory_market_category_o(itch_stock_directory_market_category),
	.itch_stock_directory_financial_status_indicator_o(itch_stock_directory_financial_status_indicator),
	.itch_stock_directory_round_lot_size_o(itch_stock_directory_round_lot_size),
	.itch_stock_directory_round_lots_only_o(itch_stock_directory_round_lots_only),
	.itch_stock_directory_issue_classification_o(itch_stock_directory_issue_classification),
	.itch_stock_directory_issue_sub_type_o(itch_stock_directory_issue_sub_type),
	.itch_stock_directory_authenticity_o(itch_stock_directory_authenticity),
	.itch_stock_directory_short_sale_threshold_indicator_o(itch_stock_directory_short_sale_threshold_indicator),
	.itch_stock_directory_ipo_flag_o(itch_stock_directory_ipo_flag),
	.itch_stock_directory_luld_reference_price_tier_o(itch_stock_directory_luld_reference_price_tier),
	.itch_stock_directory_etp_flag_o(itch_stock_directory_etp_flag),
	.itch_stock_directory_etp_leverage_factor_o(itch_stock_directory_etp_leverage_factor),
	.itch_stock_directory_inverse_indicator_o(itch_stock_directory_inverse_indicator),
	.itch_stock_trading_action_v_o(itch_stock_trading_action_v),
	.itch_stock_trading_action_stock_locate_o(itch_stock_trading_action_stock_locate),
	.itch_stock_trading_action_tracking_number_o(itch_stock_trading_action_tracking_number),
	.itch_stock_trading_action_timestamp_o(itch_stock_trading_action_timestamp),
	.itch_stock_trading_action_stock_o(itch_stock_trading_action_stock),
	.itch_stock_trading_action_trading_state_o(itch_stock_trading_action_trading_state),
	.itch_stock_trading_action_reserved_o(itch_stock_trading_action_reserved),
	.itch_stock_trading_action_reason_o(itch_stock_trading_action_reason),
	.itch_reg_sho_restriction_v_o(itch_reg_sho_restriction_v),
	.itch_reg_sho_restriction_stock_locate_o(itch_reg_sho_restriction_stock_locate),
	.itch_reg_sho_restriction_tracking_number_o(itch_reg_sho_restriction_tracking_number),
	.itch_reg_sho_restriction_timestamp_o(itch_reg_sho_restriction_timestamp),
	.itch_reg_sho_restriction_stock_o(itch_reg_sho_restriction_stock),
	.itch_reg_sho_restriction_reg_sho_action_o(itch_reg_sho_restriction_reg_sho_action),
	.itch_market_participant_position_v_o(itch_market_participant_position_v),
	.itch_market_participant_position_stock_locate_o(itch_market_participant_position_stock_locate),
	.itch_market_participant_position_tracking_number_o(itch_market_participant_position_tracking_number),
	.itch_market_participant_position_timestamp_o(itch_market_participant_position_timestamp),
	.itch_market_participant_position_mpid_o(itch_market_participant_position_mpid),
	.itch_market_participant_position_stock_o(itch_market_participant_position_stock),
	.itch_market_participant_position_primary_market_maker_o(itch_market_participant_position_primary_market_maker),
	.itch_market_participant_position_market_maker_mode_o(itch_market_participant_position_market_maker_mode),
	.itch_market_participant_position_market_participant_state_o(itch_market_participant_position_market_participant_state),
	.itch_mwcb_decline_level_v_o(itch_mwcb_decline_level_v),
	.itch_mwcb_decline_level_stock_locate_o(itch_mwcb_decline_level_stock_locate),
	.itch_mwcb_decline_level_tracking_number_o(itch_mwcb_decline_level_tracking_number),
	.itch_mwcb_decline_level_timestamp_o(itch_mwcb_decline_level_timestamp),
	.itch_mwcb_decline_level_level_1_o(itch_mwcb_decline_level_level_1),
	.itch_mwcb_decline_level_level_2_o(itch_mwcb_decline_level_level_2),
	.itch_mwcb_decline_level_level_3_o(itch_mwcb_decline_level_level_3),
	.itch_mwcb_status_v_o(itch_mwcb_status_v),
	.itch_mwcb_status_stock_locate_o(itch_mwcb_status_stock_locate),
	.itch_mwcb_status_tracking_number_o(itch_mwcb_status_tracking_number),
	.itch_mwcb_status_timestamp_o(itch_mwcb_status_timestamp),
	.itch_mwcb_status_breached_level_o(itch_mwcb_status_breached_level),
	.itch_ipo_quoting_period_update_v_o(itch_ipo_quoting_period_update_v),
	.itch_ipo_quoting_period_update_stock_locate_o(itch_ipo_quoting_period_update_stock_locate),
	.itch_ipo_quoting_period_update_tracking_number_o(itch_ipo_quoting_period_update_tracking_number),
	.itch_ipo_quoting_period_update_timestamp_o(itch_ipo_quoting_period_update_timestamp),
	.itch_ipo_quoting_period_update_stock_o(itch_ipo_quoting_period_update_stock),
	.itch_ipo_quoting_period_update_ipo_quotation_release_time_o(itch_ipo_quoting_period_update_ipo_quotation_release_time),
	.itch_ipo_quoting_period_update_ipo_quotation_release_qualifier_o(itch_ipo_quoting_period_update_ipo_quotation_release_qualifier),
	.itch_ipo_quoting_period_update_ipo_price_o(itch_ipo_quoting_period_update_ipo_price),
	.itch_luld_auction_collar_v_o(itch_luld_auction_collar_v),
	.itch_luld_auction_collar_stock_locate_o(itch_luld_auction_collar_stock_locate),
	.itch_luld_auction_collar_tracking_number_o(itch_luld_auction_collar_tracking_number),
	.itch_luld_auction_collar_timestamp_o(itch_luld_auction_collar_timestamp),
	.itch_luld_auction_collar_stock_o(itch_luld_auction_collar_stock),
	.itch_luld_auction_collar_auction_collar_reference_price_o(itch_luld_auction_collar_auction_collar_reference_price),
	.itch_luld_auction_collar_upper_auction_collar_price_o(itch_luld_auction_collar_upper_auction_collar_price),
	.itch_luld_auction_collar_lower_auction_collar_price_o(itch_luld_auction_collar_lower_auction_collar_price),
	.itch_luld_auction_collar_auction_collar_extension_o(itch_luld_auction_collar_auction_collar_extension),
	.itch_operational_halt_v_o(itch_operational_halt_v),
	.itch_operational_halt_stock_locate_o(itch_operational_halt_stock_locate),
	.itch_operational_halt_tracking_number_o(itch_operational_halt_tracking_number),
	.itch_operational_halt_timestamp_o(itch_operational_halt_timestamp),
	.itch_operational_halt_stock_o(itch_operational_halt_stock),
	.itch_operational_halt_market_code_o(itch_operational_halt_market_code),
	.itch_operational_halt_operational_halt_action_o(itch_operational_halt_operational_halt_action),
	.itch_add_order_v_o(itch_add_order_v),
	.itch_add_order_stock_locate_o(itch_add_order_stock_locate),
	.itch_add_order_tracking_number_o(itch_add_order_tracking_number),
	.itch_add_order_timestamp_o(itch_add_order_timestamp),
	.itch_add_order_order_reference_number_o(itch_add_order_order_reference_number),
	.itch_add_order_buy_sell_indicator_o(itch_add_order_buy_sell_indicator),
	.itch_add_order_shares_o(itch_add_order_shares),
	.itch_add_order_stock_o(itch_add_order_stock),
	.itch_add_order_price_o(itch_add_order_price),
	.itch_add_order_with_mpid_v_o(itch_add_order_with_mpid_v),
	.itch_add_order_with_mpid_stock_locate_o(itch_add_order_with_mpid_stock_locate),
	.itch_add_order_with_mpid_tracking_number_o(itch_add_order_with_mpid_tracking_number),
	.itch_add_order_with_mpid_timestamp_o(itch_add_order_with_mpid_timestamp),
	.itch_add_order_with_mpid_order_reference_number_o(itch_add_order_with_mpid_order_reference_number),
	.itch_add_order_with_mpid_buy_sell_indicator_o(itch_add_order_with_mpid_buy_sell_indicator),
	.itch_add_order_with_mpid_shares_o(itch_add_order_with_mpid_shares),
	.itch_add_order_with_mpid_stock_o(itch_add_order_with_mpid_stock),
	.itch_add_order_with_mpid_price_o(itch_add_order_with_mpid_price),
	.itch_add_order_with_mpid_attribution_o(itch_add_order_with_mpid_attribution),
	.itch_order_executed_v_o(itch_order_executed_v),
	.itch_order_executed_stock_locate_o(itch_order_executed_stock_locate),
	.itch_order_executed_tracking_number_o(itch_order_executed_tracking_number),
	.itch_order_executed_timestamp_o(itch_order_executed_timestamp),
	.itch_order_executed_order_reference_number_o(itch_order_executed_order_reference_number),
	.itch_order_executed_executed_shares_o(itch_order_executed_executed_shares),
	.itch_order_executed_match_number_o(itch_order_executed_match_number),
	.itch_order_executed_with_price_v_o(itch_order_executed_with_price_v),
	.itch_order_executed_with_price_stock_locate_o(itch_order_executed_with_price_stock_locate),
	.itch_order_executed_with_price_tracking_number_o(itch_order_executed_with_price_tracking_number),
	.itch_order_executed_with_price_timestamp_o(itch_order_executed_with_price_timestamp),
	.itch_order_executed_with_price_order_reference_number_o(itch_order_executed_with_price_order_reference_number),
	.itch_order_executed_with_price_executed_shares_o(itch_order_executed_with_price_executed_shares),
	.itch_order_executed_with_price_match_number_o(itch_order_executed_with_price_match_number),
	.itch_order_executed_with_price_printable_o(itch_order_executed_with_price_printable),
	.itch_order_executed_with_price_execution_price_o(itch_order_executed_with_price_execution_price),
	.itch_order_cancel_v_o(itch_order_cancel_v),
	.itch_order_cancel_stock_locate_o(itch_order_cancel_stock_locate),
	.itch_order_cancel_tracking_number_o(itch_order_cancel_tracking_number),
	.itch_order_cancel_timestamp_o(itch_order_cancel_timestamp),
	.itch_order_cancel_order_reference_number_o(itch_order_cancel_order_reference_number),
	.itch_order_cancel_cancelled_shares_o(itch_order_cancel_cancelled_shares),
	.itch_order_delete_v_o(itch_order_delete_v),
	.itch_order_delete_stock_locate_o(itch_order_delete_stock_locate),
	.itch_order_delete_tracking_number_o(itch_order_delete_tracking_number),
	.itch_order_delete_timestamp_o(itch_order_delete_timestamp),
	.itch_order_delete_order_reference_number_o(itch_order_delete_order_reference_number),
	.itch_order_replace_v_o(itch_order_replace_v),
	.itch_order_replace_stock_locate_o(itch_order_replace_stock_locate),
	.itch_order_replace_tracking_number_o(itch_order_replace_tracking_number),
	.itch_order_replace_timestamp_o(itch_order_replace_timestamp),
	.itch_order_replace_original_order_reference_number_o(itch_order_replace_original_order_reference_number),
	.itch_order_replace_new_order_reference_number_o(itch_order_replace_new_order_reference_number),
	.itch_order_replace_shares_o(itch_order_replace_shares),
	.itch_order_replace_price_o(itch_order_replace_price),
	.itch_trade_v_o(itch_trade_v),
	.itch_trade_stock_locate_o(itch_trade_stock_locate),
	.itch_trade_tracking_number_o(itch_trade_tracking_number),
	.itch_trade_timestamp_o(itch_trade_timestamp),
	.itch_trade_order_reference_number_o(itch_trade_order_reference_number),
	.itch_trade_buy_sell_indicator_o(itch_trade_buy_sell_indicator),
	.itch_trade_shares_o(itch_trade_shares),
	.itch_trade_stock_o(itch_trade_stock),
	.itch_trade_price_o(itch_trade_price),
	.itch_trade_match_number_o(itch_trade_match_number),
	.itch_cross_trade_v_o(itch_cross_trade_v),
	.itch_cross_trade_stock_locate_o(itch_cross_trade_stock_locate),
	.itch_cross_trade_tracking_number_o(itch_cross_trade_tracking_number),
	.itch_cross_trade_timestamp_o(itch_cross_trade_timestamp),
	.itch_cross_trade_shares_o(itch_cross_trade_shares),
	.itch_cross_trade_stock_o(itch_cross_trade_stock),
	.itch_cross_trade_cross_price_o(itch_cross_trade_cross_price),
	.itch_cross_trade_match_number_o(itch_cross_trade_match_number),
	.itch_cross_trade_cross_type_o(itch_cross_trade_cross_type),
	.itch_broken_trade_v_o(itch_broken_trade_v),
	.itch_broken_trade_stock_locate_o(itch_broken_trade_stock_locate),
	.itch_broken_trade_tracking_number_o(itch_broken_trade_tracking_number),
	.itch_broken_trade_timestamp_o(itch_broken_trade_timestamp),
	.itch_broken_trade_match_number_o(itch_broken_trade_match_number),
	.itch_net_order_imbalance_indicator_v_o(itch_net_order_imbalance_indicator_v),
	.itch_net_order_imbalance_indicator_stock_locate_o(itch_net_order_imbalance_indicator_stock_locate),
	.itch_net_order_imbalance_indicator_tracking_number_o(itch_net_order_imbalance_indicator_tracking_number),
	.itch_net_order_imbalance_indicator_timestamp_o(itch_net_order_imbalance_indicator_timestamp),
	.itch_net_order_imbalance_indicator_paired_shares_o(itch_net_order_imbalance_indicator_paired_shares),
	.itch_net_order_imbalance_indicator_imbalance_shares_o(itch_net_order_imbalance_indicator_imbalance_shares),
	.itch_net_order_imbalance_indicator_imbalance_direction_o(itch_net_order_imbalance_indicator_imbalance_direction),
	.itch_net_order_imbalance_indicator_stock_o(itch_net_order_imbalance_indicator_stock),
	.itch_net_order_imbalance_indicator_far_price_o(itch_net_order_imbalance_indicator_far_price),
	.itch_net_order_imbalance_indicator_near_price_o(itch_net_order_imbalance_indicator_near_price),
	.itch_net_order_imbalance_indicator_current_reference_price_o(itch_net_order_imbalance_indicator_current_reference_price),
	.itch_net_order_imbalance_indicator_cross_type_o(itch_net_order_imbalance_indicator_cross_type),
	.itch_net_order_imbalance_indicator_price_variation_indicator_o(itch_net_order_imbalance_indicator_price_variation_indicator),

	.itch_retail_price_improvement_indicator_v_o(itch_retail_price_improvement_indicator_v),	
	.itch_retail_price_improvement_indicator_stock_locate_o(itch_retail_price_improvement_indicator_stock_locate),
	.itch_retail_price_improvement_indicator_tracking_number_o(itch_retail_price_improvement_indicator_tracking_number),
	.itch_retail_price_improvement_indicator_timestamp_o(itch_retail_price_improvement_indicator_timestamp),
	.itch_retail_price_improvement_indicator_stock_o(itch_retail_price_improvement_indicator_stock),
	.itch_retail_price_improvement_indicator_interest_flag_o(itch_retail_price_improvement_indicator_interest_flag)
);



`ifdef FORMAL
`endif
endmodule
