----------------------------------------------------------------------------------
--.########..####..######...####.########....###....##..........####
--.##.....##..##..##....##...##.....##......##.##...##...........##.
--.##.....##..##..##.........##.....##.....##...##..##...........##.
--.##.....##..##..##...####..##.....##....##.....##.##...........##.
--.##.....##..##..##....##...##.....##....#########.##...........##.
--.##.....##..##..##....##...##.....##....##.....##.##...........##.
--.########..####..######...####....##....##.....##.########....####  
 -- ____     ___    _   ____  
 --|___ \   / _ \  / | | ___| 
 --  __) | | | | | | | |___ \ 
 -- / __/  | |_| | | |  ___) |
 --|_____|  \___/  |_| |____/ 

-- Company: 		   		UNI

-- Engineer/students: 		Yeser Morales
--									Keller Jiron
--									Jarib Castillo
--									Jonathan Fuentes
-- 
-- Create Date:       21:20:13 07/28/2015 
-- Design Name: 
-- Module Name:       TOP_PROJECT - Behavioral 
-- Project Name: 	    ELEK.DIGITAL I
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;
USE 	  IEEE.STD_LOGIC_ARITH.ALL; 
USE 	  IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE 	  IEEE.NUMERIC_STD.ALL; 

------------------------------------------------------------------------------------



entity PROCESO_LL_VA is
    Port ( MHZ50      : IN  STD_LOGIC;							 		--Señal de reloj
           SEG7       : OUT  STD_LOGIC_VECTOR (6 downto 0);  	--7 segmentos
           SEL7       : OUT  STD_LOGIC_VECTOR (3 downto 0);  	--Anodo
     	     PULSO      : IN STD_LOGIC; 							 		--SENSOR 1
			  PULSO1     : IN STD_LOGIC;							 	   --SENSOR 2
	        SALIDA     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 	--Variable guardado de pulsos (diferencia)
			  LEVEL      : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			  LTX        : OUT  STD_LOGIC_VECTOR (7 downto 0);
			  R          : IN STD_LOGIC ;  								--Reset
			  SOLENOIDE1 : OUT std_logic;						 			--Estado de solenoide de entrada tanque
			  SOLENOIDE2 : OUT std_logic;						 			--Estado de solenoide de salida tanque
			  SOLENOIDE3 : OUT std_logic;						 			--Estado de solenoide de entrada directa (FC)al calentador
		--   SOLENOIDE4 : OUT std_logic;						 			--Estado de solenoide de salida del calentador una vez finalizado el proceso de calentamiento
			  BOMBA      : OUT std_logic;					    			--Estado de bomba(on/ off)
	  	--   BOMBA2     : OUT std_logic;					    			--Estado de bomba2(on/ off)			  
			  FWYN       : IN std_logic								   --FLOWING WATER (YES OR NO)/ Hay o no Agua?
			  );
end PROCESO_LL_VA;

architecture Behavioral of PROCESO_LL_VA is

