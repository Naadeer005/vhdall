library ieee;
use ieee.std_logic_1164.all;

entity bin_to_dual_7seg is
    port (bin : in std_logic_vector(3 downto 0); hex1, hex0 : out std_logic_vector(7 downto 0));
end entity;

architecture Structural of bin_to_dual_7seg is
    signal tens, units_digit : std_logic_vector(3 downto 0);
begin
    U_BCD: entity work.bin_to_bcd(Dataflow) port map (bin => bin, bcd1 => tens, bcd0 => units_digit);
    U_TENS: entity work.bcd_to_7seg(Structural) port map (bcd => tens, seg => hex1);
    U_UNITS: entity work.bcd_to_7seg(Structural) port map (bcd => units_digit, seg => hex0);
end architecture;
