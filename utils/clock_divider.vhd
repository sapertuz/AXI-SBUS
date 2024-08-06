----------------------------------------------------------------------------------
	-- Company: Chair of Adaptive Dynamic Systems
	-- Engineer: Sebastian Schneider 
	-- 
	-- Create Date: 01/19/2021 07:03:42 PM
	-- Design Name: 
	-- Module Name: Clock_Divider - Behavioral
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
	
	entity Clock_Divider is
	Generic ( Fin : natural := 100000000;
	          Fout : natural := 100000
	             );
	    Port ( Clk : in STD_LOGIC;       --clock input
	           Clk_out : out STD_LOGIC   --clock output
			 );
	end Clock_Divider;
	
	architecture Behavioral of Clock_Divider is
	    signal s_counter : natural range 0 to 1000 := 0;
	    signal s_clock : std_logic := '0';
	    begin
	        process(Clk, s_clock)
	            begin
	                if(rising_edge(Clk)) then
	                    s_counter <= s_counter +1;  
	                    if(s_counter = Fin/(Fout*2)-1) then             
	                        s_counter <= 0;
	                        s_clock <= not(s_clock);
	                    end if;
	                end if;
	                Clk_out <= s_clock;
	        end process;
	end Behavioral;