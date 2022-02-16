----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Additional Comments:
-- 
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

entity Debouncer is
 Port ( CLK100MHZ: in std_logic;
 BTN: in std_logic;
 BTN_db:out std_logic;
 reset: in std_logic);
end Debouncer;

architecture Behavioral of Debouncer is
signal cntr: natural:=0;
signal SyncReset: std_logic;
signal Pulse200Hz: std_logic;
signal delay1:std_logic;
signal delay2:std_logic;


constant Maxcount: natural:=500000;---Change this back to 500,000 after simulation
begin
process(CLK100MHZ,reset)
begin 
    if(reset = '1') then 
        cntr <= 0;
    elsif(rising_edge(CLK100MHZ)) then
        if(syncReset = '1') then
            cntr <= 0;
        else
        cntr <= cntr + 1;
        end if;
    end if;
end process;

syncReset <= '1' when (cntr = Maxcount) else '0';
Pulse200Hz <= syncReset;

process(clk100mhz,reset)
begin
    if reset='1' then
        delay1<= '0';
        delay2<= '0';
    elsif (rising_edge(clk100mhz)) then
        if pulse200hz = '1' then
            delay1<= BTN;--------delay1 takes the value of btn press on the next
            delay2<= delay1; ----delay2 takes the value of delay 1 on the next clock
        end if;
    end if;
   
end process;
Btn_db<= delay1 and (not delay2);
end Behavioral;
