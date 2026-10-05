library ieee;
    use ieee.std_logic_1164.all;

entity mux_2to1_gate is
    port (
        i0, i1, s : in    std_logic;
        y         : out   std_logic
    );
end entity;

architecture Structural of mux_2to1_gate is

    signal s_not, and_s0, and_s1 : std_logic;

begin

    s_not  <= not s;
    and_s0 <= i0 and s_not;
    and_s1 <= i1 and s;
    y      <= and_s0 or and_s1;

end architecture;
