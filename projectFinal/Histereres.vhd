library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Histereres is
	port( RESETN :in std_logic;
		 CLK: in std_logic;
		 offb:  in std_logic_vector(7 downto 0);
		 highorlow:  out std_logic
		 --what: out std_logic_vector(7 downto 0)
		  );
end entity;

architecture arc_Histereres of Histereres is
	signal tmp_out: std_logic;

	
	begin
	
	
	process(CLK,RESETN)
	variable int: integer range -200 to 300 :=0;
--	variable tmp_out: std_logic;
	begin
		if RESETN = '0' then
			tmp_out <= '0';
		elsif rising_edge(CLK) then
			int :=conv_integer(unsigned(offb));
			if (int>154) then
				tmp_out <= '1';
			elsif(int<128) then
				tmp_out <= '0';
			else
				tmp_out <= tmp_out;
			end if;
		end if;
		--what<=conv_std_logic_vector(int,8);
	end process;
	highorlow <= tmp_out;
end arc_Histereres;