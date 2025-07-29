class first;
  bit[7:0] data1;
  bit[7:0] data2;
  bit[7:0] data3;
  
  function new(input bit[7:0] data1, input bit[7:0]data2,input bit[7:0]data3);
  this.data1=data1;
  this.data2=data2;
  this.data3=data3;
  endfunction
  
  task display();
    $display("the value of data1 : %0d",data1);
    $display("the value of data2 : %0d",data2);
    $display("the value of data3 : %0d",data3);
  endtask
  
endclass

module tb;
  first f;
  initial begin
    f=new(2,4,56);
    f.display();
  end
  
endmodule