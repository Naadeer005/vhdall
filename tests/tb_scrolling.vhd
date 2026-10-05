library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_pkg.all;

entity tb_scrolling is end entity;
architecture Test of tb_scrolling is
    signal clk : std_logic := '0'; signal sw9 : std_logic := '0';
    signal h : segment_array(0 to 5);
    signal addr : std_logic_vector(3 downto 0); signal char : std_logic_vector(4 downto 0);
    signal rom_seg : segment;
    signal code : std_logic_vector(4 downto 0); signal code_seg : segment;
begin
    U: entity work.scrolling_top(Structural) generic map (DIV_COUNT => 4) port map (clk => clk, sw9 => sw9, hex5 => h(5), hex4 => h(4), hex3 => h(3), hex2 => h(2), hex1 => h(1), hex0 => h(0));
    R: entity work.message_rom(Behavioral) port map (addr => addr, char => char);
    D: entity work.char_to_7seg(Behavioral) port map (char => char, seg => rom_seg);
    C: entity work.char_to_7seg(Behavioral) port map (char => code, seg => code_seg);
    process
    begin
        for i in 0 to 15 loop
            addr <= std_logic_vector(to_unsigned(i, 4)); wait for 1 ns;
            assert rom_seg = message(i) report "Message ROM mismatch" severity failure;
        end loop;
        for i in 0 to 31 loop
            code <= std_logic_vector(to_unsigned(i, 5)); wait for 1 ns;
            case i is
                when 1 => assert code_seg = x"89" severity failure;
                when 2 => assert code_seg = x"86" severity failure;
                when 3 => assert code_seg = x"C7" severity failure;
                when 4 => assert code_seg = x"C0" severity failure;
                when others => assert code_seg = x"FF" severity failure;
            end case;
        end loop;
        for j in 0 to 5 loop assert h(j) = message(j) severity failure; end loop;
        step(clk, 1);
        for p in 1 to 6 loop
            step(clk, 4);
            for j in 0 to 5 loop assert h(j) = message((p mod 3)+j) report "Forward position" severity failure; end loop;
        end loop;
        sw9 <= '1';
        for p in 1 to 6 loop
            step(clk, 4);
            for j in 0 to 5 loop assert h(j) = message(((3-p mod 3) mod 3)+j) report "Reverse position" severity failure; end loop;
        end loop;
        report "PASS: tb_scrolling" severity note;
        wait;
    end process;
end architecture;
