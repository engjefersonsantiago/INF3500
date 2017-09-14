-------------------------------------------------------------------------------
-- reduce_and.vhd: AND reduction to a vector/Fonction pour reduction ET
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;

entity reduce_and is
	generic (
		N_BITS			: integer := 8;			-- Input bit number	/ Nombre de bits d'entree
		FUNCTION_IMPL	: boolean := false		-- Enables function implementation / Implemente avec fonction
	);	
	port (
		X				: in	std_logic_vector(N_BITS - 1 downto 0);
		reduced_X		: out	std_logic
	);
end reduce_and;

architecture reduce_and of reduce_and is

	-- AND reduction Function
	-- Fonction redcution ET
	function reduce_and_function (data_in : std_logic_vector) return std_logic is
		variable tmp_data	: std_logic;
	begin
		tmp_data := data_in(data_in'low);
		for i in data_in'low + 1 to data_in'high loop
			tmp_data := tmp_data and data_in(i);	-- bit-by-bit AND
		end loop;
		return tmp_data;
	end function;

begin

	-- Process parameters: signals, inputs to be evaluated inside the process
	-- Parametres du processe: sinaux, entrees utilizes dans le processe
	process (X)
		variable tmp_data	: std_logic;
	begin
		--X'high: highest X index (N_BITS - 1)
		--X'high: le plus haut index (N_BITS - 1)
		--X'low: lowest X index (0)
		--X'low: le plus bas index (0)
		tmp_data := X(X'low);
		for i in X'low + 1 to X'high loop
			-- no need for incrementing the loop index
			-- Pas besoin de incrementer l'index
			tmp_data := tmp_data and X(i);	-- bit-by-bit AND
		end loop;
	
		if FUNCTION_IMPL then
			reduced_X <= reduce_and_function(X);
		else
			reduced_X <= tmp_data;
		end if;
	end process;

end reduce_and;
