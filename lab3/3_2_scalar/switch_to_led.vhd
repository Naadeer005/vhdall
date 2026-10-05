library ieee;
    use ieee.std_logic_1164.all;

entity switch_to_led is
    port (
        sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8, sw9           : in    std_logic;
        led0, led1, led2, led3, led4, led5, led6, led7, led8, led9 : out   std_logic
    );
end entity;

architecture Dataflow of switch_to_led is

begin

    led0 <= sw0;
    led1 <= sw1;
    led2 <= sw2;
    led3 <= sw3;
    led4 <= sw4;
    led5 <= sw5;
    led6 <= sw6;
    led7 <= sw7;
    led8 <= sw8;
    led9 <= sw9;

end architecture;
