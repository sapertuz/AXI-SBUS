library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sbus_axis is
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
        sbus_in : in STD_LOGIC;
        sbus_out : out STD_LOGIC;
        M_AXIS_tdata    : out STD_LOGIC_VECTOR(15 downto 0);
        M_AXIS_tvalid   : out STD_LOGIC;
        M_AXIS_tlast    : out STD_LOGIC;
        M_AXIS_tready   : in STD_LOGIC;
        S_AXIS_tdata    : in STD_LOGIC_VECTOR(15 downto 0);
        S_AXIS_tvalid   : in STD_LOGIC;
        S_AXIS_tlast    : in STD_LOGIC;
        S_AXIS_tready   : out STD_LOGIC;
        emergency   : out STD_LOGIC);
end sbus_axis;

architecture Behavioral of sbus_axis is

    signal s_clk_100k, s_EmergencySwitch, s_tx_sbus_out : std_logic;
    type t_Channels is array (0 to 16) of std_logic_vector(10 downto 0);
    signal s_channel_tx, s_channel_rx : t_Channels;
    
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
            
    inst_Axis_Slave: entity work.Axis_Slave(Behavioral)
        Port map(  
            clk => clk,
            rst => rst, 
            axis_tvalid => S_AXIS_tvalid,
            axis_tdata => S_AXIS_tdata,
            axis_tlast => S_AXIS_tlast,
            axis_tready => S_AXIS_tready,
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

    inst_AXIS_Master: entity work.AXIS_Master(Behavioral)
    Port map (  
        clk => clk,
        rst => rst,         
        axis_tvalid => M_AXIS_tvalid,
        axis_tdata  => M_AXIS_tdata,
        axis_tlast  => M_AXIS_tlast,
        axis_tready => M_AXIS_tready,
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
        Channel_16 => s_channel_rx(16)
        );      

    sbus_out <= s_tx_sbus_out when (EmergencyButton='0') else
                sbus_in when (s_EmergencySwitch='0') else
                s_tx_sbus_out;
    emergency <= s_EmergencySwitch;

end Behavioral;
