class first;
  
  rand bit wr,rd;
  rand bit[1:0] var1,var2;
  
  constraint ctrl {
    wr dist{ 0 := 10 ,1 := 90};
    rd dist{ 0 :/ 10 , 1 :/ 90};
    
  }
  
  constraint data{
    var1 dist{ 0 := 10 ,[1:3] := 10};
    var2 dist {0 :/ 10 ,[1:3]:/ 10};
  }
endclass

module tb;
  first f;
  initial begin
    f=new();
    
    for(int i=0;i<15;i++) begin
      f.randomize();
      $display("the value of var1(:=) :%0d and var2(:/) :%0d ",f.var1,f.var2);
    end
    
  end
  
endmodule

