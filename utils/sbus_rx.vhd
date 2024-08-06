----------------------------------------------------------------------------------
	-- Company: Chair of Adaptive Dynamic Systems
	-- Engineer: Sebastian Schneider
	-- 
	-- Create Date: 01/19/2021 12:56:19 PM
	-- Design Name: 
	-- Module Name: SBUS_Rx - Behavioral
	-- Project Name:
	-- Target Devices: 
	-- Tool Versions: 
	-- Description: 
	-- 
	-- Dependencies: 
	-- 
	-- Revision:
	-- Revision 0.01 - File Created
	-- Additional Comments:
	-- 
	----------------------------------------------------------------------------------
	
	
	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.all;
	
	entity SBUS_Rx is
	    Generic ( SbusMode          : String  := "FRSKY";    --possible: "FRSKY" | "FUTABA"
	              SbusCheckValue    : std_logic := '1';
	              SbusParityCheck       : std_logic :=  '1';
	              SbusMinValue      : natural := 172;
	              SbusMaxValue      : natural := 1811;
	              EmergencyChannel  : natural range 0 to 15  := 15;
	              EmergencyTriggerValue : natural range 0 to 2047 := 172;
	              EmergencyTrigger  : String := ">"    -- "> | = | <"
	             );
	    port(
	       Clk_100k : in  std_logic;
	       rst      : in std_logic;
	       Rx       : in  std_logic;
	       Channel_0  : out std_logic_vector (10 downto 0);
	       Channel_1  : out std_logic_vector (10 downto 0);
	       Channel_2  : out std_logic_vector (10 downto 0);
	       Channel_3  : out std_logic_vector (10 downto 0);
	       Channel_4  : out std_logic_vector (10 downto 0);
	       Channel_5  : out std_logic_vector (10 downto 0);
	       Channel_6  : out std_logic_vector (10 downto 0);
	       Channel_7  : out std_logic_vector (10 downto 0);
	       Channel_8  : out std_logic_vector (10 downto 0);
	       Channel_9  : out std_logic_vector (10 downto 0);
	       Channel_10 : out std_logic_vector (10 downto 0);
	       Channel_11 : out std_logic_vector (10 downto 0);
	       Channel_12 : out std_logic_vector (10 downto 0);
	       Channel_13 : out std_logic_vector (10 downto 0);
	       Channel_14 : out std_logic_vector (10 downto 0);
	       Channel_15 : out std_logic_vector (10 downto 0);
	       Channel_16 : out std_logic_vector (10 downto 0);
	       EmergencySwitch : out std_logic );
	end SBUS_Rx;
	
	architecture Behavioral of SBUS_Rx is
	    
	    type Channel_Array is array (0 to 16) of std_logic_vector(10 downto 0);
	    
	    constant PACKAGE_START : std_logic := '0';
	    constant PACKAGE_STOP  : std_logic_vector(1 downto 0) := "11";
	    constant SBUS_HEADER : std_logic_vector(7 downto 0):=x"0F";
	    constant SBUS_FOOTER : std_logic_vector(7 downto 0):=x"00";
	
	    signal s_Channels : Channel_Array := (others => (others => '0'));
	    signal s_EmergencySwitch : std_logic := '0';
	    signal s_payload : std_logic_vector(299 downto 0):=(others =>'1'); --  contains incoming data
	    signal s_footer : STD_LOGIC := '0';
	    signal s_header : STD_LOGIC := '0';
	    signal s_sp1 : STD_LOGIC := '0';
	    signal s_sp2 : STD_LOGIC := '0';
	    
	    shared variable v_Channels : Channel_Array := (others => (others => '0'));
	    shared variable v_Channels_Parity_Pass : STD_LOGIC_VECTOR(0 to 16) := (others => '0');    --variable for parity check pass
	    shared variable v_Channels_Pass : STD_LOGIC_VECTOR(0 to 16) := (others => '0');
	    shared variable v_package_parity_pass : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
	    shared variable v_package_pass : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
	    shared variable Header : STD_LOGIC := '0';
	    shared variable Footer : STD_LOGIC := '0';
	
	    attribute MARK_DEBUG : string;
	    attribute MARK_DEBUG of s_Channels : signal is "True";
	    attribute MARK_DEBUG of s_payload   : signal is "True";
	    attribute MARK_DEBUG of s_EmergencySwitch  : signal is "True";
	    attribute MARK_DEBUG of s_Header  : signal is "True";
	    attribute MARK_DEBUG of s_Footer  : signal is "True";
	    attribute MARK_DEBUG of s_sp1  : signal is "True";
	    attribute MARK_DEBUG of s_sp2  : signal is "True";
	
	    attribute KEEP : string;
	    attribute KEEP of s_EmergencySwitch : signal is "True";
	    attribute KEEP of s_Header : signal is "True";
	    attribute KEEP of s_Footer : signal is "True";
	    attribute KEEP of s_sp1 : signal is "True";
	    attribute KEEP of s_sp2 : signal is "True";
	
	begin
	
	   Payload_Handling : process(clk_100k, rst, s_payload)
	       
	       begin
	           if(s_payload(0)=PACKAGE_START and s_payload(8 downto 1)=SBUS_HEADER and s_payload(11 downto 10)=PACKAGE_STOP)then
	               Header :='1'; else Header := '0'; 
	           end if;
	           if(s_payload(288)=PACKAGE_START and s_payload(296 downto 289)=SBUS_FOOTER and s_payload(299 downto 298)=PACKAGE_STOP)then
	               Footer := '1'; else Footer := '0';
	           end if;
	           
	           if(rising_edge(clk_100k))then
	                --set incoming data mode
	                if(SbusMode = "FRSKY")then
	                    s_payload(299) <= not(RX);    -- invert data
	                else
	                    s_payload(299) <= RX;         -- normal data
	                end if;
	                
	               -- shift/ clear data
	               if((Header = '1' and Footer = '1') or rst = '0')then
	                   s_payload(298 downto 0) <= (others => '0');  --reset buffer
	               else
	                   s_payload(298 downto 0) <= s_payload(299 downto 1); --shift data
	               end if; 
	           end if;
        end process Payload_Handling;
	    
	    Channel_Handling : process(s_payload)
	       variable v_channel_vector : STD_LOGIC_VECTOR(183 downto 0) := (others => '0');
	       variable v_package_parity : STD_LOGIC_VECTOR(24 downto 0);
	       begin
	           v_package_parity := (others => '0');
	           for I in 0 to 24 loop   --25 packages-2 (header/Footer) = 23 packages
	               if(not(I=0 or I=24))then
	                   --get data from packages
	                   v_channel_vector(7+(I-1)*8 downto (I-1)*8) := s_payload(8+I*12 downto 1+I*12);
	               end if; 
	               --Package parity checks
	               for J in 8 downto 1 loop --data bits
	               v_package_parity(I) := v_package_parity(I) xor s_payload(I*12+J);
	               end loop;
	               if(v_package_parity(I)=s_payload(9+I*12))then
	                  v_Package_Parity_Pass(I) := '1';else v_Package_Parity_Pass(I) := '0';
	               end if;
	               --package start and stop bits check
	               if(s_payload(I*12)=PACKAGE_START and s_payload(11+I*12 downto 10+I*12)=PACKAGE_STOP)then
	                   v_package_pass(I) := '1'; else v_package_pass(I) := '0';
	               end if;
	           end loop;
	           --convert packages to channels
	           for I in 0 to 16 loop
	               --package data to channel data
	               if(I = 16)then
	                   v_Channels(16)(7 downto 0) := v_channel_vector(183 downto 176);
	               else
	                   v_Channels(I) := v_channel_vector(10+I*11 downto I*11);
	               end if;
	               --start, stop, parity bits to channel data
	               case I is
	                   when 0 =>   if(v_package_pass(1)='1' and v_package_pass(2)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(1)='1' and v_package_parity_pass(2)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 1 =>   if(v_package_pass(2)='1' and v_package_pass(3)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(2)='1' and v_package_parity_pass(3)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 2 =>   if(v_package_pass(3)='1' and v_package_pass(4)='1' and v_package_pass(5)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(3)='1' and v_package_parity_pass(4)='1' and v_package_parity_pass(5)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 3 =>   if(v_package_pass(5)='1' and v_package_pass(6)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(5)='1' and v_package_parity_pass(6)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 4 =>   if(v_package_pass(6)='1' and v_package_pass(7)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(6)='1' and v_package_parity_pass(7)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 5 =>   if(v_package_pass(7)='1' and v_package_pass(8)='1' and v_package_pass(9)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(7)='1' and v_package_parity_pass(8)='1' and v_package_parity_pass(9)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 6 =>   if(v_package_pass(9)='1' and v_package_pass(10)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(9)='1' and v_package_parity_pass(10)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 7 =>   if(v_package_pass(10)='1' and v_package_pass(11)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(10)='1' and v_package_parity_pass(11)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 8 =>   if(v_package_pass(12)='1' and v_package_pass(13)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(12)='1' and v_package_parity_pass(13)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 9 =>   if(v_package_pass(13)='1' and v_package_pass(14)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(13)='1' and v_package_parity_pass(14)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 10 =>   if(v_package_pass(14)='1' and v_package_pass(15)='1' and v_package_pass(16)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(14)='1' and v_package_parity_pass(15)='1' and v_package_parity_pass(16)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 11 =>   if(v_package_pass(16)='1' and v_package_pass(17)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(16)='1' and v_package_parity_pass(17)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 12 =>   if(v_package_pass(17)='1' and v_package_pass(18)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(17)='1' and v_package_parity_pass(18)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 13 =>   if(v_package_pass(18)='1' and v_package_pass(19)='1' and v_package_pass(20)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(18)='1' and v_package_parity_pass(19)='1' and v_package_parity_pass(20)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 14 =>   if(v_package_pass(20)='1' and v_package_pass(21)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(20)='1' and v_package_parity_pass(21)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 15 =>   if(v_package_pass(21)='1' and v_package_pass(22)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(21)='1' and v_package_parity_pass(22)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	                   when 16 =>   if(v_package_pass(23)='1')then
	                                   v_Channels_pass(I) := '1'; else v_Channels_Pass(I):= '0';
	                               end if;
	                               if(v_package_parity_pass(23)='1')then
	                                   v_Channels_Parity_Pass(I) := '1'; else v_Channels_Parity_Pass(I) := '0';
	                               end if;
	               end case;
	           end loop;
	           
	    end process Channel_Handling;
	    
	    Save_Data : process(clk_100k,s_Channels)
	    
	    begin
	       
	       if(rising_edge(clk_100k))then
	           if(Header = '1' and Footer = '1' and v_package_pass(0)='1' and v_package_pass(24)='1' 
	           --and v_package_parity_pass(0)='1' and v_package_parity_pass(24)='1'
	               )then
	               for I in 0 to 16 loop
	                   if(not(I = 16))then
	                       if(v_Channels_pass(I)='1')then
	                           if(SbusParityCheck = '1')then
	                               if(v_Channels_Parity_Pass(I) = '1')then
	                                   if(SbusCheckValue = '1')then
	                                       if(to_integer(unsigned(v_Channels(I))) >= SbusMinValue and to_integer(unsigned(v_Channels(I))) <= SbusMaxValue)then
	                                           s_channels(I) <= v_Channels(I);
	                                       end if;
	                                   else
	                                       s_channels(I) <= v_Channels(I);
	                                   end if;
	                               end if;
	                           else
	                               if(SbusCheckValue = '1')then
	                                   if(to_integer(unsigned(v_Channels(I))) >= SbusMinValue and to_integer(unsigned(v_Channels(I))) <= SbusMaxValue)then
	                                       s_channels(I) <= v_Channels(I);
	                                   end if;
	                               else
	                                   s_channels(I) <= v_Channels(I);
	                               end if;
	                           end if;
	                       end if;
	                   else --I=16 => Last channel is digital
	                       if(v_Channels_pass(I)='1')then
	                           if(SbusParityCheck = '1')then
	                               if(v_Channels_Parity_Pass(I) = '1')then
	                                   s_channels(I) <= v_Channels(I);
	                               end if;
	                           else
	                               s_channels(I) <= v_Channels(I);
	                           end if;
	                       end if;
	                   end if;
	               end loop;
	               
	               --s_Channels <= v_Channels;
	           end if;
	       end if;
	       
	    
	       case Emergencytrigger is
	           when ">" => if(unsigned(s_Channels(EmergencyChannel)) > EmergencyTriggerValue)then
	                           s_EmergencySwitch <= '1'; else s_EmergencySwitch <= '0'; 
	                       end if;
	           when "<" => if(unsigned(s_Channels(EmergencyChannel)) < EmergencyTriggerValue)then
	                           s_EmergencySwitch <= '1'; else s_EmergencySwitch <= '0'; 
	                       end if;
	           when others => if(unsigned(s_Channels(EmergencyChannel)) = EmergencyTriggerValue)then
	                           s_EmergencySwitch <= '1'; else s_EmergencySwitch <= '0'; 
	                       end if;
	       end case;
	    
	    end process Save_Data;
	    
	    
        channel_0  <= s_Channels(0);
        channel_1  <= s_Channels(1);
        channel_2  <= s_Channels(2);
        channel_3  <= s_Channels(3);
        channel_4  <= s_Channels(4);
        channel_5  <= s_Channels(5);
        channel_6  <= s_Channels(6);
        channel_7  <= s_Channels(7);
        channel_8  <= s_Channels(8);
        channel_9  <= s_Channels(9);
        channel_10 <= s_Channels(10);
        channel_11 <= s_Channels(11);
        channel_12 <= s_Channels(12);
        channel_13 <= s_Channels(13);
        channel_14 <= s_Channels(14);
        channel_15 <= s_Channels(15);
        channel_16 <= s_Channels(16);
        EmergencySwitch <= s_EmergencySwitch;
        s_header <= header;
        s_footer <= footer;
           
    end Behavioral;