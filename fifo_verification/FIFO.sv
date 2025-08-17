module FIFO (
  input clk,write,read,reset
  input [7:0] din;
  output reg [7:0] dout;
  output   full,
  output   empty
);

reg[3:0] wptr,rptr; //pointer for write and read opertions
reg[4:0] cnt=0; // counter for tracking number of elemnet in fifo

reg[4:0] mem[15:0]; //memory array to store data

always @(posedge clk) begin
  if( reset = 1'b1) begin
    
    wptr <= 0;
    rptr <= 0;
    count<= 0;
  end

  else if(write=1'b1 && full !=1) begin
    mem[wptr] <= din;
    wptr <= wptr+1;
    cnt <= cnt+1;
  end

  else if(read =1'b1 && empty !=1 ) begin
    dout <= din;
    rptr <= rptr+1;
    cnt <= cnt-1;
  end
end

assign empty =(cnt ==0) ?1'b1:1'b0;
assign full  =(cnt == 16)? 1'b1:1'b0;

endmodule

 
 
  

interface fifo_if;
  logic clk,read,write; //clock signal
  logic rst; // Reset signal
  logic[7:0] din; // Data input
  logic [7:0] dout; //Data output
  logic full,empty;
  
endinterface 