----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2023 02:00:39 PM
-- Design Name: 
-- Module Name: TestSource - Behavioral
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

entity TestSource is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           tx : out STD_LOGIC);
end TestSource;


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity instr_fetch is
  port (
    clk            : in    std_logic; 
    reset          : in    std_logic;
    enable         : in    std_logic;
    jump           : in    std_logic;
    pcsrc          : in    std_logic;
    branch_address : in    std_logic_vector(15 downto 0); --input this
    jump_address   : in    std_logic_vector(15 downto 0); --input this
    pc_plus_one    : out   std_logic_vector(15 downto 0); --add at the end
    instr          : out   std_logic_vector(15 downto 0)
  );
end entity instr_fetch;

architecture rtl of instr_fetch is

  type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);

   signal rom : rom_type := (
     b"000_000_001_010_0_000",		
   b"000_000_001_010_0_001",
   b"000_000_011_100_1_011",
   b"000_010_011_110_0_100",        
   b"000_010_011_110_0_101",
   b"000_000_001_111_0_110",
   b"000_010_011_110_0_111",
   b"001_000_001_0000000",
   b"010_010_011_0000001",
   b"011_010_011_0000010",
   b"100_011_100_0000100",
   b"101_011_100_0001000",
   b"100_111_000_0010000",
   b"111_1111111111111",
     others => x"0000"
   );
   
   signal counter: STD_LOGIC_VECTOR(15 downto 0);
   signal counter_out: STD_LOGIC_VECTOR(15 downto 0);
   
   signal add: STD_LOGIC_VECTOR(15 downto 0);
   signal mux_out: STD_LOGIC_VECTOR(15 downto 0);  
    
begin
process(clk)
begin
    if rising_edge(clk) then
        if enable = '1' then
            counter_out <= counter; 
        elsif reset = '1' then
            counter_out <= x"0000";
        end if;
    end if;
end process;

add <= counter_out + 1;
pc_plus_one <= add;
    
    instr <= rom(conv_integer(counter(7 downto 0)));
    
mux_out <= add when pcsrc = '0' else branch_address;
counter <= mux_out when jump = '0' else jump_address;

end architecture rtl;


architecture Behavioral of TestSource is

component MonoPulse is
    Port ( btn : in STD_LOGIC_VECTOR(4 downto 0);
           clk : in STD_LOGIC;
           en : out STD_LOGIC_VECTOR(4 downto 0));
end component;

component SevenSegment is
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           anod : out STD_LOGIC_VECTOR (3 downto 0);
           catod : out STD_LOGIC_VECTOR (6 downto 0));
