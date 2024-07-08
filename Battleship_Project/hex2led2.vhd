LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY hex2led2 IS
	PORT (
		HEX : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		LED : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END hex2led2;

ARCHITECTURE Behavioral OF hex2led2 IS

	--HEX-to-seven-segment decoder
	-- HEX: in STD_LOGIC_VECTOR (3 downto 0);
	-- LED: out STD_LOGIC_VECTOR (6 downto 0);
	-- 
	--      0 
	--     ---   
	--  5 |   | 1 
	--     ---   <- 6 
	--  4 |   | 2 
	--     --- 
	--      3

BEGIN
	WITH HEX SELECT
	LED <= "1111001" WHEN "0001", --1
	       "0100100" WHEN "0010", --2
	       "0110000" WHEN "0011", --3
	       "0011001" WHEN "0100", --4
	       "0010010" WHEN "0101", --5
	       "0000010" WHEN "0110", --6
	       "1111000" WHEN "0111", --7
	       "0000000" WHEN "1000", --8
	       "0010000" WHEN "1001", --9
	       "0001000" WHEN "1010", --A
	       "0000011" WHEN "1011", --b
	       "1000110" WHEN "1100", --C
	       "0100001" WHEN "1101", --d
	       "0000110" WHEN "1110", --E
	       "0001110" WHEN "1111", --F
	       "1000000" WHEN OTHERS; --0
 

END Behavioral;