library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
ENTITY sign2bin IS
	PORT( signed_int : in std_logic_vector (7 downto 0);
	 	binary_offset : out std_logic_vector (7 downto 0));
end entity;
architecture arc2 of sign2bin is 
	begin binary_offset <= not(signed_int(7)) & signed_int(6 downto 0);
END arc2 ;
