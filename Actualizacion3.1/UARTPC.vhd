----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:52 01/05/2016 
-- Design Name: 
-- Module Name:    UARTPC - Behavioral 
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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:05:16 01/05/2016 
-- Design Name: 
-- Module Name:    UART - Behavioral 
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

entity UARTPC is
    Port ( clk 				: IN	STD_LOGIC;
           enable 			: IN	STD_LOGIC;
           parallelDataIn	: IN	STD_LOGIC_VECTOR (7 downto 0);
           transmitRequest : IN	STD_LOGIC;
			  txIsReady			: OUT	STD_LOGIC;
           serialDataOut 	: OUT	STD_LOGIC
			  );
end UARTPC;

architecture Behavioral of UARTPC is

-- viz UART_baudRateGenerator.vhd
component UART_baudRateGenerator
port (clk						:	IN	 STD_LOGIC;
		enable					:	IN	 STD_LOGIC;
		baudRateEnable			:	OUT STD_LOGIC
		);
end component UART_baudRateGenerator;

-- viz UART_transmitter.vhd
component UART_transmitter
port (clk					:	IN  STD_LOGIC;
		enable				:	IN  STD_LOGIC;
		baudRateEnable		:	IN  STD_LOGIC;
		parallelDataIn		:	IN	 STD_LOGIC_VECTOR(7 downto 0);
		transmitRequest	:	IN	 STD_LOGIC;
		txIsReady			:	OUT STD_LOGIC;
		serialDataOut		:	OUT STD_LOGIC
		);
end component UART_transmitter;
		
signal baudRateEnable		:	STD_LOGIC;

		
begin
	baudRateGenerator : UART_baudRateGenerator port map (
					clk						=>	clk,
					enable					=>	enable,
					baudRateEnable			=>	baudRateEnable
	);

	transmitter : UART_transmitter port map (
					clk					=>	clk,
					enable				=> enable,
					baudRateEnable		=>	baudRateEnable,
					parallelDataIn		=>	parallelDataIn,
					transmitRequest	=>	transmitRequest,
					txIsReady			=>	txIsReady,
					serialDataOut		=> serialDataOut
	);
end Behavioral;