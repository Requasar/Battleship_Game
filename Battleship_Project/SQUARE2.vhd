library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package SQUARE2 is
    procedure SQ2(
        SIGNAL Xcur, Ycur, Xpos, Ypos : IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    );
end SQUARE2;

package body SQUARE2 is
    procedure SQ2(
        SIGNAL Xcur, Ycur, Xpos, Ypos: IN INTEGER;
        SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        SIGNAL DRAW: OUT STD_LOGIC
    ) is
    begin
        -- Kontrol: Xcur ve Ycur, Xpos ve Ypos'tan 40 birim genişliğe kadar olan alanda mı?
        if (Xcur >= Xpos and Xcur < (Xpos + 40) and Ycur >= Ypos and Ycur < (Ypos + 40)) then
            -- Kontrol: İç çerçeve dışındaki alanlar mı?
            if (Xcur < (Xpos + 3) or Xcur >= (Xpos + 37) or Ycur < (Ypos + 3) or Ycur >= (Ypos + 37)) then
                RGB <= "1111"; -- Çerçeve rengini belirle
                DRAW <= '1';
            else
                DRAW <= '0';
            end if;
        else
            DRAW <= '0';
        end if;
    end SQ2;
end SQUARE2;