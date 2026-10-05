library ieee;
    use ieee.std_logic_1164.all;

entity stopwatch_top is
    generic (
        DIV_COUNT : positive := 50000000
    );
    port (
        clk, key0, key1 : in    std_logic;
        hex5            : out   std_logic_vector(7 downto 0);
        hex4            : out   std_logic_vector(7 downto 0);
        hex3            : out   std_logic_vector(7 downto 0);
        hex2            : out   std_logic_vector(7 downto 0);
        hex1            : out   std_logic_vector(7 downto 0);
        hex0            : out   std_logic_vector(7 downto 0)
    );
end entity;

architecture Structural of stopwatch_top is

    signal tick, sec_en, clr      : std_logic;
    signal c0, c1, c2, c3         : std_logic;
    signal d0, d1, d2, d3, d4, d5 : std_logic_vector(3 downto 0);
    signal press_start            : std_logic;
    signal run                    : std_logic := '0';

begin

    U_START : entity work.button_press(Behavioral)
        port map (
            clk   => clk,
            key_n => key0,
            press => press_start
        );

    U_RESET : entity work.button_press(Behavioral)
        port map (
            clk   => clk,
            key_n => key1,
            press => clr
        );

    process (clk)
    begin

        if rising_edge(clk) then
            if clr = '1' then
                run <= '0';
            elsif press_start = '1' then
                run <= not run;
            end if;
        end if;

    end process;

    sec_en <= tick and run;

    U_DIV : entity work.clock_divider(Behavioral)
        generic map (
            DIV_COUNT => DIV_COUNT
        )
        port map (
            clk  => clk,
            tick => tick
        );

    U_SEC_U : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 10
        )
        port map (
            clk   => clk,
            en    => sec_en,
            count => d0,
            carry => c0,
            clr   => clr
        );

    U_SEC_T : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 6
        )
        port map (
            clk   => clk,
            en    => c0,
            count => d1,
            carry => c1,
            clr   => clr
        );

    U_MIN_U : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 10
        )
        port map (
            clk   => clk,
            en    => c1,
            count => d2,
            carry => c2,
            clr   => clr
        );

    U_MIN_T : entity work.mod_counter(Behavioral)
        generic map (
            MOD_VALUE => 6
        )
        port map (
            clk   => clk,
            en    => c2,
            count => d3,
            carry => c3,
            clr   => clr
        );

    U_HOURS : entity work.hours_counter(Behavioral)
        port map (
            clk     => clk,
            en      => c3,
            tens    => d5,
            \units\ => d4,
            clr     => clr
        );

    U_DEC0 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d0,
            seg => hex0
        );

    U_DEC1 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d1,
            seg => hex1
        );

    U_DEC2 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d2,
            seg => hex2
        );

    U_DEC3 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d3,
            seg => hex3
        );

    U_DEC4 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d4,
            seg => hex4
        );

    U_DEC5 : entity work.bcd_to_7seg(Structural)
        port map (
            bcd => d5,
            seg => hex5
        );

end architecture;
