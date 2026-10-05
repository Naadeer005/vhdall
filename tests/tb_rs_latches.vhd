library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use work.tb_pkg.all;

entity tb_rs_latches is
end entity;

architecture Test of tb_rs_latches is

    signal s_n, r_n, s, r, e, q, q_n, gq : std_logic := '1';

begin

    U : entity work.rs_latch(Structural)
        port map (
            s_n => s_n,
            r_n => r_n,
            q   => q,
            q_n => q_n
        );

    G : entity work.rs_gated_latch(Structural)
        port map (
            e => e,
            s => s,
            r => r,
            q => gq
        );

    process
    begin

        s_n <= '0';
        r_n <= '1';
        e   <= '1';
        s   <= '1';
        r   <= '0';
        wait for 1 ns;
        assert q = '1' and q_n = '0' and gq = '1'
            severity failure;
        s_n <= '1';
        s   <= '0';
        wait for 1 ns;
        assert q = '1' and gq = '1'
            report "Set hold"
            severity failure;
        r_n <= '0';
        r   <= '1';
        wait for 1 ns;
        assert q = '0' and q_n = '1' and gq = '0'
            severity failure;
        r_n <= '1';
        e   <= '0';
        wait for 1 ns;
        s   <= '1';
        r   <= '0';
        wait for 1 ns;
        assert q = '0' and gq = '0'
            report "Reset hold / gated disable"
            severity failure;
        e   <= '1';
        wait for 1 ns; assert gq = '1'
            severity failure;
        s_n <= '0';
        r_n <= '0';
        wait for 1 ns;
        assert q = '1' and q_n = '1'
            report "Forbidden state"
            severity failure;
        -- Release one input at a time: simultaneous release is intentionally undefined.
        s_n <= '1';
        wait for 1 ns; assert q = '0' and q_n = '1'
            severity failure;
        r_n <= '1';
        wait for 1 ns;
        report "PASS: tb_rs_latches"
            severity note;
        wait;

    end process;

end architecture;
