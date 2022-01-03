library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VendingMachine is
	port(
		CLK : in std_logic;
		RST : in std_logic;
        BUTTON : in std_logic_vector(4 downto 0);
        SW : in std_logic_vector(3 downto 0);
        SEGMENT : out std_logic_vector(6 downto 0);
        AN : out std_logic_vector(7 downto 0);
		LED : out std_logic_vector(6 downto 0)
	);
end VendingMachine;


architecture Behavioral of VendingMachine is

	COMPONENT synchrnzr
		port (
			clk : in std_logic;
			async_bt10 : in std_logic;
            async_bt20 : in std_logic;
            async_bt50 : in std_logic;
            async_bt100 : in std_logic;
            async_cancel : in std_logic;
            sync_bt10_out : out std_logic;
            sync_bt20_out : out std_logic;
            sync_bt50_out : out std_logic;
            sync_bt100_out : out std_logic;
            sync_cancel_out : out std_logic
		);
	END COMPONENT;

	COMPONENT edgedtctr
		port(
			clk : in std_logic;
        	sync_bt10_in : in std_logic;
            sync_bt20_in : in std_logic;
            sync_bt50_in : in std_logic;
            sync_bt100_in : in std_logic;
            sync_cancel_in : in std_logic;
            edge_bt10 : out std_logic;
            edge_bt20 : out std_logic;
            edge_bt50 : out std_logic;
            edge_bt100 : out std_logic;
            edge_cancel : out std_logic
		);
	END COMPONENT;

	COMPONENT timer 
		port(
			clk : in std_logic;
            reset : in std_logic;
            start : in std_logic;
            data : in integer;
            count : out integer;
            done : out std_logic
		);
	END COMPONENT;

	COMPONENT s1fsm
		port(
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
	END COMPONENT;

	COMPONENT s2fsm
		port(
			clk : in std_logic;
    		reset : in std_logic;
    		start : in std_logic;
    		selection :  in std_logic_vector(3 downto 0);
    		done : out std_logic;
			productslctr : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT counter
		port(
			clk : in std_logic;
    		reset : in std_logic;
    		add_100 : in std_logic;
    		add_50 : in std_logic;
    		add_20 : in std_logic;
    		add_10 : in std_logic;
    		count: out std_logic_vector(4 downto 0)
		);
	END COMPONENT;

	COMPONENT decoder
		port(
			clk : in std_logic;
   			code : in std_logic_vector(3 downto 0);
    		display : out std_logic_vector(6 downto 0);
    		current_display : out std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT mainfsm
		port(
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
	END COMPONENT;

	signal sync_in: std_logic_vector(4 downto 0);
	signal edge_out: std_logic_vector(4 downto 0);

	signal reset_timer: std_logic;
	signal start_timer: std_logic;
	signal done_timer: std_logic;
	signal data_timer: INTEGER;

	signal reset_s1: std_logic;
	signal start_s1: std_logic;
	signal done_s1: std_logic;
	signal code_s1: std_logic_vector(3 downto 0);
	signal error_s1: std_logic;
	signal coin_s1: std_logic_vector(3 downto 0);

	signal reset_counter: std_logic;
	signal count_counter: std_logic_vector(4 downto 0);
	signal coin_counter: std_logic_vector(3 downto 0);

	signal reset_s2: std_logic;
	signal start_s2: std_logic;
	signal done_s2: std_logic;
	signal selection_s2: std_logic_vector(3 downto 0);
	signal productslctr_s2: std_logic_vector(3 downto 0);

	signal code_decoder: std_logic_vector(3 downto 0);
	

begin
	
	Inst_sync: synchrnzr PORT MAP(
		  clk => CLK,
		  async_bt10 => BUTTON(0),
          async_bt20 => BUTTON(1),
          async_bt50 => BUTTON(2),
          async_bt100 => BUTTON(3),
          async_cancel => BUTTON(4),
          sync_bt10_out => sync_in(0),
          sync_bt20_out => sync_in(1),
          sync_bt50_out => sync_in(2),
          sync_bt100_out => sync_in(3),
          sync_cancel_out => sync_in(4)
	);


	Inst_edgedtctr: edgedtctr PORT MAP( 
		  clk => CLK,
          sync_bt10_in => sync_in(0),
          sync_bt20_in => sync_in(1),
          sync_bt50_in => sync_in(2),
          sync_bt100_in => sync_in(3),
          sync_cancel_in => sync_in(4), 
          edge_bt10 => edge_out(0),
          edge_bt20 => edge_out(1),
          edge_bt50 => edge_out(2),
          edge_bt100 => edge_out(3),
          edge_cancel => edge_out(4)
	);

	Inst_timer: timer PORT MAP(
		  clk => CLK,
          reset => reset_timer,
          start => start_timer,
          data => data_timer,
          --count => count_timer,
          done => done_timer
	);

	Inst_fsm1: s1fsm PORT MAP(
		  clk => CLK,
    	  reset => reset_s1,
    	  start => start_s1,
    	  coin_100 => coin_s1(3),
    	  coin_50 => coin_s1(2),
    	  coin_20 => coin_s1(1),
    	  coin_10 => coin_s1(0),
    	  count_counter => count_counter,
    	  error => error_s1,
    	  done => done_s1,
    	  code => code_s1,
    	  reset_counter => reset_counter,
    	  coin_100_counter => coin_counter(3),
    	  coin_50_counter => coin_counter(2),
    	  coin_20_counter => coin_counter(1),
    	  coin_10_counter => coin_counter(0)
	);

	Inst_fsm2: s2fsm PORT MAP(
		clk => CLK,
    	reset => reset_s2,
    	start => start_s2,
   		selection => selection_s2,
    	done => done_s2,
		productslctr => productslctr_s2
	);

	Inst_counter: counter PORT MAP(
		  clk => CLK,
    	  reset => reset_counter,
    	  add_100 => coin_counter(3),
    	  add_50 => coin_counter(2),
    	  add_20 => coin_counter(1),
    	  add_10 => coin_counter(0),
    	  count => count_counter
	);

	Inst_decoder: decoder PORT MAP(
		    clk => CLK,
   		    code => code_decoder,
    		display => SEGMENT,
    		current_display => AN
	);

	Inst_mainfsm: mainfsm PORT MAP(
		    clk => CLK,
    		reset => RST,
    		cancel_in => edge_out(4),
    		button_10_in => edge_out(0),
    		button_20_in => edge_out(1),
    		button_50_in => edge_out(2),
    		button_100_in => edge_out(3),
    		switches_in => SW,
    		code_s1_in => code_s1,
    		done_s1_in => done_s1,
    		error_s1_in => error_s1,
    		productslctr_s2_in => productslctr_s2,
    		done_s2_in => done_s2,
    		done_timer_in => done_timer,
    		code_display_out => code_decoder,
    		product_out => LED(3 downto 0),
    		error_out => LED(4),
    		sold_out => LED(5),
    		recover_out => LED(6),
    		reset_s1_out => reset_s1,
    		start_s1_out => start_s1,
    		coin_10_s1_out => coin_s1(0),
    		coin_20_s1_out => coin_s1(1),
    		coin_50_s1_out => coin_s1(2),
    		coin_100_s1_out => coin_s1(3),
    		reset_s2_out => reset_s2,
    		start_s2_out => start_s2,
    		selection_s2_out => selection_s2,
    		reset_timer_out => reset_timer,
    		start_timer_out => start_timer,
    		data_timer_out => data_timer
	);

end Behavioral;