// Code your testbench here
// or browse Examples

class first;
  
  int data=1;
  
  function new(input int data);
    this.data=data;
  endfunction
    
endclass

class second extends first;
  
  int temp;
  
  function new(int data,int temp);
    super.new(data);
    this.temp=temp;
  endfunction
  
  
endclass


module tb;
  second s;
  
  initial begin
    s=new(69,59);
    $display("s.temp :%0d  and  s.data:%0d ",s.temp,s.data);
  end
  
endmodule