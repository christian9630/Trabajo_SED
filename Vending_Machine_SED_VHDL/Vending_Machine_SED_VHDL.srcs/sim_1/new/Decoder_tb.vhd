library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is

    component Decoder
        port (CLK             : in std_logic;
              code            : in std_logic_vector (3 downto 0);
              display         : out std_logic_vector (6 downto 0);
              current_display : out std_logic_vector (7 downto 0));
    end component;

    signal CLK             : std_logic;
    signal code            : std_logic_vector (3 downto 0);
    signal display         : std_logic_vector (6 downto 0);
    signal current_display : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Decoder
    port map (CLK             => CLK,
              code            => code,
              display         => display,
              current_display => current_display);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- Initialization
        code <= (others => '0');

        -- Stimuli
        FOR i in 0 to 15 LOOP
        wait for 1000000*TbPeriod; -- es necesario simular 160 milisegundos para verlo bien
        code <= code + 1;
        end LOOP;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;
    
end Behavioral;