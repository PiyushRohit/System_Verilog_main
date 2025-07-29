class first;
  local int data=32;
  task set(int data);
    this.data=data;
  endtask 
  
  function int get();
    return data;
  endfunction
  
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
    s.f1.set(67);
    $display("the value of data : %0d",s.f1.get());
  end
endmodule