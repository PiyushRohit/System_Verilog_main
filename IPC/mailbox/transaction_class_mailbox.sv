class transaction;
  rand bit[3:0] data1;
  rand bit[3:0] data2;
  
  
endclass



class generator;
  
  transaction t;
  mailbox mbx;
  
  function new(mailbox mbx);
    this.mbx=mbx;
    
  endfunction
  
  task main();
    for(int i=0;i<10;i++) begin
      t=new();
      assert(t.randomize) else $display("randomization failed ");
      $display("the sent data data1:%0d  data2:%0d",t.data1,t.data2);
      mbx.put(t);
      #10;
    end
    
  endtask
  
  
endclass

class driver;
  mailbox mbx;
 
  transaction dc;
  function new(mailbox mbx);
    this.mbx=mbx;
    
  endfunction
  
  task main();
    
    forever begin
      mbx.get(dc);
      $display("DATA RECEVIED data1:%0d and data2:%0d",dc.data1,dc.data2);
    
      #10;
    end
  endtask
  
  
endclass

module tb;
  generator g;
  driver d;
  mailbox mbx;
  
  initial begin
   mbx=new();
   g=new(mbx);
   d=new(mbx);
 
    fork
      g.main();
      d.main();
    
    join
  
  end
endmodule