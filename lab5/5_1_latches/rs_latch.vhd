library ieee;
use ieee.std_logic_1164.all;

entity rs_latch is
    port (s_n, r_n : in std_logic; q, q_n : out std_logic);
end entity;

architecture Structural of rs_latch is
    signal q_int, qn_int : std_logic;
begin
    -- Cross-coupled NAND pair. No artificial power-up state or gate delays.
    q_int <= not (s_n and qn_int);
    qn_int <= not (r_n and q_int);
    q <= q_int;
    q_n <= qn_int;
end architecture;
