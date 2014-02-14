LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY statemachine IS
	PORT(

	   slow_clock : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		
		dscore : IN STD_LOGIC_VECTOR(3 downto 0);
		pscore : IN STD_LOGIC_VECTOR(3 downto 0);
		pcard3 : IN STD_LOGIC_VECTOR(3 downto 0);
		
		load_pcard1, load_pcard2, load_pcard3 : OUT STD_LOGIC := '0';
		load_dcard1, load_dcard2, load_dcard3 : OUT STD_LOGIC := '0';
		
  		LEDR : out std_logic_vector (10 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(1 downto 0)	
	);
END statemachine;


ARCHITECTURE behavioural OF statemachine IS
signal present_state : STD_LOGIC_VECTOR (3 downto 0);
begin
-- Your code goes here.  This is the most challenge of all the files
-- to write.
	process(resetb,slow_clock)
	begin
	if(resetb = '0') then
		present_state <= "0000";
		LEDG <= "00";
		load_dcard1 <= '0';
		load_dcard2 <= '0';
		load_dcard3	<= '0';
		load_pcard1 <= '0';
		load_pcard2 <= '0';
		load_pcard3 <= '0';
		LEDR <= "00000000000";
	elsif (slow_clock'event and slow_clock = '0') then
		load_dcard1 <= '0';
		load_dcard2 <= '0';
		load_dcard3	<= '0';
		load_pcard1 <= '0';
		load_pcard2 <= '0';
		load_pcard3 <= '0';
		case (present_state) is
			when "0000" => load_pcard1 <= '1'; --player gets first card
					present_state <= "0001";
					LEDR(0)<= '1';
			when "0001" => load_dcard1 <= '1'; --dealer gets first card
					present_state <= "0010";
					LEDR(1) <= '1';
			when "0010" => load_pcard2 <= '1'; --player gets second card
					present_state <= "0011"; 
					LEDR(2) <= '1';
			when "0011" => load_dcard2 <= '1'; --dealer gets second card
					present_state <= "0100";
					LEDR(3) <= '1';
			when "0100" => --player natural victory
					if(unsigned(pscore) >= 8) then
						present_state <= "1011";
					else
						present_state <= "0101";
					end if;			
					LEDR(4) <= '1';
			when "0101" => --dealer natural victory
					if(unsigned(dscore) >= 8) then 
						present_state <= "1011";
					else
						present_state <= "0110"; 
					end if;						
					LEDR(5) <= '1';
			when "0110" =>
					if(unsigned(pscore) >= 0 and unsigned(pscore) <= 5) then -- player has between 0 and 5 points
						present_state <= "0111";
					else --player has 6 or 7 points
						present_state <= "1001";
					end if;
					LEDR(6) <= '1';
			when "0111" => load_pcard3 <= '1'; --player buys a card
					present_state <= "1000";
					LEDR(7) <= '1';
			when "1000" => --player has between 0 and 5 points,after he got a card
					if(unsigned(dscore) = 7) then
						present_state <= "1011";
					end if;			
					if(unsigned(dscore) = 6 and (pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 6 or 7
						present_state <= "1010"; --dealer gets a card
					else
						present_state <= "1011";
					end if;	
					if(unsigned(dscore) = 5 and (pcard3 = "0100" or pcard3 = "0101" or pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 4,5,6 or 7
						present_state <= "1010"; --dealer gets a card
					else
						present_state <= "1011";
					end if;	
					if(unsigned(dscore) = 4 and (pcard3 = "0010" or pcard3 = "0011" or pcard3 = "0100" or pcard3 = "0101" or pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 2,3,4,5,6 or 7
						present_state <= "1010"; --dealer gets a card
					else
						present_state <= "1011";
					end if;	
					if(unsigned(dscore) = 3 and pcard3 /= "1000") then --pcard3 is anything but 8
						present_state <= "1010"; --dealer gets a card
					else
						present_state <= "1011";
					end if;	
					if((unsigned(dscore) = 0) or (unsigned(dscore) = 1) or (unsigned(dscore) = 2)) then
						present_state <= "1010"; --dealer gets a card
					else
						present_state <= "1011";
					end if;		
					LEDR (8) <= '1';
			when "1001" => --player has 6 or 7 points,and the dealer will buy or not a card
					if (unsigned(dscore) >= 0 and unsigned(dscore) <= 5) then
						present_state <= "1010";
					else
						present_state <= "1011";
					end if;			
					LEDR(9) <= '1';
			when "1010" => load_dcard3 <= '1'; --dealer gets the third card
					present_state <= "1111"; --NOTE this one needs one extra cycle to get updated I don't know why
			when "1011" => --game over player wins		
					if(unsigned(pscore) > unsigned(dscore)) then
						LEDG(0) <= '1'; --player wins
					else
						present_state <= "1100";
					end if;	
					LEDR(10) <= '1';
			when "1100" => --game over	dealer wins	
					if (unsigned(dscore) > unsigned(pscore)) then
						LEDG(1) <= '1'; --dealer wins	
					else
						LEDG(0) <= '1';
						LEDG(1) <= '1'; --tie
					end if;	
			when others => present_state <= "1011";

			end case;
	end if;
	end process;
		


END;
