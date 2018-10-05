-------------------------------------------------------------------------------
-- mult_simple.vhd: Non-Pipelined multiplication / Multiplication non-pipeline
-- Notes:
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity mult_simple is
	generic (
		N_BITS  : integer := 3		-- Input bit number / Nombre de bits d'entree
	);
	port (
		A		: in	unsigned(N_BITS - 1 downto 0);
		B		: in	unsigned(N_BITS - 1 downto 0);
		R		: out	unsigned(2*N_BITS - 1 downto 0)
	);
end mult_simple;

architecture mult_simple of mult_simple is

	-- User defined types
	type intermediate_product_t is array (integer range <>) of unsigned(N_BITS - 1 downto 0);
	type intermediate_results_t is array (integer range <>) of unsigned(2*N_BITS - 1 downto 0);


	-- Signal declarations
	signal intermediate_product : intermediate_product_t(N_BITS - 1 downto 0);
	signal intermediate_results : intermediate_results_t(N_BITS - 2 downto 0);

begin

    -- Intermediate Products
	b_loop: for i in 0 to b'high generate
	    a_loop: for j in 0 to a'high generate
		    intermediate_product(i)(j)	<= A(j) and B(i);
	    end generate;
	end generate;

    -- First sum
    intermediate_results(0)  <= resize(intermediate_product(0), 2*N_BITS) + resize(intermediate_product(1) & '0', 2*N_BITS);

    -- Intemediate sums
	r_loop: for i in 1 to intermediate_results'high generate
       intermediate_results(i)  <= resize(intermediate_results(i-1) + shift_left(resize(intermediate_product(i+1), 2*N_BITS), i+1), 2*N_BITS);
    end generate;

    R   <= intermediate_results(intermediate_results'high);

end mult_simple;
