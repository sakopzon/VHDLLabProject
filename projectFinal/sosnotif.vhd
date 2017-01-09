library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
USE ieee.numeric_std.ALL;


entity sosnotif is
	port ( 	clk:	in 	std_logic;
		resetN:		in 	std_logic;
		lcddata:  	in	std_logic_vector(7 downto 0);
		ena:			in 	std_logic;
		shine: out std_logic_vector(17 downto 0)
);
end sosnotif;

architecture arc_sosnotif of sosnotif is 
  type state_type is (idle,prespace ,sone, hone ,dione,oo, eee, uuu, dtwo, ell); --enumerated type for state machine
  signal tmp: std_logic_vector (7 downto 0);
	begin
    process (clk, resetN)
		variable state : state_type;
		variable outtmp: std_logic_vector(17 downto 0);
    begin
        if (resetN = '0') then
            state := idle;
			tmp <= "00000000";
			outtmp :="000000000000000000";
       elsif (rising_edge(clk)) then
				tmp <=lcddata;
				if(ena='1') then
					outtmp :="000000000000000000";
						case state is
							when idle=>
								outtmp:="000000000000000000";
								if(tmp="11100100") then
									state := prespace;
								else
									state :=idle;
								end if;
							when prespace=>
								if(tmp="00000011") then
									state := sone;
								elsif(tmp="00000100") then
									state := hone;
								elsif(tmp="10000011") then
									state := dione;
								else
									state :=idle;
								end if;
					--1ST CHAR-----
							when sone=>
								if(tmp="11100011") then
									state := oo;
								else
									state :=idle;
								end if;
							when hone=>
								if(tmp="00000001") then
									state := eee;
								else
									state :=idle;
								end if;
							when dione=>
								if(tmp="00100011") then
									state := uuu;
								else
									state :=idle;
								end if;
					--2ND CHAR-----	
							when oo =>
								if(tmp="00000011") then
									outtmp :="000000111111111111";
									state := idle;
								else
									state :=idle;
								end if;
							when eee =>
								if(tmp="01000100") then
									state := ell;
								else
									state :=idle;
								end if;
							when uuu=>
								if(tmp="10000011") then
									state := dtwo;
								else
									state :=idle;
								end if;
						--3RD CHAR----
							when ell =>
								if(tmp="01100100") then
									 outtmp :="000000000000111111";
									state := idle;
								else
									state :=idle;
								end if;
							when dtwo=>
								if(tmp="10110100") then
									outtmp :="111111111111111111";
								else
									state :=idle;
								end if;
						end case;
					else
					outtmp :=outtmp;
				end if;
        end if;
        shine <=outtmp;
    end process;
end arc_sosnotif ; 