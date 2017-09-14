-------------------------------------------------------------------------------
-- add3bits.vhd: additioneur a 3 bits.
-- Pierre Langlois
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

entity add3bits is
	port (
		Cin		: in	std_logic;
		X		: in	std_logic;
		Y		: in	std_logic;
		Cout	: out	std_logic;
		S		: out	std_logic
	);
end add3bits;

architecture flotdonnees of add3bits is
	signal T1	: std_logic;
	signal T2	: std_logic;	
	signal T3	: std_logic;
begin
	S		<= T1 xor Cin;
	Cout	<= T3 or T2;
	T1		<= X xor Y;
	T2		<= X and Y;
	T3		<= Cin and T1;
end flotdonnees;
