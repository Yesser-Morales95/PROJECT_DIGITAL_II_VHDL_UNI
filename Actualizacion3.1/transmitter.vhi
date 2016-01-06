
-- VHDL Instantiation Created from source file transmitter.vhd -- 16:37:41 01/05/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT transmitter
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		TX1 : IN std_logic;
		TX2 : IN std_logic;
		data_in_1 : IN std_logic_vector(7 downto 0);
		data_in_2 : IN std_logic_vector(7 downto 0);
		UARTRX : IN std_logic;          
		enable_LED : OUT std_logic;
		DATAOUT : OUT std_logic_vector(7 downto 0);
		UARTTX : OUT std_logic
		);
	END COMPONENT;

	Inst_transmitter: transmitter PORT MAP(
		clk => ,
		enable => ,
		TX1 => ,
		TX2 => ,
		enable_LED => ,
		data_in_1 => ,
		data_in_2 => ,
		DATAOUT => ,
		UARTRX => ,
		UARTTX => 
	);


