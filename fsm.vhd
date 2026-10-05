library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
  port (
    clk  : in std_logic;
    rst  : in std_logic;
    hex1 : out std_logic_vector(6 downto 0)
  );
end fsm;

architecture arch of fsm is
  signal tick5 : std_logic;

  type state_type is (S0, S1, S2, S3, S4);
  signal state : state_type := S0;
begin

  U1 : entity work.timer5s
    generic map(
      CLK_FREQ_HZ => 50_000_000
    )
    port map
    (
      clk   => clk,
      rst   => rst,
      tick5 => tick5
    );

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state <= S0;
      else
        case state is
          when S0 =>
            if tick5 = '1' then
              state <= S1;
            end if;
          when S1 =>
            if tick5 = '1' then
              state <= S2;
            end if;

          when S2 =>
            if tick5 = '1' then
              state <= S3;
            end if;

          when S3 =>
            if tick5 = '1' then
              state <= S4;
            end if;

          when S4 =>
            if tick5 = '1' then
              state <= S0;
            end if;

        end case;
      end if;
    end if;
  end process;
end architecture;