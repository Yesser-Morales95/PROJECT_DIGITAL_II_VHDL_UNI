----------------------------------------------------------------------------
--	transmitControler.vhd - Submodul pro rizeni prenosu namerenych dat do PC pres RS-232
----------------------------------------------------------------------------
-- Autor:  		 			Pavel Gregar
-- Datum vytvoreni:     13:58:13 03/15/2014
-- Modul:    				transmitControler - Behavioral 
-- Projekt: 				Meteostanice
-- Cilove zarizeni: 		Nexys4
-- Pouzite nastroje:		Xilinx 14.6
----------------------------------------------------------------------------
--
----------------------------------------------------------------------------
--	Tento submodul slouzi k rizeni prenosu namerenych dat ze senzoru pomoci seriove linky.
-- Modul ceka na odber dat z pripojenych senzoru DS18B20, DHT11 a ADT7420, 
--	cekanim na nastaveni portu sendRequest_T1, sendRequest_T2 a sendRequest_H1. Pote je 
-- vytvorena sekvence bitu k odeslani na seriovou linku pomoci submodulu UART se kterym 
-- je komunikace rizena pomoci portu parallelDataOut, txIsReady a transmitRequest. 
-- 
--         				
-- Porty modulu:
--
--		clk						- 100 MHz takt.
--		enable					- Spusteni vysilani dat (aktivni v log. 1).
--		transmit_enable_LED 	- Indikace LED vysilani pres RS-232 do PC.
--		sendRequest_T1			- Pouziva se k indikaci prichodu novych dat na portu data_in_T1. Predchozi modul 
--									  by mel nastavit tento signal na jeden takt do logicke 1.			  
--		data_in_T1				- Vstupni data ze senzoru teploty DS18B20.
--		sendRequest_T2			- Viz sendRequest_T1.
--		data_in_T2				- Vstupni data ze senzoru teploty ADT7420.
--		sendRequest_H1			- Viz sendRequest_T1.
--		data_in_H1				- Vstupni data ze senzoru vlhkosti DHT11.
--		parallelDataOut		- Odesilany bajt data pro submodul UART.
--		transmitRequest		- Pouziva se k indikaci zadosti o spusteni vysilani dat z portu parallelDataOut.
--		txIsReady				- Kontrola pripravenosti submodulu UART k odeslani bajtu dat.
--
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity transmitControler is
    Port ( clk 						: in  STD_LOGIC;
			  enable 					: in  STD_LOGIC;
			  TX1 			    		: in  STD_LOGIC;
			  TX2 			   		: in  STD_LOGIC;
			  enable_LED				: out	STD_LOGIC;
           data_in_1				: in  STD_LOGIC_VECTOR (7 downto 0);
           data_in_2 				: in  STD_LOGIC_VECTOR (7 downto 0);         
           parallelDataOut 		: out  STD_LOGIC_VECTOR (7 downto 0);
           transmitRequest 		: out  STD_LOGIC;
           txIsReady 				: in  STD_LOGIC );
end transmitControler;

architecture Behavioral of transmitControler is

