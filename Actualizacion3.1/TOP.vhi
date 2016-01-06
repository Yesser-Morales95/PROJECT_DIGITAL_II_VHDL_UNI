
-- VHDL Instantiation Created from source file TOP.vhd -- 21:20:40 01/01/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT TOP
	PORT(
		MHZ50 : IN std_logic;
		PULSO : IN std_logic;
		PULSO1 : IN std_logic;
		R : IN std_logic;
		FWYN : IN std_logic;          
		SEG7 : OUT std_logic_vector(6 downto 0);
		SEL7 : OUT std_logic_vector(3 downto 0);
		SALIDA : OUT std_logic_vector(15 downto 0);
		LEVEL : OUT std_logic_vector(2 downto 0);
		LTX : OUT std_logic_vector(7 downto 0);
		SOLENOIDE1 : OUT std_logic;
		SOLENOIDE2 : OUT std_logic;
		SOLENOIDE3 : OUT std_logic;
		BOMBA : OUT std_logic
		);
	END COMPONENT;

	Inst_TOP: TOP PORT MAP(
		MHZ50 => ,
		SEG7 => ,
		SEL7 => ,
		PULSO => ,
		PULSO1 => ,
		SALIDA => ,
		LEVEL => ,
		LTX => ,
		R => ,
		SOLENOIDE1 => ,
		SOLENOIDE2 => ,
		SOLENOIDE3 => ,
		BOMBA => ,
		FWYN => 
	);


