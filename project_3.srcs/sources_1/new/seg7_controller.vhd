----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ayodeji Wemida
-- 
-- Create Date: 02/12/2020 03:38:51 PM
-- Design Name: 7 segment controller
-- Module Name: seg7_controller - Behavioral
-- Project Name: 
-- Target Devices: Nexys4 DDR 

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
-----Initializing my 7 segment controller with the ports to be referenced
entity seg7_controller is
    Port ( CLK100MHZ : in STD_LOGIC;
           Char :  in STD_LOGIC_VECTOR (15 downto 0);
           SW: in std_logic;
           SEG7_CATH1: out std_logic_vector(7 downto 0);
           AN: out std_logic_vector(7 downto 0));       
end seg7_controller;

architecture Behavioral of seg7_controller is
    signal pulse1khz : std_logic;
    signal cntr1: unsigned(1 downto 0);
    signal digin: std_logic_vector(3 downto 0);
    signal Maxcounter:unsigned(2 downto 0);
begin
--------Create an instance of the pulse generator for 1khz in the 7 seg controller----------
This_pulse : entity pulseGenerator
    generic map(maxcnt=>100000)
    port map(
        clk => CLK100MHZ,
        reset => SW,
        Pulseout => pulse1khz
);

--------This counter increases on every 1khz cycle----------
process(CLK100MHZ, SW)
begin
    if(SW = '1') then
        cntr1 <= (others => '0');
    elsif(rising_edge(CLK100MHZ)) then
        if(pulse1khz = '1') then
            cntr1 <= cntr1 + 1;
        end if;
    end if;
    end process;

-------------Creating an instance of the 7 segment decoder-----------
Seg1: entity seg7_hex port map(digit=> digin ,seg7 => SEG7_CATH1);
    process(cntr1,char)
    begin
        ------------------The anodes and cathodes time multiplex at a rate of 1khz based on the counter values---------------
        if (cntr1 = "00") then
               AN<=  "11111110";
            digin <= Char(3 downto 0);
        elsif(cntr1 = "01") then
            AN<= "11111101";
            digin <= Char(7 downto 4);
        elsif(cntr1 = "10") then
            AN <= "11111011";
            digin <= Char(11 downto 8);
        elsif(cntr1= "11") then
            AN <= "11110111";
            digin <= Char(15 downto 12);
--elsif(cntr1= "100") then
--    AN <= "11101111";
--    digin <= Char(19 downto 16);
--elsif(cntr1 = "101") then
--    AN <= "11011111";
--    digin <= Char(23 downto 20);
--elsif (cntr1="110") then
--    AN <= "10111111";
--    digin <= Char(27 downto 24);
--elsif (cntr1= "111") then
--    AN <= "01111111";
--    digin <= Char(31 downto 28);
else
AN<= "00000000";
digin<= (others=> '1');
end if;
end process;
end Behavioral;
