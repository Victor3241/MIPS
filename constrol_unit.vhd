----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 03:04:44 PM
-- Design Name: 
-- Module Name: constrol_unit - Behavioral
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

--regdst
--extop
--alusrc
--branch
--jump
--aluop
--memwrite
--memtoreg
--regwrite

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity constrol_unit is
port(
    instr: in std_logic_vector(2 downto 0);
    REGDST: out std_logic;
    EXTOP: out std_logic;
    ALUSRC: out std_logic;
    BRANCH: out std_logic;
    JUMP: out std_logic;
    ALUOP: out std_logic_vector(2 downto 0);
    MEMWRITE: out std_logic;
    MEMTOREG: out std_logic;
    REGWRITE: out std_logic
);
end constrol_unit;

architecture Behavioral of constrol_unit is

begin

process(instr)
begin
case instr is
    when "000" =>
        REGDST <= '1'; 
        EXTOP <= '0';
        ALUSRC <= '0'; 
        BRANCH <= '0'; 
        JUMP <= '0'; 
        ALUOP <= "000"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '1';
    when "001" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '0'; 
        JUMP <= '0'; 
        ALUOP <= "001"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '1';
    when "010" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '0'; 
        JUMP <= '0'; 
        ALUOP <= "010"; 
        MEMWRITE <= '1';
        MEMTOREG <= '1'; 
        REGWRITE <= '1'; 
    when "011" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '0'; 
        JUMP <= '0'; 
        ALUOP <= "011"; 
        MEMWRITE <= '1';
        MEMTOREG <= '1'; 
        REGWRITE <= '0';
    when "100" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '1'; 
        JUMP <= '0'; 
        ALUOP <= "100"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '0'; 
    when "101" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '1'; 
        JUMP <= '0'; 
        ALUOP <= "101"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '0';
    when "110" =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '1'; 
        BRANCH <= '1'; 
        JUMP <= '0'; 
        ALUOP <= "110"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '0'; 
    when others =>
        REGDST <= '0'; 
        EXTOP <= '0';
        ALUSRC <= '0'; 
        BRANCH <= '0'; 
        JUMP <= '1'; 
        ALUOP <= "111"; 
        MEMWRITE <= '0';
        MEMTOREG <= '0'; 
        REGWRITE <= '0'; 
end case;

end process;


end Behavioral;
