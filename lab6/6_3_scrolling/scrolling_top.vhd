library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scrolling_top is
    generic (DIV_COUNT : positive := 50000000);
    port (clk, sw9 : in std_logic; hex5 : out std_logic_vector(7 downto 0); hex4 : out std_logic_vector(7 downto 0); hex3 : out std_logic_vector(7 downto 0); hex2 : out std_logic_vector(7 downto 0); hex1 : out std_logic_vector(7 downto 0); hex0 : out std_logic_vector(7 downto 0));
end entity;

architecture Structural of scrolling_top is
    type addr_array is array (0 to 5) of std_logic_vector(3 downto 0);
    type char_array is array (0 to 5) of std_logic_vector(4 downto 0);
    type seg_array is array (0 to 5) of std_logic_vector(7 downto 0);
    signal addr : addr_array;
    signal chars : char_array;
    signal segments : seg_array;
    signal tick : std_logic;
    signal position : integer range 0 to 2 := 0;
begin
    U_DIV: entity work.clock_divider(Behavioral) generic map (DIV_COUNT => DIV_COUNT) port map (clk => clk, tick => tick);
    process(clk)
    begin
        if rising_edge(clk) then
            if tick = '1' then
                if sw9 = '0' then
                    if position = 2 then position <= 0; else position <= position+1; end if;
                else
                    if position = 0 then position <= 2; else position <= position-1; end if;
                end if;
            end if;
        end if;
    end process;
    GEN_DISPLAY: for i in 0 to 5 generate
        addr(i) <= std_logic_vector(to_unsigned(position+i, 4));
        ROM: entity work.message_rom(Behavioral) port map (addr => addr(i), char => chars(i));
        DEC: entity work.char_to_7seg(Behavioral) port map (char => chars(i), seg => segments(i));
    end generate;
    hex0 <= segments(0);
    hex1 <= segments(1);
    hex2 <= segments(2);
    hex3 <= segments(3);
    hex4 <= segments(4);
    hex5 <= segments(5);
end architecture;
