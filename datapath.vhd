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
		
		dscore_out, pscore_out : out STD_LOGIC_VECTOR(3 downto 0);
		pcard3_out	: out STD_LOGIC_VECTOR(3 downto 0);
		LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 10);
		
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
signal pcard1,pcard2,pcard3,dcard1,dcard2,dcard3,dscore_signal,pscore_signal,new_card : STD_LOGIC_VECTOR (3 downto 0);

			component card7seg is
		      PORT(
	      	   card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
					seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
		    	    );		
	   	end component;
			
			component score7seg is
		      PORT(
	      	   score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
					seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise 
		    	    );		
	   	end component;
			
			component scorehand is
		      PORT(
	      	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
					total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
		    	    );		
	   	end component;
			
			component dealcard is 
				PORT(
				 clock : in std_logic;
				 resetb :in std_logic;
				 new_card : out std_logic_vector (3 downto 0)
				 );
			end component;


begin
    -- Your code goes here
    			-- components ports declarations
    	-- The port maps
		deal_card : dealcard PORT MAP(
		clock => fast_clock,
		resetb => resetb,
		new_card => new_card);
		
	 	c7sp1 : card7seg PORT MAP (
	   card => pcard1,
		seg7 => HEX0);
		
		c7sp2 : card7seg PORT MAP (
		card => pcard2,
		seg7 => HEX1);
		
		c7sp3 : card7seg PORT MAP (
	   card => pcard3,
		seg7 => HEX2);
		
		c7sd1 : card7seg PORT MAP (
	   card => dcard1,
		seg7 => HEX4);
		
		c7sd2 : card7seg PORT MAP (
	   card => dcard2,
		seg7 => HEX5);
		
		c7sd3 : card7seg PORT MAP (
	   card => dcard3,
		seg7 => HEX6);
		
		dscore : scorehand PORT MAP (
		card1 => pcard1,
		card2 => pcard2,
		card3 => pcard3,
		total => dscore_signal);
		
		pscore : scorehand PORT MAP (
		card1 => dcard1,
		card2 => dcard2,
		card3 => dcard3,
		total => pscore_signal);
		
		ps7s : score7seg PORT MAP (
	   score => pscore_signal,
		seg7 => HEX3);
		
		ds7s : score7seg PORT MAP (
	   score => dscore_signal,
		seg7 => HEX7);

	process (resetb,slow_clock)
	begin
	if (resetb = '0') then
		pcard1 <= "0000";
		pcard2 <= "0000";
		pcard3 <= "0000";
		dcard1 <= "0000";
		dcard2 <= "0000";
		dcard3 <= "0000";
	elsif (slow_clock'event and slow_clock = '0') then
		if(load_dcard1 = '1') then
		dcard1 <= new_card;
		LEDR (17 DOWNTO 14) <= NEW_card;
		elsif(load_dcard2 = '1') then
		dcard2 <= new_card;
		elsif(load_dcard3 = '1') then
		dcard3 <= new_card;
		elsif(load_pcard1 = '1') then
		pcard1 <= new_card;
		LEDR (13 DOWNTO 10) <= NEW_card;
		elsif(load_pcard2 = '1') then
		pcard2 <= new_card;
		else 
		pcard3 <= new_card;
		end if;
	end if;
	
	end process;
	
	process (pcard3)
	begin
	pscore_out <= pscore_signal;
	dscore_out <= dscore_signal;
	pcard3_out <= pcard3;
	end process;
END;
