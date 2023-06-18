if(itch_msg->itch_system_event_v) { 
printf("Message type : system_event\n");
print_u16_t("stock_locate",itch_msg->itch_system_event_data.itch_system_event_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_system_event_data.itch_system_event_tracking_number);
print_u48_t("timestamp",itch_msg->itch_system_event_data.itch_system_event_timestamp);
print_char_t("event_code",itch_msg->itch_system_event_data.itch_system_event_event_code);
}
if(itch_msg->itch_stock_directory_v) { 
printf("Message type : stock_directory\n");
print_u16_t("stock_locate",itch_msg->itch_stock_directory_data.itch_stock_directory_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_stock_directory_data.itch_stock_directory_tracking_number);
print_u48_t("timestamp",itch_msg->itch_stock_directory_data.itch_stock_directory_timestamp);
print_char_8_t("stock",itch_msg->itch_stock_directory_data.itch_stock_directory_stock);
print_char_t("market_category",itch_msg->itch_stock_directory_data.itch_stock_directory_market_category);
print_char_t("financial_status_indicator",itch_msg->itch_stock_directory_data.itch_stock_directory_financial_status_indicator);
print_u32_t("round_lot_size",itch_msg->itch_stock_directory_data.itch_stock_directory_round_lot_size);
print_char_t("round_lots_only",itch_msg->itch_stock_directory_data.itch_stock_directory_round_lots_only);
print_char_t("issue_classification",itch_msg->itch_stock_directory_data.itch_stock_directory_issue_classification);
print_char_2_t("issue_sub_type",itch_msg->itch_stock_directory_data.itch_stock_directory_issue_sub_type);
print_char_t("authenticity",itch_msg->itch_stock_directory_data.itch_stock_directory_authenticity);
print_char_t("short_sale_threshold_indicator",itch_msg->itch_stock_directory_data.itch_stock_directory_short_sale_threshold_indicator);
print_char_t("ipo_flag",itch_msg->itch_stock_directory_data.itch_stock_directory_ipo_flag);
print_char_t("luld_reference_price_tier",itch_msg->itch_stock_directory_data.itch_stock_directory_luld_reference_price_tier);
print_char_t("etp_flag",itch_msg->itch_stock_directory_data.itch_stock_directory_etp_flag);
print_u32_t("etp_leverage_factor",itch_msg->itch_stock_directory_data.itch_stock_directory_etp_leverage_factor);
print_char_t("inverse_indicator",itch_msg->itch_stock_directory_data.itch_stock_directory_inverse_indicator);
}
if(itch_msg->itch_stock_trading_action_v) { 
printf("Message type : stock_trading_action\n");
print_u16_t("stock_locate",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_tracking_number);
print_u48_t("timestamp",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_timestamp);
print_char_8_t("stock",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_stock);
print_char_t("trading_state",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_trading_state);
print_char_t("reserved",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_reserved);
print_char_4_t("reason",itch_msg->itch_stock_trading_action_data.itch_stock_trading_action_reason);
}
if(itch_msg->itch_reg_sho_restriction_v) { 
printf("Message type : reg_sho_restriction\n");
print_u16_t("stock_locate",itch_msg->itch_reg_sho_restriction_data.itch_reg_sho_restriction_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_reg_sho_restriction_data.itch_reg_sho_restriction_tracking_number);
print_u48_t("timestamp",itch_msg->itch_reg_sho_restriction_data.itch_reg_sho_restriction_timestamp);
print_char_8_t("stock",itch_msg->itch_reg_sho_restriction_data.itch_reg_sho_restriction_stock);
print_char_t("reg_sho_action",itch_msg->itch_reg_sho_restriction_data.itch_reg_sho_restriction_reg_sho_action);
}
if(itch_msg->itch_market_participant_position_v) { 
printf("Message type : market_participant_position\n");
print_u16_t("stock_locate",itch_msg->itch_market_participant_position_data.itch_market_participant_position_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_market_participant_position_data.itch_market_participant_position_tracking_number);
print_u48_t("timestamp",itch_msg->itch_market_participant_position_data.itch_market_participant_position_timestamp);
print_char_4_t("mpid",itch_msg->itch_market_participant_position_data.itch_market_participant_position_mpid);
print_char_8_t("stock",itch_msg->itch_market_participant_position_data.itch_market_participant_position_stock);
print_char_t("primary_market_maker",itch_msg->itch_market_participant_position_data.itch_market_participant_position_primary_market_maker);
print_char_t("market_maker_mode",itch_msg->itch_market_participant_position_data.itch_market_participant_position_market_maker_mode);
print_char_t("market_participant_state",itch_msg->itch_market_participant_position_data.itch_market_participant_position_market_participant_state);
}
if(itch_msg->itch_mwcb_decline_level_v) { 
printf("Message type : mwcb_decline_level\n");
print_u16_t("stock_locate",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_tracking_number);
print_u48_t("timestamp",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_timestamp);
print_price_8_t("level_1",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_1);
print_price_8_t("level_2",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_2);
print_price_8_t("level_3",itch_msg->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_3);
}
if(itch_msg->itch_mwcb_status_v) { 
printf("Message type : mwcb_status\n");
print_u16_t("stock_locate",itch_msg->itch_mwcb_status_data.itch_mwcb_status_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_mwcb_status_data.itch_mwcb_status_tracking_number);
print_u48_t("timestamp",itch_msg->itch_mwcb_status_data.itch_mwcb_status_timestamp);
print_char_t("breached_level",itch_msg->itch_mwcb_status_data.itch_mwcb_status_breached_level);
}
if(itch_msg->itch_ipo_quoting_period_update_v) { 
printf("Message type : ipo_quoting_period_update\n");
print_u16_t("stock_locate",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_tracking_number);
print_u48_t("timestamp",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_timestamp);
print_char_8_t("stock",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_stock);
print_u32_t("ipo_quotation_release_time",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_quotation_release_time);
print_char_t("ipo_quotation_release_qualifier",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_quotation_release_qualifier);
print_price_4_t("ipo_price",itch_msg->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_price);
}
if(itch_msg->itch_luld_auction_collar_v) { 
printf("Message type : luld_auction_collar\n");
print_u16_t("stock_locate",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_tracking_number);
print_u48_t("timestamp",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_timestamp);
print_char_8_t("stock",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_stock);
print_price_4_t("auction_collar_reference_price",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_auction_collar_reference_price);
print_price_4_t("upper_auction_collar_price",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_upper_auction_collar_price);
print_price_4_t("lower_auction_collar_price",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_lower_auction_collar_price);
print_u32_t("auction_collar_extension",itch_msg->itch_luld_auction_collar_data.itch_luld_auction_collar_auction_collar_extension);
}
if(itch_msg->itch_operational_halt_v) { 
printf("Message type : operational_halt\n");
print_u16_t("stock_locate",itch_msg->itch_operational_halt_data.itch_operational_halt_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_operational_halt_data.itch_operational_halt_tracking_number);
print_u48_t("timestamp",itch_msg->itch_operational_halt_data.itch_operational_halt_timestamp);
print_char_8_t("stock",itch_msg->itch_operational_halt_data.itch_operational_halt_stock);
print_char_t("market_code",itch_msg->itch_operational_halt_data.itch_operational_halt_market_code);
print_char_t("operational_halt_action",itch_msg->itch_operational_halt_data.itch_operational_halt_operational_halt_action);
}
if(itch_msg->itch_add_order_v) { 
printf("Message type : add_order\n");
print_u16_t("stock_locate",itch_msg->itch_add_order_data.itch_add_order_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_add_order_data.itch_add_order_tracking_number);
print_u48_t("timestamp",itch_msg->itch_add_order_data.itch_add_order_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_add_order_data.itch_add_order_order_reference_number);
print_char_t("buy_sell_indicator",itch_msg->itch_add_order_data.itch_add_order_buy_sell_indicator);
print_u32_t("shares",itch_msg->itch_add_order_data.itch_add_order_shares);
print_char_8_t("stock",itch_msg->itch_add_order_data.itch_add_order_stock);
print_price_4_t("price",itch_msg->itch_add_order_data.itch_add_order_price);
}
if(itch_msg->itch_add_order_with_mpid_v) { 
printf("Message type : add_order_with_mpid\n");
print_u16_t("stock_locate",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_tracking_number);
print_u48_t("timestamp",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_order_reference_number);
print_char_t("buy_sell_indicator",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_buy_sell_indicator);
print_u32_t("shares",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_shares);
print_char_8_t("stock",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_stock);
print_price_4_t("price",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_price);
print_char_4_t("attribution",itch_msg->itch_add_order_with_mpid_data.itch_add_order_with_mpid_attribution);
}
if(itch_msg->itch_order_executed_v) { 
printf("Message type : order_executed\n");
print_u16_t("stock_locate",itch_msg->itch_order_executed_data.itch_order_executed_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_order_executed_data.itch_order_executed_tracking_number);
print_u48_t("timestamp",itch_msg->itch_order_executed_data.itch_order_executed_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_order_executed_data.itch_order_executed_order_reference_number);
print_u32_t("executed_shares",itch_msg->itch_order_executed_data.itch_order_executed_executed_shares);
print_u64_t("match_number",itch_msg->itch_order_executed_data.itch_order_executed_match_number);
}
if(itch_msg->itch_order_executed_with_price_v) { 
printf("Message type : order_executed_with_price\n");
print_u16_t("stock_locate",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_tracking_number);
print_u48_t("timestamp",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_order_reference_number);
print_u32_t("executed_shares",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_executed_shares);
print_u64_t("match_number",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_match_number);
print_char_t("printable",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_printable);
print_price_4_t("execution_price",itch_msg->itch_order_executed_with_price_data.itch_order_executed_with_price_execution_price);
}
if(itch_msg->itch_order_cancel_v) { 
printf("Message type : order_cancel\n");
print_u16_t("stock_locate",itch_msg->itch_order_cancel_data.itch_order_cancel_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_order_cancel_data.itch_order_cancel_tracking_number);
print_u48_t("timestamp",itch_msg->itch_order_cancel_data.itch_order_cancel_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_order_cancel_data.itch_order_cancel_order_reference_number);
print_u32_t("cancelled_shares",itch_msg->itch_order_cancel_data.itch_order_cancel_cancelled_shares);
}
if(itch_msg->itch_order_delete_v) { 
printf("Message type : order_delete\n");
print_u16_t("stock_locate",itch_msg->itch_order_delete_data.itch_order_delete_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_order_delete_data.itch_order_delete_tracking_number);
print_u48_t("timestamp",itch_msg->itch_order_delete_data.itch_order_delete_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_order_delete_data.itch_order_delete_order_reference_number);
}
if(itch_msg->itch_order_replace_v) { 
printf("Message type : order_replace\n");
print_u16_t("stock_locate",itch_msg->itch_order_replace_data.itch_order_replace_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_order_replace_data.itch_order_replace_tracking_number);
print_u48_t("timestamp",itch_msg->itch_order_replace_data.itch_order_replace_timestamp);
print_u64_t("original_order_reference_number",itch_msg->itch_order_replace_data.itch_order_replace_original_order_reference_number);
print_u64_t("new_order_reference_number",itch_msg->itch_order_replace_data.itch_order_replace_new_order_reference_number);
print_u32_t("shares",itch_msg->itch_order_replace_data.itch_order_replace_shares);
print_price_4_t("price",itch_msg->itch_order_replace_data.itch_order_replace_price);
}
if(itch_msg->itch_trade_v) { 
printf("Message type : trade\n");
print_u16_t("stock_locate",itch_msg->itch_trade_data.itch_trade_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_trade_data.itch_trade_tracking_number);
print_u48_t("timestamp",itch_msg->itch_trade_data.itch_trade_timestamp);
print_u64_t("order_reference_number",itch_msg->itch_trade_data.itch_trade_order_reference_number);
print_char_t("buy_sell_indicator",itch_msg->itch_trade_data.itch_trade_buy_sell_indicator);
print_u32_t("shares",itch_msg->itch_trade_data.itch_trade_shares);
print_char_8_t("stock",itch_msg->itch_trade_data.itch_trade_stock);
print_price_4_t("price",itch_msg->itch_trade_data.itch_trade_price);
print_u64_t("match_number",itch_msg->itch_trade_data.itch_trade_match_number);
}
if(itch_msg->itch_cross_trade_v) { 
printf("Message type : cross_trade\n");
print_u16_t("stock_locate",itch_msg->itch_cross_trade_data.itch_cross_trade_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_cross_trade_data.itch_cross_trade_tracking_number);
print_u48_t("timestamp",itch_msg->itch_cross_trade_data.itch_cross_trade_timestamp);
print_u64_t("shares",itch_msg->itch_cross_trade_data.itch_cross_trade_shares);
print_char_8_t("stock",itch_msg->itch_cross_trade_data.itch_cross_trade_stock);
print_price_4_t("cross_price",itch_msg->itch_cross_trade_data.itch_cross_trade_cross_price);
print_u64_t("match_number",itch_msg->itch_cross_trade_data.itch_cross_trade_match_number);
print_char_t("cross_type",itch_msg->itch_cross_trade_data.itch_cross_trade_cross_type);
}
if(itch_msg->itch_broken_trade_v) { 
printf("Message type : broken_trade\n");
print_u16_t("stock_locate",itch_msg->itch_broken_trade_data.itch_broken_trade_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_broken_trade_data.itch_broken_trade_tracking_number);
print_u48_t("timestamp",itch_msg->itch_broken_trade_data.itch_broken_trade_timestamp);
print_u64_t("match_number",itch_msg->itch_broken_trade_data.itch_broken_trade_match_number);
}
if(itch_msg->itch_net_order_imbalance_indicator_v) { 
printf("Message type : net_order_imbalance_indicator\n");
print_u16_t("stock_locate",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_tracking_number);
print_u48_t("timestamp",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_timestamp);
print_u64_t("paired_shares",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_paired_shares);
print_u64_t("imbalance_shares",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_imbalance_shares);
print_char_t("imbalance_direction",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_imbalance_direction);
print_char_8_t("stock",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_stock);
print_price_4_t("far_price",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_far_price);
print_price_4_t("near_price",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_near_price);
print_price_4_t("current_reference_price",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_current_reference_price);
print_char_t("cross_type",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_cross_type);
print_char_t("price_variation_indicator",itch_msg->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_price_variation_indicator);
}
if(itch_msg->itch_retail_price_improvement_indicator_v) { 
printf("Message type : retail_price_improvement_indicator\n");
print_u16_t("stock_locate",itch_msg->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_stock_locate);
print_u16_t("tracking_number",itch_msg->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_tracking_number);
print_u48_t("timestamp",itch_msg->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_timestamp);
print_char_8_t("stock",itch_msg->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_stock);
print_char_t("interest_flag",itch_msg->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_interest_flag);
}
if(itch_msg->itch_end_of_snapshot_v) { 
printf("Message type : end_of_snapshot\n");
print_char_20_t("sequence_number",itch_msg->itch_end_of_snapshot_data.itch_end_of_snapshot_sequence_number);
}
