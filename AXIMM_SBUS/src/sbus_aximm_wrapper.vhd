library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity sbus_aximm is
    Generic ( 
        Fin : natural := 100000000; -- Input frequency from the board (pynq is 125MHz on pin H16)
        Fsbus : natural := 100000; -- SBUS frequency 100KHz
        
        SbusIntervallMs : natural range 3 to 1000 := 14;
        
        SbusMode          : String  := "FRSKY";    --possible: "FRSKY" | "FUTABA"
        SbusParityCheck   : std_logic :=  '1';
	    SbusCheckValue    : std_logic := '1';
	    SbusMinValue      : natural := 172;
	    SbusMaxValue      : natural := 1811;
	    
	    EmergencyButton : std_logic := '1';
	    EmergencyChannel  : natural range 0 to 15  := 15;
	    EmergencyTriggerValue : natural range 0 to 2047 := 172;
	    EmergencyTrigger  : String := ">");    -- "> | = | <"
    Port ( 
         clk : in STD_LOGIC;
         rst : in STD_LOGIC;
--        ap_clk : IN STD_LOGIC;
--        ap_rst_n : IN STD_LOGIC;
        interrupt : OUT STD_LOGIC;

        sbus_in : in STD_LOGIC;
        sbus_out : out STD_LOGIC;

        -- AXI lite interface
        s_axi_control_AWADDR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s_axi_control_AWVALID : IN STD_LOGIC;
        s_axi_control_AWREADY : OUT STD_LOGIC;
        s_axi_control_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_control_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_control_WVALID : IN STD_LOGIC;
        s_axi_control_WREADY : OUT STD_LOGIC;
        s_axi_control_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_control_BVALID : OUT STD_LOGIC;
        s_axi_control_BREADY : IN STD_LOGIC;
        s_axi_control_ARADDR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s_axi_control_ARVALID : IN STD_LOGIC;
        s_axi_control_ARREADY : OUT STD_LOGIC;
        s_axi_control_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_control_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_control_RVALID : OUT STD_LOGIC;
        s_axi_control_RREADY : IN STD_LOGIC;
        
        -- MM interface
        m_axi_gmem_AWID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_AWADDR : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        m_axi_gmem_AWLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axi_gmem_AWSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_AWBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_AWLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_AWREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_AWQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWVALID : OUT STD_LOGIC;
        m_axi_gmem_AWREADY : IN STD_LOGIC;
        m_axi_gmem_WID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_WDATA : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
        m_axi_gmem_WSTRB : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axi_gmem_WLAST : OUT STD_LOGIC;
        m_axi_gmem_WVALID : OUT STD_LOGIC;
        m_axi_gmem_WREADY : IN STD_LOGIC;
        m_axi_gmem_BID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_BRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_BVALID : IN STD_LOGIC;
        m_axi_gmem_BREADY : OUT STD_LOGIC;
        m_axi_gmem_ARID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_ARADDR : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        m_axi_gmem_ARLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axi_gmem_ARSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_ARBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_ARLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_ARREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_ARQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARVALID : OUT STD_LOGIC;
        m_axi_gmem_ARREADY : IN STD_LOGIC;
        m_axi_gmem_RID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_RDATA : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        m_axi_gmem_RRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_RLAST : IN STD_LOGIC;
        m_axi_gmem_RVALID : IN STD_LOGIC;
        m_axi_gmem_RREADY : OUT STD_LOGIC;
        --

        emergency   : out STD_LOGIC
    );
end sbus_aximm;

