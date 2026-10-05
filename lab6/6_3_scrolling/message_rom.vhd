library ieee;
use ieee.std_logic_1164.all;

entity message_rom is
    port (addr : in std_logic_vector(3 downto 0); char : out std_logic_vector(4 downto 0));
end entity;

architecture Behavioral of message_rom is

begin
    with addr select char <=
        "00001" when "0000", "00010" when "0001",
        "00011" when "0010" | "0011", "00100" when "0100",
        "00000" when others;
end architecture;
