library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity stopwatch is
    generic (
        CLK_FREQ_HZ : positive := 50_000_000
    );
    port (
        clk  : in    std_logic;
        rst  : in    std_logic;
        hex1 : out   std_logic_vector(6 downto 0);
        hex2 : out   std_logic_vector(6 downto 0);
        hex3 : out   std_logic_vector(6 downto 0);
        hex4 : out   std_logic_vector(6 downto 0);
        hex5 : out   std_logic_vector(6 downto 0);
        hex6 : out   std_logic_vector(6 downto 0)
    );
end stopwatch;

architecture arch of stopwatch is

    signal counter : natural range 0 to CLK_FREQ_HZ - 1 := 0;
    signal tick1   : std_logic;
    signal seconds : natural range 0 to 59              := 0;
    signal minutes : natural range 0 to 59              := 0;
    signal hours   : natural range 0 to 23              := 0;

begin

    process (clk)
    begin

        if rising_edge(clk) then
            if rst = '1' then
                counter <= 0;
            elsif counter = CLK_FREQ_HZ - 1 then
                counter <= 0;
                tick1   <= '1';
            else
                counter <= counter + 1;
                tick1   <= '0';
            end if;
        end if;

    end process;

    process (clk)
    begin

        if rising_edge(clk) then
            if rst = '1' then
                seconds <= 0;
                minutes <= 0;
                hours   <= 0;
            elsif tick1 = '1' then
                if seconds = 59 then
                    if minutes = 59 then
                        if hours = 23 then
                            hours <= 0;
                        else
                            hours <= hours + 1;
                        end if;
                        minutes <= 0;
                    else
                        minutes <= minutes + 1;
                    end if;
                    seconds <= 0;
                else
                    seconds <= seconds + 1;
                end if;
            end if;
        end if;

    end process;

    Hex1 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(seconds mod 10, 4)),
            hex => hex1
        );

    Hex2 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(seconds / 10, 4)),
            hex => hex2
        );

    Hex3 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(minutes mod 10, 4)),
            hex => hex3
        );

    Hex4 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(minutes / 10, 4)),
            hex => hex4
        );

    Hex5 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(hours mod 10, 4)),
            hex => hex5
        );

    Hex6 : entity work.bcd7seg
        port map (
            bcd => std_logic_vector(to_unsigned(hours / 10, 4)),
            hex => hex6
        );

end architecture;
