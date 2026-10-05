library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_flip_flops is end entity;
architecture Test of tb_flip_flops is
    signal clk, d, e, lq, lqn, msq, bq : std_logic := '0';
begin
    L: entity work.d_gated_latch(Structural) port map (e => e, d => d, q => lq, q_n => lqn);
    M: entity work.d_flip_flop_ms(Structural) port map (clk => clk, d => d, q => msq);
    B: entity work.d_flip_flop(Behavioral) port map (clk => clk, d => d, q => bq);
    process
    begin
        e <= '1'; wait for 1 ns;
        assert lq = '0' and lqn = '1' severity failure;
        d <= '1'; wait for 1 ns; assert lq = '1' and lqn = '0' severity failure;
        e <= '0'; wait for 1 ns; d <= '0'; wait for 1 ns;
        assert lq = '1' report "D latch hold" severity failure;
        step(clk); assert msq = '0' and bq = '0' severity failure;
        d <= '1'; wait for 1 ns;
        assert msq = '0' and bq = '0' report "No capture while clock high" severity failure;
        step(clk); assert msq = '1' and bq = '1' report "Rising capture" severity failure;
        d <= '0'; wait for 1 ns;
        assert msq = '1' and bq = '1' severity failure;
        clk <= '0'; wait for 1 ns;
        assert msq = '1' and bq = '1' report "No falling-edge capture" severity failure;
        step(clk); assert msq = '0' and bq = '0' severity failure;
        report "PASS: tb_flip_flops" severity note;
        wait;
    end process;
end architecture;
