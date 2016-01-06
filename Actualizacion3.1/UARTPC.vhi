
-- VHDL Instantiation Created from source file UARTPC.vhd -- 13:07:33 01/05/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT UARTPC
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		parallelDataIn : IN std_logic_vector(7 downto 0);
		transmitRequest : IN std_logic;          
		txIsReady : OUT std_logic;
		serialDataOut : OUT std_logic
		);
	END COMPONENT;

	Inst_UARTPC: UARTPC PORT MAP(
		clk => ,
		enable => ,
		parallelDataIn => ,
		transmitRequest => ,
		txIsReady => ,
		serialDataOut => 
	);


