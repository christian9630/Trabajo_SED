library ieee;
use ieee.std_logic_1164.all;

entity s2fsm_tb is
end s2fsm_tb;

architecture Behavioral of s2fsm_tb is

    component s2fsm
        port (clk          : in std_logic;
              reset        : in std_logic;
              start        : in std_logic;
              selection    : in std_logic_vector (3 downto 0);
              done         : out std_logic;
              productslctr : out std_logic_vector (3 downto 0));
    end component;

    signal clk          : std_logic;
    signal reset        : std_logic;
    signal start        : std_logic;
    signal selection    : std_logic_vector (3 downto 0);
    signal done         : std_logic;
    signal productslctr : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : s2fsm
    port map (clk          => clk,
              reset        => reset,
              start        => start,
              selection    => selection,
              done         => done,
              productslctr => productslctr);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- Initialization
        start <= '0';
        selection <= (others => '0');
        
        -- Stimuli
        wait for TbPeriod;
        reset <= '1';
        start <= '1';
        wait for TbPeriod;
        selection <= "0001";
        wait for TbPeriod;
        reset <= '0';
        wait for TbPeriod;
        reset <= '1';
        start <= '1';
        wait for TbPeriod;
        selection <= "0010";
        wait for TbPeriod;
        reset <= '0';
        wait for TbPeriod;
        reset <= '1';
        start <= '1';
        wait for TbPeriod;
        selection <= "0100";
        wait for TbPeriod;
        reset <= '0';
        wait for TbPeriod;
        reset <= '1';
        start <= '1';
        wait for TbPeriod;
        selection <= "1000";
        wait for TbPeriod;
        reset <= '0';
        wait for TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end Behavioral;
