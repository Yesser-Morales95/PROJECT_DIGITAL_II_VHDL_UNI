----------------------------------------------------------------------------------
--.########..####..######...####.########....###....##..........####..#### 
--.##.....##..##..##....##...##.....##......##.##...##...........##....##.
--.##.....##..##..##.........##.....##.....##...##..##...........##....##.
--.##.....##..##..##...####..##.....##....##.....##.##...........##....##.
--.##.....##..##..##....##...##.....##....#########.##...........##....##.
--.##.....##..##..##....##...##.....##....##.....##.##...........##....##.
--.########..####..######...####....##....##.....##.########....####..#### 





-- 

-- Company: 		   		UNI

-- Engineer/students: 		Yeser Morales
--									Keller Jiron
--									Jarib Castillo
--									Jonathan Fuentes

-- Create Date:    15:39:13 12/04/2015 
-- Design Name: 
-- Module Name:       TOP_PROJECT - Behavioral 
-- Project Name: 	    ELEK.DIGITAL II
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
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Actualizacion3P1 is

 Port ( 	  MHZ50      : IN  STD_LOGIC;							 		--Señal de reloj
           SEG7       : OUT STD_LOGIC_VECTOR (6 downto 0);  	--7 segmentos
           SEL7       : OUT STD_LOGIC_VECTOR (3 downto 0);  	--Anodo
     	     PULSO      : IN  STD_LOGIC; 							 		--SENSOR FLUJO 1
			  PULSO1     : IN  STD_LOGIC;							 	   --SENSOR FLUJO 2
	        SALIDA     : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 	--Variable guardado de pulsos (diferencia)
			  R          : IN  STD_LOGIC ;  								--Reset o KEY
			  SOLENOIDE1 : OUT std_logic;						 			--Estado de solenoide de entrada
			  SOLENOIDE2 : OUT std_logic;						 			--Estado de solenoide de salida
			  SOLENOIDE3 : OUT std_logic;									--Estado de solenoide de entrada directa si hay agua
			  SOLENOIDE4 : OUT std_logic;									--Estado de solenoide de salida del calentdor del agua
			  BOMBA      : OUT std_logic;					    			--Estado de bomba(on/ off)
			  BOMBA2     : OUT std_logic;					    			--Estado de bomba2(on/ off) salida de agua al usuario
			  FWYN       : IN  std_logic;								   --FLOWING WATER (YES OR NO)/ Hay o no Agua?
			  LEDR		 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			  UART_TXD	 : OUT STD_LOGIC;
   		  UART_RXD	 : IN  STD_LOGIC;
			  TXD        : OUT STD_LOGIC;
			  RXD        : IN  STD_LOGIC;
			  HEATER     : OUT STD_LOGIC;
			  SW		    : IN  STD_LOGIC;
			  TX1 			    		: in  STD_LOGIC;
			  TX2 			   		: in  STD_LOGIC;
			  DQ : INOUT std_logic  
			  );


end Actualizacion3P1;

architecture Behavioral of Actualizacion3P1 is


