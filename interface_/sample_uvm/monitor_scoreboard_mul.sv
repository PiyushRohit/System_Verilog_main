class transaction;
  bit[3:0]a,b;
  bit[8:0] mul;
  
  function void display();
    
    $display(" a:%0d  b:%0d  mul:%0d ",a,b,mul);
    
  endfunction
  
endclass

interface mul_if;
  logic [3:0] a;
  logic[3:0] b;
  logic[8:0] mul;
  logic clk;
  
endinterface

class monitor;
  mailbox #(transaction) mbx;
  transaction trans;
  virtual mul_if mif;
  
  function new(mailbox #(transaction) mbx);
  this.mbx=mbx;
  endfunction
  
  task run();
    trans=new();
    forever begin
      repeat(2) @(posedge mif.clk);
      trans.a=mif.a;
      trans.b=mif.b;
      trans.mul=mif.mul;
      $display("-------------------------");
      $display("[MON] :DATA SENT TO SCOREBOARD");
      trans.display();
      mbx.put(trans);
      
    end
    
  endtask
  
endclass

class scoreboard;
  
  mailbox #(transaction) mbx;
  transaction trans;
  
  function new (mailbox #(transaction) mbx);
    this.mbx=mbx;
    
  endfunction
  
  task compare(input transaction trans);
    if( (trans.mul)==(trans.a * trans.b))
      $display("[SCO] :MUL RESULT MATCHED");
    else
      $error("[SCO] :MUL RESULT MISMATCHED");
  endtask
  
  task run();
    forever begin
      mbx.get(trans);
      $display("SCO :DATA RCVD FROM MONITOR ");
      trans.display();
      compare(trans);
      $display("-------------------------");
      
    end
  endtask
  
endclass

module tb;
  
  mul_if mif();
  monitor mon;
  scoreboard sco;
  mailbox #(transaction) mbx;
  
  mul dut(mif.a,mif.b,mif.mul,mif.clk);
  
  initial begin
    mif.clk=0;
  end
  
  always #10 mif.clk <= ~mif.clk;
  
  initial begin
    for(int i=0; i<20 ;i++) begin
      repeat(2) @(posedge mif.clk);
      mif.a <=$urandom_range(0,15);
      mif.b <= $urandom_range(0,15);
      
    end
    
  end
  
  initial begin
    mbx=new();
    mon= new(mbx);
    sco=new(mbx);
    mon.mif=mif;
    
  end
  
  initial begin
    fork
    mon.run();
    sco.run();
    join
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;  
    #450;
    $finish();
  end
  
endmodule