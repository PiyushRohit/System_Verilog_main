class first;
  int data=32;
  
endclass

class second;
  first f1;
  
  function new();
    f1=new(); 
  endfunction
  
  
endclass

module tb();
  second s;
  initial begin
    s=new();
    $display("the value of data : %0d",s.f1.data);
  end
endmodule