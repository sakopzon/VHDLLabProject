library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.ALL;

entity CLOSE_f_paramFin is
	port( RESETN :in std_logic;
		 CLK: in std_logic;
		 n_param: in std_logic_vector(8 downto 0);
		 close_param:  out std_logic_vector(2 downto 0) 
		  );
end entity;

architecture arc_CLOSE_f_paramFin of CLOSE_f_paramFin is
signal fin_param :integer range 0 to 511;
begin
	process(CLK,RESETN)
	variable curr_par: std_logic_vector (8 downto 0);
	variable int_param: integer range 0 to 511;
	begin
	if (RESETN = '0') then
		curr_par :="000000000";
		int_param :=0;
		fin_param<=4;
	elsif (rising_edge(CLK)) then
		curr_par :=n_param;
		int_param :=conv_integer(curr_par);
		if (int_param>=163) then
			if (abs(int_param-163)<abs(int_param-195)) then
				fin_param <= 1;--n param is 163--Kav
			else
				fin_param <=0;--n param is 195--Kav
			end if;
		elsif (int_param<150) then
			if(int_param=97 or int_param=98) then
				fin_param <= 1;--n param is 163--Kav
			elsif (abs(int_param-70)<abs(int_param-75)) then
				if(int_param=0) then
					fin_param<=4;
				else
					fin_param <= 3;---n param is 70--Dot
				end if;
			else
				fin_param <=2;----n param is 75--Dot
			end if;
		else
			fin_param <= fin_param;
		end if;
	end if;
	end process;
	close_param<=conv_std_logic_vector(fin_param,3);
end arc_CLOSE_f_paramFin;