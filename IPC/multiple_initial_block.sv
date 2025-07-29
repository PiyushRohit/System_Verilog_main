module tb;
  
  int data1,data2;
  int i=0;
  event done;
  
  ///Generator
  initial begin
    for(i=0;i<10;i++) begin
      data1=$urandom;
      $display("data sent :%0d ",data1);
      #10;
    end
    -> done;
  end
  
  ///Driver
  initial begin
   forever begin
     #10;
     data2=data1;
     $display("data received :%0d",data2);
     
   end 
  end
  
  ///task
  initial begin
    wait(done.triggered);
    $finish;    
  end

endmodule