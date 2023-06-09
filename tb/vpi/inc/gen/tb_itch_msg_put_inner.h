tb_vpi_put_logic_u16_t(argv,itch_s->itch_system_event_data.itch_system_event_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_system_event_data.itch_system_event_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_system_event_data.itch_system_event_timestamp);
tb_vpi_put_logic_char_t(argv,itch_s->itch_system_event_data.itch_system_event_event_code);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_market_category);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_financial_status_indicator);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_round_lot_size);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_round_lots_only);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_issue_classification);
tb_vpi_put_logic_char_2_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_issue_sub_type);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_authenticity);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_short_sale_threshold_indicator);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_ipo_flag);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_luld_reference_price_tier);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_etp_flag);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_etp_leverage_factor);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_directory_data.itch_stock_directory_inverse_indicator);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_trading_state);
tb_vpi_put_logic_char_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_reserved);
tb_vpi_put_logic_char_4_t(argv,itch_s->itch_stock_trading_action_data.itch_stock_trading_action_reason);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_reg_sho_restriction_data.itch_reg_sho_restriction_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_reg_sho_restriction_data.itch_reg_sho_restriction_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_reg_sho_restriction_data.itch_reg_sho_restriction_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_reg_sho_restriction_data.itch_reg_sho_restriction_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_reg_sho_restriction_data.itch_reg_sho_restriction_reg_sho_action);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_timestamp);
tb_vpi_put_logic_char_4_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_mpid);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_primary_market_maker);
tb_vpi_put_logic_char_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_market_maker_mode);
tb_vpi_put_logic_char_t(argv,itch_s->itch_market_participant_position_data.itch_market_participant_position_market_participant_state);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_timestamp);
tb_vpi_put_logic_price_8_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_1);
tb_vpi_put_logic_price_8_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_2);
tb_vpi_put_logic_price_8_t(argv,itch_s->itch_mwcb_decline_level_data.itch_mwcb_decline_level_level_3);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_mwcb_status_data.itch_mwcb_status_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_mwcb_status_data.itch_mwcb_status_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_mwcb_status_data.itch_mwcb_status_timestamp);
tb_vpi_put_logic_char_t(argv,itch_s->itch_mwcb_status_data.itch_mwcb_status_breached_level);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_stock);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_quotation_release_time);
tb_vpi_put_logic_char_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_quotation_release_qualifier);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_ipo_quoting_period_update_data.itch_ipo_quoting_period_update_ipo_price);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_auction_collar_reference_price);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_upper_auction_collar_price);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_lower_auction_collar_price);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_luld_auction_collar_data.itch_luld_auction_collar_auction_collar_extension);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_market_code);
tb_vpi_put_logic_char_t(argv,itch_s->itch_operational_halt_data.itch_operational_halt_operational_halt_action);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_add_order_data.itch_add_order_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_add_order_data.itch_add_order_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_add_order_data.itch_add_order_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_add_order_data.itch_add_order_order_reference_number);
tb_vpi_put_logic_char_t(argv,itch_s->itch_add_order_data.itch_add_order_buy_sell_indicator);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_add_order_data.itch_add_order_shares);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_add_order_data.itch_add_order_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_add_order_data.itch_add_order_price);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_order_reference_number);
tb_vpi_put_logic_char_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_buy_sell_indicator);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_shares);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_price);
tb_vpi_put_logic_char_4_t(argv,itch_s->itch_add_order_with_mpid_data.itch_add_order_with_mpid_attribution);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_executed_data.itch_order_executed_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_executed_data.itch_order_executed_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_order_executed_data.itch_order_executed_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_executed_data.itch_order_executed_order_reference_number);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_order_executed_data.itch_order_executed_executed_shares);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_executed_data.itch_order_executed_match_number);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_order_reference_number);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_executed_shares);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_match_number);
tb_vpi_put_logic_char_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_printable);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_order_executed_with_price_data.itch_order_executed_with_price_execution_price);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_cancel_data.itch_order_cancel_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_cancel_data.itch_order_cancel_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_order_cancel_data.itch_order_cancel_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_cancel_data.itch_order_cancel_order_reference_number);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_order_cancel_data.itch_order_cancel_cancelled_shares);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_delete_data.itch_order_delete_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_delete_data.itch_order_delete_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_order_delete_data.itch_order_delete_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_delete_data.itch_order_delete_order_reference_number);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_replace_data.itch_order_replace_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_order_replace_data.itch_order_replace_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_order_replace_data.itch_order_replace_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_replace_data.itch_order_replace_original_order_reference_number);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_order_replace_data.itch_order_replace_new_order_reference_number);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_order_replace_data.itch_order_replace_shares);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_order_replace_data.itch_order_replace_price);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_trade_data.itch_trade_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_trade_data.itch_trade_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_trade_data.itch_trade_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_trade_data.itch_trade_order_reference_number);
tb_vpi_put_logic_char_t(argv,itch_s->itch_trade_data.itch_trade_buy_sell_indicator);
tb_vpi_put_logic_u32_t(argv,itch_s->itch_trade_data.itch_trade_shares);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_trade_data.itch_trade_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_trade_data.itch_trade_price);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_trade_data.itch_trade_match_number);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_shares);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_cross_price);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_match_number);
tb_vpi_put_logic_char_t(argv,itch_s->itch_cross_trade_data.itch_cross_trade_cross_type);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_broken_trade_data.itch_broken_trade_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_broken_trade_data.itch_broken_trade_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_broken_trade_data.itch_broken_trade_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_broken_trade_data.itch_broken_trade_match_number);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_timestamp);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_paired_shares);
tb_vpi_put_logic_u64_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_imbalance_shares);
tb_vpi_put_logic_char_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_imbalance_direction);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_stock);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_far_price);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_near_price);
tb_vpi_put_logic_price_4_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_current_reference_price);
tb_vpi_put_logic_char_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_cross_type);
tb_vpi_put_logic_char_t(argv,itch_s->itch_net_order_imbalance_indicator_data.itch_net_order_imbalance_indicator_price_variation_indicator);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_stock_locate);
tb_vpi_put_logic_u16_t(argv,itch_s->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_tracking_number);
tb_vpi_put_logic_u48_t(argv,itch_s->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_timestamp);
tb_vpi_put_logic_char_8_t(argv,itch_s->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_stock);
tb_vpi_put_logic_char_t(argv,itch_s->itch_retail_price_improvement_indicator_data.itch_retail_price_improvement_indicator_interest_flag);
tb_vpi_put_logic_char_20_t(argv,itch_s->itch_end_of_snapshot_data.itch_end_of_snapshot_sequence_number);
