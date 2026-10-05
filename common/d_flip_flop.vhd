library ieee;
    use ieee.std_logic_1164.all;

entity d_flip_flop is
    port (
        clk, d : in    std_logic;
        q      : out   std_logic
    );
end entity;

architecture Behavioral of d_flip_flop is

    -- Defined power-up state lets the feedback ripple counter simulate.
    signal q_int : std_logic := '0';

begin

    process (clk)
    begin

        if rising_edge(clk) then
            q_int <= d;
        end if;

    end process;

    q <= q_int;

end architecture;
