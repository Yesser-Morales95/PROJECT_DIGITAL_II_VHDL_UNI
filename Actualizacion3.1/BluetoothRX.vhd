----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:33 10/07/2015 
-- Design Name: 
-- Module Name:    BluetoothRX - Behavioral 
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
use     IEEE.STD_LOGIC_1164.ALL;
USE 	  IEEE.STD_LOGIC_ARITH.ALL; 
USE 	  IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE 	  IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BluetoothRX is
    Port ( Rx 		 : in  STD_LOGIC;
           clk 	 : in  STD_LOGIC;
           clr 	 : in  STD_LOGIC;
			  NIVELES : in  STD_LOGIC_VECTOR(7 downto 0);
			  TEMP    : out STD_LOGIC_VECTOR(7 downto 0);
			  RX_IN   : OUT std_logic;
			  Tx 		 : out STD_LOGIC
			  
			   );
end BluetoothRX;


architecture Behavioral of BluetoothRX is



COMPONENT RS232
	PORT(
		CLK : IN std_logic;
		RX : IN std_logic;
		TX_INI : IN std_logic;
		DATAIN : IN std_logic_vector(7 downto 0);          
		TX_FIN : OUT std_logic;
		TX : OUT std_logic;
		RX_IN : OUT std_logic;
		DOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;


COMPONENT maquina_estados
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		a : OUT std_logic
	  
		);
	END COMPONENT;

COMPONENT DIVISOR_FREQ
	PORT(
		mclk : IN std_logic;
		clr : IN std_logic;          
		clkuser : OUT std_logic
		);
	END COMPONENT;

	
--	SIGNAL recibida : std_logic_vector(7 downto 0);
--	SIGNAL enviando1 : std_logic_vector(7 downto 0);
	signal est_txini :std_logic;
	signal est_txfin :std_logic;
--	SIGNAL rec : std_logic_vector(7 downto 0);
	signal CLOCK1 : std_logic;

begin
		
  U1: RS232 PORT MAP(
		CLK => clk,
		RX => Rx,
		TX_INI => est_txini,
   	TX_FIN => est_txfin,
		TX => Tx,
		RX_IN => RX_IN,
		DATAIN => NIVELES,
		DOUT => TEMP
	);


  U3: maquina_estados PORT MAP(
		clk => CLOCK1,
		rst => clr,
		a => est_txini
	);

  U4: DIVISOR_FREQ PORT MAP(
		mclk => clk,
		clr => clr,
		clkuser => CLOCK1
	);
	

end Behavioral;

