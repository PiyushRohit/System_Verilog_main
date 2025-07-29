class first;
  int data=1;
  
  
endclass

class second;
  first f1;
  int ds=12;
  function new();
    f1=new();
  endfunction
  
endclass

module tb;
  second s1;
  second s2;
  
  initial begin
    
    s1=new();
    s2=new s1;
    
    $display("data value of s1 :%0d",s1.ds);
    s2.ds=59;
    $display("data value of s2 :%0d",s2.ds);///independent data member
    s2.f1.data=100;
    $display("data value of s1.f1  :%0d",s1.f1.data); ///common handler
    
  end
  
endmodule