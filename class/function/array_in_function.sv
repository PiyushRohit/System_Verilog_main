// how to pass array by reference in function

module tb;
  bit[3:0]res[16:0];
  function automatic void int_arr(ref bit[3:0]a[16:0]);
    for(int i=0;i<=16;i++)begin
      a[i]=i;
    end
    
  endfunction
  
  initial begin
    int_arr(res);
    $display("after the function call values of res :");
    for(int i=0;i<=16;i++)begin
      $display(" res[%0d] : %0d ",i,res[i]);
    end
  end
  
  
endmodule