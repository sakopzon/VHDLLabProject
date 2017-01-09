library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.ALL;

entity ENABLE_TRANS is
	port( RESETN :in std_logic;
		 CLK: in std_logic;
		 leng: in std_logic_vector(2 downto 0);
		 make:  in std_logic;
		 quatersec: in std_logic;
		 enab_trans: out std_logic
		  );
end entity;

architecture arc_ENABLE_TRANS of ENABLE_TRANS is
signal counter: integer;
signal tmp_ena: std_logic;
begin
	process(CLK,RESETN)
		variable lenght_bin: std_logic_vector (2 downto 0):= leng;
		variable runtime: integer range 0 to 8; -- for Real operation
		--variable runtime: integer range 0 to 30; -- for simulation
	begin
		if RESETN = '0' then
			tmp_ena<='0';
			counter<=0;
		elsif rising_edge(CLK) then
			runtime:=conv_integer(lenght_bin)+3;
			if (make = '1') then
			counter<=0;
			end if;
			if(quatersec='1' and counter<runtime ) then
			counter <= counter+1;
			tmp_ena<='1';
			end if;
			if (counter = runtime) then
			tmp_ena<='0';
			end if;
		end if;
	end process;
	enab_trans<=tmp_ena;
end arc_ENABLE_TRANS;