LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY scorehand IS
	PORT(
	   card1, card2, card3 : IN STD_LOGIC_VECTOR(3 downto 0);
		total : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)  -- total value of hand
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
		c1 := unsigned(card1);
		c2 := unsigned(card2);
		c3 := unsigned(card3);
		score := (c1 + c2 + c3) mod 10;
		total <= std_logic_vector(score);
	end process;
	
END;