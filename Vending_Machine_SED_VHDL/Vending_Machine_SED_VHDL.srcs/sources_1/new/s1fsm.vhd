library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity s1fsm is
    Port (
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
end s1fsm;

architecture Behavioral of s1fsm is
    type states is (s0, s0b, s1, s2, s3);
    signal current_state : states := s0;
    signal next_state : states;
begin

    state_register : process (reset, clk)
    begin 
        if reset = '0' then
            current_state <= s0b;
        elsif rising_edge (clk) then
            current_state <= next_state;
        end if;
    end process;
    
    nextstate_decod : process (start, count_counter, current_state)
    begin
        next_state <= current_state;
            case current_state is
                when s0 => if start = '1' then
                next_state <= s1; end if;
                when s0b => next_state <= s0;
                when s1 => if count_counter = "01010" then
                next_state <= s2; end if;
                           if count_counter > "01010" then
                next_state <= s3; end if;
                when s2 => next_state <= s0;
                when s3 => next_state <= s0; 
                when others => next_state <= s0;
            end case;
    end process;
    
    output_decod : process (current_state, clk) -- Ponemos clk, para enviar señales
                                                -- como el reset, durante un ciclo
                                                -- solamente, y para que se actualice 
                                                -- la cuenta según cambia. 
    begin
    --ponemos a cero las salidas
    error <= '0'; done <= '0'; code <= "0000";
    reset_counter <= '1'; coin_100_counter <= '0';
    coin_50_counter <= '0';  coin_20_counter <= '0';
    coin_10_counter <= '0';
    case current_state is 
                when s0 =>
                when s0b => reset_counter <= '0';
                when s1 => code <= count_counter(3 downto 0); -- 5 bits a 4 bits, como se asigna?
                           coin_100_counter <= coin_100;
                           coin_50_counter <= coin_50;
                           coin_20_counter <= coin_20;
                           coin_10_counter <= coin_10;
                when s2 => done <= '1'; 
                           reset_counter <= '0';
                when s3 => error <= '1';
                           reset_counter <= '0';
                when others => 
            end case;
    end process;
end Behavioral;
