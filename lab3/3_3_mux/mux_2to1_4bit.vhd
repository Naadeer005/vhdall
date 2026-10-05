library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1_4bit is
    port (a, b : in std_logic_vector(3 downto 0); s : in std_logic; y : out std_logic_vector(3 downto 0));
end entity;

architecture Dataflow of mux_2to1_4bit is

begin
    y <= a when s = '0' else b;
end architecture;
