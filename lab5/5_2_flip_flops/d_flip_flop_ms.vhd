library ieee;
    use ieee.std_logic_1164.all;

entity d_flip_flop_ms is
    port (
        clk, d : in    std_logic;
        q      : out   std_logic
    );
end entity;

architecture Structural of d_flip_flop_ms is

    signal clk_n, m : std_logic;

begin

    clk_n <= not clk;

    U_MASTER : entity work.d_gated_latch(Structural)
        port map (
            e   => clk_n,
            d   => d,
            q   => m,
            q_n => open
        );

    U_SLAVE : entity work.d_gated_latch(Structural)
        port map (
            e   => clk,
            d   => m,
            q   => q,
            q_n => open
        );

end architecture;
