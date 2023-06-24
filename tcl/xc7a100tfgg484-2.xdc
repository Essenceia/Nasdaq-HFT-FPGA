set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]


# The 1st channel Gigabit Ethernet pin assignments are as follows：
# Signal Name FPGA Pin Description
# E1_GTXC G21 Ethernet GMII transmit clock
set_property -dict {LOC G21 IOSTANDARD LVCMOS33 SLEW FAST DRIVE} [get_ports eth1_phy_gmii_tx_clk]
# E1_TXD0 D22 Ethernet Transmit Data bit0
set_property -dict {LOC D22  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[0]}]
# E1_TXD1 H20 Ethernet Transmit Data bit1
set_property -dict {LOC H20  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[1]}]
# E1_TXD2 H22 Ethernet Transmit Data bit2
set_property -dict {LOC H22  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[2]}]
# E1_TXD3 J22 Ethernet Transmit Data bit3
set_property -dict {LOC J22  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[3]}]
# E1_TXD4 K22 Ethernet Transmit Data bit4
set_property -dict {LOC K22  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[4]}]
# E1_TXD5 L19 Ethernet Transmit Data bit5
set_property -dict {LOC L19  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[5]}]
# E1_TXD6 K19 Ethernet Transmit Data bit6
set_property -dict {LOC K19  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[6]}]
# E1_TXD7 L20 Ethernet Transmit Data bit7
set_property -dict {LOC L20  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {eth1_phy_txd[7]}]
# E1_TXEN G22 Ethernet transmit enable signal
set_property -dict {LOC G22  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports eth1_phy_tx_en]
# E1_TXER K17 Ethernet transmit error signal
set_property -dict {LOC K17  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports eth1_phy_tx_err]
# E1_TXC K21 Ethernet GMII transmit clock
set_property -dict {LOC K21  IOSTANDARD LVCMOS33} [get_ports eth1_phy_gmii_tx_en]
# E1_RXC K18 Ethernet GMII receive clock
set_property -dict {LOC K18  IOSTANDARD LVCMOS33} [get_ports eth1_phy_gmii_rx_clk]
# E1_RXDV M22 Ethernet receive data valid signal
set_property -dict {LOC M22  IOSTANDARD LVCMOS33} [get_ports eth1_phy_rx_v]
# E1_RXER N18 Ethernet receiving data error
set_property -dict {LOC N18  IOSTANDARD LVCMOS33} [get_ports eth1_phy_rx_err]
# E1_RXD0 N22 Ethernet Receive Data Bit0
set_property -dict {LOC N22  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[0]}]
# E1_RXD1 H18 Ethernet Receive Data Bit1
set_property -dict {LOC H18  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[1]}]
# E1_RXD2 H17 Ethernet Receive Data Bit2
set_property -dict {LOC H17  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[2]}]
# E1_RXD3 M21 Ethernet Receive Data Bit3
set_property -dict {LOC M21  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[3]}]
# E1_RXD4 L21 Ethernet Receive Data Bit4
set_property -dict {LOC L21  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[4]}]
# E1_RXD5 N20 Ethernet Receive Data Bit5
set_property -dict {LOC N20  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[5]}]
# E1_RXD6 M20 Ethernet Receive Data Bit6
set_property -dict {LOC M20  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[6]}]
# E1_RXD7 N19 Ethernet Receive Data Bit7
set_property -dict {LOC N19  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rxd[7]}]
# E1_COL M18 Ethernet Collision signal
set_property -dict {LOC M18  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_col}]
# E1_CRS L18 Ethernet Carrier Sense Signal
set_property -dict {LOC L18  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_crs]}]
# E1_RESET G20 Ethernet Reset Signal
set_property -dict {LOC G20  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_rst}]
# E1_MDC J17 Ethernet Management Clock
set_property -dict {LOC J17  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_m_clk}]
# E1_MDIO L16 Ethernet Management Data
set_property -dict {LOC L16  IOSTANDARD LVCMOS33} [get_ports {eth1_phy_m_d}]

