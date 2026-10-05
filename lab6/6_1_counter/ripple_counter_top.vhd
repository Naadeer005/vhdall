library ieee;
use ieee.std_logic_1164.all;

entity ripple_counter_top is
    port (clk : in std_logic; led : out std_logic_vector(3 downto 0));
end entity;

architecture Structural of ripple_counter_top is
    signal q, qb : std_logic_vector(3 downto 0);
begin
    qb <= not q;
    U0: entity work.d_flip_flop(Behavioral) port map (clk => clk, d => qb(0), q => q(0));
    GEN_FF: for i in 1 to 3 generate
        U: entity work.d_flip_flop(Behavioral) port map (clk => qb(i-1), d => qb(i), q => q(i));
    end generate;
    led <= q;
end architecture;
