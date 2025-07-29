module tb;
  ////restrict access to variables
  task automatic swap(const ref bit[1:0] a,ref bit[1:0]b);
    bit[1:0] temp;
    temp=a;
   // b=a;
    b=temp;
    $display(" a:%0d  b:%0d ",a,b);
  endtask
  
  bit[1:0] a;
  bit[1:0] b;
  
  initial begin
    a=1;
    b=2;
    swap(a,b);
    $display("after swaping of a and b");
    $display(" a:%0d  b:%0d ",a,b);
  end
endmodule