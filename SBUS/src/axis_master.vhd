----------------------------------------------------------------------------------
	-- Company: Chair of Adaptive Dynamic Systems
	-- Engineer: Sebastian Schneider
	-- 
	-- Create Date: 01/19/2021 06:02:29 PM
	-- Design Name: 
	-- Module Name: AXIS_Master - Behavioral
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
	
	entity AXIS_Master is
	   Generic (AXI_Send_Interval_ms      : natural range 3 to 100 := 15); --default 15ms, transmission duration is 3ms
	   
	    Port (  clk         : in std_logic;
	            rst         : in std_logic;
	            
	            axis_tvalid : out std_logic;
	            axis_tdata  : out std_logic_vector (15 downto 0);
	            axis_tlast  : out std_logic;
	            axis_tready : in std_logic;
	            
	            Channel_0   : in std_logic_vector (10 downto 0);
	            Channel_1   : in std_logic_vector (10 downto 0);
	            Channel_2   : in std_logic_vector (10 downto 0);
	            Channel_3   : in std_logic_vector (10 downto 0);
	            Channel_4   : in std_logic_vector (10 downto 0);
	            Channel_5   : in std_logic_vector (10 downto 0);
	            Channel_6   : in std_logic_vector (10 downto 0);
	            Channel_7   : in std_logic_vector (10 downto 0);
	            Channel_8   : in std_logic_vector (10 downto 0);
	            Channel_9   : in std_logic_vector (10 downto 0);
	            Channel_10  : in std_logic_vector (10 downto 0);
	            Channel_11  : in std_logic_vector (10 downto 0);
	            Channel_12  : in std_logic_vector (10 downto 0);
	            Channel_13  : in std_logic_vector (10 downto 0);
	            Channel_14  : in std_logic_vector (10 downto 0);
	            Channel_15  : in std_logic_vector (10 downto 0);
	            Channel_16  : in std_logic_vector (10 downto 0));
	end AXIS_Master;
	
	architecture Behavioral of AXIS_Master is
	
	    type Channel_Array is array (0 to 16) of std_logic_vector(10 downto 0);  
	
	    constant CHANNELS : natural := 17;
	
	    signal s_counter  : natural range 0 to 100000 := 0; --counter for periodic signal
	    signal s_count_ms : natural range 0 to 100000 := 0; --count ms for periodic signal
	    signal channel_ctr  : natural range 0 to 17 := 0; --counter for current transmitted channel
	    signal s_Channels   : Channel_Array := (others => (others => '0'));
	    
	    shared variable tvalid : std_logic := '0';
	    
	    attribute MARK_DEBUG : string;
	    --attribute MARK_DEBUG of clk         : signal is "True";
	    attribute MARK_DEBUG of rst           : signal is "True";
	    attribute MARK_DEBUG of s_Channels    : signal is "True";
	    attribute MARK_DEBUG of axis_tvalid   : signal is "True";
	    attribute MARK_DEBUG of axis_tdata    : signal is "True";
	    attribute MARK_DEBUG of axis_tready   : signal is "True";
	    attribute MARK_DEBUG of axis_tlast   : signal is "True";
	    attribute MARK_DEBUG of Channel_ctr   : signal is "True";
	
	begin
	
	    save_channel: process(clk, rst)
	        
	        begin
	            if(rising_edge(clk))then
	                if(rst = '1')then
	                    s_Channels <= (Channel_0, Channel_1, Channel_2, Channel_3, Channel_4, Channel_5, Channel_6, Channel_7, Channel_8,
	                                   Channel_9 , Channel_10 , Channel_11 , Channel_12 , Channel_13 , Channel_14 , Channel_15 , Channel_16);
	                else
	                    s_Channels <= (others => (others => '0')); --reset values of Channel
	                end if;
	            end if;
	        end process save_channel;
	
	    sm : process(clk, s_Channels, channel_ctr)
	    variable tlast : std_logic := '0';
	        begin
	           
	            if(Channel_ctr = Channels)then
	               tlast := '1'; else tlast := '0';
	            end if;
	            if(Channel_ctr = 0)then
	               axis_tdata <= (b"00000" & s_Channels(channel_ctr)); else axis_tdata <= (b"00000" & s_Channels(channel_ctr-1));
	            end if;
	            if(Channel_ctr = 0)then
	               tvalid := '0'; else tvalid := '1'; 
	            end if;
	            axis_tlast <= tlast;
	            axis_tvalid <= tvalid;
	         	

	            
	            
	    end process sm;
	    
	    timing : process(clk, channel_ctr)
	    begin
	       if(rising_edge(clk))then
	           if(rst = '1')then
	               --increment/reset Channel Counter
	               if(channel_ctr = Channels and axis_tready = '1' and tvalid = '1')then
	                   channel_ctr <= 0;
	               end if;
	               if(not(channel_ctr = Channels) and axis_tready = '1' and tvalid = '1')then
	                   channel_ctr <= channel_ctr +1;
	               end if;
	               --send intervall counter
	               if(s_counter = 99999)then
	                   if(s_count_ms = AXI_Send_Interval_ms)then
	                       if(channel_ctr = 0)then
	                           channel_ctr <= 1;
	                       end if;
	                       s_count_ms <= 0;
	                   else
	                       s_count_ms <= s_count_ms +1;
	                   end if;
	                   s_counter <= 0;
	               else
	                   s_counter <= s_counter +1;
	               end if;
	           else
	               s_counter <= 0;
	               Channel_ctr <= 0;
	           end if;
	       end if;
	    
	    end process timing;
	
	end Behavioral;