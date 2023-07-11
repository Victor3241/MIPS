----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2023 03:07:53 PM
-- Design Name: 
-- Module Name: SevenSegment - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegment is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           anod : out STD_LOGIC_VECTOR (3 downto 0);
           catod : out STD_LOGIC_VECTOR (6 downto 0));
end SevenSegment;

architecture Behavioral of SevenSegment is


signal HEX:std_logic_vector(3 downto 0);
signal sel:std_logic_vector(1 downto 0);
signal counter:std_logic_vector(15 downto 0);

begin

process(clk)
begin
    if rising_edge(clk) then
       counter <= counter + 1;
   end if;
end process;

sel <= counter(15 downto 14);

process(digit0, digit1, digit2, digit3, sel)
begin
case sel is 
    when "00" => HEX <= digit0;
    when "01" => HEX <= digit1;
    when "10" => HEX <= digit2;
    when others => HEX <= digit3;
    end case;
    
   case sel is
   when "00" => anod <= "1110";
   when "01" => anod <= "1101";
   when "10" => anod <= "1011";
   when others => anod <= "0111";
   end case;
end process;

process(HEX)
begin 
        with HEX  SELect
catod<= "1111001" when "0001",   --1
     "0100100" when "0010",   --2
     "0110000" when "0011",   --3
     "0011001" when "0100",   --4
     "0010010" when "0101",   --5
     "0000010" when "0110",   --6
     "1111000" when "0111",   --7
     "0000000" when "1000",   --8
     "0010000" when "1001",   --9
     "0001000" when "1010",   --A
     "0000011" when "1011",   --b
     "1000110" when "1100",   --C
     "0100001" when "1101",   --d
     "0000110" when "1110",   --E
     "0001110" when "1111",   --F
     "1000000" when others;   --0
end process;

end Behavioral;
