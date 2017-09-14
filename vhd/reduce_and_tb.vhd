-------------------------------------------------------------------------------
-- addNbits_tb.vhd: Test bench reduce AND / Banc d'essai reduction ET
-- Jeferson S. Silva
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity reduce_and_tb is
	generic (
		N_BITS	: integer := 8
	);
end reduce_and_tb;

architecture reduce_and_tb of reduce_and_tb is

	signal X	: std_logic_vector(N_BITS - 1 downto 0);
	signal X_r	: std_logic;
	signal X_rf	: std_logic;

begin

	UUT: entity work.reduce_and
		generic map (
			N_BITS			=> N_BITS,
			FUNCTION_IMPL	=> false
		)	
		port map (
			X				=> X,
			reduced_X		=> X_r
		);

	UUT2: entity work.reduce_and
            generic map (
                N_BITS           => N_BITS,
                FUNCTION_IMPL    => true
            )    
            port map (
                X                => X,
                reduced_X        => X_rf
            );
	
	process
	begin
		-- All possible inputs for X and Y
		for i in 0 to 2**N_BITS - 1 loop
			X	<= std_logic_vector(to_unsigned(i, N_BITS));
			wait for 10 ns;
			assert X_r = X_rf
				report "Fonction et Process genere des resultats diferents." severity failure;	
		end loop;
		
		assert (false)	
			report "La simulation est terminee." severity failure;
	end process;
	
end reduce_and_tb;
