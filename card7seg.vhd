LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY card7seg IS
	PORT(
		card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- card type (Ace, 2..10, J, Q, K)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF card7seg IS
signal inv : std_logic_vector(6 downto 0);
BEGIN

   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.

		process(card)
		begin
		case card (3 downto 0) is
			when "0000" => inv <= "1111111"; --no cards
			when "0001" => inv <= "1111001"; --1
			when "0010" => inv <= "0100100"; --2
			when "0011" => inv <= "0110000"; --3           
			when "0100" => inv <= "0011001"; --4
			when "0101" => inv <= "0010010"; --5
			when "0110" => inv <= "0000010"; --6
			when "0111" => inv <= "1111000"; --7
			when "1000" => inv <= "0000000"; --8
			when "1001" => inv <= "0010000"; --9
			when "1010" => inv <= "1000000"; --10
			when "1011" => inv <= "1110001"; --J
			when "1100" => inv <= "0011000"; --Q
			when "1101" => inv <= "0001001"; --H
			when others => inv <= "1111111";
		end case;
		end process;
		
		process(inv)
		begin
		seg7 <= inv;
		end process;
END;
