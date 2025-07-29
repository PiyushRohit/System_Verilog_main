class generator;
  
  int data=39;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx=mbx;
    
  endfunction
  
  task run();
    mbx.put(data);
    $display(" [GEN] : SENT DATA : %0d",data);
    
  endtask
  
  
endclass

class driver;
  mailbox mbx;
  int data;
  
  function new(mailbox mbx);
    this.mbx=mbx;
    
  endfunction
  
  task run();
    mbx.get(data);
    $display(" [DRV] : RCV DATA : %0d",data);
    
  endtask
  
  
endclass

module tb;
  generator gen;
  driver drv;
  mailbox mbx;
  
  initial begin
   mbx=new();
   gen=new(mbx);
   drv=new(mbx);
 
    
 
    
    gen.run();
    drv.run();
  
  end
endmodule