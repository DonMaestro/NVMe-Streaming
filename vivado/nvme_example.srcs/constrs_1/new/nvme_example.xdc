# DDR4 indicator - GPIO_LED_0
set_property PACKAGE_PIN C9 [get_ports c0_init_calib_complete_0]
set_property IOSTANDARD LVCMOS33 [get_ports c0_init_calib_complete_0]

# PCI indicator - GPIO_LED_1
set_property PACKAGE_PIN D9 [get_ports pci_user_lnk_up_0]
set_property IOSTANDARD LVCMOS33 [get_ports pci_user_lnk_up_0]

# FMC_HPC_GBTCLK0_M2C_C_P 100MHz
set_property PACKAGE_PIN K7 [get_ports {CLK_PCI_0_clk_p[0]}]
set_property PACKAGE_PIN K6 [get_ports {CLK_PCI_0_clk_n[0]}]
create_clock -period 10.000 -name CLK_PCI_0_clk_p -waveform {0.000 5.000} [get_ports CLK_PCI_0_clk_p]

# FMC_HPC_LA00_CC_P 
set_property PACKAGE_PIN AD20 [get_ports {pci_reset_0[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pci_reset_0[0]}]

# PCI FMC DP[3:0]_M2C (rxp)
# table 3-22 user guide kcu116
set_property PACKAGE_PIN D2 [get_ports {pci_express_x4_rxp[0]}]
set_property PACKAGE_PIN C4 [get_ports {pci_express_x4_rxp[1]}]
set_property PACKAGE_PIN B2 [get_ports {pci_express_x4_rxp[2]}]
set_property PACKAGE_PIN A4 [get_ports {pci_express_x4_rxp[3]}]
# DP[0]_C2M (txp) F7
# DP[1]_C2M (txp) E5
# DP[2]_C2M (txp) D7
# DP[3]_C2M (txp) B7

#set_property LOC GTYE4_CHANNEL_X0Y15 [get_cells nvme_i/xdma_0/inst/pcie4_ip_i/inst/nvme_xdma_0_0_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/nvme_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.nvme_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST]
#set_property LOC GTYE4_CHANNEL_X0Y14 [get_cells nvme_i/xdma_0/inst/pcie4_ip_i/inst/nvme_xdma_0_0_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/nvme_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.nvme_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST]
#set_property LOC GTYE4_CHANNEL_X0Y13 [get_cells nvme_i/xdma_0/inst/pcie4_ip_i/inst/nvme_xdma_0_0_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/nvme_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.nvme_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST]
#set_property LOC GTYE4_CHANNEL_X0Y12 [get_cells nvme_i/xdma_0/inst/pcie4_ip_i/inst/nvme_xdma_0_0_pcie4_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/gt_wizard.gtwizard_top_i/nvme_xdma_0_0_pcie4_ip_gt_i/inst/gen_gtwizard_gtye4_top.nvme_xdma_0_0_pcie4_ip_gt_gtwizard_gtye4_inst/gen_gtwizard_gtye4.gen_channel_container[3].gen_enabled_channel.gtye4_channel_wrapper_inst/channel_inst/gtye4_channel_gen.gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST]


# Configuration via Dual Quad SPI settings for KCU116
#set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
#set_property CONFIG_VOLTAGE 1.8 [current_design]
#set_property CFGBVS GND [current_design]
#set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

set_property PACKAGE_PIN N23       [get_ports "SPI_1_0_io0_io"]
set_property IOSTANDARD  LVCMOS18  [get_ports "SPI_1_0_io0_io"]
set_property PACKAGE_PIN P23       [get_ports "SPI_1_0_io1_io"]
set_property IOSTANDARD  LVCMOS18  [get_ports "SPI_1_0_io1_io"]
set_property PACKAGE_PIN R20       [get_ports "SPI_1_0_io2_io"]
set_property IOSTANDARD  LVCMOS18  [get_ports "SPI_1_0_io2_io"]
set_property PACKAGE_PIN R21       [get_ports "SPI_1_0_io3_io"]
set_property IOSTANDARD  LVCMOS18  [get_ports "SPI_1_0_io3_io"]

set_property PACKAGE_PIN U22       [get_ports "SPI_1_0_ss_io"]
set_property IOSTANDARD  LVCMOS18  [get_ports "SPI_1_0_ss_io"]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
