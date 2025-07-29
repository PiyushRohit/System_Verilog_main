module tb;
  
  bit[7:0] data1,data2;
  int i=0;
  event done;
  event next;
  
  ///Generator
  task generator();
    for(i=0;i<10;i++) begin
      data1=$urandom;
      $display("data sent :%0d ",data1);
      #10;
      wait(next.triggered);
    end
    -> done;
  
  endtask
  ///Driver
  task receiver();
   forever begin
     #10;
     data2=data1;
     $display("data received :%0d",data2);
     ->next;
   end 
  endtask
  
  task wait_event();
    wait(done.triggered);
    $display("com[leted sending all the files ");
    $finish();
  endtask
  
  ///task
  initial begin
    fork 
      generator();
      receiver();
      wait_event();
    join
  end

endmodule