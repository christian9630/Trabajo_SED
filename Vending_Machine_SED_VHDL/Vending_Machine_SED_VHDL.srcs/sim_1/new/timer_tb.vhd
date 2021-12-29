library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer_tb is
--  Port ( );
end Timer_tb;

architecture Behavioral of Timer_tb is
    component Timer 
    port (
            clk : in std_logic;
            reset : in std_logic;
            start : in std_logic;
            data : in integer;
            count : out integer;
            done : out std_logic
    );
    end component;
 
signal clk, start, reset, done : std_logic;
signal data, count : integer; -- counter : integer;

constant TbPeriod : time := 10 ns; -- periodo de clk
signal TbClock : std_logic := '0';
signal TbSimEnded : std_logic := '0';
    
begin
    uut: Timer port map (
        clk => clk, 
        reset => reset,
        start => start, 
        data => data,
        count => count,
        done => done
        );
   
   -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
   
    tb : process
        begin
        start <= '0';  reset <= '1'; data <= 0;-- Valores iniciales
        wait for 10*TbPeriod;
        
        start <= '1'; data <= 9;
        --49999999 es medio segundo; data = 299999999 para 3 segundos
        -- tiempo deseado = (data+1)/frecuencia
        wait for 2*TbPeriod;
        start <= '0'; 
        
        assert count = data
        report "funcionamiento incorrecto. "
        severity failure;
        
        wait for 19*TbPeriod; 
        
        assert done = '1'
        report "funcionamiento incorrecto. "
        severity failure;
        
        reset <= '0';
        wait for 1*TbPeriod;
        reset <= '1';
        wait for 9*TbPeriod;
        
        assert count = 0
        report "funcionamiento incorrecto. "
        severity failure;
        
        assert done = '0'
        report "funcionamiento incorrecto. "
        severity failure;
        
        data <= 0;
        wait for 10*TbPeriod;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait for 10 * TbPeriod;
        
        assert false
        report "Simulacion superada. Test finalizado. "
        severity failure;
        
    end process;
end Behavioral;