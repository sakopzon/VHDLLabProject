--------------------------------------------------------
-- Keyboard bit receiver for the PS2 interface unit   --
--------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all ;
entity bitrec is
   port ( resetN    : in  std_logic                    ;
          clk       : in  std_logic                    ;
          kbd_clk   : in  std_logic                    ;
          kbd_dat   : in  std_logic                    ;
          dout_new  : out std_logic                    ;
          dout      : out std_logic_vector(7 downto 0) ) ;
end bitrec ;
architecture arc_bitrec of bitrec is
   signal clr_cnt   : std_logic                    ; -- clear bit counter  & shift register
   signal ena_cnt   : std_logic                    ; -- enable bit counter & shift register
   signal ena_out   : std_logic                    ; -- enable output register
   signal count     : integer range 0 to 15        ; -- bit counter
   signal count9    : std_logic                    ; -- detect end of transmission
   signal shift_reg : std_logic_vector(9 downto 0) ;
   signal parity_ok : std_logic                    ;

type state is (idle,start,high_clk,cnt_shift,low_clk,chk_data,update_out,
               tell_out,last_low);
signal cur_state, next_state : state := idle;   



begin


   -- internal bit counter
   process ( resetN , clk )
   begin
      if resetN = '0' then
         count <= 0 ;
      elsif clk'event and clk = '1' then
         if    clr_cnt = '1' then
            count <= 0 ;
         elsif ena_cnt = '1' then
            count <= count + 1 ;
         end if ;
      end if ;
   end process ;
   -- combinatorial detection of count of 9
   count9 <= '1' when count = 9 else '0' ;

   -- internal data shift register (sipo)
   process ( resetN , clk )
   begin
      if resetN = '0' then
         shift_reg <= (others => '0') ;
      elsif clk'event and clk = '1' then
         if    clr_cnt = '1' then
            shift_reg <= (others => '0') ;
         elsif ena_cnt = '1' then
            shift_reg <= kbd_dat & shift_reg(9 downto 1) ;
         end if ;
      end if ;
   end process ;

   -- detect that total parity is ok (odd)
   parity_ok <=     shift_reg(8) -- same as kbd_dat
                xor shift_reg(7) xor shift_reg(6)
                xor shift_reg(5) xor shift_reg(4)
                xor shift_reg(3) xor shift_reg(2)
                xor shift_reg(1) xor shift_reg(0);

   -- output (result) register (pipo)
   process ( resetN , clk )
   begin
      if resetN = '0' then
         dout <= (others => '0') ;
      elsif clk'event and clk = '1' then
         if ena_out  = '1' then
            dout <= shift_reg(7 downto 0) ;
         end if ;
      end if ;
   end process ;

   process(cur_state)
   begin
		clr_cnt<='0';ena_cnt<='0';ena_out<='0';dout_new<='0';
		case cur_state is
		when idle=>
			clr_cnt<='1';
			if kbd_clk='0' and kbd_dat='0' then
				next_state<=start;
			else
				next_state<=idle;
			end if;
		when start=>
			if kbd_clk='0' then
				next_state<=start;
			else
				next_state<=high_clk;
			end if;
		when high_clk=>
			if kbd_clk='0' then
				next_state<=cnt_shift;
			else
				next_state<=high_clk;
			end if;
		when cnt_shift=>
			ena_cnt<='1';
			if count9='0' then
				next_state<=low_clk;
			else
				next_state<=chk_data;
			end if;
			
		when low_clk=>
			if kbd_clk='0' then
				next_state<=low_clk;
			else
				next_state<=high_clk;
			end if;
		when chk_data=>
			if kbd_dat='1'and parity_ok='1' then
				next_state<=update_out;
			else
				next_state<=last_low;
			end if;
		when update_out=>
			ena_out<='1';
			next_state<=tell_out;
		when tell_out=>
		dout_new<='1';
		next_state<=last_low;
		when last_low=>
			if kbd_clk='0' then
				next_state<=last_low;
			else
				next_state<=idle;
			end if;
		end case ;		
	end process;
	
	process(clk,resetN)
	begin
		if resetN='0' then
			cur_state<=idle;
		elsif clk'event and clk='1' then
			cur_state<=next_state;
	    end if;
	end process;
	
end arc_bitrec;











