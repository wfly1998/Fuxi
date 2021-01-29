# DIFF CLOCK
set_property IOSTANDARD DIFF_SSTL15 [get_ports diff_clk_*]
set_property PACKAGE_PIN R4 [get_ports diff_clk_p]
set_property PACKAGE_PIN T4 [get_ports diff_clk_n]
# set_property PACKAGE_PIN F6 [get_ports diff_clk_p]
# set_property PACKAGE_PIN E6 [get_ports diff_clk_n]
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets diff_clk_*]

# RESET
set_property IOSTANDARD LVCMOS15 [get_ports rst_n]
set_property PACKAGE_PIN T6 [get_ports rst_n]

# CFG FLASH
set_property IOSTANDARD LVCMOS33 [get_ports CFG_FLASH_*]
set_property PACKAGE_PIN R22 [get_ports CFG_FLASH_miso]
set_property PACKAGE_PIN P22 [get_ports CFG_FLASH_mosi]
set_property PACKAGE_PIN T19 [get_ports CFG_FLASH_ss]

# SPI FLASH
set_property IOSTANDARD LVCMOS33 [get_ports SPI_FLASH_*]
set_property PACKAGE_PIN E17 [get_ports SPI_FLASH_miso]
set_property PACKAGE_PIN C15 [get_ports SPI_FLASH_mosi]
set_property PACKAGE_PIN C14 [get_ports SPI_FLASH_sck]
set_property PACKAGE_PIN B16 [get_ports SPI_FLASH_ss]

# MDIO
set_property IOSTANDARD LVCMOS33 [get_ports MDIO_*]
set_property PACKAGE_PIN W10 [get_ports MDIO_mdc]
set_property PACKAGE_PIN V10 [get_ports MDIO_mdio]

# UART
set_property IOSTANDARD LVCMOS33 [get_ports UART_*]
set_property PACKAGE_PIN Y12 [get_ports UART_rxd]
set_property PACKAGE_PIN Y11 [get_ports UART_txd]

# VGA
set_property IOSTANDARD LVCMOS33 [get_ports VGA_*]
set_property PACKAGE_PIN AA11 [get_ports VGA_hsync]
set_property PACKAGE_PIN AA10 [get_ports VGA_vsync]
set_property PACKAGE_PIN AA19 [get_ports {VGA_b[0]}]
set_property PACKAGE_PIN AA18 [get_ports {VGA_b[1]}]
set_property PACKAGE_PIN AB18 [get_ports {VGA_b[2]}]
set_property PACKAGE_PIN T20 [get_ports {VGA_b[3]}]
set_property PACKAGE_PIN Y17 [get_ports {VGA_b[4]}]
set_property PACKAGE_PIN W22 [get_ports {VGA_b[5]}]
set_property PACKAGE_PIN V17 [get_ports {VGA_g[0]}]
set_property PACKAGE_PIN W17 [get_ports {VGA_g[1]}]
set_property PACKAGE_PIN U15 [get_ports {VGA_g[2]}]
set_property PACKAGE_PIN V15 [get_ports {VGA_g[3]}]
set_property PACKAGE_PIN AB21 [get_ports {VGA_g[4]}]
set_property PACKAGE_PIN AB22 [get_ports {VGA_g[5]}]
set_property PACKAGE_PIN W12 [get_ports {VGA_r[0]}]
set_property PACKAGE_PIN W11 [get_ports {VGA_r[1]}]
set_property PACKAGE_PIN V14 [get_ports {VGA_r[2]}]
set_property PACKAGE_PIN V13 [get_ports {VGA_r[3]}]
set_property PACKAGE_PIN T15 [get_ports {VGA_r[4]}]
set_property PACKAGE_PIN T14 [get_ports {VGA_r[5]}]

# MII
set_property IOSTANDARD LVCMOS33 [get_ports MII_*]
set_property PACKAGE_PIN N22 [get_ports {MII_rxd[0]}]
set_property PACKAGE_PIN H18 [get_ports {MII_rxd[1]}]
set_property PACKAGE_PIN H17 [get_ports {MII_rxd[2]}]
set_property PACKAGE_PIN K19 [get_ports {MII_rxd[3]}]
set_property PACKAGE_PIN M21 [get_ports {MII_rxd[4]}]
set_property PACKAGE_PIN L21 [get_ports {MII_rxd[5]}]
set_property PACKAGE_PIN M20 [get_ports {MII_rxd[7]}]
set_property PACKAGE_PIN N20 [get_ports {MII_rxd[6]}]
set_property PACKAGE_PIN M15 [get_ports {MII_txd[0]}]
set_property PACKAGE_PIN L14 [get_ports {MII_txd[1]}]
set_property PACKAGE_PIN K16 [get_ports {MII_txd[2]}]
set_property PACKAGE_PIN L16 [get_ports {MII_txd[3]}]
set_property PACKAGE_PIN K17 [get_ports {MII_txd[4]}]
set_property PACKAGE_PIN L20 [get_ports {MII_txd[5]}]
set_property PACKAGE_PIN L19 [get_ports {MII_txd[6]}]
set_property PACKAGE_PIN L13 [get_ports {MII_txd[7]}]
set_property PACKAGE_PIN N18 [get_ports MII_col]
set_property PACKAGE_PIN M18 [get_ports MII_crs]
set_property PACKAGE_PIN L15 [get_ports MII_rst_n]
set_property PACKAGE_PIN K18 [get_ports MII_rx_clk]
set_property PACKAGE_PIN J17 [get_ports MII_tx_clk]
set_property PACKAGE_PIN M22 [get_ports MII_rx_dv]
set_property PACKAGE_PIN N19 [get_ports MII_rx_er]
set_property PACKAGE_PIN M16 [get_ports MII_tx_en]
set_property PACKAGE_PIN M13 [get_ports MII_tx_er]

# I cannot understand
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets soc_inst/ethernet_controller/U0/o]
