library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.ALL;

entity ena_morse is
port(
	clk,resetN,make,break : in std_logic;
	dout : out std_logic
	);
end ena_morse;

architecture ena_morse_behavior of ena_morse is
	type state is (is_released, is_pressed);
	signal next_state, present_state : state;
	signal outena : std_logic;
	signal innerenable : std_logic;
	begin
	process(clk,resetN)
	begin
	if resetN='0' then
	present_state <= is_released;
	outena <='0';
	elsif rising_edge(clk) then
	present_state <= next_state;
	if (innerenable='1') then
	outena <= '1' ;
	end if;
	end if;
	end process;
	process(present_state, make, break)
		begin
		innerenable <='0';
		case present_state is
			when is_released =>
			if make='1' then
				next_state <= is_pressed;
				innerenable <='1';
			else
				next_state <= is_released;
			end if;
			when is_pressed =>
				if break='1' then
					next_state <= is_released;
			else
					next_state <= is_pressed;
			end if;
		end case;
	end process;
	dout <= outena;
end ena_morse_behavior; 