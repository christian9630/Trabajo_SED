library ieee;
use ieee.std_logic_1164.all;

entity VendingMachine_tb is
end VendingMachine_tb;

architecture Behavioral of VendingMachine_tb is

    component VendingMachine
        port (CLK     : in std_logic;
              RST     : in std_logic;
              BUTTON  : in std_logic_vector (4 downto 0);
              SW      : in std_logic_vector (3 downto 0);
              SEGMENT : out std_logic_vector (6 downto 0);
              AN      : out std_logic_vector (7 downto 0);
	          LED     : out std_logic_vector (6 downto 0));
    end component;

    signal CLK     : std_logic;
    signal RST     : std_logic;
    signal BUTTON  : std_logic_vector (4 downto 0);
    signal SW      : std_logic_vector (3 downto 0);
    signal SEGMENT : std_logic_vector (6 downto 0);
    signal AN      : std_logic_vector (7 downto 0);
    signal LED     : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : VendingMachine
    port map (CLK     => CLK,
              RST     => RST,
              BUTTON  => BUTTON,
              SW      => SW,
              SEGMENT => SEGMENT,
              AN      => AN,
	          LED     => LED);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
    BUTTON <= (others => '0');
	SW <= (others => '0');
	RST <= '1';

        -- EDIT Add stimuli here
    wait for 10ms;
    
	BUTTON <= "00001"; 	-- Se activa la máquina pulsando el botón de 10 céntimos
	wait for 2ms;
	BUTTON <= "00000";
	wait for 10ms;
	
	BUTTON <= "00010";	-- Se suma 20 céntimos
	wait for 2ms;
	BUTTON <= "00000"; 
	wait for 10 ms;
	
	BUTTON <= "00100";	-- Se suma 50 céntimos
	wait for 100 * TbPeriod;
	BUTTON <= "01000";	-- Se suma 1 euro para ver que pasa cuando se desborda la cantidad introducida
	wait for 5000ms;		-- Se espera 5 segundos ya que para que pase al estado inicial se necesitan 3 segundos
	BUTTON <= "01000"; 	-- Se vuelve a introducir 1 euro
	wait for 100 * TbPeriod;
	SW <= "0010";		-- Se selecciona un producto
	wait for 5000ms;		-- Se esperan 5 segundos para que vuelva al estado inicial
	BUTTON <= "00100";	-- Se vuelve a introducir 50 céntimos
	wait for 100 * TbPeriod;
	BUTTON <= "10000";	-- Se presiona el botón de cancelar
	wait for 5000ms;		-- Se esperan 5 segundo para que vuelva al estado inicial
	BUTTON <= "00010";	-- Se introducen 20 céntimos
	wait for 100 * TbPeriod;
	RST <= '0';		-- Se resetea la máquina
	wait for 100 * TbPeriod;
	RST <= '1';

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end Behavioral;