-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

-- Copyright (C) 1991-2007 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.


-- Generated by Quartus II Version 7.1 (Build Build 178 06/25/2007)
-- Created on Sun Mar 22 10:14:51 2009

LIBRARY ieee;
USE ieee.std_logic_1164.all;


--  Entity Declaration

ENTITY Clk_Divider IS
	-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
--	GENERIC(Div : string:= 500; );
	
	-- We want to be an input!
	--GENERIC(Div : integer range 0 to 50000000);
	PORT
	(
		Clk_in : IN STD_LOGIC;
		Resetn : IN STD_LOGIC;
		Clk_out : OUT STD_LOGIC;
		Div : IN integer range 0 to 500
	);
	-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!
	
END Clk_Divider;


--  Architecture Body

ARCHITECTURE Clk_Divider_architecture OF Clk_Divider IS
	
	signal clk_in_sig	:	std_logic;
	signal clk_out_sig	:	std_logic;
	signal clk_div_param:	integer range 0 to 50000000;

	
BEGIN

	clk_in_sig		<=	Clk_in;

	process(clk_in_sig,Resetn)
		begin
			if (Resetn = '0') then
				clk_div_param	<=	Div;
			elsif (clk_in_sig = '1' and clk_in_sig'event) then
				if (clk_div_param = Div) then
					clk_div_param <= 0;
					clk_out_sig <= '1';
				else
					clk_div_param <= clk_div_param + 1;
					clk_out_sig <= '0';
				end if;
			end if;
	end process;
	
	Clk_out	<=	clk_out_sig;	
			

	

END Clk_Divider_architecture;
