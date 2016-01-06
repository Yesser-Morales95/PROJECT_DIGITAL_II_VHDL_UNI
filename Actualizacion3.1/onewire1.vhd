----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:03:19 11/24/2015 
-- Design Name: 
-- Module Name:    onewire1 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity temp is
	port(
			DQ		    :inout STD_LOGIC;  					
			inclk       :in std_logic;						 
			current_temp:out std_logic_vector(10 downto 0); 
			clr :in std_logic;
			an : OUT std_logic_vector(3 downto 0);
		   a_to_g : OUT std_logic_vector(6 downto 0);
			Leds:out std_logic_vector(7 downto 0)
		);
end entity;

architecture Behavior of temp is

	
	constant cmd_0xcc_0x44:std_logic_vector(15 downto 0):="00110011"&"00100010";   
	constant cmd_0xcc_0xbe:std_logic_vector(15 downto 0):="00110011"&"01111101";  
	signal temp1,temp2:std_logic_vector(7 downto 0);    
	signal nflag:std_logic;   
	signal clk:std_logic;  
	signal count:std_logic_vector(4 downto 0); 
	signal A:std_logic_vector(9 downto 0);
	signal temper: std_logic_vector(10 downto 0);
	SIGNAL X :  std_logic_vector(15 downto 0); 
	SIGNAL point_out :  std_logic_vector(7 downto 0);
   SIGNAL output :  std_logic_vector(7 downto 0);

   SIGNAL Y1 :  std_logic_vector(7 downto 0);
	signal H7:std_logic_vector(6 downto 0);
	
--	COMPONENT DIVISOR_FREQ
--	PORT(
--		mclk : IN std_logic;
--		clr : IN std_logic;          
--		clkuser : OUT std_logic
--		);
--	END COMPONENT;

	
	

--	COMPONENT Binary_BCD
--	PORT(
--		b : IN std_logic_vector(7 downto 0);          
--		p : OUT std_logic_vector(9 downto 0)
--		);
--	END COMPONENT;
	
--	COMPONENT X7seg
--	PORT(
--		x : IN std_logic_vector(15 downto 0);
--		clk : IN std_logic;
--		clr : IN std_logic;          
--		an : OUT std_logic_vector(3 downto 0);
--		a_to_g : OUT std_logic_vector(6 downto 0)
--		);
--	END COMPONENT;
	
	begin
	

	


--	U1: X7seg PORT MAP(
--		x => X,
--		clk => inclk,
--		clr => clr,
--		an => an,
--		a_to_g => a_to_g
--	);
	

--	U2: Binary_BCD PORT MAP(
--		b => Y1,
--		p =>A 
--	);


--Y1 <= "0" & temper(10 downto 4);

