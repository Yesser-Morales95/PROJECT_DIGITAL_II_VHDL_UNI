
-- VHDL Instantiation Created from source file UART.vhd -- 18:11:10 01/01/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT UART
	PORT(
		CLOCK_50 : IN std_logic;
		DATAIN : IN std_logic_vector(7 downto 0);
		KEY : IN std_logic;
		UART_RXD : IN std_logic;          
		DATAOUT : OUT std_logic_vector(7 downto 0);
		UART_TXD : OUT std_logic
		);
	END COMPONENT;

	Inst_UART: UART PORT MAP(
		CLOCK_50 => ,
		DATAIN => ,
		KEY => ,
		DATAOUT => ,
		UART_TXD => ,
		UART_RXD => 
	);


