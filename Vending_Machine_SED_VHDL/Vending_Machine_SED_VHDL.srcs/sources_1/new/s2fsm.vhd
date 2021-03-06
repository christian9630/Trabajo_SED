library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity s2fsm is
    Port (
    clk : in std_logic;
    reset : in std_logic;
    start : in std_logic;
    selection :  in std_logic_vector(3 downto 0);
    done : out std_logic;
    productslctr : out std_logic_vector(3 downto 0)
    );
end s2fsm;

architecture Behavioral of s2fsm is
    type states is (s0, s1, s2, s3, s4, s5);
    signal current_state : states := s0;
    signal next_state : states;
begin

    state_register : process (reset, clk) -- Proceso para el reset de la máquina de estados y el cambio de estado con el pulso de reloj
    begin 
        if reset = '0' then
            current_state <= s0;
        elsif rising_edge (clk) then
            current_state <= next_state;
        end if;
    end process;
    
    nextstate_decod : process (start, selection, current_state) -- Proceso que define las condiciones de cambio de estado
    begin
        next_state <= current_state;
            case current_state is
                when s0 => 
                if start = '1' then
                    next_state <= s1; 
                end if;
                when s1 => 
                if selection = "0001" then
                    next_state <= s2;
                end if; 
                if selection = "0010" then
                    next_state <= s3;
                end if;
                if selection = "0100" then
                    next_state <= s4;
                end if;
                if selection = "1000" then
                    next_state <= s5;
                end if;
                when s2 => 
                    next_state <= s0;
                when s3 => 
                    next_state <= s0;
                when s4 =>
                    next_state <= s0; 
                when s5 => 
                    next_state <= s0;  
                when others => 
                    next_state <= s0;
            end case;
    end process;
    
    output_decod : process (current_state, clk) --Proceso que define las salidas en función del estado actual
                                                
                                                
                                                 
    begin

    productslctr <= (others => '0');
    
    case current_state is 
                when s0 =>
                    done <= '0';
                when s1 => productslctr <= selection;
                when s2 =>
                    done <= '1';
                    productslctr <= selection;
                when s3 => 
                    done <= '1';
                    productslctr <= selection;
                when s4 =>  
                    done <= '1';
                    productslctr <= selection;
                when s5 =>
                    done <= '1';
                    productslctr <= selection;
                when others => 
            end case;
    end process;
end Behavioral;
