library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clock_Divider is
    port ( 
        clk      : in  std_logic;
        reset    : in  std_logic;
        clock_out: out std_logic
    );
end Clock_Divider;

architecture bhv of Clock_Divider is
    signal count: integer := 1;
    signal tmp  : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= 1;
            tmp <= '0';
        elsif rising_edge(clk) then
            if count = 75000 then
                tmp <= NOT tmp;
                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clock_out <= tmp;
end bhv;
