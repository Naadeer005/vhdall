library ieee;
use ieee.std_logic_1164.all;

entity mux_7seg is
    port (sw : in std_logic_vector(1 downto 0); hex0 : out std_logic_vector(7 downto 0));
end entity;

architecture Dataflow of mux_7seg is

begin
    with sw select hex0 <=
        "11000000" when "00", "11111001" when "01",
        "10100100" when "10", "10110000" when "11",
        "11111111" when others;
end architecture;
