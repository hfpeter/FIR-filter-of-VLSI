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
	--type arr16bit is array (0 to 8) of signed (11 downto 0);--integer;-- range  -32767 to 32767;
	--signal coef_arr : arr16bit;	
	type arrs  is array (0 to 2) of signed (23 downto 0);	
	signal sum_arr: arrs;

	signal vcnt :integer;
	signal	d3k_reg1: signed(11 downto 0); signal	d3k_reg2: signed(11 downto 0); 
	signal	d3k1_reg1: signed(11 downto 0); signal	d3k1_reg2: signed(11 downto 0); signal d3k1_reg3: signed(11 downto 0)	;
	signal	d3k2_reg1: signed(11 downto 0); signal	d3k2_reg2: signed(11 downto 0); signal d3k2_reg3: signed(11 downto 0);
begin 

fir_proc: process (CLK, RST_n)
begin  -- process
if RST_n = '0' then                 -- asynchronous reset (active low)
vcnt<=0;

--stmp1<=(others => (others => '0'));
sum_arr<=(others => (others => '0'));
d3k_reg1<=(others=>'0');d3k_reg2<=(others=>'0');d3k1_reg1<=(others=>'0');d3k1_reg2<=(others=>'0');d3k1_reg3<=(others=>'0');d3k2_reg1<=(others=>'0');d3k2_reg2<=(others=>'0');d3k2_reg3<=(others=>'0');
			else 
				if (CLK'event and CLK = '1') then 
				if VIN='1' then
				d3k_reg1 <=signed(DIN3k);   --d3k_reg1(31 downto 12) <= (others=>DIN3k(11));
				d3k_reg2<=d3k_reg1;
				d3k1_reg1 <=signed(DIN3k1);--d3k1_reg1(31 downto 12) <= (others=>DIN3k1(11)); 
				d3k1_reg2<=d3k1_reg1;
				d3k1_reg3<=d3k1_reg2;
				d3k2_reg1 <=signed(DIN3k2);
				--d3k2_reg1(31 downto 12) <= (others=>DIN3k2(11));  
				d3k2_reg2<=d3k2_reg1;
				d3k2_reg3<=d3k2_reg2;	

	sum_arr(0)<=signed((signed(DIN3k)*signed(B0)  ) and X"ff0000")+
signed((d3k2_reg1*signed(B1)  ) and X"ff0000")+
signed((d3k1_reg1*signed(B2)  ) and X"ff0000")+
signed((d3k_reg1*signed(B3) ) and X"ff0000")+
signed((d3k2_reg2*signed(B4) ) and X"ff0000")+
signed((d3k1_reg2*signed(B5) ) and X"ff0000")+
signed((d3k_reg2*signed(B6) ) and X"ff0000")+
signed((d3k2_reg3*signed(B7)  ) and X"ff0000")+
signed((d3k1_reg3*signed(B8) ) and X"ff0000");
	
	sum_arr(1)<=signed((signed(DIN3k1)*signed(B0) ) and X"ff0000")+
signed((signed(DIN3k)*signed(B1) ) and X"ff0000")+
signed((d3k2_reg1*signed(B2) ) and X"ff0000")+
signed((d3k1_reg1*signed(B3) ) and X"ff0000")+
signed((d3k_reg1*signed(B4) ) and X"ff0000")+
signed((d3k2_reg2*signed(B5) ) and X"ff0000")+
signed((d3k1_reg2*signed(B6) ) and X"ff0000")+
signed((d3k_reg2*signed(B7) ) and X"ff0000")+
signed((d3k2_reg3*signed(B8) ) and X"ff0000");
        
	sum_arr(2)<=signed((signed(DIN3k2)*signed(B0) ) and X"ff0000")+
signed((signed(DIN3k1)*signed(B1)  ) and X"ff0000")+
signed((signed(DIN3k)*signed(B2) ) and X"ff0000")+
signed((d3k2_reg1*signed(B3) ) and X"ff0000")+
signed((d3k1_reg1*signed(B4) ) and X"ff0000")+
signed((d3k_reg1*signed(B5) ) and X"ff0000")+
signed((d3k2_reg2*signed(B6) ) and X"ff0000")+
signed((d3k1_reg2*signed(B7) ) and X"ff0000")+
signed((d3k_reg2*signed(B8) ) and X"ff0000");					
						if vcnt =1 then 
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
