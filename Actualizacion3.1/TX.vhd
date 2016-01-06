----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:15:37 11/27/2015 
-- Design Name: 
-- Module Name:    TX - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TX is
PORT (

CLK : IN STD_LOGIC;
START : IN STD_LOGIC;
BUSY : OUT STD_LOGIC;
DATA : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
TX_LINE : OUT STD_LOGIC 


);

end TX;

architecture Behavioral of TX is

SIGNAL PRSCL: INTEGER RANGE 0 TO 5208 :=0;
SIGNAL INDEX: INTEGER RANGE 0 TO 9:=0;
SIGNAL DATAFLL: STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL TX_FLG: STD_LOGIC :='0';

begin

PROCESS(CLK)

BEGIN

IF(CLK'EVENT AND CLK='1') THEN
	IF(TX_FLG ='0' AND START ='1') THEN
		TX_FLG <='1';
		BUSY <= '1';
		DATAFLL(0)<='0'; 
		DATAFLL(9)<='1';
		DATAFLL(8 DOWNTO 1)<=DATA;
	END IF;
	
	IF(TX_FLG ='1')THEN
		IF(PRSCL < 5207) THEN
			PRSCL <= PRSCL+1;
		ELSE
			PRSCL <=0;
		END IF;
		
		IF(PRSCL = 2607) THEN
			TX_LINE <= DATAFLL(INDEX);
			 IF(INDEX < 9) THEN
				INDEX <= INDEX+1;
			 ELSE
			 TX_FLG <='0';
			 BUSY <= '0';
			 INDEX <= 0;
			 END IF;
		END IF; 
	
	END IF;
		
END IF;

END PROCESS;

end Behavioral;

