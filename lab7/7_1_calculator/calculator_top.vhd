library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_top is
    port (clk : in std_logic; a, b : in std_logic_vector(3 downto 0); key0, key1 : in std_logic; hex2, hex1, hex0 : out std_logic_vector(7 downto 0));
end entity;

architecture Structural of calculator_top is
    signal press0, press1, mode : std_logic;
    signal a_ext, b_ext, b_proc, sum_bits : std_logic_vector(5 downto 0);
    signal result : signed(5 downto 0) := (others => '0');
    signal magnitude : unsigned(5 downto 0);
    signal abs_result : std_logic_vector(4 downto 0);
    signal tens, units_digit : std_logic_vector(3 downto 0);
begin
    U_KEY0: entity work.button_press(Behavioral) port map (clk => clk, key_n => key0, press => press0);
    U_KEY1: entity work.button_press(Behavioral) port map (clk => clk, key_n => key1, press => press1);
    mode <= press1 and not press0; -- Simultaneous operations: addition wins.
    a_ext <= "00" & a;
    b_ext <= "00" & b;
    b_proc <= b_ext xor (5 downto 0 => mode);
    U_ADD: entity work.adder_n(Structural) generic map (N => 6)
        port map (a => a_ext, b => b_proc, cin => mode, sum => sum_bits, cout => open);
    process(clk)
    begin
        if rising_edge(clk) then
            if press0 = '1' or press1 = '1' then result <= signed(sum_bits); end if;
        end if;
    end process;
    magnitude <= unsigned(-result) when result < 0 else unsigned(result);
    abs_result <= std_logic_vector(magnitude(4 downto 0));
    U_BCD: entity work.bin_to_bcd(Dataflow) port map (bin => abs_result, bcd1 => tens, bcd0 => units_digit);
    U_TENS: entity work.bcd_to_7seg(Structural) port map (bcd => tens, seg => hex1);
    U_UNITS: entity work.bcd_to_7seg(Structural) port map (bcd => units_digit, seg => hex0);
    hex2 <= "10111111" when result < 0 else "11111111";
end architecture;
