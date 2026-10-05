library ieee;
use ieee.std_logic_1164.all;

entity d_gated_latch is
    port (e, d : in std_logic; q, q_n : out std_logic);
end entity;

architecture Structural of d_gated_latch is
    signal d_n, s_n, r_n : std_logic;
begin
    d_n <= not d;
    s_n <= not (d and e);
    r_n <= not (d_n and e);
    U_RS: entity work.rs_latch(Structural) port map (s_n => s_n, r_n => r_n, q => q, q_n => q_n);
end architecture;
