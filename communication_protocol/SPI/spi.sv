module spi(
  input logic clk,reset,
  input logic [7:0] din,
  input logic [15:0] dvsr,
  input logic start ,cpol,cpha,
  output logic [7:0] dout,
  output logic spi_done_tick ,ready,
  output logic sclk,
  input logic miso,
  output logic mosi
);

typedef enum{idle,cpha_delay,po,p1} state_type;

state_type state_reg,state_next;

logic p_clk;
logic [15:0] c_reg,c_next;
logic spi_clk_reg ,ready_i ,spi_done_tick_i ;
logic spi_clk_next;
logic [2:0] n_reg , n_next;
logic[7:0] si_reg ,si_next;
logic [7:0] so_reg ,so_next;

always_ff @( posedge clk, posedge reset ) 
   if (reset) begin
    state_reg <= idle;
    si_reg <= 0;
    so_reg <= 0;
    n_reg <= 0;
    c_reg <= 0;
    spi_clk_reg <= 0;

   end

   else begin
    state_reg <= state_next;
    si_reg <= si_next;
    so_reg <= so_next;
    n_reg <= n_next;
    c_reg <= c_next;
    spi_clk_reg <= spi_clk_next;
   end

always_comb begin 
  state_next =state_reg;
  ready_i =0;
  spi_done_tick_i =0;
  si_next =si_reg;
  so_next =so_reg;
  n_next = n_reg;
  c_next =c_reg;
  case (state_reg)
   idle :begin
    ready_i =1;
    if(start) begin
      ready_i =1;
      if(start) begin
        so_next =din;
        n_next =0;
        c_next =0;
        if(cpha) state_next =cpha_delay;
        else state_next =po;
      end
      end
    end
    cpha_delay :begin
      if(c_reg ==dvsr) begin
        state_next = po;
        c_next =0;
      end
    end
    po:begin
      if (c_reg ==dvsr) begin
        state_next =p1;
        si_next ={si_reg[6:0],miso};
        c_next =0;
      end
      else c_next=c_reg +1;
    end
    p1:begin
      if(c_reg ==dvsr)
       if(n_reg ==7) begin
        spi_done_tick_i =1;
        state_next =idle;
       end
       else begin
        so_next ={so_reg[6:0],1'b0};
        state_next =po;
        n_next =n_reg +1;
        c_next=0;
       end
       else c_next =c_reg+1;
    end
  endcase
end
assign ready=ready_i;
assign spi_done_tick =spi_done_tick_i;

assign p_clk=(state_next == p1 && ~cpha) || (state_next==po && cpha);
assign spi_clk_next =(cpol) ? ~p_clk :p_clk;

assign dout=si_reg;
assign mosi =so_reg[7];
assign sclk =spi_clk_reg;

endmodule