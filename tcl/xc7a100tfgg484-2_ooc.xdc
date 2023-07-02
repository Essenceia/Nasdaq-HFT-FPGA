create_clock -name "TS_CLK" -period 5.0 [ get_ports clk ]
set_property HD.CLK_SRC BUFGCTRL_X0Y0 [ get_ports clk ]
