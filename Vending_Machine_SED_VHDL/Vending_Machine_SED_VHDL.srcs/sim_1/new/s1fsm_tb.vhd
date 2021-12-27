library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity s1fsm_tb is
--  Port ( );
end s1fsm_tb;

architecture Behavioral of s1fsm_tb is
    component s1fsm 
    port (
        clk : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        coin_100 : in std_logic;
        coin_50 : in std_logic;
        coin_20 : in std_logic;
        coin_10 : in std_logic;
        count_counter :  in std_logic_vector(4 downto 0);
        error : out std_logic;
        done : out std_logic;
        code : out std_logic_vector(3 downto 0);
        reset_counter : out std_logic;
        coin_100_counter : out std_logic;
        coin_50_counter : out std_logic;
        coin_20_counter : out std_logic;
        coin_10_counter : out std_logic
    );
    end component;
 
signal clk, start, reset, done, error : std_logic;
signal coin_100, coin_50, coin_20, coin_10 : std_logic;
signal count_counter : std_logic_vector(4 downto 0);
signal code : std_logic_vector(3 downto 0);
signal reset_counter, coin_100_counter : std_logic;
signal coin_50_counter, coin_20_counter : std_logic;
signal coin_10_counter : std_logic;



constant TbPeriod : time := 10 ns; -- periodo de clk
signal TbClock : std_logic := '0';
signal TbSimEnded : std_logic := '0';

    
begin
    uut: s1fsm port map (
        clk => clk,
        reset => reset,
        start => start, 
        coin_100 => coin_100, 
        coin_50 => coin_50,
        coin_20 => coin_20, 
        coin_10 => coin_10, 
        count_counter => count_counter, 
        error => error,
        done => done,
        code => code,
        reset_counter => reset_counter, 
        coin_100_counter => coin_100_counter, 
        coin_50_counter => coin_50_counter, 
        coin_20_counter => coin_20_counter, 
        coin_10_counter => coin_10_counter
        );
   
   -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
   
    tb : process
        begin
        start <= '0';  reset <= '1'; -- Valores iniciales
        coin_100 <= '0'; coin_50 <= '0'; 
        coin_20 <= '0'; coin_10 <= '0';
        count_counter <= "00000";
        wait for 10*TbPeriod;
        
        coin_10 <= '1'; 
        wait for TbPeriod;
        coin_10 <= '0'; 
        wait for 4*TbPeriod;
        
        start <= '1'; 
        wait for TbPeriod;
        start <= '0'; 
        wait for 4*TbPeriod;
        
        coin_10 <= '1'; 
        wait for TbPeriod;
        count_counter <= "00001";
        coin_10 <= '0'; 
        wait for 4*TbPeriod;
        
        assert code = "0001"
        report "funcionamiento incorrecto. "
        severity failure;
        
        coin_20 <= '1'; 
        wait for TbPeriod;
        count_counter <= "00011";
        coin_20 <= '0'; 
        wait for 4*TbPeriod;
        
        assert code = "0011"
        report "funcionamiento incorrecto. "
        severity failure;
        
        reset <= '0'; 
        count_counter <= "00000";
        wait for TbPeriod;
        reset <= '1'; 
        wait for 19*TbPeriod;
        
        start <= '1';
        coin_100 <= '1'; 
        wait for TbPeriod;
        count_counter <= "01010";
        coin_100 <= '0'; 
        start <= '0';
        wait for TbPeriod;
        assert done = '1'
        report "funcionamiento incorrecto. "
        severity failure;
        count_counter <= "00000";
        wait for 18*TbPeriod;
        
        start <= '1';
        coin_50 <= '1'; 
        wait for TbPeriod;
        count_counter <= "00101";
        coin_50 <= '0'; 
        start <= '0';
        wait for 4*TbPeriod;
        
        coin_100 <= '1'; 
        wait for TbPeriod;
        count_counter <= "01111";
        coin_100 <= '0'; 
        wait for TbPeriod;
        assert error = '1'
        report "funcionamiento incorrecto. "
        severity failure;
        count_counter <= "00000";
        wait for 18*TbPeriod;
        
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait for 10 * TbPeriod;
        
        assert false
        report "Simulacion superada. Test finalizado. "
        severity failure;
        
    end process;
end Behavioral;