----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:18 01/05/2016 
-- Design Name: 
-- Module Name:    UARTPCFULL - Behavioral 
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

entity UARTPCFULL is
    Port ( 		  
			   clk 						: in  STD_LOGIC;
			  enable 					: in  STD_LOGIC;
			  TX1 			    		: in  STD_LOGIC;
			  TX2 			   		: in  STD_LOGIC;
			  enable_LED				: out	STD_LOGIC;			  
           data_in_1			   	: in  STD_LOGIC_VECTOR (7 downto 0);
           data_in_2 				: in  STD_LOGIC_VECTOR (7 downto 0);
			  DATAOUT               : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			  UARTRX             	: IN	STD_LOGIC;			  
			  UARTTX             	: OUT	STD_LOGIC		  
		   );
end UARTPCFULL;

architecture Behavioral of UARTPCFULL is


component UARTPC
    port ( clk 				: IN	STD_LOGIC;
           enable 			: IN	STD_LOGIC;
           serialDataOut 	: OUT	STD_LOGIC;
           parallelDataIn	: IN	STD_LOGIC_VECTOR (7 downto 0);
           transmitRequest : IN	STD_LOGIC;
           txIsReady 		: OUT	STD_LOGIC);
end component UARTPC;

-- viz transmitControler.vhd

COMPONENT transmitControler
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		TX1 			    		: in  STD_LOGIC;
	   TX2 			   		: in  STD_LOGIC;
		data_in_1 : IN std_logic_vector(7 downto 0);
		data_in_2 : IN std_logic_vector(7 downto 0);
		txIsReady : IN std_logic;          
		enable_LED : OUT std_logic;
		parallelDataOut : OUT std_logic_vector(7 downto 0);
		transmitRequest : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT RX
	PORT(
		CLK : IN std_logic;
		RX_LINE : IN std_logic;          
		BUSY : OUT std_logic;
		DATA : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	
	SIGNAL RX_BUSY:  STD_LOGIC;
	SIGNAL RX_DATA:  STD_LOGIC_VECTOR(7 DOWNTO 0);



signal transmitRequest	: STD_LOGIC := 'U';
signal txIsReady			: STD_LOGIC := 'U';
signal parallelDataOut	: STD_LOGIC_VECTOR(7 downto 0) := "UUUUUUUU";

begin

	UART_1 : UARTPC port map (
					clk					=>	clk,
					enable				=>	enable,
					serialDataOut		=>	UARTTX,
					parallelDataIn		=>	parallelDataOut,
					transmitRequest	=>	transmitRequest,
					txIsready			=>	txIsReady
	);
	
	
	u1: transmitControler PORT MAP(
					clk 					=> clk,
					enable 				=> enable,
					TX1    				=> TX1,
					TX2    				=> TX2,
					enable_LED 			=> enable_LED,
					data_in_1 			=> data_in_1	,
					data_in_2 			=> data_in_2	,
					parallelDataOut 	=> parallelDataOut,
					transmitRequest 	=> transmitRequest,
					txIsReady 			=> txIsReady
	);
	
	U2: RX PORT MAP(
		CLK => clk,
		BUSY =>RX_BUSY,
		DATA => RX_DATA,
		RX_LINE => UARTRX
	);
	
	
	PROCESS(RX_BUSY)
BEGIN

IF(RX_BUSY'EVENT AND RX_BUSY='0') THEN

DATAOUT<=RX_DATA;

END IF;

END PROCESS;

end Behavioral;