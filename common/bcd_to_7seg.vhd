library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_7seg is
    port (bcd : in std_logic_vector(3 downto 0); seg : out std_logic_vector(7 downto 0));
end entity;

architecture Structural of bcd_to_7seg is
    signal a, b, c, d, e, f, g : std_logic;
begin
    -- a: OFF for decimal inputs 1, 4, 10, 11, 12, 13, 14, 15.
    a <= (not bcd(3) and not bcd(2) and not bcd(1) and bcd(0)) or
          (bcd(2) and not bcd(1) and not bcd(0)) or
          (bcd(3) and bcd(1)) or
          (bcd(3) and bcd(2));
    -- b: OFF for decimal inputs 5, 6, 10, 11, 12, 13, 14, 15.
    b <= (bcd(2) and not bcd(1) and bcd(0)) or
          (bcd(2) and bcd(1) and not bcd(0)) or
          (bcd(3) and bcd(1)) or
          (bcd(3) and bcd(2));
    -- c: OFF for decimal inputs 2, 10, 11, 12, 13, 14, 15.
    c <= (not bcd(2) and bcd(1) and not bcd(0)) or
          (bcd(3) and bcd(1)) or
          (bcd(3) and bcd(2));
    -- d: OFF for decimal inputs 1, 4, 7, 10, 11, 12, 13, 14, 15.
    d <= (not bcd(3) and not bcd(2) and not bcd(1) and bcd(0)) or
          (bcd(2) and not bcd(1) and not bcd(0)) or
          (bcd(2) and bcd(1) and bcd(0)) or
          (bcd(3) and bcd(1)) or
          (bcd(3) and bcd(2));
    -- e: OFF for decimal inputs 1, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15.
    e <= (bcd(0)) or
          (bcd(2) and not bcd(1)) or
          (bcd(3) and bcd(1));
    -- f: OFF for decimal inputs 1, 2, 3, 7, 10, 11, 12, 13, 14, 15.
    f <= (not bcd(3) and not bcd(2) and bcd(0)) or
          (not bcd(2) and bcd(1)) or
          (bcd(1) and bcd(0)) or
          (bcd(3) and bcd(2));
    -- g: OFF for decimal inputs 0, 1, 7, 10, 11, 12, 13, 14, 15.
    g <= (not bcd(3) and not bcd(2) and not bcd(1)) or
          (bcd(2) and bcd(1) and bcd(0)) or
          (bcd(3) and bcd(1)) or
          (bcd(3) and bcd(2));
    seg <= '1' & g & f & e & d & c & b & a;
end architecture;
