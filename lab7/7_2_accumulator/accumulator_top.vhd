library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator_top is
  port (
    clk                    : in std_logic;
    a                      : in std_logic_vector(7 downto 0);
    add_sub, key0, key1    : in std_logic;
    hex3, hex2, hex1, hex0 : out std_logic_vector(7 downto 0);
    overflow               : out std_logic);
end entity;

architecture Structural of accumulator_top is
  signal press_add, press_rst                             : std_logic;
  signal a_proc, acc                                      : signed(8 downto 0) := (others => '0');
  signal sum_full                                         : signed(9 downto 0);
  signal magnitude                                        : unsigned(9 downto 0);
  signal h_raw, t_raw, u_raw, hundreds, tens, units_digit : std_logic_vector(3 downto 0);
  signal overflow_int                                     : std_logic := '0';
begin
  U_KEY0 : entity work.button_press(Behavioral) port map
    (clk => clk, key_n => key0, press => press_add);
  U_KEY1 : entity work.button_press(Behavioral) port map
    (clk => clk, key_n => key1, press => press_rst);
  -- Zero-extend the UNSIGNED switch value before treating it as signed.
  a_proc <= signed('0' & a) when add_sub = '0' else
    - signed('0' & a);
  sum_full <= resize(acc, 10) + resize(a_proc, 10);
  process (clk)
  begin
    if rising_edge(clk) then
      if press_rst = '1' then
        acc          <= (others => '0');
        overflow_int <= '0';
      elsif press_add = '1' then
        -- Slice (rather than signed resize) to preserve modulo-512 wrapping.
        acc <= sum_full(8 downto 0);
        if sum_full > 255 or sum_full < 0 then
          overflow_int <= '1';
        else
          overflow_int <= '0';
        end if;
      end if;
    end if;
  end process;
  magnitude <= unsigned(-resize(acc, 10)) when acc < 0 else
    unsigned(resize(acc, 10));
  U_BCD : entity work.bin_to_bcd(Dataflow)
    port map
      (bin => std_logic_vector(magnitude(7 downto 0)), bcd2 => h_raw, bcd1 => t_raw, bcd0 => u_raw);
  -- Magnitude 256 is the only value outside the reused eight-bit converter.
  hundreds <= "0010" when magnitude = 256 else
    h_raw;
  tens <= "0101" when magnitude = 256 else
    t_raw;
  units_digit <= "0110" when magnitude = 256 else
    u_raw;
  U_HUNDREDS : entity work.bcd_to_7seg(Structural) port map
    (bcd => hundreds, seg => hex2);
  U_TENS : entity work.bcd_to_7seg(Structural) port map
    (bcd => tens, seg => hex1);
  U_UNITS : entity work.bcd_to_7seg(Structural) port map
    (bcd => units_digit, seg => hex0);
  hex3 <= "10111111" when acc < 0 else
    "11111111";
  overflow <= overflow_int;
end architecture;
