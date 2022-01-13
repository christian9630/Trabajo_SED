library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder is
port(
    clk : in std_logic;
    code : in std_logic_vector(3 downto 0);
    display : out std_logic_vector(6 downto 0);
    current_display : out std_logic_vector(7 downto 0)
);
end decoder;

architecture Behavioral of Decoder is

    constant max_refresh_count: INTEGER := 100000; 
    signal refresh_count: INTEGER range 0 to max_refresh_count;
    signal refresh_state: STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal display_sel: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
begin

current_display <= display_sel;

gen_clock: process(clk)

begin
  
    if clk'event and clk='1' then
        if refresh_count < max_refresh_count then
            refresh_count <= refresh_count + 1;
        else
            refresh_state <= refresh_state + 1;
            refresh_count <= 0; 
        end if; 
    end if; 
end process;
    
show_display: process(refresh_state, code)
 
begin

case refresh_state is 
    when "000" => 
        display_sel <= "11111110"; -- Display 0 
    when "001" => 
        display_sel <= "11111101"; -- Display 1 
    when "010" => 
        display_sel <= "11111011"; -- Display 2 
    when "011" => 
        display_sel <= "11110111"; -- Display 3 
    when "100" => 
        display_sel <= "11101111"; -- Display 4 
    when "101" => 
        display_sel <= "11011111"; -- Display 5 
    when "110" => 
        display_sel <= "10111111"; -- Display 6 
    when "111" => 
        display_sel <= "01111111"; -- Display 7 
    when others => 
        display_sel <= "11111111"; 
end case;

case code is
    when "0000"=> -- 
        case display_sel is 
            when "11111110" => 
                display <= "1110000"; 
            when "11111101" => 
                display <= "1111010";
            when "11111011" => 
                display <= "0110000";
            when "11110111" => 
                display <= "0100100"; 
            when "11101111" => 
                display <= "1101010"; 
            when "11011111" => 
                display <= "1001111";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "0110000"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "0001"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "1001111";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "0010"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0010010";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";  
        end case;
    when "0011"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0000110";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";
        end case;
    when "0100"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "1001100";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "0101"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0100100";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";  
        end case;
    when "0110"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0100000";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";  
        end case;
    when "0111"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0001111";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";  
        end case;
    when "1000"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0000000";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";  
        end case;
    when "1001"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0000100";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111";   
        end case;
    when "1010"=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "0110000";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "1111111"; 
            when "11101111" => 
                display <= "0000001"; 
            when "11011111" => 
                display <= "0000001";
            when "10111111" => 
                display <= "1001111";
            when "01111111" => 
                display <= "1110000"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "1011"=>
        case display_sel is 
            when "11111110" => 
                display <= "0011000"; 
            when "11111101" => 
                display <= "1111111";
            when "11111011" => 
                display <= "0000010";
            when "11110111" => 
                display <= "1000011"; 
            when "11101111" => 
                display <= "1001111"; 
            when "11011111" => 
                display <= "1110001";
            when "10111111" => 
                display <= "0110000";
            when "01111111" => 
                display <= "1111010"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "1100"=>
        case display_sel is 
            when "11111110" => 
                display <= "1100010"; 
            when "11111101" => 
                display <= "1111010";
            when "11111011" => 
                display <= "1111010";
            when "11110111" => 
                display <= "0110000"; 
            when "11101111" => 
                display <= "1111111"; 
            when "11011111" => 
                display <= "1111111";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1111010"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "1101"=>
        case display_sel is 
            when "11111110" => 
                display <= "0000010"; 
            when "11111101" => 
                display <= "1001111";
            when "11111011" => 
                display <= "1110010";
            when "11110111" => 
                display <= "0000010"; 
            when "11101111" => 
                display <= "1111010"; 
            when "11011111" => 
                display <= "0100001";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "0100100"; 
            when others =>
                display <= "1111111"; 
        end case;
    when "1110"=>
        case display_sel is 
            when "11111110" => 
                display <= "0000010"; 
            when "11111101" => 
                display <= "1110001";
            when "11111011" => 
                display <= "0110000";
            when "11110111" => 
                display <= "1110010"; 
            when "11101111" => 
                display <= "1101010"; 
            when "11011111" => 
                display <= "0000010";
            when "10111111" => 
                display <= "0110001";
            when "01111111" => 
                display <= "1111010"; 
            when others =>
                display <= "1111111"; 
        end case;
    when others=>
        case display_sel is 
            when "11111110" => 
                display <= "1101010"; 
            when "11111101" => 
                display <= "1100011";
            when "11111011" => 
                display <= "0111000";
            when "11110111" => 
                display <= "1111111";
            when "11101111" => 
                display <= "1100010";
            when "11011111" => 
                display <= "1101010";
            when "10111111" => 
                display <= "1111111";
            when "01111111" => 
                display <= "1110010";
            when others =>
                display <= "1111111"; 
        end case;
end case;

end process;

end Behavioral;
