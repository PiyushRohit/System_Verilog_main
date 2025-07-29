module tb;
  
  task first();
    
    $display("task 1 started at %0t",$time);
    #20;
    $display("task 1 ended at %0t",$time);
    
  endtask
  
  task second();
    
    $display("task 2 started at %0t",$time);
    #30;
    $display("task 2 ended at %0t",$time);
  
  endtask
  
  task third();
    
    $display("reached next to join at %0t",$time);
   
  
  endtask
  
  initial begin
    fork
      first();
      second;

    join_any
    third();
    
  end
  
endmodule