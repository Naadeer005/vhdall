library ieee;
    use ieee.std_logic_1164.all;

entity full_adder is
    port (
        a, b, cin : in    std_logic;
        sum, cout : out   std_logic
    );
end entity;

architecture Structural of full_adder is

    signal axb : std_logic;

begin

    axb  <= a xor b;
    sum  <= axb xor cin;
    cout <= (a and b) or (axb and cin);

end architecture;
