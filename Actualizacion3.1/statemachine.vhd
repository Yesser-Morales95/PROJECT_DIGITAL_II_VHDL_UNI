 LIBRARY IEEE;
     USE IEEE.STD_LOGIC_1164.ALL;

     ENTITY maquina_estados IS
       PORT (clk : IN std_logic;
             rst : IN std_logic;
             a : OUT std_logic;
             estado : OUT std_logic_vector(3 downto 0));
     END maquina_estados;

     ARCHITECTURE synth OF maquina_estados IS
       SIGNAL pstate, n_state : std_logic_vector(3 downto 0);
     BEGIN

    -- maquina de estados

     PROCESS (clk, rst)
     BEGIN
       IF rst = '1' THEN
         pstate <= "0000";
       ELSIF clk = '1' AND clk'event THEN
         pstate <= n_state;
       END IF;
     END PROCESS;

     estado <= pstate;

     n_state <= "0001" WHEN (pstate = "0000") ELSE
	             "0010" WHEN (pstate = "0001") ELSE
--                "0011" WHEN (pstate = "0010") ELSE
--	             "0100" WHEN (pstate = "0011") ELSE
--                "0101" WHEN (pstate = "0100") ELSE
--	             "0011" WHEN (pstate = "0101") ELSE
--	             "0111" WHEN (pstate = "0011") ELSE
--	             "1000" WHEN (pstate = "0111") ELSE
--	             "1001" WHEN (pstate = "1000") ELSE
                "0000";

a <= '0' WHEN pstate = "0000" ELSE --0
	  '1' WHEN pstate = "0001" ELSE --1
--	  '0' WHEN pstate = "0010" ELSE --2
--	  '0' WHEN pstate = "0011" ELSE --3
--	  '0' WHEN pstate = "0100" ELSE --4 
--	  '0' WHEN pstate = "0101" ELSE --5
--	  '0' WHEN pstate = "0110" ELSE --6
--	  '0' WHEN pstate = "0111" ELSE --7
--	  '0' WHEN pstate = "1000" ELSE --8
--	  '0' WHEN pstate = "1001" ELSE --9
	  '0';


     END synth;