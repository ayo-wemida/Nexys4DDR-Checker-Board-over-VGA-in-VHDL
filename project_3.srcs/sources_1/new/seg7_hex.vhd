----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ayodeji Wemida
-- 
-- Create Date: 02/10/2020 12:45:10 PM
-- Design Name: 7 Segment display component
-- Module Name: seg7_hex - Behavioral
-- Project Name: FPGA_Lab1
-- Target Devices: Nexys4 DDR

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

entity seg7_hex is
    Port ( digit : std_logic_vector (3 downto 0);---Component input port
           seg7 : out STD_LOGIC_VECTOR (7 downto 0));--- Component output port
end seg7_hex;

architecture Behavior of seg7_hex is
    signal display_digit : std_logic_vector(3 downto 0);--- Creating a signal for digit
begin
display_digit <= digit; ---display_digit reads from digit
    with display_digit select
 seg7 <=
 "11000000" when x"0" ,
 "11111001" when x"1" ,
 "10100100" when x"2" ,
 "10110000" when x"3" ,
 "10011001" when x"4" ,
 "10010010" when x"5" ,
 "10000010" when x"6" ,
 "11111000" when x"7" ,
 "10000000" when x"8" ,
 "10010000" when x"9" ,
 "10001000" when x"A" ,
 "10000011" when x"B" ,
 "11000110" when x"C" ,
 "10100001" when x"D" ,
 "10000110" when x"E" ,
 "10001110" when others;---- selecting the values for the seven segment vector based on switch 3 down to 0 position
end Behavior;
