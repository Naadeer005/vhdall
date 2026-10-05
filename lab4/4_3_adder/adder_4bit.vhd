library ieee;
    use ieee.std_logic_1164.all;

entity adder_4bit is
    port (
        a, b     : in    std_logic_vector(3 downto 0);
        sum      : out   std_logic_vector(3 downto 0);
        overflow : out   std_logic
    );
end entity;

architecture Structural of adder_4bit is

    signal c : std_logic_vector(4 downto 0);

begin

    c(0) <= '0';

    GEN_FA : for i in 0 to 3 generate

        FA : entity work.full_adder(Structural)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c(i),
                sum  => sum(i),
                cout => c(i + 1)
            );

    end generate;

    overflow <= c(4);

end architecture;
