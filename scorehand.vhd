LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY scorehand IS
	PORT(
	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)  -- total value of hand
	);
END scorehand;


ARCHITECTURE behavioral OF scorehand IS
BEGIN

-- Your code goes here.
	process(card1,card2,card3)
	variable c1 : unsigned (3 downto 0);
	variable c2 : unsigned (3 downto 0);
	variable c3 : unsigned (3 downto 0);
	variable score : unsigned (4 downto 0);
	begin
		if(card1 = "1010" or card1 = "1011" or card1 = "1100" or card1 = "1101") then
		c1 := "0000";
		else
		c1 := unsigned(card1);
		end if;
		if(card2 = "1010" or card2 = "1011" or card2 = "1100" or card2 = "1101") then
		c2 := "0000";
		else
		c2 := unsigned(card2);
		end if;
		if(card3 = "1010" or card3 = "1011" or card3 = "1100" or card3 = "1101") then
		c3 := "0000";
		else
		c3 := unsigned(card3);
		end if;
		
		score := (('0' & c1) + ('0' & c2) + ('0' & c3)) mod 10;
		total <= std_logic_vector(score(3 downto 0));
	end process;
	
END;