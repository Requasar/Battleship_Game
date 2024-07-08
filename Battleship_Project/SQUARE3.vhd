library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SQUARE3 is
    procedure SQ3(
        SIGNAL Xcur, Ycur, Xpos, Ypos : IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    );      
end SQUARE3;

package body SQUARE3 is
    procedure SQ3(
        SIGNAL Xcur, Ycur, Xpos, Ypos: IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    ) is
    begin
        if (Xcur > Xpos and Xcur < (Xpos + 36) and Ycur > Ypos and Ycur < (Ypos + 36)) then
            RGB <= "1111";
            DRAW <= '1';
        else
            DRAW <= '0';
        end if;
    end SQ3;
end SQUARE3;