architecture Behavioral of sbus_aximm is

    COMPONENT sbus_mm_0
    PORT (
        s_axi_control_AWADDR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s_axi_control_AWVALID : IN STD_LOGIC;
        s_axi_control_AWREADY : OUT STD_LOGIC;
        s_axi_control_WDATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_control_WSTRB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_control_WVALID : IN STD_LOGIC;
        s_axi_control_WREADY : OUT STD_LOGIC;
        s_axi_control_BRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_control_BVALID : OUT STD_LOGIC;
        s_axi_control_BREADY : IN STD_LOGIC;
        s_axi_control_ARADDR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        s_axi_control_ARVALID : IN STD_LOGIC;
        s_axi_control_ARREADY : OUT STD_LOGIC;
        s_axi_control_RDATA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_control_RRESP : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_control_RVALID : OUT STD_LOGIC;
        s_axi_control_RREADY : IN STD_LOGIC;
        ap_clk : IN STD_LOGIC;
        ap_rst_n : IN STD_LOGIC;
        interrupt : OUT STD_LOGIC;
        m_axi_gmem_AWID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_AWADDR : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        m_axi_gmem_AWLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axi_gmem_AWSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_AWBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_AWLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_AWREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_AWQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_AWVALID : OUT STD_LOGIC;
        m_axi_gmem_AWREADY : IN STD_LOGIC;
        m_axi_gmem_WID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_WDATA : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
        m_axi_gmem_WSTRB : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axi_gmem_WLAST : OUT STD_LOGIC;
        m_axi_gmem_WVALID : OUT STD_LOGIC;
        m_axi_gmem_WREADY : IN STD_LOGIC;
        m_axi_gmem_BID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_BRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_BVALID : IN STD_LOGIC;
        m_axi_gmem_BREADY : OUT STD_LOGIC;
        m_axi_gmem_ARID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_ARADDR : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        m_axi_gmem_ARLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axi_gmem_ARSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_ARBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_ARLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_ARREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        m_axi_gmem_ARQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        m_axi_gmem_ARVALID : OUT STD_LOGIC;
        m_axi_gmem_ARREADY : IN STD_LOGIC;
        m_axi_gmem_RID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        m_axi_gmem_RDATA : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        m_axi_gmem_RRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        m_axi_gmem_RLAST : IN STD_LOGIC;
        m_axi_gmem_RVALID : IN STD_LOGIC;
        m_axi_gmem_RREADY : OUT STD_LOGIC;
        channel0_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel1_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel2_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel3_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel4_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel5_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel6_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel7_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel8_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel9_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel10_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel11_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel12_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel13_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel14_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel15_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel16_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel0_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel1_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel3_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel4_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel5_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel6_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel7_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel8_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel9_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel10_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel11_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel12_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel13_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel14_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel15_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        channel16_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
    );
    END COMPONENT;

    signal s_clk_100k, s_EmergencySwitch, s_tx_sbus_out : std_logic;
    -- Channel ports 10 bits
    type t_Channels is array (0 to 16) of std_logic_vector(10 downto 0);
    signal s_channel_tx, s_channel_rx : t_Channels;
    -- Channel ports 16 bits
    type t_mmChannels is array (0 to 16) of std_logic_vector(15 downto 0);
    signal mm_channel_tx, mm_channel_rx : t_mmChannels;


    
