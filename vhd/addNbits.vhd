-------------------------------------------------------------------------------
-- addNbits.vhd: N bits adder (ripple carry) / Additionneur a N bits
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

entity addNbits is
	generic (
		N_BITS	: integer := 8		-- Input bit number / Nombre de bits d'entree
	);	
	port (
		Cin		: in	std_logic;
		X		: in	std_logic_vector(N_BITS - 1 downto 0);
		Y		: in	std_logic_vector(N_BITS - 1 downto 0);
		Cout	: out	std_logic;
		S		: out	std_logic_vector(N_BITS - 1 downto 0) 
	);
end addNbits;

architecture addNbits of addNbits is
	signal Cin_int	: std_logic_vector(N_BITS downto 0);
	signal Cout_int	: std_logic_vector(N_BITS - 1 downto 0);
	signal S_int	: std_logic_vector(N_BITS - 1 downto 0); 
begin

	-- N_BITS instances of add3bits (in parallel)
	-- N_BITS instances du add3bits (en parallele)
	adders_loop: for i in 0 to N_BITS - 1 generate
		adders: entity work.add3bits
			port map (
				Cin		=> Cin_int(i),
				X		=> X(i),
				Y		=> Y(i),
				Cout	=> Cout_int(i),
				S		=> S(i)
			);
			Cin_int(i+1)	<= Cout_int(i);
	end generate;

	Cin_int(0)	<= Cin;
	Cout		<= Cout_int(N_BITS - 1);

	-- No need for process
	-- Pas besoin de processe
end addNbits;
