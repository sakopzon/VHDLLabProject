library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.ALL;

entity f_finder_fin is
	port( RESETN :in std_logic;
		 CLK: in std_logic;
		 slow_clk: in std_logic;
		 current_amp:  in std_logic;
		 n_param:  out std_logic_vector(8 downto 0);
		 charend: out std_logic 
		  );
end entity;

architecture arc_f_finder_fin of f_finder_fin is
type state_type is (idle  ,first_seq, fall ,rise , fin, silent);
signal count_low: integer range 0 to 1000000 ;
signal count_high: integer range 0 to 1000000 ;
signal count_t :integer range 0 to 1000000;
signal per_num: integer range 0 to 70;
signal hush: std_logic;
signal n: integer range 0 to 300;
begin
	process(CLK,RESETN)
	variable state : state_type;
	variable countforsilent: integer range 0 to 50000000;
	variable count_tone :integer range 0 to 1000000;
	variable count_ttwo :integer range 0 to 1000000;
	begin
	 if (RESETN = '0') then
			count_low <= 0;
			count_high <=0;
			count_tone:=0;
			count_ttwo:=0;
			count_t <=0;
			per_num <=0;
			n<=0;
			countforsilent :=0;
            state := idle;
	elsif (rising_edge(CLK)) then
					case state is
						when idle=>
								count_low <= 0;
								count_high <=0;
								count_t <=0;
								count_tone:=0;
								count_ttwo:=0;
								per_num <=0;
								n<=0;
								if(current_amp='1') then
									state := idle ;
								end if;
								if(current_amp='0') then
									state := first_seq;
									countforsilent :=countforsilent+1;
								end if;
						when first_seq=>
							if(current_amp='1') then
									state := rise;
							end if;
							if(current_amp='0') then
									if(countforsilent=2500000) then
										state :=silent;
									end if;
									countforsilent :=countforsilent+1;
									state := first_seq;
							end if;
						when rise=>
							countforsilent :=0;
							if(current_amp='1') then
								count_high <=count_high+1;
								state := rise ;
							elsif(current_amp='0') then
								count_low <= 0;
								countforsilent :=countforsilent+1;
								state := fall;
							end if;
						when fall=>
							if(current_amp='1') then
								per_num <=per_num+1;
								if(per_num <=16) then
									count_tone:=count_tone+count_high+count_low;
									count_high<=0;
									count_low<=0;
									state := rise;
								else
									count_ttwo:=count_ttwo+count_high+count_low;
									if(per_num >=32) then
										if(count_ttwo=count_tone) then
											count_t<=count_tone;
											state := fin;
										else
											count_t<=count_ttwo;
											state := fin;
										end if;
									else
										count_high<=0;
										count_low<=0;
										state := rise;
									end if;
								end if;
							else
								count_low <=count_low+1;
								if(countforsilent=12500000) then
										state :=silent;
									end if;
								countforsilent :=countforsilent+1;
								state := fall;
							end if;
						when fin=>
							n <=count_t/4096;
							if(slow_clk='1') then
								state:=idle;
							end if;
						when silent=>
							hush<='1';
							if(slow_clk='1') then
								hush<='0';
							end if;
						end case;
				end if;
	end process;
	charend<=hush;
	n_param<=conv_std_logic_vector(n,9);
end arc_f_finder_fin;