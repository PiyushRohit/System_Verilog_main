module tb;
  int arr[$];
  int j=0;
  initial begin
    arr={1,2,3};
    $display("%0p ",arr);
    
    arr.push_front(7);
    $display("%0p ",arr);
    
    arr.push_back(9);
    $display("%0p ",arr);
    
    arr.insert(2,10);
    $display("%0p ",arr);
    
    j=arr.pop_front();
    $display("%0p ",arr);
    $display("element popped %0d  ",j);
    
     j=arr.pop_back();
    $display("%0p ",arr);
    $display("element popped %0d  ",j);
    
    arr.delete(1);
    $display("%0p ",arr);
    
    
  end
  
  
endmodule