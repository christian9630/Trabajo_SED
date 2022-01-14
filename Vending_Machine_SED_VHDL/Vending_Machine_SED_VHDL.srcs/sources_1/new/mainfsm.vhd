library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mainfsm is
    Port (
    clk : in std_logic;
    reset : in std_logic;
    cancel_in : in std_logic; 
    button_10_in : in std_logic;
    button_20_in : in std_logic;
    button_50_in : in std_logic;
    button_100_in : in std_logic;
    switches_in :  in std_logic_vector(3 downto 0);
    code_s1_in : in std_logic_vector(3 downto 0);
    done_s1_in : in std_logic;
    error_s1_in : in std_logic;
    productslctr_s2_in : in std_logic_vector(3 downto 0); 
    done_s2_in : in std_logic;
    done_timer_in : in std_logic;
    code_display_out : out std_logic_vector(3 downto 0);
    product_out : out std_logic_vector(3 downto 0);
    error_out : out std_logic;
    sold_out : out std_logic;
    recover_out : out std_logic;
    reset_s1_out : out std_logic;
    start_s1_out : out std_logic;
    coin_10_s1_out : out std_logic;
    coin_20_s1_out : out std_logic;
    coin_50_s1_out : out std_logic;
    coin_100_s1_out : out std_logic;
    reset_s2_out : out std_logic;
    start_s2_out : out std_logic;
    selection_s2_out : out std_logic_vector(3 downto 0);
    reset_timer_out : out std_logic;
    start_timer_out : out std_logic;
    data_timer_out : out integer
     );
end mainfsm;

architecture Behavioral of mainfsm is
    type states is (s0, s0b, s1, s2, s3, s4, s5);
    signal current_state : states := s0;
    signal next_state : states;
    signal product : std_logic_vector(3 downto 0); 
begin

    state_register : process (reset, clk)
    begin 
        if reset = '0' then
            current_state <= s0b;
        elsif rising_edge (clk) then
            current_state <= next_state;
        end if;
    end process;
    
    nextstate_decod : process (button_10_in, button_20_in, button_50_in, button_100_in, done_s1_in, 
                               error_s1_in, cancel_in, done_s2_in, done_timer_in)
    begin
        next_state <= current_state;
            case current_state is
                when s0 => if (button_10_in or button_20_in
                or button_50_in or button_100_in) = '1' then
                next_state <= s1; end if;
                when s0b => next_state <= s0;   
                when s1 => if done_s1_in = '1' then
                next_state <= s2; end if;
                           if error_s1_in = '1' then
                next_state <= s3; end if;
                           if cancel_in = '1' then
                next_state <= s5; end if;
                when s2 => if done_s2_in = '1' then
                next_state <= s4; end if;
                           if cancel_in = '1' then
                next_state <= s5; end if;
                when s3 => if done_timer_in = '1' then
                next_state <= s0b; end if;  
                when s4 => if done_timer_in = '1' then
                next_state <= s0b; end if; 
                when s5 => if done_timer_in = '1' then 
                next_state <= s0b; end if;
                when others => next_state <= s0;
            end case;
    end process;
    
     output_decod : process (current_state, clk) -- Ponemos clk, para que se actualice 
                                                 -- la cuenta según cambia. 
    begin
    --ponemos a cero las salidas
    code_display_out <= "0000"; product_out <= "0000"; error_out <= '0'; sold_out <= '0';
    recover_out <= '0'; reset_s1_out <= '1'; start_s1_out <= '0'; coin_10_s1_out <= '0';
    coin_20_s1_out <= '0'; coin_50_s1_out <= '0'; coin_100_s1_out <= '0';
    reset_s2_out <= '1'; start_s2_out <= '0'; selection_s2_out <= "0000";
    reset_timer_out <= '1'; start_timer_out <= '0'; data_timer_out <= 0; 
    case current_state is 
        when s0 => coin_10_s1_out <= button_10_in; -- Se han añadido estas líneas
                   coin_20_s1_out <= button_20_in; -- para que se cuente la primera
                   coin_50_s1_out <= button_50_in; -- moneda. 
                   coin_100_s1_out <= button_100_in;
        when s0b => reset_timer_out <= '0'; 
                    reset_s1_out <= '0';
                    reset_s2_out <= '0';
        when s1 => start_s1_out <= '1';
                   coin_10_s1_out <= button_10_in;
                   coin_20_s1_out <= button_20_in;
                   coin_50_s1_out <= button_50_in;
                   coin_100_s1_out <= button_100_in; 
                   code_display_out <= code_s1_in;
        when s2 => start_s2_out <= '1';
                   code_display_out <= "1011";
                   selection_s2_out <= switches_in;
                   product <= productslctr_s2_in;
        when s3 => code_display_out <= "1100";
                   error_out <= '1';
                   recover_out <= '1';
                   data_timer_out <= 299999999;
                   --data_timer_out <= 2999999; --solo para simulación
                   start_timer_out <= '1';
        when s4 => code_display_out <= "1101";
                   product_out <= product;
                   sold_out <= '1';
                   data_timer_out <= 299999999; 
                   --data_timer_out <= 2999999; -- solo para simulación
                   start_timer_out <= '1';
        when s5 => code_display_out <= "1110";
                   recover_out <= '1';
                   data_timer_out <= 299999999; 
                   --data_timer_out <= 2999999; --solo para simulación
                   start_timer_out <= '1';
        when others => 
        end case;
    end process;
end Behavioral;
