class first;
  int data;
  function new(input int datain);
  data=datain;
  endfunction
  
endclass

module tb;
  first f;
  initial begin
    f=new(32);
    $display("the value of data : %0d",f.data);
  end
  
endmodule