library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
    port(
    clk : in std_logic;
    reset : in std_logic;
    add_100 : in std_logic;
    add_50 : in std_logic;
    add_20 : in std_logic;
    add_10 : in std_logic;
    count: out std_logic_vector(4 downto 0)
    );
end counter;

architecture Behavioral of counter is
signal cnt : std_logic_vector(4 downto 0) := "00000";
begin
    process (clk, reset)
    begin
        if (reset = '0') then 
            cnt <= "00000";
        elsif rising_edge(clk) then
            if (add_100 = '1') then
                cnt <= cnt + 10; 
            end if;
            if (add_50 = '1') then
                cnt <= cnt + 5; 
            end if;
            if (add_20 = '1') then
                cnt <= cnt + 2;
            end if;
            if (add_10 = '1') then
                cnt <= cnt + 1; 
            end if;
        end if;
    end process;
    count <= cnt;
end Behavioral;
