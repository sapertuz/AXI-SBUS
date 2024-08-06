----------------------------------------------------------------------------------
	-- Company: Chair of Adaptive Dynamic Systems
	-- Engineer: Sebastian Schneider
	-- 
	-- Create Date: 01/19/2021 11:31:02 AM
	-- Design Name: 
	-- Module Name: SBUS_Tx - Behavioral
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
	
	entity SBUS_Tx is
	    Generic (Send_Interval_ms      : natural range 3 to 100 := 15; --default 15ms, transmission duration is 3ms
	             SBUS_MODE             : String  := "FRSKY");         -- FRSKY | FUTABA
	                       
	    Port(Clk_100k   : in std_logic;
	        rst         : in std_logic;
	        Tx          : out std_logic;
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
	end SBUS_Tx;
	
	architecture Behavioral of SBUS_Tx is
	    type Channel_Array is array (0 to 16) of std_logic_vector(10 downto 0);  
	    
	    constant START_BIT   : std_logic := '0';
	    constant STOPP_BITs  : std_logic_vector(1 downto 0) := "11";
	    constant HEADER_BYTE : std_logic_vector(7 downto 0):=x"0F";
	    constant FOOTER_BYTE : std_logic_vector(7 downto 0):=x"00";
	    
	    signal s_Channels   : Channel_Array := (others => (others => '0'));
	    --counter
	    signal s_counter : natural range 0 to 10000 := 0; --counter for periodic signal
	    signal s_package : natural range 0 to 25 := 1; --counter for send packages
	    signal s_bit : natural range 0 to 11 := 0;  -- counter for current bit in package
	    --miscellanious
	    signal s_odd : std_logic := '0'; --parity variable
	    signal s_tx : std_logic :='1';  -- output signal
	
	    -- attribute MARK_DEBUG : string;
	    -- attribute MARK_DEBUG of s_bit : signal is "True";
	    -- attribute MARK_DEBUG of s_package : signal is "True";
	    -- attribute MARK_DEBUG of tx : signal is "True";
	
	
	begin
	    flags : process(Clk_100k)
	    begin
	        if(rising_edge(Clk_100k))then
	            if(not(rst = '0'))then
	                --package flag
	                if(s_counter = 100*Send_Interval_ms) then   --send in interval           
	                s_package <= 1;
	                s_counter <= 0;
	                else
	                    s_counter <= s_counter +1;              --count until next transmission
	                end if;
	                if(s_package = 25 and s_bit = 11)then       --all data send
	                    s_package <= 0;                         --stopp sending
	                elsif(s_bit = 11)then
	                    s_package <= s_package + 1;             --send next package
	                end if;
	                --s_bit flag
	                if(s_bit = 11)then
	                    s_bit <= 0;                             --reset bit for next package
	                elsif(s_package > 0)then
	                    s_bit <= s_bit + 1;                     --increment when
	                end if;     
	            else --reset
	                s_bit <= 0;
	                s_package <= 0;
	                s_counter <= 0;
	            end if;
	            
	        end if;
	        
	    end process flags;
	
	save_channels : process(Clk_100k)
	    begin
	        if(rising_edge(Clk_100k)) then
	            if(not(rst = '0'))then
	                s_Channels(0)   <= channel_0 ;
	                s_Channels(1)   <= channel_1 ;
	                s_Channels(2)   <= channel_2 ;
	                s_Channels(3)   <= channel_3 ;
	                s_Channels(4)   <= channel_4 ;
	                s_Channels(5)   <= channel_5 ;
	                s_Channels(6)   <= channel_6 ;
	                s_Channels(7)   <= channel_7 ;
	                s_Channels(8)   <= channel_8 ;
	                s_Channels(9)   <= channel_9 ;
	                s_Channels(10)  <= channel_10;
	                s_Channels(11)  <= channel_11;
	                s_Channels(12)  <= channel_12;
	                s_Channels(13)  <= channel_13;
	                s_Channels(14)  <= channel_14;
	                s_Channels(15)  <= channel_15;
	                s_Channels(16)  <= channel_16;
	            else    --reset data
	                s_Channels <= (others => (others =>'0'));
	            end if;
	        end if;
	end process save_channels;
	
	
	send_data: process(Clk_100k,s_tx)
	        variable v_data_row : natural range 0 to 16 := 0;
	        variable v_data_row_pos : natural range 0 to 10 :=0;
	        
	        begin
	            if(rising_edge(Clk_100k))then
	                if(s_package >= 1)then -- package = 0 equals idle
	                    if(s_bit = 0)then
	                        s_tx <= START_BIT;
	                        s_odd <= '0'; -- reset parity bit
	                    end if;
	                    if(s_bit < 9 and s_bit > 0)then -- data bits
	                        --header byte
	                        if(s_package = 1)then
	                            s_tx <= HEADER_BYTE(s_bit-1);
	                        end if;
	                        --footer byte
	                        if(s_package = 25)then  --FOOTER BYTE
	                            s_tx <= FOOTER_BYTE(s_bit -1);
	                        end if;
	                        if(s_package > 1 and s_package < 25)then
	                            v_data_row := ((s_package-2)*8 + s_bit-1)/11;
	                            v_data_row_pos := ((s_package-2)*8 + s_bit-1)mod 11;
	                            s_tx <=s_Channels(v_data_row)(v_data_row_pos);--send data bit
	                            s_odd <= s_odd xor s_tx; 
	                        end if;
	                    end if;
	                    if(s_bit = 9)then -- send parity bit
	                        s_tx <= s_odd xor s_tx;
	                    end if;
	                    if(s_bit = 10 or s_bit = 11)then --send stopp bits
	                        s_tx <= STOPP_BITS(s_bit - 10);
	                    end if;
	                else
	                    s_tx <= '1'; --reset tx output
	                end if;
	            end if;
	            
	            if(SBUS_MODE = "FRSKY")then
	              Tx <= not(s_tx);   
	            else
	                Tx <= s_tx;
	            end if;  
	    end process;
	
	end Behavioral;
