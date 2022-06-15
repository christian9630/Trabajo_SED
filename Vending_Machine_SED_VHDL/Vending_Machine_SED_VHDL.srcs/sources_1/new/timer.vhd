
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer is
    port(
    clk : in std_logic;                         -- Clock
    working : in std_logic;
    reset: in std_logic;
    ---CE  : in std_logic;                         -- Chip Enable
    ---code: out std_logic_vector(9 downto 0);      -- Valor de 0 a 9
    done : out std_logic
    );
end timer;

architecture Behavioral of timer is
signal cnt : std_logic_vector(16 downto 0) := "00000000000000000";
---signal donesignal : std_logic := '0';
signal segundos : integer;
begin
process (clk)
begin
done <= '0';
    if (reset = '0') then
        cnt <= "00000000000000000";
        segundos <= 0;
        --done <= '0';
    elsif rising_edge(clk) then
        if (working = '1') then
            if (cnt = "11000011010100000") then ---hasta 1 segundo debería contar
                cnt <= "00000000000000000";
                ---donesignal <= NOT(donesignal);
                segundos <= segundos + 1;
            else
                -- code debe aumentar en 1 unidad
                cnt <= cnt + 1;
            end if;
    end if;
    end if;
    
--    if (segundos = 0) then code <= "0000000000";
--    elsif (segundos = 1) then code <= "0000000001";
--    elsif (segundos = 2) then code <= "0000000011";
      if (segundos = 3) then --code <= "0000000111"; 
      done <= '1'; 
      end if; 
--    elsif (segundos = 4) then code <= "0000001111";
--    elsif (segundos = 5) then code <= "0000011111";
--    elsif (segundos = 6) then code <= "0000111111";
--    elsif (segundos = 7) then code <= "0001111111";
--    elsif (segundos = 8) then code <= "0011111111";
--    elsif (segundos = 9) then code <= "0111111111";
--    elsif (segundos = 10) then code <= "1111111111";
--    else code <= "0000000000"; end if;
end process;
end Behavioral;