COMPONENT DS18B20
	PORT(
		clk1m : IN std_logic;    
		ds_data_bus : INOUT std_logic;      
		crc_en : OUT std_logic;
		dataOut : OUT std_logic_vector(71 downto 0)
		);
	END COMPONENT;
	
	COMPONENT divider1MHz
	PORT(
		clk_in : IN std_logic;          
		clk_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT CRC
	PORT(
		clk : IN std_logic;
		data_en : IN std_logic;
		dataIn : IN std_logic_vector(71 downto 0);          
		dataOut : OUT std_logic_vector(15 downto 0);
		dataValid : OUT std_logic
		);
	END COMPONENT;
	
COMPONENT PROCESO_LL_VA
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
	
	COMPONENT UARTPCFULL
	PORT(
		clk : IN std_logic;
		enable : IN std_logic;
		TX1 			    		: in  STD_LOGIC;
	   TX2 			   		: in  STD_LOGIC;
		data_in_1 : IN std_logic_vector(7 downto 0);
		data_in_2 : IN std_logic_vector(7 downto 0); 
		UARTRX : IN std_logic;
		DATAOUT : OUT std_logic_vector(7 downto 0);		
		enable_LED : OUT std_logic;
		UARTTX : OUT std_logic
		);
	END COMPONENT;

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
---------------------------------------------------------------------	
	signal TMP        : std_logic_vector(10 downto 0);
	signal ESTADOTEMP : std_logic;
   signal clk1       : std_logic;
	signal LEVELTX		: std_logic_vector(2 downto 0);
	signal TXSTATE		: std_logic_vector(7 downto 0);
	signal TXLEVEL		: std_logic_vector(7 downto 0);
	signal TXLITRO		: std_logic_vector(7 downto 0);
	signal TXLITROS	: std_logic_vector(7 downto 0);
	signal RXTEMPPC 	: std_logic_vector(7 downto 0);
	signal RXTEMPAPP 	: std_logic_vector(7 downto 0);
	signal SRXTEMPPC  : std_logic_vector(7 downto 0);
	
	signal ORRXTEMP  : std_logic_vector(7 downto 0);

	
	signal SRXTEMPAPP : std_logic_vector(7 downto 0);
	signal TOUARTPC   : std_logic;                     -- Solo puede estar activa una Recepción a la vez
   signal WATCHDOGRX   : std_logic;                     -- Solo puede estar activa una Recepción a la vez


--	signal RXTEMPX  	: std_logic_vector(7 downto 0);

	signal GRADOS  	: std_logic_vector(7 downto 0);
---------------------------------------------------------------------
	signal TFWYN      : std_logic;
	signal TLEVEL  	: std_logic_vector(2 downto 0);
	SIGNAL SOLE4		: std_logic;							--SOLENOIDE N#4
	SIGNAL PUMP2		: std_logic;							--SEÑAL QUE PERMITE EL ENCENDIDO DE LA BOMBA2
	

---------------TEMPERATURA-------------------------------------------	
	SIGNAL CLK1MHZ	   : STD_LOGIC;
	SIGNAL DOK   		: STD_LOGIC;
	signal REQUEST 	: STD_LOGIC;
	SIGNAL DATA   	   : STD_LOGIC_VECTOR(71 downto 0);
	SIGNAL DATA16  	: STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL DATA12 	   : STD_LOGIC_VECTOR(11 downto 0);
	SIGNAL DATA4  	   : STD_LOGIC_VECTOR(3 downto 0);
----------------------------------------------------------------------
begin
--RXTEMPX <="00101101";



WATCHDOGRX <= TOUARTPC;
------VARIABLES PARA EL PROCESO DE TRANSMISION-----------
TXLEVEL <= "01000" & LEVELTX; --CONCATENACION DE VARIABLE  NIVELES A TRANSMITIR APP SMARTPHONE
TXLITRO <= TXLITROS;          --VARIABLE A TRANSMITIR UART LABVIEW

-----ASIGNACION DE LA VARIABLE DE SALIDA DEL CALENTADOR------
HEATER <= ESTADOTEMP;

------VARIABLES PARA EL PROCESO DE APERTURA DE BOMBA2 Y SOLENOIDE 4-----------
TFWYN      <=FWYN;
TLEVEL	  <= LEVELTX;
SOLENOIDE4 <= SOLE4;
BOMBA2     <= PUMP2;
------------------------------------------------------------------------------
DATA12 <= DATA(15 downto 4); -- 0000 XXXX XXXX	TEMPERATURA MEDIDA POR EL SENSOR DS18B20

ORRXTEMP <= (SRXTEMPPC OR SRXTEMPAPP);


-----CALENTAMIENTO AGUA----
Process(DATA12, ESTADOTEMP, TFWYN,TLEVEL,ORRXTEMP)
begin



if ((DATA12 > ORRXTEMP ) ) THEN
ESTADOTEMP <= '0';


elsif ((TFWYN = '1' OR TLEVEL > "000")) THEN
ESTADOTEMP <= '1';
SOLE4      <= '0';
PUMP2      <= '0';
else
ESTADOTEMP <= '0';
SOLE4      <= '0';
PUMP2      <= '0';
end if;

if(ESTADOTEMP = '0' AND (TFWYN = '1' OR TLEVEL > "000")) THEN
SOLE4      <= '1';
PUMP2      <= '1';
else
SOLE4      <= '0';
PUMP2      <= '0';

end if;


END PROCESS;

------------------------------------------------------------------------------
---------PROCESO DE VERIFICACION DE ENTRADA DE VARIABLES DE LA PC Y APP-------
Process(RXTEMPPC, RXTEMPAPP,WATCHDOGRX, ORRXTEMP)
begin

IF (RXTEMPAPP(7) = '1' ) THEN
SRXTEMPPC <= "00000000" ;
SRXTEMPAPP <= '0' & RXTEMPAPP(6 downto 0);


ELSE

SRXTEMPAPP <= "00000000";
SRXTEMPPC <= RXTEMPPC;



END IF;

END PROCESS;

------------------------------------------------------------------------------


		U1: PROCESO_LL_VA PORT MAP(
		MHZ50 => MHZ50,
		SEG7 => SEG7,
		SEL7 => SEL7,
		PULSO => PULSO,
		PULSO1 => PULSO1,
		SALIDA => SALIDA,
		LEVEL => LEVELTX,
		LTX =>TXLITROS,
		R => R,
		SOLENOIDE1 => SOLENOIDE1,
		SOLENOIDE2 => SOLENOIDE2,
		SOLENOIDE3 => SOLENOIDE3,
		BOMBA => BOMBA,
		FWYN => FWYN
	);
	
	
	   U3: BluetoothRX PORT MAP(
		Rx => RXD,
		clk => MHZ50,
		clr => R,
		NIVELES => TXLEVEL,
		TEMP => RXTEMPAPP,
		RX_IN => TOUARTPC,
		Tx => TXD
	);
--	

      U4: UARTPCFULL PORT MAP(
		clk => MHZ50,
		enable => SW,
		TX1    				=> TX1,
		TX2    				=> TX2,
		enable_LED => LEDR(7),
		data_in_1 => DATA12(7 DOWNTO 0),
		data_in_2 => "00010010",
		DATAOUT => RXTEMPPC,
		UARTRX => UART_RXD,
		UARTTX  => UART_TXD
	);
	
		U6: DS18B20 PORT MAP(
		clk1m => CLK1MHZ,
		crc_en => DOK,
		dataOut => DATA,
		ds_data_bus => DQ
	);

	U7: divider1MHz PORT MAP(
		clk_in => MHZ50,
		clk_out => CLK1MHZ
	);

	U8: CRC PORT MAP(
		clk => CLK1MHZ,
		data_en => DOK,
		dataIn => DATA,
		dataOut => DATA16,
		dataValid =>REQUEST 
	);



end Behavioral;
