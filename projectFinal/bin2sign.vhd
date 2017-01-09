library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
ENTITY bin2sign IS
	PORT( binary_offset : in std_logic_vector (7 downto 0);
		 signed_int : out std_logic_vector (7 downto 0));
end entity;
architecture arc1 of bin2sign is
	begin
	signed_int <= not(binary_offset(7)) & binary_offset(6 downto 0);
END arc1 ;
