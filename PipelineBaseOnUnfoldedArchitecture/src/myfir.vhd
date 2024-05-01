library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

--use work.tp.all;


--data 16 bit come from data_maker the 4th port
entity myfir is
  port (
	clk : in  std_logic;
	RST_n     : in std_logic;
	din3k   : in std_logic_vector(11 downto 0);
	din3k1   : in std_logic_vector(11 downto 0);
	din3k2   : in std_logic_vector(11 downto 0);	
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
	DOUT3k:out std_logic_vector(11 downto 0);--16 in or out?
	DOUT3k1:out std_logic_vector(11 downto 0);	
	DOUT3k2:out std_logic_vector(11 downto 0);	
	VOUT: out std_logic--3???：1?：2o：??：'??VOUT|━?data maker
	);--1	
end myfir;

architecture beh of myfir is	
	type arr16bit is array (0 to 8) of signed (11 downto 0);--integer;-- range  -32767 to 32767;
	signal coef_arr : arr16bit;	
	type arrs  is array (0 to 2) of signed (23 downto 0);	
	signal sum_arr: arrs;
	type arrs27  is array (0 to 26) of signed (23 downto 0);	
	signal stmp  : arrs27;
	--signal stmp1 : arrs27;
	signal vcnt :integer;
	signal	d3k_reg1: signed(11 downto 0); signal	d3k_reg2: signed(11 downto 0); 
	signal	d3k1_reg1: signed(11 downto 0); signal	d3k1_reg2: signed(11 downto 0); signal d3k1_reg3: signed(11 downto 0)	;
	signal	d3k2_reg1: signed(11 downto 0); signal	d3k2_reg2: signed(11 downto 0); signal d3k2_reg3: signed(11 downto 0);
begin 

fir_proc: process (CLK, RST_n)
begin  -- process
if RST_n = '0' then                 -- asynchronous reset (active low)
vcnt<=0;
coef_arr(0) <=signed(B0);
coef_arr(1) <=signed(B1);
coef_arr(2) <=signed(B2);
coef_arr(3) <=signed(B3);
coef_arr(4) <=signed(B4);
coef_arr(5) <=signed(B5);
coef_arr(6) <=signed(B6);
coef_arr(7) <=signed(B7);
coef_arr(8) <=signed(B8);
stmp<=(others => (others => '0'));
--stmp1<=(others => (others => '0'));
sum_arr<=(others => (others => '0'));
d3k_reg1<=(others=>'0');d3k_reg2<=(others=>'0');d3k1_reg1<=(others=>'0');d3k1_reg2<=(others=>'0');d3k1_reg3<=(others=>'0');d3k2_reg1<=(others=>'0');d3k2_reg2<=(others=>'0');d3k2_reg3<=(others=>'0');
			else 
				if (CLK'event and CLK = '1') then 
				if VIN='1' then
				d3k_reg1<=signed(DIN3k);d3k_reg2<=d3k_reg1;
				d3k1_reg1<=signed(DIN3k1);d3k1_reg2<=d3k1_reg1;d3k1_reg3<=d3k1_reg2;
				d3k2_reg1<=signed(DIN3k2);d3k2_reg2<=d3k2_reg1;d3k2_reg3<=d3k2_reg2;	

				stmp(0)<= signed(DIN3k)*coef_arr(0);stmp(1)<= d3k2_reg1*coef_arr(1); stmp(2)<= d3k1_reg1*coef_arr(2);
				stmp(3)<= d3k_reg1*coef_arr(3);     stmp(4)<= d3k2_reg2*coef_arr(4); stmp(5)<= d3k1_reg2*coef_arr(5);
				stmp(6)<= d3k_reg2*coef_arr(6);     stmp(7)<= d3k2_reg3*coef_arr(7); stmp(8)<= d3k1_reg3*coef_arr(8);

				stmp(9)<= signed(DIN3k1)*coef_arr(0);stmp(10)<= signed(DIN3k)*coef_arr(1);stmp(11)<= d3k2_reg1*coef_arr(2);
				stmp(12)<= d3k1_reg1*coef_arr(3) ;   stmp(13)<= d3k_reg1*coef_arr(4);     stmp(14)<= d3k2_reg2*coef_arr(5);
				stmp(15)<= d3k1_reg2*coef_arr(6) ;   stmp(16)<= d3k_reg2*coef_arr(7)    ; stmp(17)<= d3k2_reg3*coef_arr(8);	

				stmp(18)<=  signed(DIN3k2)*coef_arr(0);stmp(19)<= signed(DIN3k1)*coef_arr(1);stmp(20)<= signed(DIN3k)*coef_arr(2);
				stmp(21)<= d3k2_reg1*coef_arr(3) ;     stmp(22)<= d3k1_reg1*coef_arr(4)   ;  stmp(23)<= d3k_reg1*coef_arr(5);
				stmp(24)<= d3k2_reg2*coef_arr(6)  ;    stmp(25)<= d3k1_reg2*coef_arr(7)  ;   stmp(26)<= d3k_reg2*coef_arr(8);	


				sum_arr(0)(23 downto 0)<=signed(stmp(0) and X"ff0000")  +signed(stmp(1) and X"ff0000")+signed(stmp(2) and X"ff0000")+signed(stmp(3) and X"ff0000")+signed(stmp(4) and X"ff0000")+signed(stmp(5) and X"ff0000")+signed(stmp(6) and X"ff0000")+signed(stmp(7) and X"ff0000")+signed(stmp(8) and X"ff0000");
				sum_arr(1)(23 downto 0)<=signed(stmp(9) and X"ff0000") +signed(stmp(10) and X"ff0000")+signed(stmp(11) and X"ff0000")+signed(stmp(12) and X"ff0000")+signed(stmp(13) and X"ff0000")+signed(stmp(14) and X"ff0000")+signed(stmp(15) and X"ff0000")+signed(stmp(16) and X"ff0000")+signed(stmp(17) and X"ff0000");
				sum_arr(2)(23 downto 0)<=signed(stmp(18) and X"ff0000")+signed(stmp(19) and X"ff0000")+signed(stmp(20) and X"ff0000")+signed(stmp(21) and X"ff0000")+signed(stmp(22) and X"ff0000")+signed(stmp(23) and X"ff0000")+signed(stmp(24) and X"ff0000")+signed(stmp(25) and X"ff0000")+signed(stmp(26) and X"ff0000");			
						if vcnt =2 then 
							VOUT<='1';
							dout3k  (11 downto 0)<=std_logic_vector(sum_arr(0)(22 downto 11));
							dout3k1 (11 downto 0)<=std_logic_vector(sum_arr(1)(22 downto 11));
							dout3k2 (11 downto 0)<=std_logic_vector(sum_arr(2)(22 downto 11));			
						else
							vcnt<=vcnt+1;	
						end if;			
					else
					VOUT<='0';
				end if;
	end if;
end if;
	end process fir_proc;
end architecture;
