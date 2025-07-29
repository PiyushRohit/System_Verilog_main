module tb;
  
  function bit [4:0] add(input [3:0]a,b);
    return a+b;
  endfunction
  
  bit [4:0] res=0;
  
  initial begin
    res=add(4'b0100,4'b0010);
    $display("value of res :%0d ",res);
    
  end
  
endmodule