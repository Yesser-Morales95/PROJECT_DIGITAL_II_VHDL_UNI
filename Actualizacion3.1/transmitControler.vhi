
-- VHDL Instantiation Created from source file transmitControler.vhd -- 12:34:50 01/05/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT transmitControler
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		data_in_1 : IN std_logic_vector(7 downto 0);
		data_in_2 : IN std_logic_vector(7 downto 0);
		txIsReady : IN std_logic;          
		enable_LED : OUT std_logic;
		parallelDataOut : OUT std_logic_vector(7 downto 0);
		transmitRequest : OUT std_logic
		);
	END COMPONENT;

	Inst_transmitControler: transmitControler PORT MAP(
		clk => ,
		enable => ,
		enable_LED => ,
		data_in_1 => ,
		data_in_2 => ,
		parallelDataOut => ,
		transmitRequest => ,
		txIsReady => 
	);


