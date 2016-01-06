
-- VHDL Instantiation Created from source file ContadorBCD.vhd -- 16:24:10 12/07/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT ContadorBCD
	PORT(
		MHZ50 : IN std_logic;
		PULSO : IN std_logic;
		R : IN std_logic;          
		SALIDA : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_ContadorBCD: ContadorBCD PORT MAP(
		MHZ50 => ,
		PULSO => ,
		SALIDA => ,
		R => 
	);


