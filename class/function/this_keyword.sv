class first;
  int data1;
  bit[8:0] data2;
  shortint data3;
  
  function new(input int data1,input bit[8:0] data2,shortint data3);
  this.data1=data1;
  this.data2=data2;
  this.data3=data3;
  endfunction
  
endclass

module tb;
  first f;
  initial begin
    f=new(4,12,23);
    $display("the value of data1 : %0d",f.data1);
    $display("the value of data2 : %0d",f.data2);
    $display("the value of data3 : %0d",f.data3);
  end
  
endmodule