-------------------------------------------------------------------------------
-- addNbits_tb.vhd: Test bench N bits adder / Banc d'essai additioneur a N bits
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity addNbits_tb is
	generic (
		N_BITS	: integer := 4
	);
end addNbits_tb;

architecture addNbits_tb of addNbits_tb is

	signal Cin	: std_logic;
	signal X	: std_logic_vector(N_BITS - 1 downto 0);
	signal Y	: std_logic_vector(N_BITS - 1 downto 0);
	signal Cout	: std_logic;
	signal S	: std_logic_vector(N_BITS - 1 downto 0);

begin

	UUT: entity work.addNbits
		generic map (
			N_BITS	=> N_BITS
		)
		port map (
			Cin		=> '0', 
			X		=> X,
			Y		=> Y,
			Cout	=> Cout,
			S		=> S
		);
	
	process
	begin
		-- All possible inputs for X and Y
		-- Touts les possibles cas de X et Y
		for i in 0 to 2**N_BITS - 1 loop
			for j in 0 to 2**N_BITS - 1 loop
				X	<= std_logic_vector(to_unsigned(i, N_BITS));
				Y	<= std_logic_vector(to_unsigned(j, N_BITS));
				wait for 10 ns;

				-- Evalutes the output of the N bits adder
				-- Verifie les sortie du additioneur a N bits
				assert Cout & S = std_logic_vector(to_unsigned(i+j, N_BITS + 1))		
					report "Erreur. Somme erronee. Entrees: X = " & integer'image(i) & " et Y = " & integer'image(j) severity error;
			end loop;
		end loop;
		
		assert (false)	
			report "La simulation est terminee." severity failure;
	end process;
	
end addNbits_tb;
