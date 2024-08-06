	----------------------------------------------------------------------------------
	-- Company: Chair of Adaptive Dynamic Systems
	-- Engineer: Sebastian Schneider
	-- 
	-- Create Date: 01/19/2021 05:04:49 PM
	-- Design Name: 
	-- Module Name: Axis_Slave - Behavioral
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
	
	entity Axis_Slave is
	    Port (  clk : in std_logic;
	            rst : in std_logic;
	            axis_tvalid : in std_logic;
	            axis_tdata  : in std_logic_vector (15 downto 0);
	            axis_tlast  : in std_logic;
	            axis_tready : out std_logic;
	            Channel_0   : out std_logic_vector (10 downto 0);
	            Channel_1   : out std_logic_vector (10 downto 0);
	            Channel_2   : out std_logic_vector (10 downto 0);
	            Channel_3   : out std_logic_vector (10 downto 0);
	            Channel_4   : out std_logic_vector (10 downto 0);
	            Channel_5   : out std_logic_vector (10 downto 0);
	            Channel_6   : out std_logic_vector (10 downto 0);
	            Channel_7   : out std_logic_vector (10 downto 0);
	            Channel_8   : out std_logic_vector (10 downto 0);
	            Channel_9   : out std_logic_vector (10 downto 0);
	            Channel_10  : out std_logic_vector (10 downto 0);
	            Channel_11  : out std_logic_vector (10 downto 0);
	            Channel_12  : out std_logic_vector (10 downto 0);
	            Channel_13  : out std_logic_vector (10 downto 0);
	            Channel_14  : out std_logic_vector (10 downto 0);
	            Channel_15  : out std_logic_vector (10 downto 0);
	            Channel_16  : out std_logic_vector (10 downto 0));
	end Axis_Slave;
	
	architecture Behavioral of Axis_Slave is
	
	type Channel_Array is array (0 to 16) of std_logic_vector(10 downto 0);  
	
	signal s_Channels : Channel_Array := (others => (others => '0'));
	
	signal s_channel : natural range 0 to 16 := 0; --send channel counter
	signal s_axis_tready  : std_logic := '0'; -- tready default value
	
	attribute MARK_DEBUG : string;
	attribute MARK_DEBUG of clk         : signal is "True";
	attribute MARK_DEBUG of rst         : signal is "True";
	attribute MARK_DEBUG of axis_tvalid : signal is "True";
	attribute MARK_DEBUG of axis_tdata  : signal is "True";
	attribute MARK_DEBUG of axis_tlast  : signal is "True";
	attribute MARK_DEBUG of axis_tready : signal is "True";
	attribute MARK_DEBUG of s_Channels  : signal is "True";
	
	begin
	
	    process(clk, s_axis_tready, s_Channels)
	        begin
	            if(rising_edge(clk))then
	                s_axis_tready <= '1';
	                if(rst = '1')then
	                    if(axis_tvalid = '1')then -- if data is valid
	                        if(axis_tlast = '1' or s_channel = 16)then --reset counter if stream ends or maximum channel received
	                            s_channel <= 0;
	                        else
	                            s_channel <= s_channel +1;
	                        end if;
	                        --save data
	                        s_Channels(s_channel) <= axis_tdata(10 downto 0);
	                    end if;
	                else
	                    s_channel <= 0;
	                    s_Channels <= (others => (others => '0'));
	                end if;
	
	            end if;
	
	            axis_tready <= s_axis_tready;
	            channel_0  <= s_Channels(0 );
	            channel_1  <= s_Channels(1 );
	            channel_2  <= s_Channels(2 );
	            channel_3  <= s_Channels(3 );
	            channel_4  <= s_Channels(4 );
	            channel_5  <= s_Channels(5 );
	            channel_6  <= s_Channels(6 );
	            channel_7  <= s_Channels(7 );
	            channel_8  <= s_Channels(8 );
	            channel_9  <= s_Channels(9 );
	            channel_10 <= s_Channels(10);
	            channel_11 <= s_Channels(11);
	            channel_12 <= s_Channels(12);
	            channel_13 <= s_Channels(13);
	            channel_14 <= s_Channels(14);
	            channel_15 <= s_Channels(15);
	            channel_16 <= s_Channels(16);
	
	    end process;
	
	end Behavioral;