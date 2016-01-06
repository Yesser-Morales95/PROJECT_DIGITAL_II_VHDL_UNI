----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:21 10/18/2015 
-- Design Name: 
-- Module Name:    DIVISOR_FREQ - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DIVISOR_FREQTX is
Port (     mclk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           clkuser : out  STD_LOGIC
			  );


end DIVISOR_FREQTX;

architecture Behavioral of DIVISOR_FREQTX is
signal q: std_logic_vector(23 downto 0);

begin

-- Clock Divider
clkdivider: process(mclk,clr)
begin
if clr = '1' then
q <= X"000000";
elsif mclk'event and mclk = '1' then
q <= q + 1;
end if;

end process;
clkuser <= q(23); -- FREQUENCY USER

end Behavioral;

