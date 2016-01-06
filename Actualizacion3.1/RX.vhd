----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:53:08 11/27/2015 
-- Design Name: 
-- Module Name:    RX - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RX is
PORT (

CLK : IN STD_LOGIC;
BUSY : OUT STD_LOGIC;
DATA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
RX_LINE : IN STD_LOGIC 


);

end RX;

architecture Behavioral of RX is
SIGNAL DATAFLL:STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL RX_FLG :  STD_LOGIC:='0';
SIGNAL PRSCL: INTEGER RANGE 0 TO 5208 :=0;
SIGNAL INDEX: INTEGER RANGE 0 TO 9:=0; 



begin

PROCESS(CLK)
BEGIN
IF(CLK'EVENT AND CLK='1') THEN
	IF(RX_FLG ='0' AND RX_LINE ='0') THEN
		INDEX <= 0;
		PRSCL <=0;
		BUSY <= '1';
		RX_FLG <='1' ;
	
	END IF;
			IF(RX_FLG ='1') THEN
				DATAFLL(INDEX) <= RX_LINE;
				IF(PRSCL < 5207) THEN
					PRSCL <= PRSCL+1;
				ELSE
					PRSCL <=0;
			END IF;
	
			IF(PRSCL = 2500) THEN
				IF(INDEX <9)THEN
				INDEX<=INDEX+1;
				ELSE
					IF(DATAFLL(0)='0' AND DATAFLL(9)='1') THEN
						DATA <= DATAFLL(8 DOWNTO 1);
						ELSE
						DATA<=(OTHERS =>'0');
					END IF;
			BUSY <= '0';
			RX_FLG <='0' ;
	END IF;
	END IF;
	END IF;
	
	

END IF;
END PROCESS;
end Behavioral;

