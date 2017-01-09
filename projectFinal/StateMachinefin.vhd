library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;


entity StateMachinefin is
	port ( 	clk:	in 	std_logic;
			slow_clk:in std_logic;
		resetN:		in 	std_logic;
		enqueue:		in 	std_logic;
		morse_code:  	in	std_logic_vector(7 downto 0);
		chosen_f: out std_logic_vector(2 downto 0);
		en_trans : out std_logic
);
end StateMachinefin;

architecture arc_StateMachinefin of StateMachinefin is 
  type state_type is (idle, kav ,dot , space); --enumerated type for state machine
	signal morsecnt: integer range 0 to 7 ;
	signal out_tmp: std_logic_vector (2 downto 0);
	signal dynamlenght : integer range 0 to 7;
	begin
    process (clk, resetN, enqueue)
		variable state : state_type;
		variable lenght_bin: std_logic_vector (2 downto 0);
		variable tmp: std_logic_vector (7 downto 0);
		variable out_trans: std_logic;
    begin
        if (resetN = '0' or enqueue='0') then
			out_trans :='0';
            state := idle;
			tmp := "00000000";
			morsecnt <= 0;
       elsif (rising_edge(clk)) then
				if(slow_clk='1') then
				-- Determine the next state synchronously, based on
				-- the current state and the input
					out_tmp <="100";
					tmp :=morse_code;
					lenght_bin :=morse_code(2)&morse_code(1)&morse_code(0);
					dynamlenght <= conv_integer(lenght_bin)-1;
					morsecnt <= 0;
					out_trans :='0';
					case state is
						when idle=>
								morsecnt <= 0;
								out_trans :='0';
								if(tmp(7)='1') then
									state := kav ;
									morsecnt <=0;
								end if;
								if(tmp(7)='0') then
									state := dot ;
									morsecnt <=0;
								end if;
						when kav=>
							out_trans :='1';
							if(out_tmp="000")then
									out_tmp <="001";
								else
									out_tmp <="000";
								end if;
							if (tmp(6-morsecnt)='1' and dynamlenght>0) then
								state :=kav;
								dynamlenght <= dynamlenght-1;
								morsecnt <= morsecnt+1;
							elsif(tmp(6-morsecnt)='0' and dynamlenght>0) then
								state :=dot;
								dynamlenght <= dynamlenght-1;
								morsecnt <= morsecnt+1;
							elsif(dynamlenght=0) then
								state := space;
							end if;
						when dot =>
							out_trans :='1';
							if(out_tmp="010")then
									out_tmp <="011";
								else
									out_tmp <="010";
								end if;
							if(tmp(6-morsecnt)='0'and dynamlenght>0) then
								state :=dot;
								dynamlenght <= dynamlenght-1;
								morsecnt <= morsecnt+1;
							elsif (tmp(6-morsecnt)='1' and dynamlenght>0) then
								state :=kav;
								dynamlenght <= dynamlenght-1;
								morsecnt <= morsecnt+1;
							elsif(dynamlenght=0) then
								state := space;
							end if;
						when space => 
							tmp := "00000000";
							out_trans :='0';
							state:=idle;
					end case;
				end if;
        end if;
   en_trans<= out_trans;
    end process;
    chosen_f <=out_tmp;
end arc_StateMachinefin ; 