end component;

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

  component instr_fetch is
    port (
      clk            : in    std_logic;
      reset          : in    std_logic;
      enable         : in    std_logic;
      jump           : in    std_logic;
      pcsrc          : in    std_logic;
      branch_address : in    std_logic_vector(15 downto 0);
      jump_address   : in    std_logic_vector(15 downto 0);
      pc_plus_one    : out   std_logic_vector(15 downto 0);
      instr          : out   std_logic_vector(15 downto 0)
    );
  end component;
  
  component instr_decode is
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
  end component;
  
  component constrol_unit is
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
  end component;
  
  component execution_unit is Port(
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
  end component;
  
  component memory_unit is Port ( 
      clk: in std_logic;
      MemWrite: in std_logic;
      ALURes: in std_logic_vector(15 downto 0);
      RD2: in std_logic_vector(15 downto 0);
      MemData: out std_logic_vector(15 downto 0);
      ALUResOut: out std_logic_vector(15 downto 0) 
  );
  end component;
  
  component tx_fsm is
    port (
      tx_data : in    std_logic_vector(7 downto 0);
      rst     : in    std_logic;
      tx_en   : in    std_logic;
      baud_en : in    std_logic;
      clk     : in    std_logic;
      tx_rdy  : out   std_logic;
      tx      : out   std_logic
    );
  end component;

  signal s_mpg_out   : std_logic_vector(4 downto 0);
  signal s_digits    : std_logic_vector(15 downto 0);
  signal pc_plus_one : std_logic_vector(15 downto 0);
  signal instr       : std_logic_vector(15 downto 0);
  signal pcsrc: std_logic;
  
  signal REGDST: std_logic;
  signal EXTOP: std_logic;
  signal ALUSRC: std_logic;
  signal BRANCH: std_logic;
  signal JUMP: std_logic;
  signal ALUOP: std_logic_vector(2 downto 0);
  signal MEMWRITE: std_logic;
  signal MEMTOREG: std_logic;
  signal REGWRITE: std_logic;
  
  signal RD1: std_logic_vector(15 downto 0);
  signal RD2: std_logic_vector(15 downto 0);
  signal Ext_Imm: std_logic_vector(15 downto 0);
  signal func: std_logic_vector(2 downto 0);
  signal sa: std_logic;
  signal zero: std_logic;
  
  signal brach_add: std_logic_vector(15 downto 0);
  signal ALURes: std_logic_vector(15 downto 0);
  signal MemData: std_logic_vector(15 downto 0);
  signal ALURes_out: std_logic_vector(15 downto 0);
  signal WriteData: std_logic_vector(15 downto 0);
  
  
  signal baud_en: std_logic;
  signal counter_baud: std_logic_vector(12 downto 0);
  signal tx_en: std_logic;
  
  signal tx_rdy: std_logic;
  
begin

  mpg : component MonoPulse
    port map (
      btn    => btn,
      clk    => clk,
      en => s_mpg_out
    );
    
    

  ssg : component SevenSegment
    port map (
      digit0 => s_digits(3 downto 0),
      digit1 => s_digits(7 downto 4),
      digit2 => s_digits(8 downto 11),
      digit3 => s_digits(15 downto 12),
      clk    => clk,
      anod     => an,
      catod    => cat
    );
    
    process(clk)
    begin
        if rising_edge(clk) then
            if conv_integer(counter_baud) = 10416 then
                baud_en <= '1';
                counter_baud <= x"000"&"0";
            else
                counter_baud <= counter_baud + 1;
                baud_en <= '0';
            end if;
        end if;
    end process;
    
    process(baud_en, s_mpg_out)
    begin
    if rising_edge(clk) then
        if baud_en = '1' then
            tx_en <= '0';
        elsif s_mpg_out(1) = '1' or s_mpg_out(0) = '1' then
            tx_en <= '1';
     end if;
    end if;
        
    end process;

  fsm : component tx_fsm
    port map(
      tx_data => sw(7 downto 0),
      rst     => '0',
      tx_en   => tx_en,
      baud_en => baud_en,
      clk     => clk,
      tx_rdy  => tx_rdy,
      tx      => tx
    );
    s_digits <= sw;
--  instr_fetch_inst : component instr_fetch
--    port map (
--      clk            => clk,
--      reset          => s_mpg_out(1),
--      enable         => s_mpg_out(0),
--      jump           => sw(1),
--      pcsrc          => sw(0),
--      branch_address => x"0002",
--      jump_address   => x"0000",
--     pc_plus_one    => pc_plus_one,
--      instr          => instr
--    );
    
--     pcsrc <= BRANCH and zero;
    
    
--    WriteData <= ALURes_out when MEMTOREG = '0' else MemData;
    
--    instr_decode_inst: component instr_decode
--    port map(
--        clk => clk,
--          instr => instr,
--          regwrite => REGWRITE,
--          regdst => REGDST,
--          extop => EXTOP,
--          wd => WriteData,
--          ext_imm => Ext_Imm,
--          func => func,
--          sa => sa,
--          rd1 => RD1,
--          rd2 => RD2
--    );
    
--    control_unit_inst: component constrol_unit
--      port map(
--          instr => instr(15 downto 13),
--          REGDST => REGDST,
--          EXTOP => EXTOP,
--          ALUSRC => ALUSRC,
--          BRANCH => BRANCH,
--          JUMP => JUMP,
--          ALUOP => ALUOP,
--          MEMWRITE => MEMWRITE,
--          MEMTOREG => MEMTOREG,
--          REGWRITE => REGWRITE
--      );
      
--      execution_unit_inst: component execution_unit
--      port map(
--            PC => pc_plus_one,
--            RD1 => RD1,
--            RD2 => RD2,
--            Ext_Imm => Ext_Imm,
--            sa => sa,
--            func => func,
--            ALUSrc => ALUSRC,
--            ALUOp => ALUOP,
--            Branch => brach_add,
--            ALURes => ALURes,
--            Zero => zero
--       );
        
--        memory_unit_inst: component memory_unit 
--        port map( 
--              clk => clk,
--              MemWrite => MEMWRITE,
--              ALURes => ALURes,
--              RD2 => RD2,
--              MemData => MemData,
--              ALUResOut => ALURes_out
--          );

--  s_digits <= instr when sw(7 downto 5) = "000" else
--              pc_plus_one when sw(7 downto 5) = "001" else
--              RD1 when sw(7 downto 5) = "010" else
--              RD2 when sw(7 downto 5) = "011" else
--              Ext_Imm when sw(7 downto 5) = "100" else
--              ALURes when sw(7 downto 5) = "101" else
--              MemData when sw(7 downto 5) = "110" else
--              WriteData when sw(7 downto 5) = "111";

end Behavioral;
