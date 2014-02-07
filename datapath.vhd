LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ensure components in other 'vhd' project files can be included  
LIBRARY WORK;
USE WORK.ALL;

ENTITY datapath IS
	PORT(

	   slow_clock : IN STD_LOGIC;
		fast_clock : IN STD_LOGIC;
		resetb : IN STD_LOGIC;
		load_pcard1, load_pcard2, load_pcard3 : IN STD_LOGIC;
		load_dcard1, load_dcard2, load_dcard3 : IN STD_LOGIC;
		new_card : IN STD_LOGIC_VECTOR (3 downto 0);
		
		dscore_out, pscore_out : out STD_LOGIC_VECTOR(3 downto 0);
		pcard3_out	: out STD_LOGIC_VECTOR(3 downto 0);
		
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END datapath;


ARCHITECTURE mixed OF datapath IS
signal pcard1,pcard2,pcard3,dcard1,dcard2,dcard3 : STD_LOGIC_VECTOR (3 downto 0);

begin
    -- Your code goes here
    			-- components ports declarations
    	-- The port maps
	 	c7sp1 : card7seg PORT MAP (
	   pcard1 => card,
		HEX0 => seg7);
		
		c7sp2 : card7seg PORT MAP (
	   pcard2 => card,
		HEX1 => seg7);
		
		c7sp3 : card7seg PORT MAP (
	   pcard3 => card,
		HEX2 => seg7);
		
		c7sd1 : card7seg PORT MAP (
	   dcard1 => card,
		HEX4 => seg7);
		
		c7sd2 : card7seg PORT MAP (
	   dcard2 => card,
		HEX5 => seg7);
		
		c7sd3 : card7seg PORT MAP (
	   dcard3 => card,
		HEX6 => seg7);
		
		ps7s : score7seg PORT MAP (
	   score => total,
		HEX3 => seg7);
		
		ds7s : score7seg PORT MAP (
	   score => total,
		HEX7 => seg7);
	
		sr : scorehand PORT MAP ( -- corrigir!!
	   card1 => card1,
		card2 => card2,
		card3 => card3,
		total => total);

	process (resetb,slow_clock)
	begin
	if (resetb = '0') then
		pcard1 <= "0000";
		pcard2 <= "0000";
		pcard3 <= "0000";
		dcard1 <= "0000";
		dcard2 <= "0000";
		dcard3 <= "0000";
	elsif (slow_clock'event and slow_clock = '1') then
		if(load_dcard1 = '1') then
		dcard1 <= new_card;
		elsif(load_dcard2 = '1') then
		dcard2 <= new_card;
		elsif(load_dcard3 = '1') then
		dcard3 <= new_card;
		elsif(load_pcard1 = '1') then
		pcard1 <= new_card;
		elsif(load_pcard2 = '1') then
		pcard2 <= new_card;
		else 
		pcard3 <= new_card;
		end if;
	end if;
	
	end process;
	
	process (pcard3)
	begin
	pcard3_out <= pcard3;
	end process;
END;
