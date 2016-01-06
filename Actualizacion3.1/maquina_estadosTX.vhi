
-- VHDL Instantiation Created from source file maquina_estadosTX.vhd -- 20:56:04 12/24/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT maquina_estadosTX
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		TX : IN std_logic_vector(7 downto 0);
		TX1 : IN std_logic_vector(7 downto 0);          
		a : OUT std_logic_vector(7 downto 0);
		b : OUT std_logic_vector(7 downto 0);
		estado : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_maquina_estadosTX: maquina_estadosTX PORT MAP(
		clk => ,
		rst => ,
		TX => ,
		TX1 => ,
		a => ,
		b => ,
		estado => 
	);


