library ieee;
    use ieee.std_logic_1164.all;

entity adder_n is
    generic (
        N : positive := 6
    );
    port (
        a, b : in    std_logic_vector(N - 1 downto 0);
        cin  : in    std_logic;
        sum  : out   std_logic_vector(N - 1 downto 0);
        cout : out   std_logic
    );
end entity;

architecture Structural of adder_n is

    signal c : std_logic_vector(N downto 0);

begin

    c(0) <= cin;

    GEN_FA : for i in 0 to N - 1 generate

        FA : entity work.full_adder(Structural)
            port map (
                a    => a(i),
                b    => b(i),
                cin  => c(i),
                sum  => sum(i),
                cout => c(i + 1)
            );

    end generate;

    cout <= c(N);

end architecture;
