----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2023 01:38:37 PM
-- Design Name: 
-- Module Name: memory_unit - Behavioral
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

entity memory_unit is Port ( 
    clk: in std_logic;
    MemWrite: in std_logic;
    ALURes: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    MemData: out std_logic_vector(15 downto 0);
    ALUResOut: out std_logic_vector(15 downto 0) 
);
end memory_unit;

architecture Behavioral of memory_unit is

type RAM is array(0 to 255) of std_logic_vector(15 downto 0);
signal memory: RAM;

begin

process(clk, ALURes)
begin

if clk = '1' and rising_edge(clk) then
    if MemWrite = '1' then
        memory(conv_integer(ALURes(7 downto 0))) <= RD2;
    end if;
end if;
end process;

MemData <= memory(conv_integer(ALURes(7 downto 0)));
ALUResOut <= ALURes;

end Behavioral;
