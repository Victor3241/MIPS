----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2023 01:40:20 PM
-- Design Name: 
-- Module Name: execution_unit - Behavioral
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

entity execution_unit is Port(
    PC: in std_logic_vector(15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15downto 0);
    Ext_Imm: in std_logic_vector(15 downto 0);
    sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    ALUSrc: in std_logic;
    ALUOp: in std_logic_vector(2 downto 0);
    Branch: out std_logic_vector(15 downto 0);
    ALURes: out std_logic_vector(15 downto 0);
    Zero: out std_logic
);
--  Port ( );
end execution_unit;

architecture Behavioral of execution_unit is

signal mux_out: std_logic_vector(15 downto 0);
signal ALUControl: std_logic_vector(5 downto 0);
signal SetLess: std_logic_vector(15 downto 0);
signal ALUResSignal: std_logic_vector(15 downto 0);

begin

mux_out <= RD2 when ALUSrc = '0' else Ext_Imm;
Branch <= Pc + Ext_Imm;
ALUControl <= func & ALUOp;
SetLess <= RD1 when RD1 < mux_out else mux_out;

ALUResSignal <= RD1 + RD2 when ALUControl = "000000" else
          RD1 - RD2 when ALUControl = "001000" else
          RD1(15 downto 1) & '0' when ALUControl = "010000" else
          '0' & RD1(14 downto 0) when ALUControl = "011000" else
          RD1 and RD2 when ALUControl = "100000" else
          RD1 or RD2 when ALUControl = "101000" else
          RD1 xor RD2 when ALUControl = "111000" else
          SetLess when ALUControl = "110000" else
          RD1 + mux_out when ALUControl = "XXX001" else
          RD1 when ALUControl = "XXX010" else 
          RD1 when ALUControl = "XXX011" else 
          x"0000" when ALUControl = "XXX100" and RD1 = x"0000" else 
          x"0000" when ALUControl = "XXX101" and not RD1 = x"0000" else 
          x"0000" when ALUControl = "XXX110" and RD1 > x"0000" else
          RD1;
          
ALURes <= ALUResSignal;
Zero <= '1' when AlUResSignal = x"0000" else '0';     


end Behavioral;
