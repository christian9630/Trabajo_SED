
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer is
    port(
    clk : in std_logic;                         -- Clock
    working : in std_logic;
    reset: in std_logic;
    data: in integer;
    done : out std_logic
    );
end timer;

architecture Behavioral of timer is
signal cnt : std_logic_vector(16 downto 0) := "00000000000000000";
signal segundos : integer;
begin
process (clk)
begin
done <= '0';
    if (reset = '0') then
        cnt <= "00000000000000000";
        segundos <= 0;
    elsif rising_edge(clk) then
        if (working = '1') then
            if (cnt = "11000011010100000") then ---hasta 1 segundo debería contar
                cnt <= "00000000000000000";
                segundos <= segundos + 1;
            else
                -- debe aumentar en 1 unidad
                cnt <= cnt + 1;
            end if;
    end if;
    end if;
    
      if (segundos = data) then  
        done <= '1'; 
      end if; 
end process;
end Behavioral;
