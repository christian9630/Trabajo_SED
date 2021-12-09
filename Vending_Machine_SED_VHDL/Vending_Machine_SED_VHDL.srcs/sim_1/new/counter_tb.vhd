library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is
    component counter 
    port (
    clk : in std_logic;
    reset : in std_logic;
    add_100 : in std_logic;
    add_50 : in std_logic;
    add_20 : in std_logic;
    add_10 : in std_logic;
    count: out std_logic_vector(4 downto 0)
    );
    end component;
 
signal clk, reset : std_logic;
signal add_100, add_50, add_20, add_10 : std_logic;
signal count : std_logic_vector (4 downto 0);

constant TbPeriod : time := 10 ns; -- periodo de clk
signal TbClock : std_logic := '0';
signal TbSimEnded : std_logic := '0';


begin
    uut: counter port map (
        clk => clk,
        reset => reset,
        add_100 => add_100,
        add_50 => add_50,
        add_20 => add_20,
        add_10 => add_10,
        count => count);
        
        
   -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
   
    tb : process
    begin
        reset <= '1'; add_100 <= '0'; add_50 <= '0'; add_20 <= '0'; add_10 <= '0'; -- Valores iniciales
        wait for 10*TbPeriod;
        
        add_10 <= '1';  -- Llega la señal del botón de 10 céntimos
        wait for TbPeriod;
        add_10 <= '0'; 
        wait for 4*TbPeriod;
        
        assert count = "00001"
        report "Funcionamiento incorrecto. "
        severity failure;
        
        add_20 <= '1'; -- Llega la señal del botón de 20 céntimos
        wait for TbPeriod;
        add_20 <= '0';
        wait for 4*TbPeriod;
        
        assert count = "00011"
        report "Funcionamiento incorrecto. "
        severity failure;
        
        add_50 <= '1'; -- Llega la señal del botón de 50 céntimos
        wait for TbPeriod;
        add_50 <= '0';
        wait for 4*TbPeriod;
        
        assert count = "01000"
        report "Funcionamiento incorrecto. "
        severity failure;
        
        add_100 <= '1'; -- Llega la señal del botón de 1 euro
        wait for TbPeriod;
        add_100 <= '0';
        wait for 4*TbPeriod;
        
        assert count = "10010"
        report "Funcionamiento incorrecto. "
        severity failure;
        
        reset <= '0'; -- Se hace reset al contador
        wait for TbPeriod;
        reset <= '1';
        wait for 4*TbPeriod;
        
        assert count = "00000"
        report "Funcionamiento incorrecto. "
        severity failure;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait for 10 * TbPeriod;
        
        assert false
        report "Simulacion superada. Test finalizado. "
        severity failure;
        
    end process;
end Behavioral;