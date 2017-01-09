library ieee ;
use ieee.std_logic_1164.all;
entity Turbo_F_div_quater is
	port( RESETN :in std_logic;
		 CLK: in std_logic;
		 TURBO: in std_logic;
		 QuaterSec: out std_logic) ;
end entity;

architecture arc_Turbo_F_div_quater of Turbo_F_div_quater is
signal qone_sec_flag: std_logic;
begin
	process(CLK,RESETN)
		variable one_sec: integer ;
		variable sec: integer := 12500000 ; -- for Real operation
		--variable sec: integer := 20 ; -- for simulation
	begin
		if (RESETN = '0') then
			one_sec := 0 ;
			qone_sec_flag <= '0' ;
		elsif rising_edge(CLK) then
			if(TURBO='1') then
			one_sec := one_sec + 4 ;
				if (one_sec = sec) then
					qone_sec_flag <= '1' ;
					one_sec := 0;
				else
					qone_sec_flag<= '0';
				end if;
			else
			one_sec := one_sec + 1 ;
				if (one_sec >= sec) then
					qone_sec_flag <= '1' ;
					one_sec := 0;
				else
					qone_sec_flag<= '0';
				end if;
			end if;
		end if;
	end process;
	QuaterSec<=qone_sec_flag;
end arc_Turbo_F_div_quater;