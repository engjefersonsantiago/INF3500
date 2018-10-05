-------------------------------------------------------------------------------
-- mult_simple_tb.vhd: Test bench N bits multiplier / Banc d'essai multiplieur a N bits
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity mult_simple_tb is
	generic (
		N_BITS	: integer := 16
	);
end mult_simple_tb;

architecture mult_simple_tb of mult_simple_tb is

	signal A	: unsigned(N_BITS - 1 downto 0);
	signal B	: unsigned(N_BITS - 1 downto 0);
	signal R	: unsigned(2*N_BITS - 1 downto 0);

begin

	UUT: entity work.mult_simple
		generic map (
			N_BITS	=> N_BITS
		)
		port map (
			A		=> A,
			B		=> B,
			R		=> R
		);
	
	process
	begin
		-- All possible inputs for X and Y
		-- Touts les possibles cas de X et Y
		for i in 0 to 2**N_BITS - 1 loop
			for j in 0 to 2**N_BITS - 1 loop
				A	<= to_unsigned(i, N_BITS);
				B	<= to_unsigned(j, N_BITS);
				wait for 1 ns;

				-- Evalutes the output of the N bits adder
				-- Verifie les sortie du additioneur a N bits
				assert R = to_unsigned(i*j, 2*N_BITS)
					report "Erreur. Multiplication erronee. Entrees: A = " & integer'image(i) & " et B = " & integer'image(j) severity error;
			end loop;
		end loop;
		
		assert (false)	
			report "La simulation est terminee." severity failure;
	end process;
	
end mult_simple_tb;
