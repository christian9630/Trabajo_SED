
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchrnzr is
        Port (
            clk : in std_logic;
            async_bt10 : in std_logic;
            async_bt20 : in std_logic;
            async_bt50 : in std_logic;
            async_bt100 : in std_logic;
            sync_bt10_out : out std_logic;
            sync_bt20_out : out std_logic;
            sync_bt50_out : out std_logic;
            sync_bt100_out : out std_logic
         );
end synchrnzr;

architecture Behavioral of synchrnzr is
signal sreg10, sreg20, sreg50, sreg100 : std_logic_vector(1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
        sync_bt10_out <= sreg10(1); 
        sreg10 <= sreg10(0) & async_bt10; 
        sync_bt20_out <= sreg20(1); 
        sreg20 <= sreg20(0) & async_bt20;
        sync_bt50_out <= sreg50(1); 
        sreg50 <= sreg50(0) & async_bt50;
        sync_bt100_out <= sreg100(1); 
        sreg100 <= sreg100(0) & async_bt100;
        end if;
    end process;
end behavioral;
