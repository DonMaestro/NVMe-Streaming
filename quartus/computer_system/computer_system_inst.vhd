	component computer_system is
		port (
			clk_clk                        : in  std_logic                     := 'X';             -- clk
			pcie_hip_ctrl_test_in          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- test_in
			pcie_hip_ctrl_simu_mode_pipe   : in  std_logic                     := 'X';             -- simu_mode_pipe
			pcie_hip_pipe_sim_pipe_pclk_in : in  std_logic                     := 'X';             -- sim_pipe_pclk_in
			pcie_hip_pipe_sim_pipe_rate    : out std_logic_vector(1 downto 0);                     -- sim_pipe_rate
			pcie_hip_pipe_sim_ltssmstate   : out std_logic_vector(4 downto 0);                     -- sim_ltssmstate
			pcie_hip_pipe_eidleinfersel0   : out std_logic_vector(2 downto 0);                     -- eidleinfersel0
			pcie_hip_pipe_eidleinfersel1   : out std_logic_vector(2 downto 0);                     -- eidleinfersel1
			pcie_hip_pipe_eidleinfersel2   : out std_logic_vector(2 downto 0);                     -- eidleinfersel2
			pcie_hip_pipe_eidleinfersel3   : out std_logic_vector(2 downto 0);                     -- eidleinfersel3
			pcie_hip_pipe_powerdown0       : out std_logic_vector(1 downto 0);                     -- powerdown0
			pcie_hip_pipe_powerdown1       : out std_logic_vector(1 downto 0);                     -- powerdown1
			pcie_hip_pipe_powerdown2       : out std_logic_vector(1 downto 0);                     -- powerdown2
			pcie_hip_pipe_powerdown3       : out std_logic_vector(1 downto 0);                     -- powerdown3
			pcie_hip_pipe_rxpolarity0      : out std_logic;                                        -- rxpolarity0
			pcie_hip_pipe_rxpolarity1      : out std_logic;                                        -- rxpolarity1
			pcie_hip_pipe_rxpolarity2      : out std_logic;                                        -- rxpolarity2
			pcie_hip_pipe_rxpolarity3      : out std_logic;                                        -- rxpolarity3
			pcie_hip_pipe_txcompl0         : out std_logic;                                        -- txcompl0
			pcie_hip_pipe_txcompl1         : out std_logic;                                        -- txcompl1
			pcie_hip_pipe_txcompl2         : out std_logic;                                        -- txcompl2
			pcie_hip_pipe_txcompl3         : out std_logic;                                        -- txcompl3
			pcie_hip_pipe_txdata0          : out std_logic_vector(31 downto 0);                    -- txdata0
			pcie_hip_pipe_txdata1          : out std_logic_vector(31 downto 0);                    -- txdata1
			pcie_hip_pipe_txdata2          : out std_logic_vector(31 downto 0);                    -- txdata2
			pcie_hip_pipe_txdata3          : out std_logic_vector(31 downto 0);                    -- txdata3
			pcie_hip_pipe_txdatak0         : out std_logic_vector(3 downto 0);                     -- txdatak0
			pcie_hip_pipe_txdatak1         : out std_logic_vector(3 downto 0);                     -- txdatak1
			pcie_hip_pipe_txdatak2         : out std_logic_vector(3 downto 0);                     -- txdatak2
			pcie_hip_pipe_txdatak3         : out std_logic_vector(3 downto 0);                     -- txdatak3
			pcie_hip_pipe_txdetectrx0      : out std_logic;                                        -- txdetectrx0
			pcie_hip_pipe_txdetectrx1      : out std_logic;                                        -- txdetectrx1
			pcie_hip_pipe_txdetectrx2      : out std_logic;                                        -- txdetectrx2
			pcie_hip_pipe_txdetectrx3      : out std_logic;                                        -- txdetectrx3
			pcie_hip_pipe_txelecidle0      : out std_logic;                                        -- txelecidle0
			pcie_hip_pipe_txelecidle1      : out std_logic;                                        -- txelecidle1
			pcie_hip_pipe_txelecidle2      : out std_logic;                                        -- txelecidle2
			pcie_hip_pipe_txelecidle3      : out std_logic;                                        -- txelecidle3
			pcie_hip_pipe_txdeemph0        : out std_logic;                                        -- txdeemph0
			pcie_hip_pipe_txdeemph1        : out std_logic;                                        -- txdeemph1
			pcie_hip_pipe_txdeemph2        : out std_logic;                                        -- txdeemph2
			pcie_hip_pipe_txdeemph3        : out std_logic;                                        -- txdeemph3
			pcie_hip_pipe_txmargin0        : out std_logic_vector(2 downto 0);                     -- txmargin0
			pcie_hip_pipe_txmargin1        : out std_logic_vector(2 downto 0);                     -- txmargin1
			pcie_hip_pipe_txmargin2        : out std_logic_vector(2 downto 0);                     -- txmargin2
			pcie_hip_pipe_txmargin3        : out std_logic_vector(2 downto 0);                     -- txmargin3
			pcie_hip_pipe_txswing0         : out std_logic;                                        -- txswing0
			pcie_hip_pipe_txswing1         : out std_logic;                                        -- txswing1
			pcie_hip_pipe_txswing2         : out std_logic;                                        -- txswing2
			pcie_hip_pipe_txswing3         : out std_logic;                                        -- txswing3
			pcie_hip_pipe_phystatus0       : in  std_logic                     := 'X';             -- phystatus0
			pcie_hip_pipe_phystatus1       : in  std_logic                     := 'X';             -- phystatus1
			pcie_hip_pipe_phystatus2       : in  std_logic                     := 'X';             -- phystatus2
			pcie_hip_pipe_phystatus3       : in  std_logic                     := 'X';             -- phystatus3
			pcie_hip_pipe_rxdata0          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rxdata0
			pcie_hip_pipe_rxdata1          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rxdata1
			pcie_hip_pipe_rxdata2          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rxdata2
			pcie_hip_pipe_rxdata3          : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rxdata3
			pcie_hip_pipe_rxdatak0         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rxdatak0
			pcie_hip_pipe_rxdatak1         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rxdatak1
			pcie_hip_pipe_rxdatak2         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rxdatak2
			pcie_hip_pipe_rxdatak3         : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rxdatak3
			pcie_hip_pipe_rxelecidle0      : in  std_logic                     := 'X';             -- rxelecidle0
			pcie_hip_pipe_rxelecidle1      : in  std_logic                     := 'X';             -- rxelecidle1
			pcie_hip_pipe_rxelecidle2      : in  std_logic                     := 'X';             -- rxelecidle2
			pcie_hip_pipe_rxelecidle3      : in  std_logic                     := 'X';             -- rxelecidle3
			pcie_hip_pipe_rxstatus0        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus0
			pcie_hip_pipe_rxstatus1        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus1
			pcie_hip_pipe_rxstatus2        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus2
			pcie_hip_pipe_rxstatus3        : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- rxstatus3
			pcie_hip_pipe_rxvalid0         : in  std_logic                     := 'X';             -- rxvalid0
			pcie_hip_pipe_rxvalid1         : in  std_logic                     := 'X';             -- rxvalid1
			pcie_hip_pipe_rxvalid2         : in  std_logic                     := 'X';             -- rxvalid2
			pcie_hip_pipe_rxvalid3         : in  std_logic                     := 'X';             -- rxvalid3
			pcie_hip_pipe_rxdataskip0      : in  std_logic                     := 'X';             -- rxdataskip0
			pcie_hip_pipe_rxdataskip1      : in  std_logic                     := 'X';             -- rxdataskip1
			pcie_hip_pipe_rxdataskip2      : in  std_logic                     := 'X';             -- rxdataskip2
			pcie_hip_pipe_rxdataskip3      : in  std_logic                     := 'X';             -- rxdataskip3
			pcie_hip_pipe_rxblkst0         : in  std_logic                     := 'X';             -- rxblkst0
			pcie_hip_pipe_rxblkst1         : in  std_logic                     := 'X';             -- rxblkst1
			pcie_hip_pipe_rxblkst2         : in  std_logic                     := 'X';             -- rxblkst2
			pcie_hip_pipe_rxblkst3         : in  std_logic                     := 'X';             -- rxblkst3
			pcie_hip_pipe_rxsynchd0        : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rxsynchd0
			pcie_hip_pipe_rxsynchd1        : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rxsynchd1
			pcie_hip_pipe_rxsynchd2        : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rxsynchd2
			pcie_hip_pipe_rxsynchd3        : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rxsynchd3
			pcie_hip_pipe_currentcoeff0    : out std_logic_vector(17 downto 0);                    -- currentcoeff0
			pcie_hip_pipe_currentcoeff1    : out std_logic_vector(17 downto 0);                    -- currentcoeff1
			pcie_hip_pipe_currentcoeff2    : out std_logic_vector(17 downto 0);                    -- currentcoeff2
			pcie_hip_pipe_currentcoeff3    : out std_logic_vector(17 downto 0);                    -- currentcoeff3
			pcie_hip_pipe_currentrxpreset0 : out std_logic_vector(2 downto 0);                     -- currentrxpreset0
			pcie_hip_pipe_currentrxpreset1 : out std_logic_vector(2 downto 0);                     -- currentrxpreset1
			pcie_hip_pipe_currentrxpreset2 : out std_logic_vector(2 downto 0);                     -- currentrxpreset2
			pcie_hip_pipe_currentrxpreset3 : out std_logic_vector(2 downto 0);                     -- currentrxpreset3
			pcie_hip_pipe_txsynchd0        : out std_logic_vector(1 downto 0);                     -- txsynchd0
			pcie_hip_pipe_txsynchd1        : out std_logic_vector(1 downto 0);                     -- txsynchd1
			pcie_hip_pipe_txsynchd2        : out std_logic_vector(1 downto 0);                     -- txsynchd2
			pcie_hip_pipe_txsynchd3        : out std_logic_vector(1 downto 0);                     -- txsynchd3
			pcie_hip_pipe_txblkst0         : out std_logic;                                        -- txblkst0
			pcie_hip_pipe_txblkst1         : out std_logic;                                        -- txblkst1
			pcie_hip_pipe_txblkst2         : out std_logic;                                        -- txblkst2
			pcie_hip_pipe_txblkst3         : out std_logic;                                        -- txblkst3
			pcie_hip_pipe_txdataskip0      : out std_logic;                                        -- txdataskip0
			pcie_hip_pipe_txdataskip1      : out std_logic;                                        -- txdataskip1
			pcie_hip_pipe_txdataskip2      : out std_logic;                                        -- txdataskip2
			pcie_hip_pipe_txdataskip3      : out std_logic;                                        -- txdataskip3
			pcie_hip_pipe_rate0            : out std_logic_vector(1 downto 0);                     -- rate0
			pcie_hip_pipe_rate1            : out std_logic_vector(1 downto 0);                     -- rate1
			pcie_hip_pipe_rate2            : out std_logic_vector(1 downto 0);                     -- rate2
			pcie_hip_pipe_rate3            : out std_logic_vector(1 downto 0);                     -- rate3
			pcie_hip_serial_rx_in0         : in  std_logic                     := 'X';             -- rx_in0
			pcie_hip_serial_rx_in1         : in  std_logic                     := 'X';             -- rx_in1
			pcie_hip_serial_rx_in2         : in  std_logic                     := 'X';             -- rx_in2
			pcie_hip_serial_rx_in3         : in  std_logic                     := 'X';             -- rx_in3
			pcie_hip_serial_tx_out0        : out std_logic;                                        -- tx_out0
			pcie_hip_serial_tx_out1        : out std_logic;                                        -- tx_out1
			pcie_hip_serial_tx_out2        : out std_logic;                                        -- tx_out2
			pcie_hip_serial_tx_out3        : out std_logic;                                        -- tx_out3
			pcie_npor_npor                 : in  std_logic                     := 'X';             -- npor
			pcie_npor_pin_perst            : in  std_logic                     := 'X';             -- pin_perst
			reset_reset_n                  : in  std_logic                     := 'X'              -- reset_n
		);
	end component computer_system;

	u0 : component computer_system
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --             clk.clk
			pcie_hip_ctrl_test_in          => CONNECTED_TO_pcie_hip_ctrl_test_in,          --   pcie_hip_ctrl.test_in
			pcie_hip_ctrl_simu_mode_pipe   => CONNECTED_TO_pcie_hip_ctrl_simu_mode_pipe,   --                .simu_mode_pipe
			pcie_hip_pipe_sim_pipe_pclk_in => CONNECTED_TO_pcie_hip_pipe_sim_pipe_pclk_in, --   pcie_hip_pipe.sim_pipe_pclk_in
			pcie_hip_pipe_sim_pipe_rate    => CONNECTED_TO_pcie_hip_pipe_sim_pipe_rate,    --                .sim_pipe_rate
			pcie_hip_pipe_sim_ltssmstate   => CONNECTED_TO_pcie_hip_pipe_sim_ltssmstate,   --                .sim_ltssmstate
			pcie_hip_pipe_eidleinfersel0   => CONNECTED_TO_pcie_hip_pipe_eidleinfersel0,   --                .eidleinfersel0
			pcie_hip_pipe_eidleinfersel1   => CONNECTED_TO_pcie_hip_pipe_eidleinfersel1,   --                .eidleinfersel1
			pcie_hip_pipe_eidleinfersel2   => CONNECTED_TO_pcie_hip_pipe_eidleinfersel2,   --                .eidleinfersel2
			pcie_hip_pipe_eidleinfersel3   => CONNECTED_TO_pcie_hip_pipe_eidleinfersel3,   --                .eidleinfersel3
			pcie_hip_pipe_powerdown0       => CONNECTED_TO_pcie_hip_pipe_powerdown0,       --                .powerdown0
			pcie_hip_pipe_powerdown1       => CONNECTED_TO_pcie_hip_pipe_powerdown1,       --                .powerdown1
			pcie_hip_pipe_powerdown2       => CONNECTED_TO_pcie_hip_pipe_powerdown2,       --                .powerdown2
			pcie_hip_pipe_powerdown3       => CONNECTED_TO_pcie_hip_pipe_powerdown3,       --                .powerdown3
			pcie_hip_pipe_rxpolarity0      => CONNECTED_TO_pcie_hip_pipe_rxpolarity0,      --                .rxpolarity0
			pcie_hip_pipe_rxpolarity1      => CONNECTED_TO_pcie_hip_pipe_rxpolarity1,      --                .rxpolarity1
			pcie_hip_pipe_rxpolarity2      => CONNECTED_TO_pcie_hip_pipe_rxpolarity2,      --                .rxpolarity2
			pcie_hip_pipe_rxpolarity3      => CONNECTED_TO_pcie_hip_pipe_rxpolarity3,      --                .rxpolarity3
			pcie_hip_pipe_txcompl0         => CONNECTED_TO_pcie_hip_pipe_txcompl0,         --                .txcompl0
			pcie_hip_pipe_txcompl1         => CONNECTED_TO_pcie_hip_pipe_txcompl1,         --                .txcompl1
			pcie_hip_pipe_txcompl2         => CONNECTED_TO_pcie_hip_pipe_txcompl2,         --                .txcompl2
			pcie_hip_pipe_txcompl3         => CONNECTED_TO_pcie_hip_pipe_txcompl3,         --                .txcompl3
			pcie_hip_pipe_txdata0          => CONNECTED_TO_pcie_hip_pipe_txdata0,          --                .txdata0
			pcie_hip_pipe_txdata1          => CONNECTED_TO_pcie_hip_pipe_txdata1,          --                .txdata1
			pcie_hip_pipe_txdata2          => CONNECTED_TO_pcie_hip_pipe_txdata2,          --                .txdata2
			pcie_hip_pipe_txdata3          => CONNECTED_TO_pcie_hip_pipe_txdata3,          --                .txdata3
			pcie_hip_pipe_txdatak0         => CONNECTED_TO_pcie_hip_pipe_txdatak0,         --                .txdatak0
			pcie_hip_pipe_txdatak1         => CONNECTED_TO_pcie_hip_pipe_txdatak1,         --                .txdatak1
			pcie_hip_pipe_txdatak2         => CONNECTED_TO_pcie_hip_pipe_txdatak2,         --                .txdatak2
			pcie_hip_pipe_txdatak3         => CONNECTED_TO_pcie_hip_pipe_txdatak3,         --                .txdatak3
			pcie_hip_pipe_txdetectrx0      => CONNECTED_TO_pcie_hip_pipe_txdetectrx0,      --                .txdetectrx0
			pcie_hip_pipe_txdetectrx1      => CONNECTED_TO_pcie_hip_pipe_txdetectrx1,      --                .txdetectrx1
			pcie_hip_pipe_txdetectrx2      => CONNECTED_TO_pcie_hip_pipe_txdetectrx2,      --                .txdetectrx2
			pcie_hip_pipe_txdetectrx3      => CONNECTED_TO_pcie_hip_pipe_txdetectrx3,      --                .txdetectrx3
			pcie_hip_pipe_txelecidle0      => CONNECTED_TO_pcie_hip_pipe_txelecidle0,      --                .txelecidle0
			pcie_hip_pipe_txelecidle1      => CONNECTED_TO_pcie_hip_pipe_txelecidle1,      --                .txelecidle1
			pcie_hip_pipe_txelecidle2      => CONNECTED_TO_pcie_hip_pipe_txelecidle2,      --                .txelecidle2
			pcie_hip_pipe_txelecidle3      => CONNECTED_TO_pcie_hip_pipe_txelecidle3,      --                .txelecidle3
			pcie_hip_pipe_txdeemph0        => CONNECTED_TO_pcie_hip_pipe_txdeemph0,        --                .txdeemph0
			pcie_hip_pipe_txdeemph1        => CONNECTED_TO_pcie_hip_pipe_txdeemph1,        --                .txdeemph1
			pcie_hip_pipe_txdeemph2        => CONNECTED_TO_pcie_hip_pipe_txdeemph2,        --                .txdeemph2
			pcie_hip_pipe_txdeemph3        => CONNECTED_TO_pcie_hip_pipe_txdeemph3,        --                .txdeemph3
			pcie_hip_pipe_txmargin0        => CONNECTED_TO_pcie_hip_pipe_txmargin0,        --                .txmargin0
			pcie_hip_pipe_txmargin1        => CONNECTED_TO_pcie_hip_pipe_txmargin1,        --                .txmargin1
			pcie_hip_pipe_txmargin2        => CONNECTED_TO_pcie_hip_pipe_txmargin2,        --                .txmargin2
			pcie_hip_pipe_txmargin3        => CONNECTED_TO_pcie_hip_pipe_txmargin3,        --                .txmargin3
			pcie_hip_pipe_txswing0         => CONNECTED_TO_pcie_hip_pipe_txswing0,         --                .txswing0
			pcie_hip_pipe_txswing1         => CONNECTED_TO_pcie_hip_pipe_txswing1,         --                .txswing1
			pcie_hip_pipe_txswing2         => CONNECTED_TO_pcie_hip_pipe_txswing2,         --                .txswing2
			pcie_hip_pipe_txswing3         => CONNECTED_TO_pcie_hip_pipe_txswing3,         --                .txswing3
			pcie_hip_pipe_phystatus0       => CONNECTED_TO_pcie_hip_pipe_phystatus0,       --                .phystatus0
			pcie_hip_pipe_phystatus1       => CONNECTED_TO_pcie_hip_pipe_phystatus1,       --                .phystatus1
			pcie_hip_pipe_phystatus2       => CONNECTED_TO_pcie_hip_pipe_phystatus2,       --                .phystatus2
			pcie_hip_pipe_phystatus3       => CONNECTED_TO_pcie_hip_pipe_phystatus3,       --                .phystatus3
			pcie_hip_pipe_rxdata0          => CONNECTED_TO_pcie_hip_pipe_rxdata0,          --                .rxdata0
			pcie_hip_pipe_rxdata1          => CONNECTED_TO_pcie_hip_pipe_rxdata1,          --                .rxdata1
			pcie_hip_pipe_rxdata2          => CONNECTED_TO_pcie_hip_pipe_rxdata2,          --                .rxdata2
			pcie_hip_pipe_rxdata3          => CONNECTED_TO_pcie_hip_pipe_rxdata3,          --                .rxdata3
			pcie_hip_pipe_rxdatak0         => CONNECTED_TO_pcie_hip_pipe_rxdatak0,         --                .rxdatak0
			pcie_hip_pipe_rxdatak1         => CONNECTED_TO_pcie_hip_pipe_rxdatak1,         --                .rxdatak1
			pcie_hip_pipe_rxdatak2         => CONNECTED_TO_pcie_hip_pipe_rxdatak2,         --                .rxdatak2
			pcie_hip_pipe_rxdatak3         => CONNECTED_TO_pcie_hip_pipe_rxdatak3,         --                .rxdatak3
			pcie_hip_pipe_rxelecidle0      => CONNECTED_TO_pcie_hip_pipe_rxelecidle0,      --                .rxelecidle0
			pcie_hip_pipe_rxelecidle1      => CONNECTED_TO_pcie_hip_pipe_rxelecidle1,      --                .rxelecidle1
			pcie_hip_pipe_rxelecidle2      => CONNECTED_TO_pcie_hip_pipe_rxelecidle2,      --                .rxelecidle2
			pcie_hip_pipe_rxelecidle3      => CONNECTED_TO_pcie_hip_pipe_rxelecidle3,      --                .rxelecidle3
			pcie_hip_pipe_rxstatus0        => CONNECTED_TO_pcie_hip_pipe_rxstatus0,        --                .rxstatus0
			pcie_hip_pipe_rxstatus1        => CONNECTED_TO_pcie_hip_pipe_rxstatus1,        --                .rxstatus1
			pcie_hip_pipe_rxstatus2        => CONNECTED_TO_pcie_hip_pipe_rxstatus2,        --                .rxstatus2
			pcie_hip_pipe_rxstatus3        => CONNECTED_TO_pcie_hip_pipe_rxstatus3,        --                .rxstatus3
			pcie_hip_pipe_rxvalid0         => CONNECTED_TO_pcie_hip_pipe_rxvalid0,         --                .rxvalid0
			pcie_hip_pipe_rxvalid1         => CONNECTED_TO_pcie_hip_pipe_rxvalid1,         --                .rxvalid1
			pcie_hip_pipe_rxvalid2         => CONNECTED_TO_pcie_hip_pipe_rxvalid2,         --                .rxvalid2
			pcie_hip_pipe_rxvalid3         => CONNECTED_TO_pcie_hip_pipe_rxvalid3,         --                .rxvalid3
			pcie_hip_pipe_rxdataskip0      => CONNECTED_TO_pcie_hip_pipe_rxdataskip0,      --                .rxdataskip0
			pcie_hip_pipe_rxdataskip1      => CONNECTED_TO_pcie_hip_pipe_rxdataskip1,      --                .rxdataskip1
			pcie_hip_pipe_rxdataskip2      => CONNECTED_TO_pcie_hip_pipe_rxdataskip2,      --                .rxdataskip2
			pcie_hip_pipe_rxdataskip3      => CONNECTED_TO_pcie_hip_pipe_rxdataskip3,      --                .rxdataskip3
			pcie_hip_pipe_rxblkst0         => CONNECTED_TO_pcie_hip_pipe_rxblkst0,         --                .rxblkst0
			pcie_hip_pipe_rxblkst1         => CONNECTED_TO_pcie_hip_pipe_rxblkst1,         --                .rxblkst1
			pcie_hip_pipe_rxblkst2         => CONNECTED_TO_pcie_hip_pipe_rxblkst2,         --                .rxblkst2
			pcie_hip_pipe_rxblkst3         => CONNECTED_TO_pcie_hip_pipe_rxblkst3,         --                .rxblkst3
			pcie_hip_pipe_rxsynchd0        => CONNECTED_TO_pcie_hip_pipe_rxsynchd0,        --                .rxsynchd0
			pcie_hip_pipe_rxsynchd1        => CONNECTED_TO_pcie_hip_pipe_rxsynchd1,        --                .rxsynchd1
			pcie_hip_pipe_rxsynchd2        => CONNECTED_TO_pcie_hip_pipe_rxsynchd2,        --                .rxsynchd2
			pcie_hip_pipe_rxsynchd3        => CONNECTED_TO_pcie_hip_pipe_rxsynchd3,        --                .rxsynchd3
			pcie_hip_pipe_currentcoeff0    => CONNECTED_TO_pcie_hip_pipe_currentcoeff0,    --                .currentcoeff0
			pcie_hip_pipe_currentcoeff1    => CONNECTED_TO_pcie_hip_pipe_currentcoeff1,    --                .currentcoeff1
			pcie_hip_pipe_currentcoeff2    => CONNECTED_TO_pcie_hip_pipe_currentcoeff2,    --                .currentcoeff2
			pcie_hip_pipe_currentcoeff3    => CONNECTED_TO_pcie_hip_pipe_currentcoeff3,    --                .currentcoeff3
			pcie_hip_pipe_currentrxpreset0 => CONNECTED_TO_pcie_hip_pipe_currentrxpreset0, --                .currentrxpreset0
			pcie_hip_pipe_currentrxpreset1 => CONNECTED_TO_pcie_hip_pipe_currentrxpreset1, --                .currentrxpreset1
			pcie_hip_pipe_currentrxpreset2 => CONNECTED_TO_pcie_hip_pipe_currentrxpreset2, --                .currentrxpreset2
			pcie_hip_pipe_currentrxpreset3 => CONNECTED_TO_pcie_hip_pipe_currentrxpreset3, --                .currentrxpreset3
			pcie_hip_pipe_txsynchd0        => CONNECTED_TO_pcie_hip_pipe_txsynchd0,        --                .txsynchd0
			pcie_hip_pipe_txsynchd1        => CONNECTED_TO_pcie_hip_pipe_txsynchd1,        --                .txsynchd1
			pcie_hip_pipe_txsynchd2        => CONNECTED_TO_pcie_hip_pipe_txsynchd2,        --                .txsynchd2
			pcie_hip_pipe_txsynchd3        => CONNECTED_TO_pcie_hip_pipe_txsynchd3,        --                .txsynchd3
			pcie_hip_pipe_txblkst0         => CONNECTED_TO_pcie_hip_pipe_txblkst0,         --                .txblkst0
			pcie_hip_pipe_txblkst1         => CONNECTED_TO_pcie_hip_pipe_txblkst1,         --                .txblkst1
			pcie_hip_pipe_txblkst2         => CONNECTED_TO_pcie_hip_pipe_txblkst2,         --                .txblkst2
			pcie_hip_pipe_txblkst3         => CONNECTED_TO_pcie_hip_pipe_txblkst3,         --                .txblkst3
			pcie_hip_pipe_txdataskip0      => CONNECTED_TO_pcie_hip_pipe_txdataskip0,      --                .txdataskip0
			pcie_hip_pipe_txdataskip1      => CONNECTED_TO_pcie_hip_pipe_txdataskip1,      --                .txdataskip1
			pcie_hip_pipe_txdataskip2      => CONNECTED_TO_pcie_hip_pipe_txdataskip2,      --                .txdataskip2
			pcie_hip_pipe_txdataskip3      => CONNECTED_TO_pcie_hip_pipe_txdataskip3,      --                .txdataskip3
			pcie_hip_pipe_rate0            => CONNECTED_TO_pcie_hip_pipe_rate0,            --                .rate0
			pcie_hip_pipe_rate1            => CONNECTED_TO_pcie_hip_pipe_rate1,            --                .rate1
			pcie_hip_pipe_rate2            => CONNECTED_TO_pcie_hip_pipe_rate2,            --                .rate2
			pcie_hip_pipe_rate3            => CONNECTED_TO_pcie_hip_pipe_rate3,            --                .rate3
			pcie_hip_serial_rx_in0         => CONNECTED_TO_pcie_hip_serial_rx_in0,         -- pcie_hip_serial.rx_in0
			pcie_hip_serial_rx_in1         => CONNECTED_TO_pcie_hip_serial_rx_in1,         --                .rx_in1
			pcie_hip_serial_rx_in2         => CONNECTED_TO_pcie_hip_serial_rx_in2,         --                .rx_in2
			pcie_hip_serial_rx_in3         => CONNECTED_TO_pcie_hip_serial_rx_in3,         --                .rx_in3
			pcie_hip_serial_tx_out0        => CONNECTED_TO_pcie_hip_serial_tx_out0,        --                .tx_out0
			pcie_hip_serial_tx_out1        => CONNECTED_TO_pcie_hip_serial_tx_out1,        --                .tx_out1
			pcie_hip_serial_tx_out2        => CONNECTED_TO_pcie_hip_serial_tx_out2,        --                .tx_out2
			pcie_hip_serial_tx_out3        => CONNECTED_TO_pcie_hip_serial_tx_out3,        --                .tx_out3
			pcie_npor_npor                 => CONNECTED_TO_pcie_npor_npor,                 --       pcie_npor.npor
			pcie_npor_pin_perst            => CONNECTED_TO_pcie_npor_pin_perst,            --                .pin_perst
			reset_reset_n                  => CONNECTED_TO_reset_reset_n                   --           reset.reset_n
		);

