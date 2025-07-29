module adder(
  input [3:0] a,b,
  output [4:0] y
);
  
  assign y= a+b;
  
endmodule

interface add_if();
  
  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] y;
endinterface


module tb;
  
  add_if aif();
  
  adder dut(aif.a,aif.b,aif.y);
  
  initial begin
    aif.a=3;
    aif.b=4;
    
    #10;
    
    aif.a=5;
    
    #10;
    
    aif.b=7;
    
  end
  
  initial begin
    $dumpfile("adder.vcd");
    $dumpvars();
    
  end

endmodule