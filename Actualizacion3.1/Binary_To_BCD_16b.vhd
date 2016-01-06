----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:39 07/22/2015 
-- Design Name: 
-- Module Name:    Binary_To_BCD_16b - Behavioral 
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
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Binary_To_BCD_16b is
PORT (
      Conv_BCD: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 BCD: OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
		 );
		
end Binary_To_BCD_16b;

architecture Behavioral of Binary_To_BCD_16b is

begin

BCD1: PROCESS(Conv_BCD) 
  VARIABLE Z:STD_LOGIC_VECTOR(34 DOWNTO 0);      
BEGIN 
  FOR I IN 0 TO 34 LOOP 
    Z(I):='0'; 
  END LOOP;  
  Z(18 DOWNTO 3):=Conv_BCD; 
  FOR I IN 0 TO 12 LOOP 
     IF Z(19 DOWNTO 16) > 4 THEN 
        Z(19 DOWNTO 16):= Z(19 DOWNTO 16)+3; 
     END IF;  
     IF Z(23 DOWNTO 20) > 4 THEN 
        Z(23 DOWNTO 20):= Z(23 DOWNTO 20)+3; 
     END IF;  
     IF Z(27 DOWNTO 24) > 4 THEN 
        Z(27 DOWNTO 24):= Z(27 DOWNTO 24)+3; 
     END IF; 
    
     IF Z(31 DOWNTO 28) > 4 THEN 
        Z(31 DOWNTO 28):= Z(31 DOWNTO 28)+3; 
     END IF; 
    
   Z(34 DOWNTO 1):= Z(33 DOWNTO 0); 
    
 END LOOP;  
  BCD<=Z(34 DOWNTO 16); 
 END PROCESS;


end Behavioral;

