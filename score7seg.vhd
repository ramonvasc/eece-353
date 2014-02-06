LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY score7seg IS
	PORT(
		score : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- score (0 to 9)
		seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- top seg 'a' = bit0, proceed clockwise
	);
END;


ARCHITECTURE behavioral OF score7seg IS
BEGIN

   -- your code goes here.  Hint: this is a simple combinational block
   -- like you did in Lab 1.  If you find this difficult, you are on the
   -- wrong track.
	
	-- HEX3 (player) and HEX7 (dealer)
	-- Here I put the 7-segment display phisical disposition, 
		-- to make it easier to work on the code below:
	   --	
		--             hex0(0)
		--            --------
		--    hex0(5)|        | hex0(1)
		--            -------- 
	   --    	      hex0(6)
		--    hex0(4)|        | hex0(2)
      --
		--             hex0(3)
		--
		-- Just to remember: the 7-segment display is "active low"
		
		-- after reset, both dealer and player scores go to '0'		
		IF resetb =  '0' THEN
			seg7 <= "0000001";
		END IF;
		
		-- Transfer the final scores to SEG7
		case score  is
			when "0000" => seg7 <= "0000001"; -- 0
			when "0001" => seg7 <= "1111001"; -- 1
			when "0010" => seg7 <= "0100100"; -- 2
			when "0011" => seg7 <= "0110000"; -- 3
			when "0100" => seg7 <= "0011001"; -- 4
			when "0101" => seg7 <= "0010010"; -- 5
			when "0110" => seg7 <= "0000010"; -- 6
			when "0111" => seg7 <= "1111000"; -- 7
			when "1000" => seg7 <= "0000000"; -- 8
			when "1001" => seg7 <= "0010000"; -- 9
			when others => seg7 <= "0000001"; -- 0 (in case a invalid value comes through 'score')
		end case;
		
		
END;
