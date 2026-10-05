library ieee;
    use ieee.std_logic_1164.all;

entity switch_to_led is
    port (
        sw  : in    std_logic_vector(9 downto 0);
        led : out   std_logic_vector(9 downto 0)
    );
end entity;

architecture Dataflow of switch_to_led is

begin

    led <= sw;

end architecture;