--------------------------------------
--MODULO: CONTADOR DE PULSOS----------

	COMPONENT ContadorBCD													
	PORT(
		MHZ50  : IN std_logic;												--	Señal de reloj
		PULSO  : IN std_logic;
		R      : IN std_logic;          
		SALIDA : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
COMPONENT Binary_To_BCD_16b
	PORT(
		Conv_BCD : IN std_logic_vector(15 downto 0);          
		BCD      : OUT std_logic_vector(18 downto 0)
		  );
	END COMPONENT;
	
	COMPONENT X7seg
	PORT(
		x   : IN std_logic_vector(15 downto 0);
		clk : IN std_logic;
		clr : IN std_logic;          
		an  : OUT std_logic_vector(3 downto 0);
		a_to_g : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;
	
---------------------------------------------------
---MODULO: DIVISION CONFIGURABLE PARA "N" BITS----
	
	COMPONENT division
	PORT(
		reset : IN std_logic;
		en    : IN std_logic;
		clk   : IN std_logic;
		num   : IN std_logic_vector(15 downto 0);
		den   : IN std_logic_vector(15 downto 0);          
		res   : OUT std_logic_vector(15 downto 0);
		rm    : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;
	
	
---------------------------------------
-------------SEÑALES-------------------

	
	SIGNAL S1				: std_logic_vector(15 downto 0);  --SALIDA MODULO 1 
	SIGNAL S2				: std_logic_vector(15 downto 0);  --SALIDA MODULO 2
	SIGNAL S3				: std_logic_vector(15 downto 0);  --SALIDA TOTAL
	SIGNAL Nivel			: std_logic_vector(15 downto 0);  --ENTRADA AL MODULO BCD PARA VARIABLE "NIVELES" 
	SIGNAL OUTNivelbcd	: std_logic_vector(18 downto 0);	 --SALIDA DEL MODULO BCD PARA VARIABLE "NIVELES"
   SIGNAL OUTLitrosbcd  : std_logic_vector(18 downto 0);	 --SALIDA DEL MODULO BCD PARA VARIABLE "LITROS"
	SIGNAL X					: std_logic_vector(15 downto 0);  --VARIABLE DE ENTRADA PARA RECEPCIONAR LOS DATOS HACIA 7SEG
	SIGNAL Litros			: std_logic_vector(15 downto 0);  --COCIENTE CANTIDAD DE LITRO
	SIGNAL RLitros			: std_logic_vector(15 downto 0);  --RESIDUO DE CANTIDAD DE LITRO
--	SIGNAL RLitros1		: std_logic_vector(15 downto 0);
--	SIGNAL RLitros2		: std_logic_vector(15 downto 0);
	SIGNAL Niveles			: std_logic_vector(2  downto 0); --RECEPCIONA VARIABLE DE NIVELES PARA SER CONCATENADA
	SIGNAL T  				: std_logic_vector(2  downto 0);	--VARIABLE QUE ENMARCA LOS NIVELES DEL TANQUE
	SIGNAL denlitro		: std_logic_vector(15 downto 0); --RAZON DE CONVERSION DE LOS PULSOS 
--	SIGNAL denlitro1		: std_logic_vector(15 downto 0);
--	SIGNAL denlitro2		: std_logic_vector(15 downto 0);
-- SIGNAL LIT				: std_logic_vector(15 downto 0);
	SIGNAL SOLE1			: std_logic;							--SOLENOIDE N#1
	SIGNAL SOLE2			: std_logic;							--SOLENOIDE N#2
	SIGNAL PUMP				: std_logic;							--SEÑAL QUE PERMITE EL ENCENDIDO DE LA BOMBA
	SIGNAL SOLE3			: std_logic;							--SOLENOIDE N#3

	


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

begin
S3       <= S1-S2;										   --DIFERENCIA ENTRE LA CANTIDAD DE PULSOS DE AMBOS SENSORES DE FLUJO
SALIDA   <= S3;														
Nivel    <= "0000000000000" & Niveles;					--CONCATENACION PARA OBTENER VARIABLE DE 16 BITS HACIA CONVERTIDOR BCD
denlitro <= "0000000101111100";						   -- 380 PULSOS EQUIVALENTES A 1 LITRO
LEVEL <= Niveles;
----LAS SIGUIENTES VARIABLES SON SALIDAS DEL TOP                ---
----POR TAL RAZON SE DECLARAN SEÑALES PARA INGRESAR AL PROCESO  ---
SOLENOIDE1 <= SOLE1;
SOLENOIDE2 <= SOLE2;
BOMBA      <= PUMP;
SOLENOIDE3 <= SOLE3;

LTX <= Litros(7 downto 0) ;

--LIT<=Litros1-Litros2;

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------



process (FWYN,S3,Niveles,T,SOLE1,SOLE2,PUMP)			---VARIABLES INVOLUCRADAS EN EL PROCESO



begin


Niveles <= T; 													---VARIABLE QUE ENMARCA LOS NIVELES DEL TANQUE


if    (S3 = "0000000000000000" OR S3 < "0000011111000110") then  --Nivel 0 -> 0-5   Litros

T <= "000";
elsif (S3 = "0000011111000110" OR S3 < "0000111110001100") then  --Nivel 1 -> 5-10  Litros

T <= "001";
elsif (S3 = "0000011111000110" OR S3 < "0001011101010010") then  --Nivel 2 -> 10-15 Litros

T <= "010";
elsif (S3 = "0001011101010010" OR S3 < "0001111100011000") then  --Nivel 3 -> 15-20 Litros

T <="011";
elsif (S3 = "0001111100011000" OR S3 <="0010011011011110") then  --Nivel 4 -> 20-...Litros
T <="100";

end if;
--
----SENTENCIAS LOGICAS QUE DEFINEN EL COMPORTAMIENTO DEL SISTEMA-----

	 								
	 if (FWYN = '1') then 						-----SI HAY AGUA-----
	 if (Niveles = "000") then					-----SI ESTA EN EL PRIMER NIVEL (0)----
	 SOLE1 <= '1';
	 SOLE2 <= '0';
	 SOLE3 <= '1';
	 PUMP  <= '1';
	 
	 elsif (Niveles = "001") then				-----SI ESTA EN EL SEGUNDO NIVEL (1)----
	 SOLE1 <= '1';
	 SOLE2 <= '0';
	 SOLE3 <= '1';
	 PUMP  <= '1';
	 
	 elsif (Niveles = "010") then			   -----SI ESTA EN EL TERCER NIVEL (2)----
	 SOLE1 <= '1';
	 SOLE2 <= '0';
	 SOLE3 <= '1';
	 PUMP  <= '1';
	 
	 elsif (Niveles = "011") then      		-----SI ESTA EN EL CUARTO NIVEL (3)----
	 SOLE1 <= '1';
	 SOLE2 <= '0';
	 SOLE3 <= '1';
	 PUMP  <= '1';
	 
	 elsif (Niveles = "100") then				-----SI ESTA EN EL QUINTO NIVEL (4) ----
	 SOLE1 <= '0';
	 SOLE2 <= '0';
	 SOLE3 <= '1';
	 PUMP  <= '0';
	 end if;
	 
	 ---CUANDO NO SE CUMPLE LA CONDICION "HAY AGUA"----
	 
	 else 
	 
	 if (Niveles = "000") then
	 SOLE1 <= '1';    -----SOLENOIDE 1 SE MANTIENE ENCENDIDA PARA NO AFECTAR EL SENSADO DE FWYN
	 SOLE2 <= '0';
	 SOLE3 <= '0';
	 PUMP  <= '0';		-----LA BOMBA SE APAGA
	 
	--CUANDO NO SE CUMPLE LA CONDICION "HAY AGUA" & "HAY AGUA EN EL TANQUE"
	--ES DECIR, LOS NIVELES SON DIFERENTES DE 0.
	
	 else
	 SOLE1 <= '1';		-----SOLENOIDE 1 SE MANTIENE ENCENDIDA PARA NO AFECTAR EL SENSADO DE FWYN
	 SOLE2 <= '1';    -----SOLENOIDE 2 PERMITA LA SALIDA DEL AGUA A PARTIR DEL TANQUE
	 SOLE3 <= '0';
	 PUMP <=  '0';		-----LA BOMBA SE APAGA
	 end if;
	 end if;
end process;

	 
-------------------------------------------------------------------
-----VALOR MOSTRADO EN LOS 7SEG------------------------------------

X( 3 downto 0 ) <= OUTNivelbcd(3 downto 0);     ---MUESTRA EL NIVEL EN EL QUE SE ENCUNETRA EL AGUA
X( 7 downto 4 ) <= "1010";     						--MONSTRANDO LA LETRA  "L" EN 7SEG
X( 11 downto 8 ) <=  OUTLitrosbcd(3 downto 0);
X( 15 downto 12 ) <= OUTLitrosbcd(7 downto 4);


------------INSTANCIAS QUE VAN HACIA LOS DIFERENTES MODULOS----------------

	CONTADOR1: ContadorBCD PORT MAP(
		MHZ50 => MHZ50,
		PULSO => PULSO,
		SALIDA => S1,
		R => R
	);
	
	CONTADOR2: ContadorBCD PORT MAP(
	   MHZ50 => MHZ50,
		PULSO => PULSO1,
		SALIDA => S2,
		R => R
	);
	
	Binary_BCD1: Binary_To_BCD_16b PORT MAP(
		Conv_BCD => Litros,
		BCD => OUTLitrosbcd
		);
	

	Binary_BCD2: Binary_To_BCD_16b PORT MAP(
		Conv_BCD => Nivel,
		BCD => OUTNivelbcd
	);

	seg: X7seg PORT MAP(
		x => X,
		clk => MHZ50,
		clr => R,
		an => SEL7,
		a_to_g =>SEG7 
	);

	div: division PORT MAP(
		reset => R,
		en => '1', 
		clk => MHZ50,
		num => S3,
		den => denlitro,
		res => Litros,  --Cociente
		rm => RLitros   --Residuo
	);
	
	
end Behavioral;


