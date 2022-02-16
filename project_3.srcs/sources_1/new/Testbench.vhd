----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/09/2020 10:06:16 PM
-- Design Name: 
-- Module Name: Testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Testbench is
--  Port ( );
end Testbench;

architecture Behavioral of Testbench is
     signal VGA_R: std_logic_vector(3 downto 0);
     signal VGA_G: std_logic_vector(3 downto 0);
     signal VGA_B: std_logic_vector(3 downto 0);
     signal v_sync: std_logic;
     signal h_sync: std_logic;
     signal CLK100MHZ: std_logic := '0';
     signal BTNU: std_logic;
     signal BTND: std_logic:='0';
     signal BTNL: std_logic:='0';
     signal BTNR: std_logic:='0';
     signal SW: std_logic_vector(1 downto 0);
     signal AN:  std_logic_vector(7 downto 0);
     signal SEG7_CATH:  std_logic_vector(7 downto 0);

    constant Period: time := 10 ns;
begin

CLK100MHZ <= not CLK100MHZ after Period/2; 
DUT : entity work.Proj3_top
 Port map ( VGA_R => VGA_R,
         VGA_G => VGA_G,
         VGA_B => VGA_B,
         v_sync => v_sync,
         h_sync => h_sync,
         CLK100MHZ => CLK100MHZ,
         BTNU => BTNU,
         BTND => BTND,
         BTNL => BTNL,
         BTNR => BTNR,
         SW => SW,
         AN => AN,
         SEG7_CATH => SEG7_CATH
     );
     
     stimulus: process
     begin
        SW(0) <= '1';
        wait for 10 ns;
        sw(0) <= '0';
       
        BTNU <= '0';
        wait for 50 ns;
        BTNU <= '1';
        wait for 1000 ns;
         BTNU<= '0';
         
         BTND <= '0';
        wait for 50 ns;
        BTND <= '1';
        wait for 1000 ns;
         BTND<= '0';
         
        BTNR <= '0';
        wait for 50 ns;
        BTNR <= '1';
        wait for 500 ms;
         BTNR<= '0';
         
        BTNL <= '0';
        wait for 50 ns;
        BTNL <= '1';
        wait for 500 ms;
         BTNL<= '0';
    end process;
    
        
end Behavioral;
