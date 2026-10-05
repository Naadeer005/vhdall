library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_fsm is
    port (clk, start : in std_logic; a, b : in std_logic_vector(3 downto 0); done : out std_logic; acc : out std_logic_vector(7 downto 0));
end entity;

architecture Behavioral of multiplier_fsm is
    type state_type is (IDLE, ADD, SHIFT, DONE_STATE);
    signal state : state_type := IDLE;
    signal a_reg, partial, product : unsigned(7 downto 0) := (others => '0');
    signal b_reg : unsigned(3 downto 0) := (others => '0');
    signal i : integer range 0 to 3 := 0;
    signal done_int : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when IDLE =>
                    if start = '1' then
                        a_reg <= resize(unsigned(a), 8); b_reg <= unsigned(b);
                        partial <= (others => '0'); i <= 0; done_int <= '0'; state <= ADD;
                    end if;
                when ADD =>
                    if b_reg(0) = '1' then partial <= partial+a_reg; end if;
                    if i = 3 then state <= DONE_STATE; else state <= SHIFT; end if;
                when SHIFT =>
                    a_reg <= shift_left(a_reg, 1); b_reg <= shift_right(b_reg, 1);
                    i <= i+1; state <= ADD;
                when DONE_STATE =>
                    product <= partial; done_int <= '1'; state <= IDLE;
            end case;
        end if;
    end process;
    done <= done_int;
    acc <= std_logic_vector(product);
end architecture;
