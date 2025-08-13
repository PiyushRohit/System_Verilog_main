module chu_spi_core # (parameter s = 2)
  
  (
    input logic clk,
    input logic reset,
    input logic cs,
    input logic read,
    input logic write,
    input logic [4:0] addr,
    input logic [31:0] wr_data,
    input logic [31:0] rd_data,

    output logic spi_sclk,
    output logic spi_mosi,
    input logic spi_miso,
    output logiv [s-1 : 0] spi_ss_n
  );

  logic wr_en ,wr_ss ,wr_spi ,wr_ctrl;
  logiv [17:0] ctrl_reg;
  logic[s-1 :0] ss_n_reg;
  logic [7:0] spi_out;
  logiv spi_ready ,cpol ,cpha;
  logic [15:0] dvsr;

  spi spi_unit(
    .clk(clk), .reset(reset),
    .din(wr_data[7:0]),
    .dvsr(dvsr),
    .start(w_spi),
    .cpol(cpol),
    .cpha(cpha),
    .dout(spi_out),
    .sclk(spi_sclk),
    .miso(spi_miso),
    .mosi(spi_mosi),
    .spi_done_tick(),
    .ready(spi_ready)
  );

  always_ff @(posedge clk ,posedge reset)
   if(reset)begin
    ctrl_reg <= 17'h0_0200;
    ss_n_reg<= {s{1'b1}};
   end
   else begin
       if(wr_ctrl) ctrl_reg <=wr_data[17:0];
       if(wr_ss) ss_n_reg <= wr_data[s-1 :0];
   end


   assign wr_en =cs & write;
   assign wr_ss =wr_en && addr[1:0] ==2'b01;
   assign wr_spi =wr_en && addr[1:0]== 2'b10;
   assign wr_ctrl =wr_en && addr[1:0] ==2'b11;

   assign dvsr =ctrl_reg[15:0];
   assign cpol=ctrl_reg[16];
   assign cpha =ctrl_reg[17];
   assign spi_ss_n =ss_n_reg;
   assign rd_data ={23'b0 ,spi_ready,spi_out};

endmodule