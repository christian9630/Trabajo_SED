library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
    Port ( 
        clk : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        data : in integer;
        counter : buffer integer;
        done : out std_logic
     );
end Timer;

architecture Behavioral of Timer is
    type state is (s0, s1, s2, s3);
    signal current_state, next_state : state;
    
begin

state_register : process (clk, reset)
    begin
    if reset = '0' then
        current_state <= s0;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process;

nextstate_decoder : process (current_state, start, counter)
begin
    next_state <= current_state;
    case current_state is
        when s0 => if start = '1' then --estado normal reseteado
        next_state <= s1; end if;
        when s1 => if counter /= 0 then --estado tomando valor
        next_state <= s2; end if;
        when s2 => if counter = 1 then --estado contando
        next_state <= s3; end if;
        when s3 =>  --estado cumplido 
        when others => next_state <= s0;
    end case;
end process;

output_decoder : process (current_state, clk) --ponemos clk, para que vaya contando aunque no cambie de estado
begin
--poner a cero salidas
    done <= '0';
    case current_state is
        when s0 => counter <= 0; done <= '0'; --estado normal reseteado
        when s1 => counter <= data; done <= '0';--estado tomando valor
        when s2 => if rising_edge(clk) then--estado contando
        counter <= counter - 1;
        end if;
        done <= '0';
        when s3 => done <= '1'; --estado cumplido 
        when others => done <= '0'; counter <= 0;
    end case;
end process;
end Behavioral;
