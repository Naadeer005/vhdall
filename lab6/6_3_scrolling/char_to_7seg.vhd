library ieee;
    use ieee.std_logic_1164.all;

entity char_to_7seg is
    port (
        char : in    std_logic_vector(4 downto 0);
        seg  : out   std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of char_to_7seg is

begin

    with char select seg <=
        "10001001" when "00001", -- H: b,c,e,f,g
        "10000110" when "00010", -- E: a,d,e,f,g
        "11000111" when "00011", -- L: d,e,f
        "11000000" when "00100", -- O: a,b,c,d,e,f
        "11111111" when others;  -- space; dp always off

end architecture;
