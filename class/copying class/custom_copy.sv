// Code your testbench here
// or browse Examples
class first;
  
  int data=34;
  bit[7:0] temp=8'h11;
  
  function first copy();
    copy=new();
    copy.data=data;
    copy.temp=temp;
  endfunction
  
endclass

module tb;
  first f1;
  first f2;
  
  initial begin
    f1=new();
    f2=f1.copy;
    
    $display("Data : %0d and TEMP : %0x", f2.data, f2.temp); 
    
  end
endmodule