
module computer_system (
	clk_clk,
	pcie_hip_ctrl_test_in,
	pcie_hip_ctrl_simu_mode_pipe,
	pcie_hip_pipe_sim_pipe_pclk_in,
	pcie_hip_pipe_sim_pipe_rate,
	pcie_hip_pipe_sim_ltssmstate,
	pcie_hip_pipe_eidleinfersel0,
	pcie_hip_pipe_eidleinfersel1,
	pcie_hip_pipe_eidleinfersel2,
	pcie_hip_pipe_eidleinfersel3,
	pcie_hip_pipe_powerdown0,
	pcie_hip_pipe_powerdown1,
	pcie_hip_pipe_powerdown2,
	pcie_hip_pipe_powerdown3,
	pcie_hip_pipe_rxpolarity0,
	pcie_hip_pipe_rxpolarity1,
	pcie_hip_pipe_rxpolarity2,
	pcie_hip_pipe_rxpolarity3,
	pcie_hip_pipe_txcompl0,
	pcie_hip_pipe_txcompl1,
	pcie_hip_pipe_txcompl2,
	pcie_hip_pipe_txcompl3,
	pcie_hip_pipe_txdata0,
	pcie_hip_pipe_txdata1,
	pcie_hip_pipe_txdata2,
	pcie_hip_pipe_txdata3,
	pcie_hip_pipe_txdatak0,
	pcie_hip_pipe_txdatak1,
	pcie_hip_pipe_txdatak2,
	pcie_hip_pipe_txdatak3,
	pcie_hip_pipe_txdetectrx0,
	pcie_hip_pipe_txdetectrx1,
	pcie_hip_pipe_txdetectrx2,
	pcie_hip_pipe_txdetectrx3,
	pcie_hip_pipe_txelecidle0,
	pcie_hip_pipe_txelecidle1,
	pcie_hip_pipe_txelecidle2,
	pcie_hip_pipe_txelecidle3,
	pcie_hip_pipe_txdeemph0,
	pcie_hip_pipe_txdeemph1,
	pcie_hip_pipe_txdeemph2,
	pcie_hip_pipe_txdeemph3,
	pcie_hip_pipe_txmargin0,
	pcie_hip_pipe_txmargin1,
	pcie_hip_pipe_txmargin2,
	pcie_hip_pipe_txmargin3,
	pcie_hip_pipe_txswing0,
	pcie_hip_pipe_txswing1,
	pcie_hip_pipe_txswing2,
	pcie_hip_pipe_txswing3,
	pcie_hip_pipe_phystatus0,
	pcie_hip_pipe_phystatus1,
	pcie_hip_pipe_phystatus2,
	pcie_hip_pipe_phystatus3,
	pcie_hip_pipe_rxdata0,
	pcie_hip_pipe_rxdata1,
	pcie_hip_pipe_rxdata2,
	pcie_hip_pipe_rxdata3,
	pcie_hip_pipe_rxdatak0,
	pcie_hip_pipe_rxdatak1,
	pcie_hip_pipe_rxdatak2,
	pcie_hip_pipe_rxdatak3,
	pcie_hip_pipe_rxelecidle0,
	pcie_hip_pipe_rxelecidle1,
	pcie_hip_pipe_rxelecidle2,
	pcie_hip_pipe_rxelecidle3,
	pcie_hip_pipe_rxstatus0,
	pcie_hip_pipe_rxstatus1,
	pcie_hip_pipe_rxstatus2,
	pcie_hip_pipe_rxstatus3,
	pcie_hip_pipe_rxvalid0,
	pcie_hip_pipe_rxvalid1,
	pcie_hip_pipe_rxvalid2,
	pcie_hip_pipe_rxvalid3,
	pcie_hip_pipe_rxdataskip0,
	pcie_hip_pipe_rxdataskip1,
	pcie_hip_pipe_rxdataskip2,
	pcie_hip_pipe_rxdataskip3,
	pcie_hip_pipe_rxblkst0,
	pcie_hip_pipe_rxblkst1,
	pcie_hip_pipe_rxblkst2,
	pcie_hip_pipe_rxblkst3,
	pcie_hip_pipe_rxsynchd0,
	pcie_hip_pipe_rxsynchd1,
	pcie_hip_pipe_rxsynchd2,
	pcie_hip_pipe_rxsynchd3,
	pcie_hip_pipe_currentcoeff0,
	pcie_hip_pipe_currentcoeff1,
	pcie_hip_pipe_currentcoeff2,
	pcie_hip_pipe_currentcoeff3,
	pcie_hip_pipe_currentrxpreset0,
	pcie_hip_pipe_currentrxpreset1,
	pcie_hip_pipe_currentrxpreset2,
	pcie_hip_pipe_currentrxpreset3,
	pcie_hip_pipe_txsynchd0,
	pcie_hip_pipe_txsynchd1,
	pcie_hip_pipe_txsynchd2,
	pcie_hip_pipe_txsynchd3,
	pcie_hip_pipe_txblkst0,
	pcie_hip_pipe_txblkst1,
	pcie_hip_pipe_txblkst2,
	pcie_hip_pipe_txblkst3,
	pcie_hip_pipe_txdataskip0,
	pcie_hip_pipe_txdataskip1,
	pcie_hip_pipe_txdataskip2,
	pcie_hip_pipe_txdataskip3,
	pcie_hip_pipe_rate0,
	pcie_hip_pipe_rate1,
	pcie_hip_pipe_rate2,
	pcie_hip_pipe_rate3,
	pcie_hip_serial_rx_in0,
	pcie_hip_serial_rx_in1,
	pcie_hip_serial_rx_in2,
	pcie_hip_serial_rx_in3,
	pcie_hip_serial_tx_out0,
	pcie_hip_serial_tx_out1,
	pcie_hip_serial_tx_out2,
	pcie_hip_serial_tx_out3,
	pcie_npor_npor,
	pcie_npor_pin_perst,
	reset_reset_n);	

	input		clk_clk;
	input	[31:0]	pcie_hip_ctrl_test_in;
	input		pcie_hip_ctrl_simu_mode_pipe;
	input		pcie_hip_pipe_sim_pipe_pclk_in;
	output	[1:0]	pcie_hip_pipe_sim_pipe_rate;
	output	[4:0]	pcie_hip_pipe_sim_ltssmstate;
	output	[2:0]	pcie_hip_pipe_eidleinfersel0;
	output	[2:0]	pcie_hip_pipe_eidleinfersel1;
	output	[2:0]	pcie_hip_pipe_eidleinfersel2;
	output	[2:0]	pcie_hip_pipe_eidleinfersel3;
	output	[1:0]	pcie_hip_pipe_powerdown0;
	output	[1:0]	pcie_hip_pipe_powerdown1;
	output	[1:0]	pcie_hip_pipe_powerdown2;
	output	[1:0]	pcie_hip_pipe_powerdown3;
	output		pcie_hip_pipe_rxpolarity0;
	output		pcie_hip_pipe_rxpolarity1;
	output		pcie_hip_pipe_rxpolarity2;
	output		pcie_hip_pipe_rxpolarity3;
	output		pcie_hip_pipe_txcompl0;
	output		pcie_hip_pipe_txcompl1;
	output		pcie_hip_pipe_txcompl2;
	output		pcie_hip_pipe_txcompl3;
	output	[31:0]	pcie_hip_pipe_txdata0;
	output	[31:0]	pcie_hip_pipe_txdata1;
	output	[31:0]	pcie_hip_pipe_txdata2;
	output	[31:0]	pcie_hip_pipe_txdata3;
	output	[3:0]	pcie_hip_pipe_txdatak0;
	output	[3:0]	pcie_hip_pipe_txdatak1;
	output	[3:0]	pcie_hip_pipe_txdatak2;
	output	[3:0]	pcie_hip_pipe_txdatak3;
	output		pcie_hip_pipe_txdetectrx0;
	output		pcie_hip_pipe_txdetectrx1;
	output		pcie_hip_pipe_txdetectrx2;
	output		pcie_hip_pipe_txdetectrx3;
	output		pcie_hip_pipe_txelecidle0;
	output		pcie_hip_pipe_txelecidle1;
	output		pcie_hip_pipe_txelecidle2;
	output		pcie_hip_pipe_txelecidle3;
	output		pcie_hip_pipe_txdeemph0;
	output		pcie_hip_pipe_txdeemph1;
	output		pcie_hip_pipe_txdeemph2;
	output		pcie_hip_pipe_txdeemph3;
	output	[2:0]	pcie_hip_pipe_txmargin0;
	output	[2:0]	pcie_hip_pipe_txmargin1;
	output	[2:0]	pcie_hip_pipe_txmargin2;
	output	[2:0]	pcie_hip_pipe_txmargin3;
	output		pcie_hip_pipe_txswing0;
	output		pcie_hip_pipe_txswing1;
	output		pcie_hip_pipe_txswing2;
	output		pcie_hip_pipe_txswing3;
	input		pcie_hip_pipe_phystatus0;
	input		pcie_hip_pipe_phystatus1;
	input		pcie_hip_pipe_phystatus2;
	input		pcie_hip_pipe_phystatus3;
	input	[31:0]	pcie_hip_pipe_rxdata0;
	input	[31:0]	pcie_hip_pipe_rxdata1;
	input	[31:0]	pcie_hip_pipe_rxdata2;
	input	[31:0]	pcie_hip_pipe_rxdata3;
	input	[3:0]	pcie_hip_pipe_rxdatak0;
	input	[3:0]	pcie_hip_pipe_rxdatak1;
	input	[3:0]	pcie_hip_pipe_rxdatak2;
	input	[3:0]	pcie_hip_pipe_rxdatak3;
	input		pcie_hip_pipe_rxelecidle0;
	input		pcie_hip_pipe_rxelecidle1;
	input		pcie_hip_pipe_rxelecidle2;
	input		pcie_hip_pipe_rxelecidle3;
	input	[2:0]	pcie_hip_pipe_rxstatus0;
	input	[2:0]	pcie_hip_pipe_rxstatus1;
	input	[2:0]	pcie_hip_pipe_rxstatus2;
	input	[2:0]	pcie_hip_pipe_rxstatus3;
	input		pcie_hip_pipe_rxvalid0;
	input		pcie_hip_pipe_rxvalid1;
	input		pcie_hip_pipe_rxvalid2;
	input		pcie_hip_pipe_rxvalid3;
	input		pcie_hip_pipe_rxdataskip0;
	input		pcie_hip_pipe_rxdataskip1;
	input		pcie_hip_pipe_rxdataskip2;
	input		pcie_hip_pipe_rxdataskip3;
	input		pcie_hip_pipe_rxblkst0;
	input		pcie_hip_pipe_rxblkst1;
	input		pcie_hip_pipe_rxblkst2;
	input		pcie_hip_pipe_rxblkst3;
	input	[1:0]	pcie_hip_pipe_rxsynchd0;
	input	[1:0]	pcie_hip_pipe_rxsynchd1;
	input	[1:0]	pcie_hip_pipe_rxsynchd2;
	input	[1:0]	pcie_hip_pipe_rxsynchd3;
	output	[17:0]	pcie_hip_pipe_currentcoeff0;
	output	[17:0]	pcie_hip_pipe_currentcoeff1;
	output	[17:0]	pcie_hip_pipe_currentcoeff2;
	output	[17:0]	pcie_hip_pipe_currentcoeff3;
	output	[2:0]	pcie_hip_pipe_currentrxpreset0;
	output	[2:0]	pcie_hip_pipe_currentrxpreset1;
	output	[2:0]	pcie_hip_pipe_currentrxpreset2;
	output	[2:0]	pcie_hip_pipe_currentrxpreset3;
	output	[1:0]	pcie_hip_pipe_txsynchd0;
	output	[1:0]	pcie_hip_pipe_txsynchd1;
	output	[1:0]	pcie_hip_pipe_txsynchd2;
	output	[1:0]	pcie_hip_pipe_txsynchd3;
	output		pcie_hip_pipe_txblkst0;
	output		pcie_hip_pipe_txblkst1;
	output		pcie_hip_pipe_txblkst2;
	output		pcie_hip_pipe_txblkst3;
	output		pcie_hip_pipe_txdataskip0;
	output		pcie_hip_pipe_txdataskip1;
	output		pcie_hip_pipe_txdataskip2;
	output		pcie_hip_pipe_txdataskip3;
	output	[1:0]	pcie_hip_pipe_rate0;
	output	[1:0]	pcie_hip_pipe_rate1;
	output	[1:0]	pcie_hip_pipe_rate2;
	output	[1:0]	pcie_hip_pipe_rate3;
	input		pcie_hip_serial_rx_in0;
	input		pcie_hip_serial_rx_in1;
	input		pcie_hip_serial_rx_in2;
	input		pcie_hip_serial_rx_in3;
	output		pcie_hip_serial_tx_out0;
	output		pcie_hip_serial_tx_out1;
	output		pcie_hip_serial_tx_out2;
	output		pcie_hip_serial_tx_out3;
	input		pcie_npor_npor;
	input		pcie_npor_pin_perst;
	input		reset_reset_n;
endmodule
