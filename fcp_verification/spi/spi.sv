module master (
  input  wire        clk,
  input  wire        newd,
  input  wire        rst,
  input  wire [11:0] din,
  output reg         cs,
  output reg         sclk,
  output reg         mosi
);

  typedef enum bit [1:0] {
    idle   = 2'b00,
    enable = 2'b01,
    send   = 2'b10,
    comp   = 2'b11
  } state_type;

  state_type state = idle;

  int countc = 0;
  int count  = 0;
  reg [11:0] temp;

  // Clock divider for sclk
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      countc <= 0;
      sclk   <= 0;
    end else begin
      if (countc < 10) countc <= countc + 1;
      else begin
        countc <= 0;
        sclk   <= ~sclk;
      end
    end
  end

  // State machine
  always @(posedge sclk or posedge rst) begin
    if (rst) begin
      cs   <= 1;
      mosi <= 0;
      state <= idle;
      count <= 0;
    end 
    else begin
      case (state)
        idle: begin
          cs   <= 1;
          mosi <= 0;
          if (newd) begin
            state <= send;
            temp  <= din;
            cs    <= 0;
            count <= 0;
          end
        end

        send: begin
          if (count <= 11) begin
            mosi  <= temp[11-count]; // MSB first
            count <= count + 1;
          end else begin
            state <= idle;
            cs    <= 1;
            mosi  <= 0;
            count <= 0;
          end
        end

        default: state <= idle;
      endcase
    end
  end
endmodule


module spi_slave (
input sclk, cs, mosi,
output [11:0] dout,
output reg done
);
 
typedef enum bit {detect_start = 1'b0, read_data = 1'b1} state_type;
state_type state = detect_start;
 
reg [11:0] temp = 12'h000;
int count = 0;
 
always@(posedge sclk)
begin
 
case(state)
detect_start: 
begin
  done   <= 1'b0;
  if(cs == 1'b0)
  state <= read_data;
  else
   state <= detect_start;
  end
 
read_data : begin
if(count <= 11)
 begin
 count <= count + 1;
 temp  <= { mosi, temp[11:1]};
 end
 else
 begin
 count <= 0;
 done <= 1'b1;
 state <= detect_start;
 end
 
end
 
endcase
end
assign dout = temp;
 
endmodule

module top #(
  parameter baud = 9600 ,
  parameter freq=1000000
  )
  (
    input clk,rst,newd,
    input [11:0]din,
    output  reg done,
    output reg dout[11:0] 
  )

  wire cs,mosi,sclk

  master m1(clk,din,newd,rst,cs,mosi,sclk);
  slave s1(cs,mosi,sclk,done,dout);


endmodule