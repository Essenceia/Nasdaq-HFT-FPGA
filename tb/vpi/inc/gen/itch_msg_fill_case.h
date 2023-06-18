
case 'S': 
exp_len = 11;
itch_s->itch_system_event_v=1;
memcpy(&itch_s->itch_system_event_data,data,sizeof(itch_s->itch_system_event_data));
break;
 
case 'R': 
exp_len = 38;
itch_s->itch_stock_directory_v=1;
memcpy(&itch_s->itch_stock_directory_data,data,sizeof(itch_s->itch_stock_directory_data));
break;
 
case 'H': 
exp_len = 24;
itch_s->itch_stock_trading_action_v=1;
memcpy(&itch_s->itch_stock_trading_action_data,data,sizeof(itch_s->itch_stock_trading_action_data));
break;
 
case 'Y': 
exp_len = 19;
itch_s->itch_reg_sho_restriction_v=1;
memcpy(&itch_s->itch_reg_sho_restriction_data,data,sizeof(itch_s->itch_reg_sho_restriction_data));
break;
 
case 'L': 
exp_len = 25;
itch_s->itch_market_participant_position_v=1;
memcpy(&itch_s->itch_market_participant_position_data,data,sizeof(itch_s->itch_market_participant_position_data));
break;
 
case 'V': 
exp_len = 34;
itch_s->itch_mwcb_decline_level_v=1;
memcpy(&itch_s->itch_mwcb_decline_level_data,data,sizeof(itch_s->itch_mwcb_decline_level_data));
break;
 
case 'W': 
exp_len = 11;
itch_s->itch_mwcb_status_v=1;
memcpy(&itch_s->itch_mwcb_status_data,data,sizeof(itch_s->itch_mwcb_status_data));
break;
 
case 'K': 
exp_len = 27;
itch_s->itch_ipo_quoting_period_update_v=1;
memcpy(&itch_s->itch_ipo_quoting_period_update_data,data,sizeof(itch_s->itch_ipo_quoting_period_update_data));
break;
 
case 'J': 
exp_len = 34;
itch_s->itch_luld_auction_collar_v=1;
memcpy(&itch_s->itch_luld_auction_collar_data,data,sizeof(itch_s->itch_luld_auction_collar_data));
break;
 
case 'h': 
exp_len = 20;
itch_s->itch_operational_halt_v=1;
memcpy(&itch_s->itch_operational_halt_data,data,sizeof(itch_s->itch_operational_halt_data));
break;
 
case 'A': 
exp_len = 35;
itch_s->itch_add_order_v=1;
memcpy(&itch_s->itch_add_order_data,data,sizeof(itch_s->itch_add_order_data));
break;
 
case 'F': 
exp_len = 39;
itch_s->itch_add_order_with_mpid_v=1;
memcpy(&itch_s->itch_add_order_with_mpid_data,data,sizeof(itch_s->itch_add_order_with_mpid_data));
break;
 
case 'E': 
exp_len = 30;
itch_s->itch_order_executed_v=1;
memcpy(&itch_s->itch_order_executed_data,data,sizeof(itch_s->itch_order_executed_data));
break;
 
case 'C': 
exp_len = 35;
itch_s->itch_order_executed_with_price_v=1;
memcpy(&itch_s->itch_order_executed_with_price_data,data,sizeof(itch_s->itch_order_executed_with_price_data));
break;
 
case 'X': 
exp_len = 22;
itch_s->itch_order_cancel_v=1;
memcpy(&itch_s->itch_order_cancel_data,data,sizeof(itch_s->itch_order_cancel_data));
break;
 
case 'D': 
exp_len = 18;
itch_s->itch_order_delete_v=1;
memcpy(&itch_s->itch_order_delete_data,data,sizeof(itch_s->itch_order_delete_data));
break;
 
case 'U': 
exp_len = 34;
itch_s->itch_order_replace_v=1;
memcpy(&itch_s->itch_order_replace_data,data,sizeof(itch_s->itch_order_replace_data));
break;
 
case 'P': 
exp_len = 43;
itch_s->itch_trade_v=1;
memcpy(&itch_s->itch_trade_data,data,sizeof(itch_s->itch_trade_data));
break;
 
case 'Q': 
exp_len = 39;
itch_s->itch_cross_trade_v=1;
memcpy(&itch_s->itch_cross_trade_data,data,sizeof(itch_s->itch_cross_trade_data));
break;
 
case 'B': 
exp_len = 18;
itch_s->itch_broken_trade_v=1;
memcpy(&itch_s->itch_broken_trade_data,data,sizeof(itch_s->itch_broken_trade_data));
break;
 
case 'I': 
exp_len = 49;
itch_s->itch_net_order_imbalance_indicator_v=1;
memcpy(&itch_s->itch_net_order_imbalance_indicator_data,data,sizeof(itch_s->itch_net_order_imbalance_indicator_data));
break;
 
case 'N': 
exp_len = 19;
itch_s->itch_retail_price_improvement_indicator_v=1;
memcpy(&itch_s->itch_retail_price_improvement_indicator_data,data,sizeof(itch_s->itch_retail_price_improvement_indicator_data));
break;
 
case 'G': 
exp_len = 20;
itch_s->itch_end_of_snapshot_v=1;
memcpy(&itch_s->itch_end_of_snapshot_data,data,sizeof(itch_s->itch_end_of_snapshot_data));
break;
 