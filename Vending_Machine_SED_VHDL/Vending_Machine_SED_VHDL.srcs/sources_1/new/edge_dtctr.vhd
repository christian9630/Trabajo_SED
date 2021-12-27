

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edgedtctr is
    Port ( 
        clk : in std_logic;
        sync_bt10_in : in std_logic;
        sync_bt20_in : in std_logic;
        sync_bt50_in : in std_logic;
        sync_bt100_in : in std_logic;
        edge_bt10 : out std_logic;
        edge_bt20 : out std_logic;
        edge_bt50 : out std_logic;
        edge_bt100 : out std_logic
    );
end edgedtctr;

architecture Behavioral of edgedtctr is
signal sreg10, sreg20, sreg50, sreg100 : std_logic_vector(2 downto 0);
begin
process(clk)
begin
    if rising_edge(clk) then
        sreg10 <= sreg10(1 downto 0) & sync_bt10_in;
        sreg20 <= sreg20(1 downto 0) & sync_bt20_in;
        sreg50 <= sreg50(1 downto 0) & sync_bt50_in;
        sreg100 <= sreg100(1 downto 0) & sync_bt100_in;
    end if;
end process;

with sreg10 select 
    edge_bt10 <= '1' when "100",
    '0' when others;
with sreg20 select 
    edge_bt20 <= '1' when "100",
    '0' when others;
with sreg50 select 
    edge_bt50 <= '1' when "100",
    '0' when others;
with sreg100 select 
    edge_bt100 <= '1' when "100",
    '0' when others;
end Behavioral;

