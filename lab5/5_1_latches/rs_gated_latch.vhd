library ieee;
use ieee.std_logic_1164.all;

entity rs_gated_latch is
    port (e, s, r : in std_logic; q : out std_logic);
end entity;

architecture Structural of rs_gated_latch is
    signal s_n, r_n : std_logic;
begin
    s_n <= not (s and e);
    r_n <= not (r and e);
    U_RS: entity work.rs_latch(Structural) port map (s_n => s_n, r_n => r_n, q => q, q_n => open);
end architecture;
