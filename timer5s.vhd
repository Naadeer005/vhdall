library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity timer5s is
    generic (
        CLK_FREQ_HZ : positive := 50_000_000
    ) ;
  port (
    clk : in std_logic ;
    rst : in std_logic ;
    tick5 : out std_logic
  ) ;
end timer5s ; 

architecture arch of timer5s is
signal counter5 : natural range 0 to CLK_FREQ_HZ * 5 - 1 := 0 ;


begin
    
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter5 <= 0 ;
                tick5 <= '0' ;
            elsif counter5 = CLK_FREQ_HZ * 5 - 1 then
                counter5 <= 0 ;
                tick5 <= '1' ;
            else
                counter5 <= counter5 + 1 ;
                tick5 <= '0' ;
            end if ;
        end if ;
    end process ;



end architecture ;