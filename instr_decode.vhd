----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 01:50:37 PM
-- Design Name: 
-- Module Name: instr_decode - Behavioral
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

entity instr_decode is
    port(
    clk: in std_logic;
    instr: in std_logic_vector(15 downto 0);
    regwrite: in std_logic;
    regdst: in std_logic;
    extop: in std_logic;
    wd: in std_logic_vector(15 downto 0);
    ext_imm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic;
    rd1: out std_logic_vector(15 downto 0);
    rd2: out std_logic_vector(15 downto 0)
    );
end instr_decode;

architecture Behavioral of instr_decode is

signal wa: std_logic_vector(2 downto 0);

component reg_file is
port (
    clk : in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    wen : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
);
end component;

begin

wa <= instr(9 downto 7) when regdst = '0' else instr(6 downto 4);
ext_imm <= x"00"&"0"&instr(6 downto 0) when regdst = '0' else x"11"&"1"&instr(6 downto 0) when instr(6) = '1' else x"00"&"0"&instr(6 downto 0);
func<= instr(2 downto 0);
sa<=instr(3);
C1:reg_file port map(clk, instr(12 downto 10), instr(9 downto 7), wa, wd, regwrite, rd1, rd2);


end Behavioral;
