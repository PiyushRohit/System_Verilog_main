// initialing class
class first;
  
  bit[2:0]data1;
  bit[2:0] data2;
  
  
endclass

module tb;
  first f;
  initial begin
    f=new(); // creating constructor
    f.data1=3'b010; // initialing data 
    f.data2=3'b010;
    f=null; // empting memory 
    
    #2;
    $display("the value of data1 :%0d and data2 :%0d ",f.data1,f.data2);
    
  end
  
endmodule