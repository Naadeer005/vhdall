library ieee;
use ieee.std_logic_1164.all;

-- Generates a one-clock-cycle pulse every second.
-- Set CLK_FREQ_HZ to the input clock frequency (default: 50 MHz).
-- rst is an active-high synchronous reset; the first tick occurs
-- after CLK_FREQ_HZ rising clock edges following reset release.
entity timer_1sec is
    generic (
        CLK_FREQ_HZ : positive := 50_000_000
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity timer_1sec;

architecture rtl of timer_1sec is
    signal counter : natural range 0 to CLK_FREQ_HZ - 1 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
                tick <= '0';
            elsif counter = CLK_FREQ_HZ - 1 then
                counter <= 0;
                tick <= '1';
            else
                counter <= counter + 1;
                tick <= '0';
            end if;
        end if;
    end process;



end architecture rtl;
