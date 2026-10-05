library ieee;
use ieee.std_logic_1164.all;

entity multiplier_top is
    port (clk : in std_logic; a, b : in std_logic_vector(3 downto 0); key0 : in std_logic; hex2, hex1, hex0 : out std_logic_vector(7 downto 0); done : out std_logic);
end entity;

architecture Structural of multiplier_top is
    signal start : std_logic;
    signal product : std_logic_vector(7 downto 0);
    signal hundreds, tens, units_digit : std_logic_vector(3 downto 0);
begin
    U_KEY: entity work.button_press(Behavioral) port map (clk => clk, key_n => key0, press => start);
    U_FSM: entity work.multiplier_fsm(Behavioral) port map (clk => clk, start => start, a => a, b => b, done => done, acc => product);
    U_BCD: entity work.bin_to_bcd(Dataflow) port map (bin => product, bcd2 => hundreds, bcd1 => tens, bcd0 => units_digit);
    U_HUNDREDS: entity work.bcd_to_7seg(Structural) port map (bcd => hundreds, seg => hex2);
    U_TENS: entity work.bcd_to_7seg(Structural) port map (bcd => tens, seg => hex1);
    U_UNITS: entity work.bcd_to_7seg(Structural) port map (bcd => units_digit, seg => hex0);
end architecture;
