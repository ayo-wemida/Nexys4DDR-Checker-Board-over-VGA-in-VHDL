----------------------------------------------------------------------------------
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

entity Sync_Gen is
  Port ( clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         h_sync:out std_logic;
         horizontal_counter: out unsigned(9 downto 0);-------Used to count the pixels on the horizontal
         vertical_counter: out unsigned(9 downto 0);---------Used to count the pixels on the vertical
         v_sync: out std_logic);
end Sync_Gen;

architecture Behavioral of Sync_Gen is
signal horizontal_counter1: unsigned(9 downto 0):=(others=>'0');
signal vertical_counter1:  unsigned(9 downto 0):=(others=>'0');
signal en25: std_logic; ------25 MHZ enable
signal syncreset: std_logic;
signal vertreset: std_logic;
constant Max_vertical:  natural:=520;
constant Max_horizontal: natural:=799;

begin
---------------------An instance of pulse generator-------------------
Pulsegeneratorinst1 : entity work.pulseGenerator port map(
clk=>clk,
reset  => reset,
Pulseout=>en25----------default generic of 4 gives a clock of 100/4
);

process(clk, reset)
begin
if(reset = '1') then
    horizontal_counter1 <= (others => '0');
    vertical_counter1 <= (others => '0');
elsif(rising_edge(clk)) then
    if (en25='1') then ------on a 25 mhz enable
        if (syncreset= '1') then -------Sync reset is 1 when horizontal counter reaches max
            horizontal_counter1<= (others => '0');
            if vertreset='1' then-----vertreset is 1 when vertical counter reaches max
                vertical_counter1 <= (others => '0');
            else
                vertical_counter1 <= vertical_counter1 + 1;---------Increment vertical counter when horizontal counter reaches max
            end if;
        else
            horizontal_counter1 <= horizontal_counter1 + 1;-----------If horizontal counter is not at max, increment by 1
        end if;
    end if;
end if;
end process;
horizontal_counter<= horizontal_counter1 ;
vertical_counter<=vertical_counter1;
syncReset <= '1' when (horizontal_counter1 = Max_horizontal) else '0';
vertreset <= '1' when (vertical_counter1 = Max_vertical) else '0';

h_sync<= '0' when (horizontal_counter1 > to_unsigned(656,10) and horizontal_counter1 < to_unsigned(752,10)) else '1';----H_sync pulse
v_sync <= '0' when (vertical_counter1 > to_unsigned(490,10) and vertical_counter1 < to_unsigned(492,10)) else '1';---V_Sync pulse

end Behavioral;
