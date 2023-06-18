/* Copyright (c) 2023, Julia Desmazes. All rights reserved.
 * 
 * This work is licensed under the Creative Commons Attribution-NonCommercial
 * 4.0 International License. 
 * 
 * This code is provided "as is" without any express or implied warranties. */ 
`ifndef DEBUG_ID
`define DEBUG_ID
`endif

`define assert_stop( X ) \
if (~( X )) begin \
$display("assert failed : time %t , line %0d",$time, `__LINE__); \
$stop; \
end 

parameter AXI_DATA_W = 64;
parameter AXI_KEEP_W = AXI_DATA_W/8;
parameter LEN   = 8;
parameter ML_W  = 2*LEN;
parameter SID_W = 10*LEN;// session id
parameter SEQ_NUM_W = 8*LEN; // sequence number
parameter MH_W  = 20*LEN;// header 
parameter MSG_MAX_W = 50*LEN;
parameter CNT_MAX   = 7;
parameter CNT_MAX_W = $clog2(CNT_MAX);
parameter DEBUG_ID_W = SID_W + SEQ_NUM_W;

module hft_tb;	
reg clk = 0;
reg nreset = 1'b0;	

logic [MH_W-1:0]       moldudp_header;
logic [ML_W-1:0]       moldudp_msg_len;
logic                  udp_axis_tvalid_i;
logic [AXI_KEEP_W-1:0] udp_axis_tkeep_i;
logic [AXI_DATA_W-1:0] udp_axis_tdata_i;
logic                  udp_axis_tlast_i;
logic                  udp_axis_tuser_i;
logic                  udp_axis_tready_o;

logic                  mold_msg_v_o;
logic                  mold_msg_start_o;
logic [AXI_KEEP_W-1:0] mold_msg_mask_o;
logic [AXI_DATA_W-1:0] mold_msg_data_o;

`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]      mold_msg_sid_o;
logic [SEQ_NUM_W-1:0]  mold_msg_seq_num_o;
`endif
logic [DEBUG_ID_W-1:0] mold_debug_id_o;

// ITCH
logic itch_msg_v_sent;

// TB output 
`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]     tb_itch_msg_sid;
logic [SEQ_NUM_W-1:0] tb_itch_msg_seq_num;
`endif

logic [DEBUG_ID_W-1:0] tb_itch_debug_id;

logic tb_itch_system_event_v;
logic [2*LEN-1:0] tb_itch_system_event_stock_locate;
logic [2*LEN-1:0] tb_itch_system_event_tracking_number;
logic [6*LEN-1:0] tb_itch_system_event_timestamp;
logic [1*LEN-1:0] tb_itch_system_event_event_code;

logic tb_itch_stock_directory_v;
logic [2*LEN-1:0] tb_itch_stock_directory_stock_locate;
logic [2*LEN-1:0] tb_itch_stock_directory_tracking_number;
logic [6*LEN-1:0] tb_itch_stock_directory_timestamp;
logic [8*LEN-1:0] tb_itch_stock_directory_stock;
logic [1*LEN-1:0] tb_itch_stock_directory_market_category;
logic [1*LEN-1:0] tb_itch_stock_directory_financial_status_indicator;
logic [4*LEN-1:0] tb_itch_stock_directory_round_lot_size;
logic [1*LEN-1:0] tb_itch_stock_directory_round_lots_only;
logic [1*LEN-1:0] tb_itch_stock_directory_issue_classification;
logic [2*LEN-1:0] tb_itch_stock_directory_issue_sub_type;
logic [1*LEN-1:0] tb_itch_stock_directory_authenticity;
logic [1*LEN-1:0] tb_itch_stock_directory_short_sale_threshold_indicator;
logic [1*LEN-1:0] tb_itch_stock_directory_ipo_flag;
logic [1*LEN-1:0] tb_itch_stock_directory_luld_reference_price_tier;
logic [1*LEN-1:0] tb_itch_stock_directory_etp_flag;
logic [4*LEN-1:0] tb_itch_stock_directory_etp_leverage_factor;
logic [1*LEN-1:0] tb_itch_stock_directory_inverse_indicator;

logic tb_itch_stock_trading_action_v;
logic [2*LEN-1:0] tb_itch_stock_trading_action_stock_locate;
logic [2*LEN-1:0] tb_itch_stock_trading_action_tracking_number;
logic [6*LEN-1:0] tb_itch_stock_trading_action_timestamp;
logic [8*LEN-1:0] tb_itch_stock_trading_action_stock;
logic [1*LEN-1:0] tb_itch_stock_trading_action_trading_state;
logic [1*LEN-1:0] tb_itch_stock_trading_action_reserved;
logic [4*LEN-1:0] tb_itch_stock_trading_action_reason;

logic tb_itch_reg_sho_restriction_v;
logic [2*LEN-1:0] tb_itch_reg_sho_restriction_stock_locate;
logic [2*LEN-1:0] tb_itch_reg_sho_restriction_tracking_number;
logic [6*LEN-1:0] tb_itch_reg_sho_restriction_timestamp;
logic [8*LEN-1:0] tb_itch_reg_sho_restriction_stock;
logic [1*LEN-1:0] tb_itch_reg_sho_restriction_reg_sho_action;

logic tb_itch_market_participant_position_v;
logic [2*LEN-1:0] tb_itch_market_participant_position_stock_locate;
logic [2*LEN-1:0] tb_itch_market_participant_position_tracking_number;
logic [6*LEN-1:0] tb_itch_market_participant_position_timestamp;
logic [4*LEN-1:0] tb_itch_market_participant_position_mpid;
logic [8*LEN-1:0] tb_itch_market_participant_position_stock;
logic [1*LEN-1:0] tb_itch_market_participant_position_primary_market_maker;
logic [1*LEN-1:0] tb_itch_market_participant_position_market_maker_mode;
logic [1*LEN-1:0] tb_itch_market_participant_position_market_participant_state;

logic tb_itch_mwcb_decline_level_v;
logic [2*LEN-1:0] tb_itch_mwcb_decline_level_stock_locate;
logic [2*LEN-1:0] tb_itch_mwcb_decline_level_tracking_number;
logic [6*LEN-1:0] tb_itch_mwcb_decline_level_timestamp;
logic [8*LEN-1:0] tb_itch_mwcb_decline_level_level_1;
logic [8*LEN-1:0] tb_itch_mwcb_decline_level_level_2;
logic [8*LEN-1:0] tb_itch_mwcb_decline_level_level_3;

logic tb_itch_mwcb_status_v;
logic [2*LEN-1:0] tb_itch_mwcb_status_stock_locate;
logic [2*LEN-1:0] tb_itch_mwcb_status_tracking_number;
logic [6*LEN-1:0] tb_itch_mwcb_status_timestamp;
logic [1*LEN-1:0] tb_itch_mwcb_status_breached_level;

logic tb_itch_ipo_quoting_period_update_v;
logic [2*LEN-1:0] tb_itch_ipo_quoting_period_update_stock_locate;
logic [2*LEN-1:0] tb_itch_ipo_quoting_period_update_tracking_number;
logic [6*LEN-1:0] tb_itch_ipo_quoting_period_update_timestamp;
logic [8*LEN-1:0] tb_itch_ipo_quoting_period_update_stock;
logic [4*LEN-1:0] tb_itch_ipo_quoting_period_update_ipo_quotation_release_time;
logic [1*LEN-1:0] tb_itch_ipo_quoting_period_update_ipo_quotation_release_qualifier;
logic [4*LEN-1:0] tb_itch_ipo_quoting_period_update_ipo_price;

logic tb_itch_luld_auction_collar_v;
logic [2*LEN-1:0] tb_itch_luld_auction_collar_stock_locate;
logic [2*LEN-1:0] tb_itch_luld_auction_collar_tracking_number;
logic [6*LEN-1:0] tb_itch_luld_auction_collar_timestamp;
logic [8*LEN-1:0] tb_itch_luld_auction_collar_stock;
logic [4*LEN-1:0] tb_itch_luld_auction_collar_auction_collar_reference_price;
logic [4*LEN-1:0] tb_itch_luld_auction_collar_upper_auction_collar_price;
logic [4*LEN-1:0] tb_itch_luld_auction_collar_lower_auction_collar_price;
logic [4*LEN-1:0] tb_itch_luld_auction_collar_auction_collar_extension;

logic tb_itch_operational_halt_v;
logic [2*LEN-1:0] tb_itch_operational_halt_stock_locate;
logic [2*LEN-1:0] tb_itch_operational_halt_tracking_number;
logic [6*LEN-1:0] tb_itch_operational_halt_timestamp;
logic [8*LEN-1:0] tb_itch_operational_halt_stock;
logic [1*LEN-1:0] tb_itch_operational_halt_market_code;
logic [1*LEN-1:0] tb_itch_operational_halt_operational_halt_action;

logic tb_itch_add_order_v;
logic [2*LEN-1:0] tb_itch_add_order_stock_locate;
logic [2*LEN-1:0] tb_itch_add_order_tracking_number;
logic [6*LEN-1:0] tb_itch_add_order_timestamp;
logic [8*LEN-1:0] tb_itch_add_order_order_reference_number;
logic [1*LEN-1:0] tb_itch_add_order_buy_sell_indicator;
logic [4*LEN-1:0] tb_itch_add_order_shares;
logic [8*LEN-1:0] tb_itch_add_order_stock;
logic [4*LEN-1:0] tb_itch_add_order_price;

logic tb_itch_add_order_with_mpid_v;
logic [2*LEN-1:0] tb_itch_add_order_with_mpid_stock_locate;
logic [2*LEN-1:0] tb_itch_add_order_with_mpid_tracking_number;
logic [6*LEN-1:0] tb_itch_add_order_with_mpid_timestamp;
logic [8*LEN-1:0] tb_itch_add_order_with_mpid_order_reference_number;
logic [1*LEN-1:0] tb_itch_add_order_with_mpid_buy_sell_indicator;
logic [4*LEN-1:0] tb_itch_add_order_with_mpid_shares;
logic [8*LEN-1:0] tb_itch_add_order_with_mpid_stock;
logic [4*LEN-1:0] tb_itch_add_order_with_mpid_price;
logic [4*LEN-1:0] tb_itch_add_order_with_mpid_attribution;

logic tb_itch_order_executed_v;
logic [2*LEN-1:0] tb_itch_order_executed_stock_locate;
logic [2*LEN-1:0] tb_itch_order_executed_tracking_number;
logic [6*LEN-1:0] tb_itch_order_executed_timestamp;
logic [8*LEN-1:0] tb_itch_order_executed_order_reference_number;
logic [4*LEN-1:0] tb_itch_order_executed_executed_shares;
logic [8*LEN-1:0] tb_itch_order_executed_match_number;

logic tb_itch_order_executed_with_price_v;
logic [2*LEN-1:0] tb_itch_order_executed_with_price_stock_locate;
logic [2*LEN-1:0] tb_itch_order_executed_with_price_tracking_number;
logic [6*LEN-1:0] tb_itch_order_executed_with_price_timestamp;
logic [8*LEN-1:0] tb_itch_order_executed_with_price_order_reference_number;
logic [4*LEN-1:0] tb_itch_order_executed_with_price_executed_shares;
logic [8*LEN-1:0] tb_itch_order_executed_with_price_match_number;
logic [1*LEN-1:0] tb_itch_order_executed_with_price_printable;
logic [4*LEN-1:0] tb_itch_order_executed_with_price_execution_price;

logic tb_itch_order_cancel_v;
logic [2*LEN-1:0] tb_itch_order_cancel_stock_locate;
logic [2*LEN-1:0] tb_itch_order_cancel_tracking_number;
logic [6*LEN-1:0] tb_itch_order_cancel_timestamp;
logic [8*LEN-1:0] tb_itch_order_cancel_order_reference_number;
logic [4*LEN-1:0] tb_itch_order_cancel_cancelled_shares;

logic tb_itch_order_delete_v;
logic [2*LEN-1:0] tb_itch_order_delete_stock_locate;
logic [2*LEN-1:0] tb_itch_order_delete_tracking_number;
logic [6*LEN-1:0] tb_itch_order_delete_timestamp;
logic [8*LEN-1:0] tb_itch_order_delete_order_reference_number;

logic tb_itch_order_replace_v;
logic [2*LEN-1:0] tb_itch_order_replace_stock_locate;
logic [2*LEN-1:0] tb_itch_order_replace_tracking_number;
logic [6*LEN-1:0] tb_itch_order_replace_timestamp;
logic [8*LEN-1:0] tb_itch_order_replace_original_order_reference_number;
logic [8*LEN-1:0] tb_itch_order_replace_new_order_reference_number;
logic [4*LEN-1:0] tb_itch_order_replace_shares;
logic [4*LEN-1:0] tb_itch_order_replace_price;

logic tb_itch_trade_v;
logic [2*LEN-1:0] tb_itch_trade_stock_locate;
logic [2*LEN-1:0] tb_itch_trade_tracking_number;
logic [6*LEN-1:0] tb_itch_trade_timestamp;
logic [8*LEN-1:0] tb_itch_trade_order_reference_number;
logic [1*LEN-1:0] tb_itch_trade_buy_sell_indicator;
logic [4*LEN-1:0] tb_itch_trade_shares;
logic [8*LEN-1:0] tb_itch_trade_stock;
logic [4*LEN-1:0] tb_itch_trade_price;
logic [8*LEN-1:0] tb_itch_trade_match_number;

logic tb_itch_cross_trade_v;
logic [2*LEN-1:0] tb_itch_cross_trade_stock_locate;
logic [2*LEN-1:0] tb_itch_cross_trade_tracking_number;
logic [6*LEN-1:0] tb_itch_cross_trade_timestamp;
logic [8*LEN-1:0] tb_itch_cross_trade_shares;
logic [8*LEN-1:0] tb_itch_cross_trade_stock;
logic [4*LEN-1:0] tb_itch_cross_trade_cross_price;
logic [8*LEN-1:0] tb_itch_cross_trade_match_number;
logic [1*LEN-1:0] tb_itch_cross_trade_cross_type;

logic tb_itch_broken_trade_v;
logic [2*LEN-1:0] tb_itch_broken_trade_stock_locate;
logic [2*LEN-1:0] tb_itch_broken_trade_tracking_number;
logic [6*LEN-1:0] tb_itch_broken_trade_timestamp;
logic [8*LEN-1:0] tb_itch_broken_trade_match_number;

logic tb_itch_net_order_imbalance_indicator_v;
logic [2*LEN-1:0] tb_itch_net_order_imbalance_indicator_stock_locate;
logic [2*LEN-1:0] tb_itch_net_order_imbalance_indicator_tracking_number;
logic [6*LEN-1:0] tb_itch_net_order_imbalance_indicator_timestamp;
logic [8*LEN-1:0] tb_itch_net_order_imbalance_indicator_paired_shares;
logic [8*LEN-1:0] tb_itch_net_order_imbalance_indicator_imbalance_shares;
logic [1*LEN-1:0] tb_itch_net_order_imbalance_indicator_imbalance_direction;
logic [8*LEN-1:0] tb_itch_net_order_imbalance_indicator_stock;
logic [4*LEN-1:0] tb_itch_net_order_imbalance_indicator_far_price;
logic [4*LEN-1:0] tb_itch_net_order_imbalance_indicator_near_price;
logic [4*LEN-1:0] tb_itch_net_order_imbalance_indicator_current_reference_price;
logic [1*LEN-1:0] tb_itch_net_order_imbalance_indicator_cross_type;
logic [1*LEN-1:0] tb_itch_net_order_imbalance_indicator_price_variation_indicator;

logic tb_itch_retail_price_improvement_indicator_v;
logic [2*LEN-1:0] tb_itch_retail_price_improvement_indicator_stock_locate;
logic [2*LEN-1:0] tb_itch_retail_price_improvement_indicator_tracking_number;
logic [6*LEN-1:0] tb_itch_retail_price_improvement_indicator_timestamp;
logic [8*LEN-1:0] tb_itch_retail_price_improvement_indicator_stock;
logic [1*LEN-1:0] tb_itch_retail_price_improvement_indicator_interest_flag;

// GLIMPS ( not used ) 
logic tb_itch_end_of_snapshot_v;
logic [79:0] tb_itch_end_of_snapshot_sequence_number;

`ifdef MOLD_MSG_IDS
logic [SID_W-1:0]     itch_msg_sid;
logic [SEQ_NUM_W-1:0] itch_msg_seq_num;
`endif
logic [DEBUG_ID_W-1:0] itch_debug_id;

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



int t;

logic tb_ready;
logic tb_valid;
logic [63:0] tb_data;
logic [7:0]  tb_keep;

logic tb_finished;

function void end_tb(input logic end_v);
	begin
		if ( end_v ) begin
			$display("End of test, time %t", $time);
			$tb_end();
			$finish;
		end	
	end
endfunction

task vpi_task;
begin
	integer i;
	for(i=0; i < 15000000 ; i++ ) begin
		#10	
		tb_ready = udp_axis_tready_o;
		$tb(tb_ready, tb_valid, tb_data, tb_keep, tb_finished);
		end_tb(tb_finished);
		udp_axis_tvalid_i = tb_valid;
		udp_axis_tdata_i  = tb_data;
		udp_axis_tkeep_i  = tb_keep;
		udp_axis_tuser_i  = 1'b0;
		udp_axis_tlast_i  = ~( tb_keep == 8'hff);
		if ( udp_axis_tlast_i == 1'b1 ) begin
			// TODO remove : back to back bug
			#10
			udp_axis_tvalid_i = 1'b0;
			#20
			udp_axis_tvalid_i = 1'b0;
			
		end
	end
end
endtask


initial
begin
	$dumpfile("build/wave.vcd"); // create a VCD waveform dump called "wave.vcd"
    $dumpvars(0, hft_tb);
	$display("Test start");
	#10

	$display("TB");
	tb_ready = 1'b0;
	nreset = 1'b0;
	#10
	tb_ready = 1'b1;
 	nreset = 1'b1;
	t = $tb_init("/home/pitchu/rtl/hft/tb/12302019.NASDAQ_ITCH50");
	//t = $tb_init("/home/pitchu/rtl/hft/tb/test.bin");
	udp_axis_tuser_i = 1'b0;
	udp_axis_tvalid_i = 1'b0;	
	#10
	vpi_task();
	#10
	$display("Test end");
	end_tb(1);
end
 /* Make a regular pulsing clock. */
always #5 clk = !clk;

hft #(
	.AXI_DATA_W(AXI_DATA_W),
	.AXI_KEEP_W(AXI_KEEP_W),
	.SID_W(SID_W),
	.SEQ_NUM_W(SEQ_NUM_W),
	.ML_W(ML_W),
	.EOS_MSG_CNT(16'hffff)
) m_hft(
	.clk(clk),
	.nreset(nreset)
);

// mold	
assign m_hft.udp_mold_axis_tvalid = udp_axis_tvalid_i;
assign m_hft.udp_mold_axis_tkeep  = udp_axis_tkeep_i;
assign m_hft.udp_mold_axis_tdata  = udp_axis_tdata_i;
assign m_hft.udp_mold_axis_tlast  = udp_axis_tlast_i;
assign m_hft.udp_mold_axis_tuser  = udp_axis_tuser_i;

assign udp_axis_tready_o = m_hft.mold_udp_axis_tready;

`ifdef MOLD_MSG_IDS
assign mold_msg_sid_o    = m_hft.mold_msg_sid;    
assign mold_msg_seq_num_o= m_hft.mold_msg_seq;
`endif
assign mold_debug_id_o  = m_hft.mold_itch_msg_debug_id;

assign mold_msg_v_o     = m_hft.mold_itch_msg_v;    
assign mold_msg_start_o = m_hft.mold_itch_msg_start;
assign mold_msg_mask_o  = m_hft.mold_itch_msg_mask; 
assign mold_msg_data_o  = m_hft.mold_itch_msg_data; 

// itch
assign itch_msg_v_sent = m_hft.m_itch.itch_msg_sent;

assign itch_debug_id  = m_hft.itch_debug_id;

assign itch_system_event_v = m_hft.itch_system_event_v;
assign itch_system_event_stock_locate = m_hft.itch_system_event_stock_locate;
assign itch_system_event_tracking_number = m_hft.itch_system_event_tracking_number;
assign itch_system_event_timestamp = m_hft.itch_system_event_timestamp;
assign itch_system_event_event_code = m_hft.itch_system_event_event_code;

assign itch_stock_directory_v = m_hft.itch_stock_directory_v;
assign itch_stock_directory_stock_locate = m_hft.itch_stock_directory_stock_locate;
assign itch_stock_directory_tracking_number = m_hft.itch_stock_directory_tracking_number;
assign itch_stock_directory_timestamp = m_hft.itch_stock_directory_timestamp;
assign itch_stock_directory_stock = m_hft.itch_stock_directory_stock;
assign itch_stock_directory_market_category = m_hft.itch_stock_directory_market_category;
assign itch_stock_directory_financial_status_indicator = m_hft.itch_stock_directory_financial_status_indicator;
assign itch_stock_directory_round_lot_size = m_hft.itch_stock_directory_round_lot_size;
assign itch_stock_directory_round_lots_only = m_hft.itch_stock_directory_round_lots_only;
assign itch_stock_directory_issue_classification = m_hft.itch_stock_directory_issue_classification;
assign itch_stock_directory_issue_sub_type = m_hft.itch_stock_directory_issue_sub_type;
assign itch_stock_directory_authenticity = m_hft.itch_stock_directory_authenticity;
assign itch_stock_directory_short_sale_threshold_indicator = m_hft.itch_stock_directory_short_sale_threshold_indicator;
assign itch_stock_directory_ipo_flag = m_hft.itch_stock_directory_ipo_flag;
assign itch_stock_directory_luld_reference_price_tier = m_hft.itch_stock_directory_luld_reference_price_tier;
assign itch_stock_directory_etp_flag = m_hft.itch_stock_directory_etp_flag;
assign itch_stock_directory_etp_leverage_factor = m_hft.itch_stock_directory_etp_leverage_factor;
assign itch_stock_directory_inverse_indicator = m_hft.itch_stock_directory_inverse_indicator;

assign itch_stock_trading_action_v = m_hft.itch_stock_trading_action_v;
assign itch_stock_trading_action_stock_locate = m_hft.itch_stock_trading_action_stock_locate;
assign itch_stock_trading_action_tracking_number = m_hft.itch_stock_trading_action_tracking_number;
assign itch_stock_trading_action_timestamp = m_hft.itch_stock_trading_action_timestamp;
assign itch_stock_trading_action_stock = m_hft.itch_stock_trading_action_stock;
assign itch_stock_trading_action_trading_state = m_hft.itch_stock_trading_action_trading_state;
assign itch_stock_trading_action_reserved = m_hft.itch_stock_trading_action_reserved;
assign itch_stock_trading_action_reason = m_hft.itch_stock_trading_action_reason;

assign itch_reg_sho_restriction_v = m_hft.itch_reg_sho_restriction_v;
assign itch_reg_sho_restriction_stock_locate = m_hft.itch_reg_sho_restriction_stock_locate;
assign itch_reg_sho_restriction_tracking_number = m_hft.itch_reg_sho_restriction_tracking_number;
assign itch_reg_sho_restriction_timestamp = m_hft.itch_reg_sho_restriction_timestamp;
assign itch_reg_sho_restriction_stock = m_hft.itch_reg_sho_restriction_stock;
assign itch_reg_sho_restriction_reg_sho_action = m_hft.itch_reg_sho_restriction_reg_sho_action;

assign itch_market_participant_position_v = m_hft.itch_market_participant_position_v;
assign itch_market_participant_position_stock_locate = m_hft.itch_market_participant_position_stock_locate;
assign itch_market_participant_position_tracking_number = m_hft.itch_market_participant_position_tracking_number;
assign itch_market_participant_position_timestamp = m_hft.itch_market_participant_position_timestamp;
assign itch_market_participant_position_mpid = m_hft.itch_market_participant_position_mpid;
assign itch_market_participant_position_stock = m_hft.itch_market_participant_position_stock;
assign itch_market_participant_position_primary_market_maker = m_hft.itch_market_participant_position_primary_market_maker;
assign itch_market_participant_position_market_maker_mode = m_hft.itch_market_participant_position_market_maker_mode;
assign itch_market_participant_position_market_participant_state = m_hft.itch_market_participant_position_market_participant_state;

assign itch_mwcb_decline_level_v = m_hft.itch_mwcb_decline_level_v;
assign itch_mwcb_decline_level_stock_locate = m_hft.itch_mwcb_decline_level_stock_locate;
assign itch_mwcb_decline_level_tracking_number = m_hft.itch_mwcb_decline_level_tracking_number;
assign itch_mwcb_decline_level_timestamp = m_hft.itch_mwcb_decline_level_timestamp;
assign itch_mwcb_decline_level_level_1 = m_hft.itch_mwcb_decline_level_level_1;
assign itch_mwcb_decline_level_level_2 = m_hft.itch_mwcb_decline_level_level_2;
assign itch_mwcb_decline_level_level_3 = m_hft.itch_mwcb_decline_level_level_3;

assign itch_mwcb_status_v = m_hft.itch_mwcb_status_v;
assign itch_mwcb_status_stock_locate = m_hft.itch_mwcb_status_stock_locate;
assign itch_mwcb_status_tracking_number = m_hft.itch_mwcb_status_tracking_number;
assign itch_mwcb_status_timestamp = m_hft.itch_mwcb_status_timestamp;
assign itch_mwcb_status_breached_level = m_hft.itch_mwcb_status_breached_level;

assign itch_ipo_quoting_period_update_v = m_hft.itch_ipo_quoting_period_update_v;
assign itch_ipo_quoting_period_update_stock_locate = m_hft.itch_ipo_quoting_period_update_stock_locate;
assign itch_ipo_quoting_period_update_tracking_number = m_hft.itch_ipo_quoting_period_update_tracking_number;
assign itch_ipo_quoting_period_update_timestamp = m_hft.itch_ipo_quoting_period_update_timestamp;
assign itch_ipo_quoting_period_update_stock = m_hft.itch_ipo_quoting_period_update_stock;
assign itch_ipo_quoting_period_update_ipo_quotation_release_time = m_hft.itch_ipo_quoting_period_update_ipo_quotation_release_time;
assign itch_ipo_quoting_period_update_ipo_quotation_release_qualifier = m_hft.itch_ipo_quoting_period_update_ipo_quotation_release_qualifier;
assign itch_ipo_quoting_period_update_ipo_price = m_hft.itch_ipo_quoting_period_update_ipo_price;

assign itch_luld_auction_collar_v = m_hft.itch_luld_auction_collar_v;
assign itch_luld_auction_collar_stock_locate = m_hft.itch_luld_auction_collar_stock_locate;
assign itch_luld_auction_collar_tracking_number = m_hft.itch_luld_auction_collar_tracking_number;
assign itch_luld_auction_collar_timestamp = m_hft.itch_luld_auction_collar_timestamp;
assign itch_luld_auction_collar_stock = m_hft.itch_luld_auction_collar_stock;
assign itch_luld_auction_collar_auction_collar_reference_price = m_hft.itch_luld_auction_collar_auction_collar_reference_price;
assign itch_luld_auction_collar_upper_auction_collar_price = m_hft.itch_luld_auction_collar_upper_auction_collar_price;
assign itch_luld_auction_collar_lower_auction_collar_price = m_hft.itch_luld_auction_collar_lower_auction_collar_price;
assign itch_luld_auction_collar_auction_collar_extension = m_hft.itch_luld_auction_collar_auction_collar_extension;

assign itch_operational_halt_v = m_hft.itch_operational_halt_v;
assign itch_operational_halt_stock_locate = m_hft.itch_operational_halt_stock_locate;
assign itch_operational_halt_tracking_number = m_hft.itch_operational_halt_tracking_number;
assign itch_operational_halt_timestamp = m_hft.itch_operational_halt_timestamp;
assign itch_operational_halt_stock = m_hft.itch_operational_halt_stock;
assign itch_operational_halt_market_code = m_hft.itch_operational_halt_market_code;
assign itch_operational_halt_operational_halt_action = m_hft.itch_operational_halt_operational_halt_action;

assign itch_add_order_v = m_hft.itch_add_order_v;
assign itch_add_order_stock_locate = m_hft.itch_add_order_stock_locate;
assign itch_add_order_tracking_number = m_hft.itch_add_order_tracking_number;
assign itch_add_order_timestamp = m_hft.itch_add_order_timestamp;
assign itch_add_order_order_reference_number = m_hft.itch_add_order_order_reference_number;
assign itch_add_order_buy_sell_indicator = m_hft.itch_add_order_buy_sell_indicator;
assign itch_add_order_shares = m_hft.itch_add_order_shares;
assign itch_add_order_stock = m_hft.itch_add_order_stock;
assign itch_add_order_price = m_hft.itch_add_order_price;

assign itch_add_order_with_mpid_v = m_hft.itch_add_order_with_mpid_v;
assign itch_add_order_with_mpid_stock_locate = m_hft.itch_add_order_with_mpid_stock_locate;
assign itch_add_order_with_mpid_tracking_number = m_hft.itch_add_order_with_mpid_tracking_number;
assign itch_add_order_with_mpid_timestamp = m_hft.itch_add_order_with_mpid_timestamp;
assign itch_add_order_with_mpid_order_reference_number = m_hft.itch_add_order_with_mpid_order_reference_number;
assign itch_add_order_with_mpid_buy_sell_indicator = m_hft.itch_add_order_with_mpid_buy_sell_indicator;
assign itch_add_order_with_mpid_shares = m_hft.itch_add_order_with_mpid_shares;
assign itch_add_order_with_mpid_stock = m_hft.itch_add_order_with_mpid_stock;
assign itch_add_order_with_mpid_price = m_hft.itch_add_order_with_mpid_price;
assign itch_add_order_with_mpid_attribution = m_hft.itch_add_order_with_mpid_attribution;

assign itch_order_executed_v = m_hft.itch_order_executed_v;
assign itch_order_executed_stock_locate = m_hft.itch_order_executed_stock_locate;
assign itch_order_executed_tracking_number = m_hft.itch_order_executed_tracking_number;
assign itch_order_executed_timestamp = m_hft.itch_order_executed_timestamp;
assign itch_order_executed_order_reference_number = m_hft.itch_order_executed_order_reference_number;
assign itch_order_executed_executed_shares = m_hft.itch_order_executed_executed_shares;
assign itch_order_executed_match_number = m_hft.itch_order_executed_match_number;

assign itch_order_executed_with_price_v = m_hft.itch_order_executed_with_price_v;
assign itch_order_executed_with_price_stock_locate = m_hft.itch_order_executed_with_price_stock_locate;
assign itch_order_executed_with_price_tracking_number = m_hft.itch_order_executed_with_price_tracking_number;
assign itch_order_executed_with_price_timestamp = m_hft.itch_order_executed_with_price_timestamp;
assign itch_order_executed_with_price_order_reference_number = m_hft.itch_order_executed_with_price_order_reference_number;
assign itch_order_executed_with_price_executed_shares = m_hft.itch_order_executed_with_price_executed_shares;
assign itch_order_executed_with_price_match_number = m_hft.itch_order_executed_with_price_match_number;
assign itch_order_executed_with_price_printable = m_hft.itch_order_executed_with_price_printable;
assign itch_order_executed_with_price_execution_price = m_hft.itch_order_executed_with_price_execution_price;

assign itch_order_cancel_v = m_hft.itch_order_cancel_v;
assign itch_order_cancel_stock_locate = m_hft.itch_order_cancel_stock_locate;
assign itch_order_cancel_tracking_number = m_hft.itch_order_cancel_tracking_number;
assign itch_order_cancel_timestamp = m_hft.itch_order_cancel_timestamp;
assign itch_order_cancel_order_reference_number = m_hft.itch_order_cancel_order_reference_number;
assign itch_order_cancel_cancelled_shares = m_hft.itch_order_cancel_cancelled_shares;

assign itch_order_delete_v = m_hft.itch_order_delete_v;
assign itch_order_delete_stock_locate = m_hft.itch_order_delete_stock_locate;
assign itch_order_delete_tracking_number = m_hft.itch_order_delete_tracking_number;
assign itch_order_delete_timestamp = m_hft.itch_order_delete_timestamp;
assign itch_order_delete_order_reference_number = m_hft.itch_order_delete_order_reference_number;

assign itch_order_replace_v = m_hft.itch_order_replace_v;
assign itch_order_replace_stock_locate = m_hft.itch_order_replace_stock_locate;
assign itch_order_replace_tracking_number = m_hft.itch_order_replace_tracking_number;
assign itch_order_replace_timestamp = m_hft.itch_order_replace_timestamp;
assign itch_order_replace_original_order_reference_number = m_hft.itch_order_replace_original_order_reference_number;
assign itch_order_replace_new_order_reference_number = m_hft.itch_order_replace_new_order_reference_number;
assign itch_order_replace_shares = m_hft.itch_order_replace_shares;
assign itch_order_replace_price = m_hft.itch_order_replace_price;

assign itch_trade_v = m_hft.itch_trade_v;
assign itch_trade_stock_locate = m_hft.itch_trade_stock_locate;
assign itch_trade_tracking_number = m_hft.itch_trade_tracking_number;
assign itch_trade_timestamp = m_hft.itch_trade_timestamp;
assign itch_trade_order_reference_number = m_hft.itch_trade_order_reference_number;
assign itch_trade_buy_sell_indicator = m_hft.itch_trade_buy_sell_indicator;
assign itch_trade_shares = m_hft.itch_trade_shares;
assign itch_trade_stock = m_hft.itch_trade_stock;
assign itch_trade_price = m_hft.itch_trade_price;
assign itch_trade_match_number = m_hft.itch_trade_match_number;

assign itch_cross_trade_v = m_hft.itch_cross_trade_v;
assign itch_cross_trade_stock_locate = m_hft.itch_cross_trade_stock_locate;
assign itch_cross_trade_tracking_number = m_hft.itch_cross_trade_tracking_number;
assign itch_cross_trade_timestamp = m_hft.itch_cross_trade_timestamp;
assign itch_cross_trade_shares = m_hft.itch_cross_trade_shares;
assign itch_cross_trade_stock = m_hft.itch_cross_trade_stock;
assign itch_cross_trade_cross_price = m_hft.itch_cross_trade_cross_price;
assign itch_cross_trade_match_number = m_hft.itch_cross_trade_match_number;
assign itch_cross_trade_cross_type = m_hft.itch_cross_trade_cross_type;

assign itch_broken_trade_v = m_hft.itch_broken_trade_v;
assign itch_broken_trade_stock_locate = m_hft.itch_broken_trade_stock_locate;
assign itch_broken_trade_tracking_number = m_hft.itch_broken_trade_tracking_number;
assign itch_broken_trade_timestamp = m_hft.itch_broken_trade_timestamp;
assign itch_broken_trade_match_number = m_hft.itch_broken_trade_match_number;

assign itch_net_order_imbalance_indicator_v = m_hft.itch_net_order_imbalance_indicator_v;
assign itch_net_order_imbalance_indicator_stock_locate = m_hft.itch_net_order_imbalance_indicator_stock_locate;
assign itch_net_order_imbalance_indicator_tracking_number = m_hft.itch_net_order_imbalance_indicator_tracking_number;
assign itch_net_order_imbalance_indicator_timestamp = m_hft.itch_net_order_imbalance_indicator_timestamp;
assign itch_net_order_imbalance_indicator_paired_shares = m_hft.itch_net_order_imbalance_indicator_paired_shares;
assign itch_net_order_imbalance_indicator_imbalance_shares = m_hft.itch_net_order_imbalance_indicator_imbalance_shares;
assign itch_net_order_imbalance_indicator_imbalance_direction = m_hft.itch_net_order_imbalance_indicator_imbalance_direction;
assign itch_net_order_imbalance_indicator_stock = m_hft.itch_net_order_imbalance_indicator_stock;
assign itch_net_order_imbalance_indicator_far_price = m_hft.itch_net_order_imbalance_indicator_far_price;
assign itch_net_order_imbalance_indicator_near_price = m_hft.itch_net_order_imbalance_indicator_near_price;
assign itch_net_order_imbalance_indicator_current_reference_price = m_hft.itch_net_order_imbalance_indicator_current_reference_price;
assign itch_net_order_imbalance_indicator_cross_type = m_hft.itch_net_order_imbalance_indicator_cross_type;
assign itch_net_order_imbalance_indicator_price_variation_indicator = m_hft.itch_net_order_imbalance_indicator_price_variation_indicator;

assign itch_retail_price_improvement_indicator_v = m_hft.itch_retail_price_improvement_indicator_v;
assign itch_retail_price_improvement_indicator_stock_locate = m_hft.itch_retail_price_improvement_indicator_stock_locate;
assign itch_retail_price_improvement_indicator_tracking_number = m_hft.itch_retail_price_improvement_indicator_tracking_number;
assign itch_retail_price_improvement_indicator_timestamp = m_hft.itch_retail_price_improvement_indicator_timestamp;
assign itch_retail_price_improvement_indicator_stock = m_hft.itch_retail_price_improvement_indicator_stock;
assign itch_retail_price_improvement_indicator_interest_flag = m_hft.itch_retail_price_improvement_indicator_interest_flag;

always @(posedge itch_msg_v_sent) begin
	// asserts, match ?
	$tb_itch(
		tb_finished,
		tb_itch_debug_id,
		tb_itch_system_event_v,
		tb_itch_stock_directory_v,
		tb_itch_stock_trading_action_v,
		tb_itch_reg_sho_restriction_v,
		tb_itch_market_participant_position_v,
		tb_itch_mwcb_decline_level_v,
		tb_itch_mwcb_status_v,
		tb_itch_ipo_quoting_period_update_v,
		tb_itch_luld_auction_collar_v,
		tb_itch_operational_halt_v,
		tb_itch_add_order_v,
		tb_itch_add_order_with_mpid_v,
		tb_itch_order_executed_v,
		tb_itch_order_executed_with_price_v,
		tb_itch_order_cancel_v,
		tb_itch_order_delete_v,
		tb_itch_order_replace_v,
		tb_itch_trade_v,
		tb_itch_cross_trade_v,
		tb_itch_broken_trade_v,
		tb_itch_net_order_imbalance_indicator_v,
		tb_itch_retail_price_improvement_indicator_v,
		tb_itch_end_of_snapshot_v,
		tb_itch_system_event_stock_locate,
		tb_itch_system_event_tracking_number,
		tb_itch_system_event_timestamp,
		tb_itch_system_event_event_code,
		tb_itch_stock_directory_stock_locate,
		tb_itch_stock_directory_tracking_number,
		tb_itch_stock_directory_timestamp,
		tb_itch_stock_directory_stock,
		tb_itch_stock_directory_market_category,
		tb_itch_stock_directory_financial_status_indicator,
		tb_itch_stock_directory_round_lot_size,
		tb_itch_stock_directory_round_lots_only,
		tb_itch_stock_directory_issue_classification,
		tb_itch_stock_directory_issue_sub_type,
		tb_itch_stock_directory_authenticity,
		tb_itch_stock_directory_short_sale_threshold_indicator,
		tb_itch_stock_directory_ipo_flag,
		tb_itch_stock_directory_luld_reference_price_tier,
		tb_itch_stock_directory_etp_flag,
		tb_itch_stock_directory_etp_leverage_factor,
		tb_itch_stock_directory_inverse_indicator,
		tb_itch_stock_trading_action_stock_locate,
		tb_itch_stock_trading_action_tracking_number,
		tb_itch_stock_trading_action_timestamp,
		tb_itch_stock_trading_action_stock,
		tb_itch_stock_trading_action_trading_state,
		tb_itch_stock_trading_action_reserved,
		tb_itch_stock_trading_action_reason,
		tb_itch_reg_sho_restriction_stock_locate,
		tb_itch_reg_sho_restriction_tracking_number,
		tb_itch_reg_sho_restriction_timestamp,
		tb_itch_reg_sho_restriction_stock,
		tb_itch_reg_sho_restriction_reg_sho_action,
		tb_itch_market_participant_position_stock_locate,
		tb_itch_market_participant_position_tracking_number,
		tb_itch_market_participant_position_timestamp,
		tb_itch_market_participant_position_mpid,
		tb_itch_market_participant_position_stock,
		tb_itch_market_participant_position_primary_market_maker,
		tb_itch_market_participant_position_market_maker_mode,
		tb_itch_market_participant_position_market_participant_state,
		tb_itch_mwcb_decline_level_stock_locate,
		tb_itch_mwcb_decline_level_tracking_number,
		tb_itch_mwcb_decline_level_timestamp,
		tb_itch_mwcb_decline_level_level_1,
		tb_itch_mwcb_decline_level_level_2,
		tb_itch_mwcb_decline_level_level_3,
		tb_itch_mwcb_status_stock_locate,
		tb_itch_mwcb_status_tracking_number,
		tb_itch_mwcb_status_timestamp,
		tb_itch_mwcb_status_breached_level,
		tb_itch_ipo_quoting_period_update_stock_locate,
		tb_itch_ipo_quoting_period_update_tracking_number,
		tb_itch_ipo_quoting_period_update_timestamp,
		tb_itch_ipo_quoting_period_update_stock,
		tb_itch_ipo_quoting_period_update_ipo_quotation_release_time,
		tb_itch_ipo_quoting_period_update_ipo_quotation_release_qualifier,
		tb_itch_ipo_quoting_period_update_ipo_price,
		tb_itch_luld_auction_collar_stock_locate,
		tb_itch_luld_auction_collar_tracking_number,
		tb_itch_luld_auction_collar_timestamp,
		tb_itch_luld_auction_collar_stock,
		tb_itch_luld_auction_collar_auction_collar_reference_price,
		tb_itch_luld_auction_collar_upper_auction_collar_price,
		tb_itch_luld_auction_collar_lower_auction_collar_price,
		tb_itch_luld_auction_collar_auction_collar_extension,
		tb_itch_operational_halt_stock_locate,
		tb_itch_operational_halt_tracking_number,
		tb_itch_operational_halt_timestamp,
		tb_itch_operational_halt_stock,
		tb_itch_operational_halt_market_code,
		tb_itch_operational_halt_operational_halt_action,
		tb_itch_add_order_stock_locate,
		tb_itch_add_order_tracking_number,
		tb_itch_add_order_timestamp,
		tb_itch_add_order_order_reference_number,
		tb_itch_add_order_buy_sell_indicator,
		tb_itch_add_order_shares,
		tb_itch_add_order_stock,
		tb_itch_add_order_price,
		tb_itch_add_order_with_mpid_stock_locate,
		tb_itch_add_order_with_mpid_tracking_number,
		tb_itch_add_order_with_mpid_timestamp,
		tb_itch_add_order_with_mpid_order_reference_number,
		tb_itch_add_order_with_mpid_buy_sell_indicator,
		tb_itch_add_order_with_mpid_shares,
		tb_itch_add_order_with_mpid_stock,
		tb_itch_add_order_with_mpid_price,
		tb_itch_add_order_with_mpid_attribution,
		tb_itch_order_executed_stock_locate,
		tb_itch_order_executed_tracking_number,
		tb_itch_order_executed_timestamp,
		tb_itch_order_executed_order_reference_number,
		tb_itch_order_executed_executed_shares,
		tb_itch_order_executed_match_number,
		tb_itch_order_executed_with_price_stock_locate,
		tb_itch_order_executed_with_price_tracking_number,
		tb_itch_order_executed_with_price_timestamp,
		tb_itch_order_executed_with_price_order_reference_number,
		tb_itch_order_executed_with_price_executed_shares,
		tb_itch_order_executed_with_price_match_number,
		tb_itch_order_executed_with_price_printable,
		tb_itch_order_executed_with_price_execution_price,
		tb_itch_order_cancel_stock_locate,
		tb_itch_order_cancel_tracking_number,
		tb_itch_order_cancel_timestamp,
		tb_itch_order_cancel_order_reference_number,
		tb_itch_order_cancel_cancelled_shares,
		tb_itch_order_delete_stock_locate,
		tb_itch_order_delete_tracking_number,
		tb_itch_order_delete_timestamp,
		tb_itch_order_delete_order_reference_number,
		tb_itch_order_replace_stock_locate,
		tb_itch_order_replace_tracking_number,
		tb_itch_order_replace_timestamp,
		tb_itch_order_replace_original_order_reference_number,
		tb_itch_order_replace_new_order_reference_number,
		tb_itch_order_replace_shares,
		tb_itch_order_replace_price,
		tb_itch_trade_stock_locate,
		tb_itch_trade_tracking_number,
		tb_itch_trade_timestamp,
		tb_itch_trade_order_reference_number,
		tb_itch_trade_buy_sell_indicator,
		tb_itch_trade_shares,
		tb_itch_trade_stock,
		tb_itch_trade_price,
		tb_itch_trade_match_number,
		tb_itch_cross_trade_stock_locate,
		tb_itch_cross_trade_tracking_number,
		tb_itch_cross_trade_timestamp,
		tb_itch_cross_trade_shares,
		tb_itch_cross_trade_stock,
		tb_itch_cross_trade_cross_price,
		tb_itch_cross_trade_match_number,
		tb_itch_cross_trade_cross_type,
		tb_itch_broken_trade_stock_locate,
		tb_itch_broken_trade_tracking_number,
		tb_itch_broken_trade_timestamp,
		tb_itch_broken_trade_match_number,
		tb_itch_net_order_imbalance_indicator_stock_locate,
		tb_itch_net_order_imbalance_indicator_tracking_number,
		tb_itch_net_order_imbalance_indicator_timestamp,
		tb_itch_net_order_imbalance_indicator_paired_shares,
		tb_itch_net_order_imbalance_indicator_imbalance_shares,
		tb_itch_net_order_imbalance_indicator_imbalance_direction,
		tb_itch_net_order_imbalance_indicator_stock,
		tb_itch_net_order_imbalance_indicator_far_price,
		tb_itch_net_order_imbalance_indicator_near_price,
		tb_itch_net_order_imbalance_indicator_current_reference_price,
		tb_itch_net_order_imbalance_indicator_cross_type,
		tb_itch_net_order_imbalance_indicator_price_variation_indicator,
		tb_itch_retail_price_improvement_indicator_stock_locate,
		tb_itch_retail_price_improvement_indicator_tracking_number,
		tb_itch_retail_price_improvement_indicator_timestamp,
		tb_itch_retail_price_improvement_indicator_stock,
		tb_itch_retail_price_improvement_indicator_interest_flag,
		tb_itch_end_of_snapshot_sequence_number
	);
	end_tb(tb_finished);

	if (~ tb_finished ) begin
		// check we are comparing the correct message
		`assert_stop( tb_itch_debug_id == itch_debug_id );

		`assert_stop( tb_itch_system_event_v == itch_system_event_v);
		`assert_stop( ~tb_itch_system_event_v | tb_itch_system_event_v & tb_itch_system_event_stock_locate == itch_system_event_stock_locate);
		`assert_stop( ~tb_itch_system_event_v | tb_itch_system_event_v & tb_itch_system_event_tracking_number == itch_system_event_tracking_number);
		`assert_stop( ~tb_itch_system_event_v | tb_itch_system_event_v & tb_itch_system_event_timestamp == itch_system_event_timestamp);
		`assert_stop( ~tb_itch_system_event_v | tb_itch_system_event_v & tb_itch_system_event_event_code == itch_system_event_event_code);
		
		`assert_stop( tb_itch_stock_directory_v == itch_stock_directory_v);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_stock_locate == itch_stock_directory_stock_locate);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_tracking_number == itch_stock_directory_tracking_number);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_timestamp == itch_stock_directory_timestamp);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_stock == itch_stock_directory_stock);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_market_category == itch_stock_directory_market_category);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_financial_status_indicator == itch_stock_directory_financial_status_indicator);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_round_lot_size == itch_stock_directory_round_lot_size);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_round_lots_only == itch_stock_directory_round_lots_only);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_issue_classification == itch_stock_directory_issue_classification);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_issue_sub_type == itch_stock_directory_issue_sub_type);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_authenticity == itch_stock_directory_authenticity);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_short_sale_threshold_indicator == itch_stock_directory_short_sale_threshold_indicator);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_ipo_flag == itch_stock_directory_ipo_flag);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_luld_reference_price_tier == itch_stock_directory_luld_reference_price_tier);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_etp_flag == itch_stock_directory_etp_flag);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_etp_leverage_factor == itch_stock_directory_etp_leverage_factor);
		`assert_stop( ~tb_itch_stock_directory_v | tb_itch_stock_directory_v & tb_itch_stock_directory_inverse_indicator == itch_stock_directory_inverse_indicator);
		
		`assert_stop( tb_itch_stock_trading_action_v == itch_stock_trading_action_v);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_stock_locate == itch_stock_trading_action_stock_locate);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_tracking_number == itch_stock_trading_action_tracking_number);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_timestamp == itch_stock_trading_action_timestamp);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_stock == itch_stock_trading_action_stock);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_trading_state == itch_stock_trading_action_trading_state);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_reserved == itch_stock_trading_action_reserved);
		`assert_stop( ~tb_itch_stock_trading_action_v | tb_itch_stock_trading_action_v & tb_itch_stock_trading_action_reason == itch_stock_trading_action_reason);
		
		`assert_stop( tb_itch_reg_sho_restriction_v == itch_reg_sho_restriction_v);
		`assert_stop( ~tb_itch_reg_sho_restriction_v | tb_itch_reg_sho_restriction_v & tb_itch_reg_sho_restriction_stock_locate == itch_reg_sho_restriction_stock_locate);
		`assert_stop( ~tb_itch_reg_sho_restriction_v | tb_itch_reg_sho_restriction_v & tb_itch_reg_sho_restriction_tracking_number == itch_reg_sho_restriction_tracking_number);
		`assert_stop( ~tb_itch_reg_sho_restriction_v | tb_itch_reg_sho_restriction_v & tb_itch_reg_sho_restriction_timestamp == itch_reg_sho_restriction_timestamp);
		`assert_stop( ~tb_itch_reg_sho_restriction_v | tb_itch_reg_sho_restriction_v & tb_itch_reg_sho_restriction_stock == itch_reg_sho_restriction_stock);
		`assert_stop( ~tb_itch_reg_sho_restriction_v | tb_itch_reg_sho_restriction_v & tb_itch_reg_sho_restriction_reg_sho_action == itch_reg_sho_restriction_reg_sho_action);
		
		`assert_stop( tb_itch_market_participant_position_v == itch_market_participant_position_v);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_stock_locate == itch_market_participant_position_stock_locate);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_tracking_number == itch_market_participant_position_tracking_number);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_timestamp == itch_market_participant_position_timestamp);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_mpid == itch_market_participant_position_mpid);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_stock == itch_market_participant_position_stock);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_primary_market_maker == itch_market_participant_position_primary_market_maker);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_market_maker_mode == itch_market_participant_position_market_maker_mode);
		`assert_stop( ~tb_itch_market_participant_position_v | tb_itch_market_participant_position_v & tb_itch_market_participant_position_market_participant_state == itch_market_participant_position_market_participant_state);
		
		`assert_stop( tb_itch_mwcb_decline_level_v == itch_mwcb_decline_level_v);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_stock_locate == itch_mwcb_decline_level_stock_locate);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_tracking_number == itch_mwcb_decline_level_tracking_number);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_timestamp == itch_mwcb_decline_level_timestamp);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_level_1 == itch_mwcb_decline_level_level_1);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_level_2 == itch_mwcb_decline_level_level_2);
		`assert_stop( ~tb_itch_mwcb_decline_level_v | tb_itch_mwcb_decline_level_v & tb_itch_mwcb_decline_level_level_3 == itch_mwcb_decline_level_level_3);
		
		`assert_stop( tb_itch_mwcb_status_v == itch_mwcb_status_v);
		`assert_stop( ~tb_itch_mwcb_status_v | tb_itch_mwcb_status_v & tb_itch_mwcb_status_stock_locate == itch_mwcb_status_stock_locate);
		`assert_stop( ~tb_itch_mwcb_status_v | tb_itch_mwcb_status_v & tb_itch_mwcb_status_tracking_number == itch_mwcb_status_tracking_number);
		`assert_stop( ~tb_itch_mwcb_status_v | tb_itch_mwcb_status_v & tb_itch_mwcb_status_timestamp == itch_mwcb_status_timestamp);
		`assert_stop( ~tb_itch_mwcb_status_v | tb_itch_mwcb_status_v & tb_itch_mwcb_status_breached_level == itch_mwcb_status_breached_level);
		
		`assert_stop( tb_itch_ipo_quoting_period_update_v == itch_ipo_quoting_period_update_v);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_stock_locate == itch_ipo_quoting_period_update_stock_locate);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_tracking_number == itch_ipo_quoting_period_update_tracking_number);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_timestamp == itch_ipo_quoting_period_update_timestamp);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_stock == itch_ipo_quoting_period_update_stock);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_ipo_quotation_release_time == itch_ipo_quoting_period_update_ipo_quotation_release_time);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_ipo_quotation_release_qualifier == itch_ipo_quoting_period_update_ipo_quotation_release_qualifier);
		`assert_stop( ~tb_itch_ipo_quoting_period_update_v | tb_itch_ipo_quoting_period_update_v & tb_itch_ipo_quoting_period_update_ipo_price == itch_ipo_quoting_period_update_ipo_price);
		
		`assert_stop( tb_itch_luld_auction_collar_v == itch_luld_auction_collar_v);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_stock_locate == itch_luld_auction_collar_stock_locate);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_tracking_number == itch_luld_auction_collar_tracking_number);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_timestamp == itch_luld_auction_collar_timestamp);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_stock == itch_luld_auction_collar_stock);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_auction_collar_reference_price == itch_luld_auction_collar_auction_collar_reference_price);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_upper_auction_collar_price == itch_luld_auction_collar_upper_auction_collar_price);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_lower_auction_collar_price == itch_luld_auction_collar_lower_auction_collar_price);
		`assert_stop( ~tb_itch_luld_auction_collar_v | tb_itch_luld_auction_collar_v & tb_itch_luld_auction_collar_auction_collar_extension == itch_luld_auction_collar_auction_collar_extension);
		
		`assert_stop( tb_itch_operational_halt_v == itch_operational_halt_v);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_stock_locate == itch_operational_halt_stock_locate);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_tracking_number == itch_operational_halt_tracking_number);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_timestamp == itch_operational_halt_timestamp);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_stock == itch_operational_halt_stock);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_market_code == itch_operational_halt_market_code);
		`assert_stop( ~tb_itch_operational_halt_v | tb_itch_operational_halt_v & tb_itch_operational_halt_operational_halt_action == itch_operational_halt_operational_halt_action);
		
		`assert_stop( tb_itch_add_order_v == itch_add_order_v);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_stock_locate == itch_add_order_stock_locate);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_tracking_number == itch_add_order_tracking_number);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_timestamp == itch_add_order_timestamp);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_order_reference_number == itch_add_order_order_reference_number);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_buy_sell_indicator == itch_add_order_buy_sell_indicator);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_shares == itch_add_order_shares);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_stock == itch_add_order_stock);
		`assert_stop( ~tb_itch_add_order_v | tb_itch_add_order_v & tb_itch_add_order_price == itch_add_order_price);
		
		`assert_stop( tb_itch_add_order_with_mpid_v == itch_add_order_with_mpid_v);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_stock_locate == itch_add_order_with_mpid_stock_locate);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_tracking_number == itch_add_order_with_mpid_tracking_number);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_timestamp == itch_add_order_with_mpid_timestamp);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_order_reference_number == itch_add_order_with_mpid_order_reference_number);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_buy_sell_indicator == itch_add_order_with_mpid_buy_sell_indicator);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_shares == itch_add_order_with_mpid_shares);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_stock == itch_add_order_with_mpid_stock);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_price == itch_add_order_with_mpid_price);
		`assert_stop( ~tb_itch_add_order_with_mpid_v | tb_itch_add_order_with_mpid_v & tb_itch_add_order_with_mpid_attribution == itch_add_order_with_mpid_attribution);
		
		`assert_stop( tb_itch_order_executed_v == itch_order_executed_v);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_stock_locate == itch_order_executed_stock_locate);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_tracking_number == itch_order_executed_tracking_number);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_timestamp == itch_order_executed_timestamp);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_order_reference_number == itch_order_executed_order_reference_number);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_executed_shares == itch_order_executed_executed_shares);
		`assert_stop( ~tb_itch_order_executed_v | tb_itch_order_executed_v & tb_itch_order_executed_match_number == itch_order_executed_match_number);
		
		`assert_stop( tb_itch_order_executed_with_price_v == itch_order_executed_with_price_v);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_stock_locate == itch_order_executed_with_price_stock_locate);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_tracking_number == itch_order_executed_with_price_tracking_number);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_timestamp == itch_order_executed_with_price_timestamp);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_order_reference_number == itch_order_executed_with_price_order_reference_number);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_executed_shares == itch_order_executed_with_price_executed_shares);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_match_number == itch_order_executed_with_price_match_number);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_printable == itch_order_executed_with_price_printable);
		`assert_stop( ~tb_itch_order_executed_with_price_v | tb_itch_order_executed_with_price_v & tb_itch_order_executed_with_price_execution_price == itch_order_executed_with_price_execution_price);
		
		`assert_stop( tb_itch_order_cancel_v == itch_order_cancel_v);
		`assert_stop( ~tb_itch_order_cancel_v | tb_itch_order_cancel_v & tb_itch_order_cancel_stock_locate == itch_order_cancel_stock_locate);
		`assert_stop( ~tb_itch_order_cancel_v | tb_itch_order_cancel_v & tb_itch_order_cancel_tracking_number == itch_order_cancel_tracking_number);
		`assert_stop( ~tb_itch_order_cancel_v | tb_itch_order_cancel_v & tb_itch_order_cancel_timestamp == itch_order_cancel_timestamp);
		`assert_stop( ~tb_itch_order_cancel_v | tb_itch_order_cancel_v & tb_itch_order_cancel_order_reference_number == itch_order_cancel_order_reference_number);
		`assert_stop( ~tb_itch_order_cancel_v | tb_itch_order_cancel_v & tb_itch_order_cancel_cancelled_shares == itch_order_cancel_cancelled_shares);
		
		`assert_stop( tb_itch_order_delete_v == itch_order_delete_v);
		`assert_stop( ~tb_itch_order_delete_v | tb_itch_order_delete_v & tb_itch_order_delete_stock_locate == itch_order_delete_stock_locate);
		`assert_stop( ~tb_itch_order_delete_v | tb_itch_order_delete_v & tb_itch_order_delete_tracking_number == itch_order_delete_tracking_number);
		`assert_stop( ~tb_itch_order_delete_v | tb_itch_order_delete_v & tb_itch_order_delete_timestamp == itch_order_delete_timestamp);
		`assert_stop( ~tb_itch_order_delete_v | tb_itch_order_delete_v & tb_itch_order_delete_order_reference_number == itch_order_delete_order_reference_number);
		
		`assert_stop( tb_itch_order_replace_v == itch_order_replace_v);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_stock_locate == itch_order_replace_stock_locate);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_tracking_number == itch_order_replace_tracking_number);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_timestamp == itch_order_replace_timestamp);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_original_order_reference_number == itch_order_replace_original_order_reference_number);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_new_order_reference_number == itch_order_replace_new_order_reference_number);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_shares == itch_order_replace_shares);
		`assert_stop( ~tb_itch_order_replace_v | tb_itch_order_replace_v & tb_itch_order_replace_price == itch_order_replace_price);
		
		`assert_stop( tb_itch_trade_v == itch_trade_v);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_stock_locate == itch_trade_stock_locate);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_tracking_number == itch_trade_tracking_number);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_timestamp == itch_trade_timestamp);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_order_reference_number == itch_trade_order_reference_number);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_buy_sell_indicator == itch_trade_buy_sell_indicator);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_shares == itch_trade_shares);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_stock == itch_trade_stock);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_price == itch_trade_price);
		`assert_stop( ~tb_itch_trade_v | tb_itch_trade_v & tb_itch_trade_match_number == itch_trade_match_number);
		
		`assert_stop( tb_itch_cross_trade_v == itch_cross_trade_v);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_stock_locate == itch_cross_trade_stock_locate);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_tracking_number == itch_cross_trade_tracking_number);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_timestamp == itch_cross_trade_timestamp);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_shares == itch_cross_trade_shares);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_stock == itch_cross_trade_stock);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_cross_price == itch_cross_trade_cross_price);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_match_number == itch_cross_trade_match_number);
		`assert_stop( ~tb_itch_cross_trade_v | tb_itch_cross_trade_v & tb_itch_cross_trade_cross_type == itch_cross_trade_cross_type);
		
		`assert_stop( tb_itch_broken_trade_v == itch_broken_trade_v);
		`assert_stop( ~tb_itch_broken_trade_v | tb_itch_broken_trade_v & tb_itch_broken_trade_stock_locate == itch_broken_trade_stock_locate);
		`assert_stop( ~tb_itch_broken_trade_v | tb_itch_broken_trade_v & tb_itch_broken_trade_tracking_number == itch_broken_trade_tracking_number);
		`assert_stop( ~tb_itch_broken_trade_v | tb_itch_broken_trade_v & tb_itch_broken_trade_timestamp == itch_broken_trade_timestamp);
		`assert_stop( ~tb_itch_broken_trade_v | tb_itch_broken_trade_v & tb_itch_broken_trade_match_number == itch_broken_trade_match_number);
		
		`assert_stop( tb_itch_net_order_imbalance_indicator_v == itch_net_order_imbalance_indicator_v);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_stock_locate == itch_net_order_imbalance_indicator_stock_locate);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_tracking_number == itch_net_order_imbalance_indicator_tracking_number);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_timestamp == itch_net_order_imbalance_indicator_timestamp);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_paired_shares == itch_net_order_imbalance_indicator_paired_shares);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_imbalance_shares == itch_net_order_imbalance_indicator_imbalance_shares);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_imbalance_direction == itch_net_order_imbalance_indicator_imbalance_direction);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_stock == itch_net_order_imbalance_indicator_stock);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_far_price == itch_net_order_imbalance_indicator_far_price);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_near_price == itch_net_order_imbalance_indicator_near_price);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_current_reference_price == itch_net_order_imbalance_indicator_current_reference_price);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_cross_type == itch_net_order_imbalance_indicator_cross_type);
		`assert_stop( ~tb_itch_net_order_imbalance_indicator_v | tb_itch_net_order_imbalance_indicator_v & tb_itch_net_order_imbalance_indicator_price_variation_indicator == itch_net_order_imbalance_indicator_price_variation_indicator);
		
		`assert_stop( tb_itch_retail_price_improvement_indicator_v == itch_retail_price_improvement_indicator_v);
		`assert_stop( ~tb_itch_retail_price_improvement_indicator_v | tb_itch_retail_price_improvement_indicator_v & tb_itch_retail_price_improvement_indicator_stock_locate == itch_retail_price_improvement_indicator_stock_locate);
		`assert_stop( ~tb_itch_retail_price_improvement_indicator_v | tb_itch_retail_price_improvement_indicator_v & tb_itch_retail_price_improvement_indicator_tracking_number == itch_retail_price_improvement_indicator_tracking_number);
		`assert_stop( ~tb_itch_retail_price_improvement_indicator_v | tb_itch_retail_price_improvement_indicator_v & tb_itch_retail_price_improvement_indicator_timestamp == itch_retail_price_improvement_indicator_timestamp);
		`assert_stop( ~tb_itch_retail_price_improvement_indicator_v | tb_itch_retail_price_improvement_indicator_v & tb_itch_retail_price_improvement_indicator_stock == itch_retail_price_improvement_indicator_stock);
		`assert_stop( ~tb_itch_retail_price_improvement_indicator_v | tb_itch_retail_price_improvement_indicator_v & tb_itch_retail_price_improvement_indicator_interest_flag == itch_retail_price_improvement_indicator_interest_flag);
	end
end

endmodule