--Decimales
X( 3 downto 0 ) <=  point_out(3 downto 0);
X( 7 downto 4 ) <=  point_out(7 downto 4);
--Enteros
X( 11 downto 8 ) <= output(3 downto 0)  ;
X( 15 downto 12) <= output(7 downto 4)  ;
	
	Leds <= temp1;
	
		H7(6 downto 0) <= temper(10 downto 4);
		
		with H7(5 downto 0) select
				output <= "0000"&"0000" when "000000",--0
						  "0000"&"0001" when "000001",--1
						  "0000"&"0010" when "000010",--2
						  "0000"&"0011" when "000011",--3
						  "0000"&"0100" when "000100",--4
						  "0000"&"0101" when "000101",--5
						  "0000"&"0110" when "000110",--6
						  "0000"&"0111" when "000111",--7
						  "0000"&"1000" when "001000",--8
						  "0000"&"1001" when "001001",--9
						  
						  "0001"&"0000" when "001010",--10					  
						  "0001"&"0001" when "001011",--11
						  "0001"&"0010" when "001100",--12
						  "0001"&"0011" when "001101",--13
						  "0001"&"0100" when "001110",--14
						  "0001"&"0101" when "001111",--15
						  "0001"&"0110" when "010000",--16
						  "0001"&"0111" when "010001",--17
						  "0001"&"1000" when "010010",--18
						  "0001"&"1001" when "010011",--19
						  
						  "0010"&"0000" when "010100",--20					  
						  "0010"&"0001" when "010101",--21
						  "0010"&"0010" when "010110",--22
						  "0010"&"0011" when "010111",--23
						  "0010"&"0100" when "011000",--24
						  "0010"&"0101" when "011001",--25
						  "0010"&"0110" when "011010",--26
						  "0010"&"0111" when "011011",--27
						  "0010"&"1000" when "011100",--28
						  "0010"&"1001" when "011101",--29
						  
						  "0011"&"0000" when "011110",--30					  
						  "0011"&"0001" when "011111",--31
						  "0011"&"0010" when "100000",--32
						  "0011"&"0011" when "100001",--33
						  "0011"&"0100" when "100010",--34
						  "0011"&"0101" when "100011",--35
						  "0011"&"0110" when "100100",--36
						  "0011"&"0111" when "100101",--37
						  "0011"&"1000" when "100110",--38
						  "0011"&"1001" when "100111",--39
						  
						  "0100"&"0000" when "101000",--40					  
						  "0100"&"0001" when "101001",--41
						  "0100"&"0010" when "101010",--42
						  "0100"&"0011" when "101011",--43
						  "0100"&"0100" when "101100",--44
						  "0100"&"0101" when "101101",--45
						  "0100"&"0110" when "101110",--46
						  "0100"&"0111" when "101111",--47
						  "0100"&"1000" when "110000",--48
						  "0100"&"1001" when "110001",--49
						  
						  "0101"&"0000" when "110010",--50					  
						  "0101"&"0001" when "110011",--51
						  "0101"&"0010" when "110100",--52
						  "0101"&"0011" when "110101",--53
						  "0101"&"0100" when "110110",--54
						  "0101"&"0101" when "110111",--55
						  "0101"&"0110" when "111000",--56
						  "0101"&"0111" when "111001",--57
						  "0101"&"1000" when "111010",--58
						  "0101"&"1001" when "111011",--59
						  
						  "0110"&"0000" when "111100",--60					  
						  "0110"&"0001" when "111101",--61
						  "0110"&"0010" when "111110",--62
						  "0110"&"0011" when "111111",--63	  
						  "0000"&"0011" when others;	
						  
	
	
	
	with temper(3 downto 0) select				  
		  point_out<= "0000"&"0000" when "0000",--0
						  "0000"&"0110" when "0001",--0.0625
						  "0001"&"0010" when "0010",--0.125
						  "0001"&"1001" when "0011",--0.1875 =0.19
						  "0010"&"0101" when "0100",--0.25
						  "0011"&"0101" when "0101",--0.31
						  "0011"&"1000" when "0110",--0.375  =0.38
						  "0100"&"0100" when "0111",--0.4375 =0.44
						  "0101"&"0000" when "1000",--0.5
						  "0101"&"0110" when "1001",--0.5625
						  "0110"&"0011" when "1010",--0.625 =0.63
						  "0110"&"1001" when "1011",--0.6875 =0.69
						  "0111"&"0101" when "1100",--0.75
						  "1000"&"0001" when "1101",--0.8125
						  "1000"&"1000" when "1110",--0.875	 =0.88
						  "1001"&"0100" when "1111",--0.9375	 =0.94	
						  "0000"&"0000" when others;		  	
	

	
		process(inclk)
		begin
			if rising_edge(inclk) then	
				if (count="11010") then --1MHZ
					clk<=not clk;
					count<="00000";
				else
					count<=count+1;
				end if;
			end if;
		end process;

	process(clk)
		variable count1:std_logic_vector(10 downto 0);  
		variable count2:std_logic_vector(9 downto 0);   
		variable count3:std_logic_vector(7 downto 0);   
		variable i:integer range -1 to 15:=15;   
		variable init:integer range 0 to 1:=0;   
		variable j:integer range 0 to 8:=0;      
		variable k:integer range 0 to 1:=0;      
		variable state:integer range 0 to 2:=0;   
		variable temp:std_logic_vector(7 downto 0);
		begin
			if rising_edge(clk) then
				if state=0 then
					if init=1 then  
						count2:=count2+1;
					if count2="0000000001" then   
						DQ<='0';
					elsif count2="0000001100" then   
						DQ<=cmd_0xcc_0x44(i);
					elsif count2="0001011010" then  
						DQ<='1';
					elsif count2="1010110100" then   
						count2:="0000000000";   
						i:=i-1;   
						if i=-1 then   
							i:=15;init:=0;state:=1;
						end if;
					end if;
				else   
					count1:=count1+1;
					if count1="000000000001" then
						DQ<='1';
					elsif count1="000000000011" then   
						DQ<='0';
					elsif count1="01010111100" then   
						DQ<='1';
					elsif count1="01011011010" then   
						DQ<='Z';
					elsif count1="01111001010" then   
						DQ<='1';
					elsif count1="10000000000" then   
						init:=1;
						count1:="00000000000";   
					end if;
				end if;
			elsif (state=1) then   
				if init=1 then
					count2:=count2+1;
					if count2="0000000001" then
						DQ<='0';
					elsif count2="0000001100" then
						DQ<=cmd_0xcc_0xbe(i);
					elsif count2="0001011010" then
						DQ<='1';
					elsif count2="0001011100" then
						count2:="0000000000";
						i:=i-1;
						if i=-1 then
							i:=15;
							init:=0;
							state:=2;
						end if;
					end if;
				else
					count1:=count1+1;
					if count1="000000000001" then
						DQ<='1';
					elsif count1="000000000011" then  
						DQ<='0';
					elsif count1="01010111100" then   
						DQ<='1';
					elsif count1="01011011010" then  
						DQ<='Z';
					elsif count1="01111001010" then   
						DQ<='1';
					elsif count1="10000000000" then   
						init:=1;
						count1:="00000000000";   
					end if;
				end if;
			else    
				if k=0 then   
					count3:=count3+1;
					if count3="00000001" then
						DQ<='0';
					elsif count3="00000100" then   
					DQ<='Z';
					elsif count3="00001101" then   
						temp(j):=DQ;
					elsif count3="01010000" then   
						DQ<='1';
					elsif count3="01010010" then   
						count3:="00000000";
						j:=j+1;   
						if j=8 then   
							j:=0;   
							k:=1;   
							temp1<=temp;
						end if;
					end if;
				else   
					count3:=count3+1;
						if count3="00000001" then
							DQ<='0';
						elsif count3="00000100" then
							DQ<='Z';
						elsif count3="00001101" then
							temp(j):=DQ;
						elsif count3="01010000" then
							DQ<='1';
						elsif count3="01010010" then
							count3:="00000000";
							j:=j+1;
							if j=8 then
								j:=0;
								k:=0;
								state:=0;   
								if (temp and "11111000")="11111000" then   
									temp:=(not temp);
									temp1<=(not temp1)+1;
								if temp1="0000000" then 
									temp:=temp+1;
								end if;
									nflag<='1';   
								else
									nflag<='0';
								end if;
							current_temp<=temp(2 downto 0) & temp1;   
							     temper <=temp(2 downto 0) & temp1;

							end if;
						end if;
					end if;
				end if;
			end if;
			--temper <= temp(2 downto 0) & temp1;
		end process;
end  Behavior;

