// Code your testbench here
// or browse Examples
class first;
  
  int data;
  
endclass

module tb;
  first f1;
  first f2;
  
  initial begin
    f1=new();
    
    f1.data=24;
    
    f2=new f1;
    $display("the value of data :%0d",f2.data);
    
    f2.data=45;
    $display("the value of data :%0d",f1.data);
    
  end
endmodule