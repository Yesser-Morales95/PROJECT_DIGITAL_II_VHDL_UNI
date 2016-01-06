
-- VHDL Instantiation Created from source file temp.vhd -- 21:15:31 12/24/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT temp
	PORT(
		inclk : IN std_logic;    
		DQ : INOUT std_logic;      
		current_temp : OUT std_logic_vector(10 downto 0)
		);
	END COMPONENT;

	Inst_temp: temp PORT MAP(
		DQ => ,
		inclk => ,
		current_temp => 
	);


