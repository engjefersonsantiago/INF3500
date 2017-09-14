-------------------------------------------------------------------------------
-- matrix_multiplication.vhd: Pipelined Matrix multiplication / Multiplication de matrices pipeline
-- Notes: Only works with matrix order power of 2. Needs to be a square matrix
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity matrix_multiplication is
	generic (
		MATRIX_ORDER	: integer := 2;		-- Matrix order / Ordre de la matrice
		N_BITS			: integer := 12		-- Input bit number / Nombre de bits d'entree
	);
	port (
		clk		: in	std_logic;
		A		: in	unsigned((MATRIX_ORDER**2)*N_BITS - 1 downto 0);
		B		: in	unsigned((MATRIX_ORDER**2)*N_BITS - 1 downto 0);
		C		: out	unsigned(2*(MATRIX_ORDER**2)*N_BITS - 1 downto 0)
	);
end matrix_multiplication;

architecture matrix_multiplication of matrix_multiplication is

	-- Constants
	constant NUM_STAGES	: integer := integer(ceil(log2(real(MATRIX_ORDER))));
	type level_type is array (0 to NUM_STAGES) of integer;
	
	function compute_levels return level_type is
		variable tmp_data	: level_type;
	begin
		for i in 0 to NUM_STAGES loop
			tmp_data(i) := 2**(NUM_STAGES-i);
		end loop;
		return tmp_data;
	end function;

	-- User defined types
	type array_order is array (integer range <>) of unsigned(N_BITS - 1 downto 0);
	type array_order_2x is array (integer range <>) of unsigned(2*N_BITS - 1 downto 0);
	type array_of_arrays is array (integer range <>) of array_order_2x(0 to MATRIX_ORDER - 1);
	type stage_type is array (integer range <>) of array_of_arrays(0 to NUM_STAGES);

	constant STAGE_LEVELS	: level_type := compute_levels; 

	-- Signal declarations
	signal A_array	: array_order(0 to MATRIX_ORDER**2 - 1) := (others => (others => '0'));
	signal B_array	: array_order(0 to MATRIX_ORDER**2 - 1) := (others => (others => '0'));
	signal mult		: array_order_2x(0 to MATRIX_ORDER**3 - 1) := (others => (others => '0'));

	signal int_sum	: stage_type(0 to MATRIX_ORDER**2 - 1);

begin

	-- Converts input array into matrix
	arrays_init: for i in 0 to MATRIX_ORDER**2 - 1 generate
		A_array(i)	<= A(N_BITS*(i+1) - 1 downto N_BITS*i);
		B_array(i)	<= B(N_BITS*(i+1) - 1 downto N_BITS*i);
		C(2*N_BITS*(i+1) - 1 downto 2*N_BITS*i)	<= int_sum(i)(NUM_STAGES)(0);
	end generate;

	process (clk)
		variable sum	: array_of_arrays(0 to MATRIX_ORDER**2 - 1);
	begin
		if rising_edge(clk) then

			--------------------------------------------
			-- First pipeline stage
			--------------------------------------------
			-- Performs all multiplications in parallel (LOTS!)
			-- O(N**3)
			for i in 0 to MATRIX_ORDER - 1 loop
				for j in 0 to MATRIX_ORDER - 1 loop
					for k in 0 to MATRIX_ORDER - 1 loop
						mult((MATRIX_ORDER**2)*i+MATRIX_ORDER*j+k) <=
							A_array(MATRIX_ORDER*i+k)*B_array(MATRIX_ORDER*k+j);
					end loop;
				end loop;
			end loop;

			for i in 0 to MATRIX_ORDER**2 - 1 loop
				for j in 0 to MATRIX_ORDER - 1 loop
		            sum(i)(j) := mult(MATRIX_ORDER*i+j);
				end loop;
			end loop;

			for i in 0 to MATRIX_ORDER**2 - 1 loop
				int_sum(i)(0)	<= sum(i);
			end loop;

			--------------------------------------------
			-- Next log2(MATRIX_ORDER) pipeline stages
			--------------------------------------------
			for i in 0 to MATRIX_ORDER**2 - 1 loop
				for s in 1 to NUM_STAGES loop
					for j in 0 to STAGE_LEVELS(s) - 1 loop
						int_sum(i)(s)(j)	<= int_sum(i)(s-1)(2*j) + int_sum(i)(s-1)(2*j + 1);
					end loop;
				end loop;
			end loop;

		end if;
	end process;

end matrix_multiplication;
