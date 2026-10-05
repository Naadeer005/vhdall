library ieee;
use ieee.std_logic_1164.all;

entity button_press is
  port (
    clk, key_n : in std_logic;
    press      : out std_logic);
end entity;

architecture Behavioral of button_press is
  signal meta, synced, previous : std_logic := '1';
begin
  -- Two-stage synchronizer, then falling-edge detection (KEY is active-low).
  -- Hardware debouncing is assumed; synchronization alone is not debouncing.
  process (clk)
  begin
    if rising_edge(clk) then
      meta     <= key_n;
      synced   <= meta;
      previous <= synced;
    end if;
  end process;
  press <= previous and not synced;
end architecture;
