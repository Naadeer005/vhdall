library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_pkg is
    subtype segment is std_logic_vector(7 downto 0);
    type segment_array is array (natural range <>) of segment;
    function digit(n : natural) return segment;
    function message(n : natural) return segment;
    procedure step(signal clk : out std_logic; n : positive := 1);
    procedure push(signal clk : out std_logic; signal key_n : out std_logic);
end package;

package body tb_pkg is
    function digit(n : natural) return segment is
    begin
        case n is
            when 0 => return x"C0"; when 1 => return x"F9";
            when 2 => return x"A4"; when 3 => return x"B0";
            when 4 => return x"99"; when 5 => return x"92";
            when 6 => return x"82"; when 7 => return x"F8";
            when 8 => return x"80"; when 9 => return x"90";
            when others => return x"FF";
        end case;
    end;
    function message(n : natural) return segment is
    begin
        case n is
            when 0 => return x"89"; -- H
            when 1 => return x"86"; -- E
            when 2 | 3 => return x"C7"; -- L
            when 4 => return x"C0"; -- O
            when others => return x"FF";
        end case;
    end;
    procedure step(signal clk : out std_logic; n : positive := 1) is
    begin
        for i in 1 to n loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end;
    procedure push(signal clk : out std_logic; signal key_n : out std_logic) is
    begin
        key_n <= '0'; step(clk, 6);
        key_n <= '1'; step(clk, 6);
    end;
end package body;
