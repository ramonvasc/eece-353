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
		
		dscore, pscore : IN STD_LOGIC_VECTOR(3 downto 0);
		pcard3 : IN STD_LOGIC_VECTOR(3 downto 0);
		
		load_pcard1, load_pcard2, load_pcard3 : OUT STD_LOGIC;
		load_dcard1, load_dcard2, load_dcard3 : OUT STD_LOGIC;
		
  		LEDG : OUT STD_LOGIC_VECTOR(1 downto 0)	
	);
END statemachine;


ARCHITECTURE behavioural OF statemachine IS
signal present_state : STD_LOGIC_VECTOR (3 downto 0);
begin
-- Your code goes here.  This is the most challenge of all the files
-- to write.
	process(resetb,slow_clock)
	--variable present_state : std_logic_vector (3 downto 0);
	begin
	if(resetb = '0') then
		present_state <= "0000";	
	elsif (slow_clock'event and slow_clock = '1') then
		case (present_state) is
			when "0000" => load_pcard1 <= '1'; --player gets first card
			present_state <= "0001";
			when "0001" => load_dcard1 <= '1'; --dealer gets first card
			present_state <= "0010";
			when "0010" => load_pcard2 <= '1'; --player gets second card
			present_state <= "0011"; 
			when "0011" => load_dcard2 <= '1'; --dealer gets second card
					if((unsigned(dscore) or unsigned(pscore)) >= 8) then
						present_state <= "0100";
					elsif(unsigned(pscore) >=0 and unsigned(pscore) <=5) then
						present_state <= "0101";
					elsif(unsigned(pscore) = 6 or unsigned(pscore) =7) then
						present_state <= "0110";
					end if;
			when "0100" => --game over
					if (unsigned(dscore) > unsigned(pscore)) then
						LEDG(1) <= '1'; --dealer wins
					elsif(unsigned(dscore) < unsigned(pscore)) then
						LEDG(0) <= '1'; --player wins
					elsif (unsigned(dscore) = unsigned(pscore)) then
						LEDG(0) <= '1';
						LEDG(1) <= '1'; --tie
					end if;
			when "0101" => load_pcard3 <= '1'; --player has between 0 and 5 points
					if(unsigned(dscore) = 7) then
						present_state <= "0100";
					elsif(unsigned(dscore) = 6 and (pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 6 or 7
						present_state <= "0111";
					elsif(unsigned(dscore) = 5 and (pcard3 = "0100" or pcard3 = "0101" or pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 4,5,6 or 7
						present_state <= "0111";
					elsif(unsigned(dscore) = 4 and (pcard3 = "0010" or pcard3 = "0011" or pcard3 = "0100" or pcard3 = "0101" or pcard3 = "0110" or pcard3 = "0111")) then --pcard3 is 2,3,4,5,6 or 7
						present_state <= "0111";
					elsif(unsigned(dscore) = 3 and pcard3 /= "1000") then --pcard3 is anything but 8
						present_state <= "0111";
					elsif((unsigned(dscore) = 0) or (unsigned(dscore) = 1) or (unsigned(dscore) = 2)) then
						present_state <= "0111";
					end if;
			when "0110" => --player has 6 or 7 points
					if (unsigned(dscore) >= 0 and unsigned(dscore) <=5) then
						present_state <= "0111";
					else
						present_state <= "0100";
					end if;
			when "0111" => load_dcard3 <= '1'; --dealer gets the third card
			present_state <= "0100";
			when others => present_state <="0000";
			end case;
	end if;
	end process;
		

END;