begin

    inst_Clock_Divider: entity work.Clock_Divider(Behavioral)
        Generic map ( 
            Fin => Fin,
            Fout => Fsbus
            )
        Port map(
            Clk => clk,
            Clk_out => s_clk_100k
            );

    inst_SBUS_Tx: entity work.SBUS_Tx(Behavioral)
        Generic map (
            Send_Interval_ms => SbusIntervallMs,
            SBUS_MODE => "FRSKY"    -- FRSKY | FUTABA
            )         
        Port map(
            Clk_100k => s_clk_100k,
            rst => rst, 
            Tx => s_tx_sbus_out, 
            Channel_0 => s_channel_tx(0),
            Channel_1 => s_channel_tx(1),
            Channel_2 => s_channel_tx(2),
            Channel_3 => s_channel_tx(3),
            Channel_4 => s_channel_tx(4),
            Channel_5 => s_channel_tx(5),
            Channel_6 => s_channel_tx(6),
            Channel_7 => s_channel_tx(7),
            Channel_8 => s_channel_tx(8),
            Channel_9 => s_channel_tx(9),
            Channel_10 => s_channel_tx(10),
            Channel_11 => s_channel_tx(11),
            Channel_12 => s_channel_tx(12),
            Channel_13 => s_channel_tx(13),
            Channel_14 => s_channel_tx(14),
            Channel_15 => s_channel_tx(15),
            Channel_16 => s_channel_tx(16)
            );
                        
    inst_SBUS_Rx: entity work.SBUS_Rx(Behavioral)
        Generic map(
            SbusMode => SbusMode, 
            SbusParityCheck => SbusParityCheck,
            SbusCheckValue  => SbusCheckValue,
            SbusMinValue    => SbusMinValue,
            SbusMaxValue    => SbusMaxValue,
            EmergencyChannel => EmergencyChannel,
            EmergencyTriggerValue => EmergencyTriggerValue,
            EmergencyTrigger => EmergencyTrigger
            )
        Port map(
            Clk_100k => s_clk_100k,
            rst => rst, 
            Rx => sbus_in,
            Channel_0 => s_channel_rx(0),
            Channel_1 => s_channel_rx(1),
            Channel_2 => s_channel_rx(2),
            Channel_3 => s_channel_rx(3),
            Channel_4 => s_channel_rx(4),
            Channel_5 => s_channel_rx(5),
            Channel_6 => s_channel_rx(6),
            Channel_7 => s_channel_rx(7),
            Channel_8 => s_channel_rx(8),
            Channel_9 => s_channel_rx(9),
            Channel_10 => s_channel_rx(10),
            Channel_11 => s_channel_rx(11),
            Channel_12 => s_channel_rx(12),
            Channel_13 => s_channel_rx(13),
            Channel_14 => s_channel_rx(14),
            Channel_15 => s_channel_rx(15),
            Channel_16 => s_channel_rx(16),
            EmergencySwitch => s_EmergencySwitch
            );            
    
