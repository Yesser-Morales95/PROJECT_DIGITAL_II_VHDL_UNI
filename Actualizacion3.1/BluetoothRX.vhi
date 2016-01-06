
-- VHDL Instantiation Created from source file BluetoothRX.vhd -- 18:27:41 01/03/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT BluetoothRX
	PORT(
		Rx : IN std_logic;
		clk : IN std_logic;
		clr : IN std_logic;
		NIVELES : IN std_logic_vector(7 downto 0);          
		TEMP : OUT std_logic_vector(7 downto 0);
		RX_IN : OUT std_logic;
		Tx : OUT std_logic
		);
	END COMPONENT;

	Inst_BluetoothRX: BluetoothRX PORT MAP(
		Rx => ,
		clk => ,
		clr => ,
		NIVELES => ,
		TEMP => ,
		RX_IN => ,
		Tx => 
	);


