module tb;
  
  event a;
  
  initial begin
    #10;
    -> a;
  end
  
  initial begin
    // @(a); edge_sensitive_blocking a()
    
    wait(a.triggered);  //level_sensitive_non_blocking wait()
    $display("the event has triggered at %0t",$time);
  end
  
endmodule