
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulseGenerator is
generic(maxcnt: natural:=4); ---Can be modified on instantiation
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Pulseout : out STD_LOGIC);
end pulseGenerator;

architecture Behavioral of pulseGenerator is
signal cntr : natural range 0 to maxcnt-1;
begin
process(clk,reset)
begin 
    if(reset = '1') then 
        cntr <= 0;
    elsif(rising_edge(clk)) then
        if cntr=maxcnt-1 then ----Counter counts from 0 to maxcnt-1 and then resets back to 0
            cntr <= 0;
        else
        cntr <= cntr + 1;
        end if;
    end if;
end process;

Pulseout <= '1' when (cntr=maxcnt-1) else '0'; ----Pulseout gives the new clock enable based on maxcnt
end Behavioral;
