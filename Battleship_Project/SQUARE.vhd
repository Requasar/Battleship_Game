library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SQUARE is
    procedure SQ(
        SIGNAL Xcur, Ycur, Xpos, Ypos : IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    );      
end SQUARE;

package body SQUARE is
    procedure SQ(
        SIGNAL Xcur, Ycur, Xpos, Ypos: IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    ) is
    begin
        if (Xcur > Xpos and Xcur < (Xpos + 10) and Ycur > Ypos and Ycur < (Ypos + 10)) then
            RGB <= "1111";
            DRAW <= '1';
        else
            DRAW <= '0';
        end if;
    end SQ;
end SQUARE;
