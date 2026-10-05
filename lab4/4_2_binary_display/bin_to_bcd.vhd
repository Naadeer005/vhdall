library ieee;
use ieee.std_logic_1164.all;

entity bin_to_bcd is
    port (bin : in std_logic_vector(3 downto 0); bcd1 : out std_logic_vector(3 downto 0); bcd0 : out std_logic_vector(3 downto 0));
end entity;

architecture Dataflow of bin_to_bcd is

begin
    with bin select bcd1 <=
        "0000" when "0000" | "0001" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000" | "1001",
        "0001" when "1010" | "1011" | "1100" | "1101" | "1110" | "1111",
        "0000" when others;
    with bin select bcd0 <=
        "0000" when "0000" | "1010",
        "0001" when "0001" | "1011",
        "0010" when "0010" | "1100",
        "0011" when "0011" | "1101",
        "0100" when "0100" | "1110",
        "0101" when "0101" | "1111",
        "0110" when "0110",
        "0111" when "0111",
        "1000" when "1000",
        "1001" when "1001",
        "0000" when others;
end architecture;
