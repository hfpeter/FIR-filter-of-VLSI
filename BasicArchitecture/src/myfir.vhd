library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

use work.tp.all;

--data 16 bit come from data_maker the 4th port
entity myfir is
  port (
	clk : in  std_logic;
	RST_n     : in std_logic;
	din   : in std_logic_vector(11 downto 0);
	VIN: in std_logic;--1
	B0:in std_logic_vector(11 downto 0);--16
	B1:in std_logic_vector(11 downto 0);--16
	B2:in std_logic_vector(11 downto 0);--16
	B3:in std_logic_vector(11 downto 0);--16
	B4:in std_logic_vector(11 downto 0);--16
	B5:in std_logic_vector(11 downto 0);--16
	B6:in std_logic_vector(11 downto 0);--16
	B7:in std_logic_vector(11 downto 0);--16
	B8:in std_logic_vector(11 downto 0);--16
	
	DOUT:out std_logic_vector(11 downto 0);--16 in or out?
	VOUT: out std_logic
	);--1	
end myfir;

architecture beh of myfir is
	signal cnt :integer;
	
	type prm_int  is array (0 to 8) of signed (11 downto 0);--integer range -32767 to 32767 ;--;
	signal din_buff :  prm_int;  
begin 

fir_proc: process (CLK, RST_n)
	variable ss: std_logic_vector(23 downto 0); 
  begin  -- process

if RST_n = '0' then                 -- asynchronous reset (active low)
			
init : for i in 0 to 8 loop
din_buff(i)<=(others=>'0');
end loop init;	
	
cnt<=0;
	else 
	if (CLK'event and CLK = '1') then 
		if VIN='1' then
			INPUTDATA : for i in 0 to N-1 loop
			din_buff(0)<=signed(DIN);
			din_buff(i+1)<=din_buff(i);	
			end loop INPUTDATA;			
			if cnt=1 then
				VOUT<='1';
				ss:=std_logic_vector(
				signed((din_buff(0)*signed(B0)) and X"ff0000" )+
				signed((din_buff(1)*signed(B1)) and X"ff0000")+
				signed((din_buff(2)*signed(B2)) and X"ff0000")+
				signed((din_buff(3)*signed(B3)) and X"ff0000")+
				signed((din_buff(4)*signed(B4)) and X"ff0000")+
				signed((din_buff(5)*signed(B5)) and X"ff0000")+
				signed((din_buff(6)*signed(B6)) and X"ff0000")+
				signed((din_buff(7)*signed(B7)) and X"ff0000")+
				signed((din_buff(8)*signed(B8)) and X"ff0000"));
				DOUT(11 downto 0)<=ss(22 downto 11);		
			else
				cnt<=cnt+1;
			end if;
	else
		--cnt<=0;
		VOUT<='0';
	end if;
end if;
end if;
	end process fir_proc;
end architecture;
