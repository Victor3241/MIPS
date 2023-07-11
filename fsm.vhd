library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity tx_fsm is
  port (
    tx_data : in    std_logic_vector(7 downto 0);
    rst     : in    std_logic;
    tx_en   : in    std_logic;
    baud_en : in    std_logic;
    clk     : in    std_logic;
    tx_rdy  : out   std_logic;
    tx      : out   std_logic
  );
end entity tx_fsm;

architecture behavioral of tx_fsm is

  type fsm_state is (st_idle, st_start, st_bit, st_stop);

  signal state   : fsm_state;
  signal bit_cnt : std_logic_vector(2 downto 0);

begin

  proc1 : process (clk, rst) is
  begin
  if rst = '1' then state <= st_idle;
  elsif rising_edge(clk) then 
  if baud_en = '1' then
    case state is
    when st_idle => if tx_en = '1' then state <= st_start;
    end if;
    bit_cnt <= "000";
    when st_start => state <= st_bit;
    when st_bit => if conv_integer(bit_cnt) < 7 then state <= st_bit;
    bit_cnt <= bit_cnt + 1;
    else state <= st_stop;
    end if;
    when others => state <= st_idle;
    end case;
    end if;
    end if;

  end process proc1;

  proc2 : process (state) is
  begin
    case state is
    when st_idle => tx <= '1'; tx_rdy <= '1';
    when st_start => tx <= '0'; tx_rdy <= '0';
    when st_bit => tx <= tx_data(conv_integer(bit_cnt)); tx_rdy <= '0';
    when others => tx <= '1'; tx_rdy <= '0';
    end case;
   

  end process proc2;

end architecture behavioral;