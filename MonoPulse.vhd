----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2023 02:58:01 PM
-- Design Name: 
-- Module Name: MonoPulse - Behavioral
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


entity MonoPulse is
    Port ( btn : in STD_LOGIC_VECTOR(4 downto 0);
           clk : in STD_LOGIC;
           en : out STD_LOGIC_VECTOR(4 downto 0));
end MonoPulse;

architecture Behavioral of MonoPulse is

signal enable: std_logic_vector(15 downto 0);
signal d1: std_logic_vector(4 downto 0);
signal d2: std_logic_vector(4 downto 0);
signal d3: std_logic_vector(4 downto 0);

begin
process(clk)
begin
    if rising_edge(clk) then
       enable <= enable + 1;
   end if;
end process;


process(clk)
begin
 if enable = x"FFFF" and rising_edge(clk) then
           d1<=btn;
           end if;
end process;

process(clk)
begin
 if rising_edge(clk) then
    d2 <= d1;
    end if;
end process;

process(clk)
begin
 if rising_edge(clk) then
    d3 <= d2;
    end if;
end process;

en <= not d3 and d2;
end Behavioral;
