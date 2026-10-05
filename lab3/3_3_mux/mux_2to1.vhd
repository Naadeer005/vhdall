library ieee;
    use ieee.std_logic_1164.all;

entity mux_2to1 is
    port (
        i0, i1, s : in    std_logic;
        y         : out   std_logic
    );
end entity;

architecture Dataflow of mux_2to1 is

begin

    y <= i0 when s = '0' else
         i1;

end architecture;
