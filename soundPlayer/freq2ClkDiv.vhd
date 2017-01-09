--------------------------------------
-- In : frequency in Hz
-- Out: Divide factor for clock divider
-- Author: Alrxander Kopzon
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq2ClkDiv is
port(
  CLK     : in  std_logic;
  RESET_N : in  std_logic;
  ENA     : in  std_logic;
  FREQ    : in  STD_LOGIC_VECTOR(13 downto 0);
  Div     : out integer range 0 to 500
);
end freq2ClkDiv;

architecture arch of freq2ClkDiv is

constant MAX_FREQ : integer := 2048;

signal freq_integer : integer range 0 to MAX_FREQ;

constant C   : integer := 1046;
constant C_d : integer := 1108;
constant D   : integer := 1175;
constant D_d : integer := 1245;
constant E   : integer := 1319;
constant F   : integer := 1397;
constant F_d : integer := 1480;
constant G   : integer := 1568;
constant G_d : integer := 1661;
constant A   : integer := 1760;
constant A_d : integer := 1867;
constant B   : integer := 1976;

-- TODO: second octava

begin
  
  freq_integer <= to_integer(unsigned(FREQ));

  SinTableTC_proc: process(RESET_N, CLK)
  begin
    if (RESET_N='0') then
      Div <= 1;
    elsif(rising_edge(CLK)) then
      if (ENA='1') then
		case freq_integer is
			when C    => Div <= 187;
			when C_d  => Div <= 176;
			when D    => Div <= 166;
			when D_d  => Div <= 157;
			when E    => Div <= 148;
			when F    => Div <= 140;
			when F_d  => Div <= 132;
			when G    => Div <= 125;
			when G_d  => Div <= 118;
			when A    => Div <= 111;
			when A_d  => Div <= 105;
			when B    => Div <= 99;
			when others => Div <= 20;
			-- TODO : second octava
		end case;
      end if;
    end if;
  end process;
end arch;