-- Funkce pro prevod dat z binarniho formatu na znak
function convertToChar(s: STD_LOGIC_VECTOR(7 downto 0)) return character is
	begin
		case (s) is
		
		when  x"00" => return NUL ;		
		when  x"01" => return SOH ;
		when  x"02" => return STX ;
		when  x"03" => return ETX ;		
		when  x"04" => return EOT ;
		when  x"05" => return ENQ ;
		when  x"06" => return ACK ;		
		when  x"07" => return BEL ;
		when  x"08" => return BS  ;
		when  x"09" => return HT  ;		
		when  x"0A" => return LF  ;
		when  x"0B" => return VT  ;
		when  x"0C" => return FF  ;
		when  x"0D" => return CR  ;		
		when  x"0E" => return SO  ;
		when  x"0F" => return SI  ;
		when  x"10" => return DLE ;
		when  x"11" => return DC1 ;
		when  x"12" => return DC2 ;
		when  x"13" => return DC3 ;
		when  x"14" => return DC4 ;
		when  x"15" => return NAK ;
		when  x"16" => return SYN ;
		when  x"17" => return ETB ;
		when  x"18" => return CAN ;
		when  x"19" => return EM  ;
		when  x"1A" => return SUB ;
		when  x"1B" => return ESC ;
		when  x"1C" => return FSP  ;
		when  x"1D" => return GSP  ;
		when  x"1E" => return RSP  ;
		when  x"1F" => return USP  ;
		
		
		
		when  x"20" => return ' ' ;		
		when  x"21" => return '!' ;
		when  x"23" => return '#' ;
		when  x"24" => return '$' ;
		when  x"25" => return '%' ;
		when  x"26" => return '&' ;
		when  x"27" => return ''' ;
      when  x"28" => return '(' ;
      when  x"29" => return ')' ;
		when  x"2A" => return '*' ;
	   when  x"2B" => return '+' ;
		when  x"2C" => return ',' ;
	   when  x"2D" => return '-' ;
		when  x"2E" => return '.' ;
		when  x"2F" => return '/' ;

		when  x"30" => return '0' ;
		when  x"31" => return '1' ;
		when  x"32" => return '2' ;
		when  x"33" => return '3' ;
		when  x"34" => return '4' ;
		when  x"35" => return '5' ;
		when  x"36" => return '6' ;
		when  x"37" => return '7' ;
		when  x"38" => return '8' ;
		when  x"39" => return '9' ;
		when  x"3A" => return ':' ;
		when  x"3B" => return ';' ;
		when  x"3C" => return '<' ;
		when  x"3D" => return '=' ;
		when  x"3E" => return '>' ;
		when  x"3F" => return '?' ;
		
		when  x"40" => return '@' ;
		when  x"41" => return 'A' ;
		when  x"42" => return 'B' ;
		when  x"43" => return 'C' ;
		when  x"44" => return 'D' ;
		when  x"45" => return 'E' ;
		when  x"46" => return 'F' ;
		when  x"47" => return 'G' ;
		when  x"48" => return 'H' ;
		when  x"49" => return 'I' ;
		when  x"4A" => return 'J' ;
		when  x"4B" => return 'K' ;
		when  x"4C" => return 'L' ;
		when  x"4D" => return 'M' ;
		when  x"4E" => return 'N' ;
		when  x"4F" => return 'O' ;
		when  x"50" => return 'P' ;
		when  x"51" => return 'Q' ;
		when  x"52" => return 'R' ;
		when  x"53" => return 'S' ;
		when  x"54" => return 'T' ;
		when  x"55" => return 'U' ;
		when  x"56" => return 'V' ;
		when  x"57" => return 'W' ;
		when  x"58" => return 'X' ;
		when  x"59" => return 'Y' ;
		when  x"5A" => return 'Z' ;
		when  x"5B" => return '[' ;
		when  x"5C" => return '\' ;
		when  x"5D" => return ']' ;
		when  x"5E" => return '^' ;
		when  x"5F" => return '_' ;

		when  x"60" => return '`' ;
		when  x"61" => return 'a' ;
		when  x"62" => return 'b' ;
		when  x"63" => return 'c' ;
      when  x"64" => return 'd' ;
		when  x"65" => return 'e' ;
	   when  x"66" => return 'f' ;
		when  x"67" => return 'g' ;
		when  x"68" => return 'h' ;
		when  x"69" => return 'i' ;
      when  x"6A" => return 'j' ;
		when  x"6B" => return 'k' ;
		when  x"6C" => return 'l' ;
		when  x"6D" => return 'm' ;
		when  x"6E" => return 'n' ;
		when  x"6F" => return 'o' ;
      when  x"70" => return 'p' ;
		when  x"71" => return 'q' ;
		when  x"72" => return 'r' ;
		when  x"73" => return 's' ;
		when  x"74" => return 't' ;
		when  x"75" => return 'u' ;
		when  x"76" => return 'v' ;
		when  x"77" => return 'w' ;
		when  x"78" => return 'x' ;
		when  x"79" => return 'y' ;
		when  x"7A" => return 'z' ;
		when  x"7B" => return '{' ;
		when  x"7C" => return '|' ;
		when  x"7D" => return '}' ;
		when  x"7E" => return '~' ;
		
		when others => return NUL;
		end case;
	end convertToChar;

-- pouzite stavy FSM
TYPE controlerState IS (IDLE, PREPARE_SEQUENCE, PREPARE_CHAR, SEND_CHAR);
-- momentalni stav FSM
SIGNAL ctrl_state		: controlerState;

-- navzorkovana data ze senzoru T1: DS18B20
--										  T2: ADT7420
--										  H1: DHT11
--										  H2: DHT22
SIGNAL dataToSend_T1		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL dataToSend_T2		: STD_LOGIC_VECTOR(7 DOWNTO 0);
--SIGNAL dataToSend_H1		: STD_LOGIC_VECTOR(12 DOWNTO 0);
--SIGNAL dataToSend_H2		: STD_LOGIC_VECTOR(12 DOWNTO 0);

-- priznaky prichodu dat ze senzoru T1: DS18B20
--										 	   T2: ADT7420
--												H1: DHT11
--												H2: DHT22
SIGNAL dataReady_T1		: STD_LOGIC;
SIGNAL dataReady_T2		: STD_LOGIC;
--SIGNAL dataReady_H1		: STD_LOGIC;
--SIGNAL dataReady_H2		: STD_LOGIC;

	-- konstanty pouzite v stringToSend

begin
	-- Proces pro rizeni prenosu dat pres seriovou linku
	process(clk)

	-- citac prave odesilaneho znaku
	VARIABLE char_send_cnt 		: INTEGER RANGE 0 TO 4;

	-- prave odesilany znak
	VARIABLE charToSend			: CHARACTER;

	-- sekvence dat k odeslani od jednotlivych senzoru
	VARIABLE	stringToSend		: STRING(1 TO 4);
	-- stringy obsahujici data ze senzoru
	VARIABLE stringToSend_T1	: STRING(1 to 2);
--	VARIABLE stringToSend_T2	: STRING;
--	VARIABLE stringToSend_H1	: STRING(1 TO 6);
--	VARIABLE stringToSend_H2	: STRING(1 TO 6);

	begin


		if (rising_edge(clk)) then
			if (enable = '0') then									-- vypnuti odesilani
				transmitRequest <= '0';								-- zruseni zadosti o odesilani
				parallelDataOut	<= (others => '0');			-- reset vsech dat
				charToSend			:= NUL;
				stringToSend_T1	:= (others => NUL);
--				stringToSend_T2	:= (others => NUL);
--				stringToSend_H1	:= (others => NUL);
--				stringToSend_H2	:= (others => NUL);
				stringToSend := stringToSend_T1 & CR & LF;
				ctrl_state		<=	IDLE;								-- navrat do zakladniho stavu
			else
				case (ctrl_state) is
				
				
					when IDLE =>										-- zakladni stav modulu, cekani na data ze vsech senzoru
						-- Cekani na data ze vsech senzoru
						if (dataReady_T1 = '1' and dataReady_T2 = '1') then
							char_send_cnt 	 := 0;							-- reset citace odeslanych znaku
							ctrl_state 			 <= PREPARE_SEQUENCE;	-- prechod do stavu PREPARE_SEQUENCE
						end if;
						
						
						

					when PREPARE_SEQUENCE =>						-- stav pro pripravu sekvence dat pro odeslani

							stringToSend_T1 := convertToChar(dataToSend_T1(7 downto 0)) &convertToChar(dataToSend_T2(7 downto 0)) ;
			
						
						stringToSend := stringToSend_T1 &  CR & LF; -- zapis kompletni sekvence dat k odeslani dat
						ctrl_state <= PREPARE_CHAR;	-- prechod do stavu PREPARE_CHAR
						
						
	
					when PREPARE_CHAR =>						-- stav pro pripravu seriovych dat 
						transmitRequest <= '0';				-- zruseni pozadavku na odesilani znaku
						if (char_send_cnt < 4) then		-- pocitani odeslanych znaku
							charToSend := stringToSend(char_send_cnt+1); -- vyber odesilaneho znaku
							-- konverze dat z char do std_logic_vector
							parallelDataOut <= std_logic_vector(to_unsigned(character'pos(charToSend), 8));
							char_send_cnt 	 := char_send_cnt + 1;		-- inkrementace odesilaneho bitu
							ctrl_state 			 <= SEND_CHAR;				-- prechod do stavu SEND_CHAR
						else
							transmitRequest <= '0';							-- ukonceni odesilani dat po odeslani 26 znaku
							ctrl_state 			 <= IDLE;					-- prechod do stavu IDLE
						end if;
						
						
						

					when SEND_CHAR =>											-- stav pro odesilani bajtu dat
						if (txIsReady = '1') then							-- cekani na submodul UART
							transmitRequest <= '1';							-- pozadavek na odeslani bajtu dat
							ctrl_state 			 <= PREPARE_CHAR;			-- navrat k dalsimu odesilani ve stavu PREPARE_CHAR
						end if;
				end case;
			end if;
		end if;
	end process;
	
	
	
	-- Proces pro cekani na data ze senzoru DS18B20
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (TX1 = '1') then		-- prichod dat ze senzoru teploty DS18B20
				dataToSend_T1	<= data_in_1;		-- odebrani vzorku dat ze senzoru teploty DS18B20
				dataReady_T1	<= '1';				-- nastaveni priznaku prichodu dat
			else
				if ctrl_state = PREPARE_SEQUENCE then
					dataReady_T1	<= '0';				-- zruseni priznaku prichodu dat
				end if;
			end if;
		end if;
	end process;
	
	-- Proces pro cekani na data ze senzoru ADT7420
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (TX2 = '1') then		-- prichod dat ze senzoru teploty ADT7420
				dataToSend_T2	<= data_in_2;		-- odebrani vzorku dat ze senzoru teploty ADT7420
				dataReady_T2	<= '1';				-- nastaveni priznaku prichodu dat
			else
				if ctrl_state = PREPARE_SEQUENCE then
					dataReady_T2	<= '0';			-- zruseni priznaku prichodu dat
				end if;
			end if;
		end if;
	end process;
	
--	-- Proces pro cekani na data ze senzoru DHT11
--	process(clk)
--	begin
--		if (rising_edge(clk)) then
--			if (sendRequest_H1 = '1') then		-- prichod dat ze senzoru vlhkosti DHT11
--				dataToSend_H1	<= data_in_H1;		-- odebrani vzorku dat ze senzoru vlhkosti DHT11
--				dataReady_H1	<= '1';				-- nastaveni priznaku prichodu dat
--			else
--				if ctrl_state = PREPARE_SEQUENCE then
--					dataReady_H1	<= '0';				-- zruseni priznaku prichodu dat
--				end if;
--			end if;
--		end if;
--	end process;
--	
--		-- Proces pro cekani na data ze senzoru DHT22
--	process(clk)
--	begin
--		if (rising_edge(clk)) then
--			if (sendRequest_H2 = '1') then		-- prichod dat ze senzoru vlhkosti DHT22
--				dataToSend_H2	<= data_in_H2;		-- odebrani vzorku dat ze senzoru vlhkosti DHT22
--				dataReady_H2	<= '1';				-- nastaveni priznaku prichodu dat
--			else
--				if ctrl_state = PREPARE_SEQUENCE then
--					dataReady_H2	<= '0';				-- zruseni priznaku prichodu dat
--				end if;
--			end if;
--		end if;
--	end process;
--	
--	enable_LED <= '1' when enable = '1' else '0';
--	
end Behavioral;