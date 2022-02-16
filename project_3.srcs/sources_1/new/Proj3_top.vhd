----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2020 05:08:14 PM
-- Design Name: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Proj3_top is
  Port ( VGA_R:out std_logic_vector(3 downto 0);
         VGA_G:out std_logic_vector(3 downto 0);
         VGA_B:out std_logic_vector(3 downto 0);
         v_sync:out std_logic;
         h_sync:out std_logic;
         CLK100MHZ:in std_logic;
         BTNU:in std_logic;
         BTND:in std_logic;
         BTNL:in std_logic;
         BTNR:in std_logic;
         SW: in std_logic_vector(1 downto 0);
         AN: out std_logic_vector(7 downto 0);
         SEG7_CATH: out std_logic_vector(7 downto 0));
    end Proj3_top;

architecture Behavioral of Proj3_top is
    signal pulse200hz: std_logic;
    signal syncreset,vertreset: std_logic;
    signal reset: std_logic;
    signal x_red: integer range 0 to 19:=0;---left top coordinates for my left square
    signal y_red: integer range 0 to 14:=0 ;---left top coordinates for my left square
    signal real_x,real_y: unsigned(9 downto 0);
    signal horizontal_counter,vertical_counter: unsigned(9 downto 0);
    signal x_val,y_val:std_logic;
    signal x_pos,y_pos: unsigned(9 downto 0);
    constant red_l,red_w: integer:= 32;
    signal Up,Down,Right,Left:std_logic;
    signal Char :  unsigned (15 downto 0):=(others=>'0');------- to hold the coordinate values
begin

reset<= SW(0);

---------Sync signal instantiation with h_sync,v_synce and the horizontal and veritcal counters
Sync_Geninst: entity work.Sync_Gen 
    port map(
        clk=>CLK100MHZ,
        reset  => reset,
        horizontal_counter=>horizontal_counter,
        vertical_counter=> vertical_counter,
        h_sync => h_sync,
        v_sync => v_sync);

------assign signals for the x and y pixels-------------
--- By using horizontal_counter(5) and vertical_counter(5), we are dividing the counters to 32 each so we can get
 ----20 columns and 15 rows since they are 480*640(modulo32 dividers)
    x_val<=horizontal_counter(5);
    y_val<=vertical_counter(5);
    x_pos<=horizontal_counter;-------pixel position on the x axis follows the horizontal counter
    y_pos<=vertical_counter;----------pixel position on the y axis follows the veritcal counter
 
---------Debounce all 4 buttons using the Debouncer.vhd----------------
BTNUinst: entity work.Debouncer 
    port map(
        CLK100MHZ=>CLK100MHZ,
        BTN=>BTNU,
        BTN_db=>Up,
        reset=>reset
);
BTNDinst: entity work.Debouncer 
    port map(
        CLK100MHZ=>CLK100MHZ,
        BTN=>BTND,
        BTN_db=>Down,
        reset=>reset
);
BTNRinst: entity Debouncer 
    port map(
        CLK100MHZ=>CLK100MHZ,
        BTN=>BTNR,
        BTN_db=>Right,
        reset=>reset
);
BTNLinst: entity Debouncer 
    port map(
        CLK100MHZ=>CLK100MHZ,
        BTN=>BTNL,
        BTN_db=>Left,
        reset=>reset
);
--------------Generate your 200hz setting max count as 500,000pulse to be used in the controls---------------
Pulsegeneratorinst2 : entity work.pulseGenerator 
    generic map(maxcnt=>500000)
    port map(
        clk=>clk100mhz,
        reset  => reset,
        Pulseout=>pulse200hz
);
-------------Up/Down &Right/Left movement---------------
process(clk100mhz,reset)
begin
    if reset='1' then
        x_red<= 0;
        y_red<= 0;
    elsif rising_edge(clk100mhz) then
        if pulse200hz = '1' then
            if Right = '1' then
                if x_red=19 then -------If red box is at rightmost box, return to leftmost box
                    x_red<=0;
                else
                    x_red<=x_red+1;----Move one step right
                end if;
            elsif Up='1' then
                if y_red /=0 then
                    y_red<=y_red-1;
                else
                    y_red <= 14;
               end if;
            
            elsif Left ='1' then
                if x_red<=0 then----If left button pressed and redbox is at leftmost box, move to the rightmost box
                    x_red<= 19;
                else 
                    x_red<=x_red-1;
                end if; 
            elsif Down ='1' then
                if y_red/=14 then
                    y_red<=y_red+1;
                else
                    y_red<=0;
                end if;
            end if; 
        end if;
    end if;     
end process;

---------------------real_x and real_y are the actual pixel values on the screen-----------------
    real_x<= to_unsigned((x_red*32),10);
    real_y<= to_unsigned((y_red*32),10);
    
process(clk100mhz)
begin
if rising_edge(clk100mhz) then
    if (x_pos >= real_x and x_pos < (real_x+red_l)) and (y_pos >= (real_y) and y_pos < (real_y+red_l)) then
        VGA_R <= ("1111");------------turn on the red color where the based on the coordinates----------------
    else 
        VGA_R<=(others =>'0'); 
    end if;
    if ((x_pos >= real_x) and (x_pos < (real_x+red_l))) and ((y_pos >= real_y) and (y_pos < (real_y+red_w))) then
        VGA_G<=  ("0000");--------------Turn off the green color when the red box is on at that location

    elsif ((x_pos >= to_unsigned(0,10)) and (x_pos < to_unsigned(639,10))) and ((y_pos >= to_unsigned(0,10)) and (y_pos < to_unsigned(479,10))) then
        VGA_G<=(x_val & x_val & x_val & x_val)xor(y_val & y_val & y_val & y_val) ;

    else 
        VGA_G<=(others =>'0');
    end if;
    if ((x_pos >= real_x) and (x_pos < (real_x+red_l))) and ((y_pos>= real_y) and (y_pos < (real_y+red_w))) then
        VGA_B<= "0000"; 
    elsif ((x_pos >= to_unsigned(0,10)) and (x_pos < to_unsigned(639,10))) and ((y_pos >= to_unsigned(0,10)) and (y_pos < to_unsigned(479,10))) then
        VGA_B<=not (x_val & x_val & x_val & x_val)xor (y_val & y_val & y_val & y_val);

    else 
        VGA_B<=(others =>'0');
    end if;
end if;
end process;
------Red Sq Coordinates---------
-------Instantiating the sevenseg controller-------
Controlseg : entity seg7_controller
    port map(
        CLK100MHZ => CLK100MHZ,
        SW => reset,
        SEG7_CATH1 => SEG7_CATH,
        Char=>std_logic_vector(Char),
        AN=>AN);

---------Track the x-y-coordinates based on button presses---------
Char(15 downto 8)<= to_unsigned(x_red,8); -------------the x coordinates are written to 15 downto 8 for AN(3 downto 2)
Char(7 downto 0)<= to_unsigned(y_red,8);---------------the y coordinates are written to 7 downto 0 for AN(1 downto 0)

end Behavioral;