sbus_mm_inst : sbus_mm_0
  PORT MAP (
    s_axi_control_AWADDR => s_axi_control_AWADDR,
    s_axi_control_AWVALID => s_axi_control_AWVALID,
    s_axi_control_AWREADY => s_axi_control_AWREADY,
    s_axi_control_WDATA => s_axi_control_WDATA,
    s_axi_control_WSTRB => s_axi_control_WSTRB,
    s_axi_control_WVALID => s_axi_control_WVALID,
    s_axi_control_WREADY => s_axi_control_WREADY,
    s_axi_control_BRESP => s_axi_control_BRESP,
    s_axi_control_BVALID => s_axi_control_BVALID,
    s_axi_control_BREADY => s_axi_control_BREADY,
    s_axi_control_ARADDR => s_axi_control_ARADDR,
    s_axi_control_ARVALID => s_axi_control_ARVALID,
    s_axi_control_ARREADY => s_axi_control_ARREADY,
    s_axi_control_RDATA => s_axi_control_RDATA,
    s_axi_control_RRESP => s_axi_control_RRESP,
    s_axi_control_RVALID => s_axi_control_RVALID,
    s_axi_control_RREADY => s_axi_control_RREADY,
    ap_clk => clk,
    ap_rst_n => rst,
    interrupt => interrupt,
    m_axi_gmem_AWID => m_axi_gmem_AWID,
    m_axi_gmem_AWADDR => m_axi_gmem_AWADDR,
    m_axi_gmem_AWLEN => m_axi_gmem_AWLEN,
    m_axi_gmem_AWSIZE => m_axi_gmem_AWSIZE,
    m_axi_gmem_AWBURST => m_axi_gmem_AWBURST,
    m_axi_gmem_AWLOCK => m_axi_gmem_AWLOCK,
    m_axi_gmem_AWREGION => m_axi_gmem_AWREGION,
    m_axi_gmem_AWCACHE => m_axi_gmem_AWCACHE,
    m_axi_gmem_AWPROT => m_axi_gmem_AWPROT,
    m_axi_gmem_AWQOS => m_axi_gmem_AWQOS,
    m_axi_gmem_AWVALID => m_axi_gmem_AWVALID,
    m_axi_gmem_AWREADY => m_axi_gmem_AWREADY,
    m_axi_gmem_WID => m_axi_gmem_WID,
    m_axi_gmem_WDATA => m_axi_gmem_WDATA,
    m_axi_gmem_WSTRB => m_axi_gmem_WSTRB,
    m_axi_gmem_WLAST => m_axi_gmem_WLAST,
    m_axi_gmem_WVALID => m_axi_gmem_WVALID,
    m_axi_gmem_WREADY => m_axi_gmem_WREADY,
    m_axi_gmem_BID => m_axi_gmem_BID,
    m_axi_gmem_BRESP => m_axi_gmem_BRESP,
    m_axi_gmem_BVALID => m_axi_gmem_BVALID,
    m_axi_gmem_BREADY => m_axi_gmem_BREADY,
    m_axi_gmem_ARID => m_axi_gmem_ARID,
    m_axi_gmem_ARADDR => m_axi_gmem_ARADDR,
    m_axi_gmem_ARLEN => m_axi_gmem_ARLEN,
    m_axi_gmem_ARSIZE => m_axi_gmem_ARSIZE,
    m_axi_gmem_ARBURST => m_axi_gmem_ARBURST,
    m_axi_gmem_ARLOCK => m_axi_gmem_ARLOCK,
    m_axi_gmem_ARREGION => m_axi_gmem_ARREGION,
    m_axi_gmem_ARCACHE => m_axi_gmem_ARCACHE,
    m_axi_gmem_ARPROT => m_axi_gmem_ARPROT,
    m_axi_gmem_ARQOS => m_axi_gmem_ARQOS,
    m_axi_gmem_ARVALID => m_axi_gmem_ARVALID,
    m_axi_gmem_ARREADY => m_axi_gmem_ARREADY,
    m_axi_gmem_RID => m_axi_gmem_RID,
    m_axi_gmem_RDATA => m_axi_gmem_RDATA,
    m_axi_gmem_RRESP => m_axi_gmem_RRESP,
    m_axi_gmem_RLAST => m_axi_gmem_RLAST,
    m_axi_gmem_RVALID => m_axi_gmem_RVALID,
    m_axi_gmem_RREADY => m_axi_gmem_RREADY,
    channel0_in => mm_channel_rx(0),
    channel1_in => mm_channel_rx(1),
    channel2_in => mm_channel_rx(2),
    channel3_in => mm_channel_rx(3),
    channel4_in => mm_channel_rx(4),
    channel5_in => mm_channel_rx(5),
    channel6_in => mm_channel_rx(6),
    channel7_in => mm_channel_rx(7),
    channel8_in => mm_channel_rx(8),
    channel9_in => mm_channel_rx(9),
    channel10_in => mm_channel_rx(10),
    channel11_in => mm_channel_rx(11),
    channel12_in => mm_channel_rx(12),
    channel13_in => mm_channel_rx(13),
    channel14_in => mm_channel_rx(14),
    channel15_in => mm_channel_rx(15),
    channel16_in => mm_channel_rx(16),
    channel0_out => mm_channel_tx(0),
    channel1_out => mm_channel_tx(1),
    channel2_out => mm_channel_tx(2),
    channel3_out => mm_channel_tx(3),
    channel4_out => mm_channel_tx(4),
    channel5_out => mm_channel_tx(5),
    channel6_out => mm_channel_tx(6),
    channel7_out => mm_channel_tx(7),
    channel8_out => mm_channel_tx(8),
    channel9_out => mm_channel_tx(9),
    channel10_out => mm_channel_tx(10),
    channel11_out => mm_channel_tx(11),
    channel12_out => mm_channel_tx(12),
    channel13_out => mm_channel_tx(13),
    channel14_out => mm_channel_tx(14),
    channel15_out => mm_channel_tx(15),
    channel16_out => mm_channel_tx(16)
    );
    

    sbus_out <= s_tx_sbus_out when (EmergencyButton='0') else
                sbus_in when (s_EmergencySwitch='0') else
                s_tx_sbus_out;

    channels_loop: for ii in 0 to 16 generate
        mm_channel_rx(ii) <= b"00000" & s_channel_rx(ii);
        s_channel_tx(ii) <= mm_channel_tx(ii)(10 downto 0);
    end generate channels_loop;

    emergency <= s_EmergencySwitch;

end Behavioral;
