// Code your testbench here
// or browse Examples
class transaction;
  rand bit din;
  bit dout;

  function transaction copy();
  copy=new();
  copy.din =this.din;
  copy.dout =this.dout;  
  endfunction

  function void display(input string tag);
   $display("[%0s] : DIN :%0b  DOUT:%0b ",tag,din,dout);

  endfunction
endclass


class generator;
  transaction tr;
  mailbox #(transaction) mbx; // generator to driver
  
  mailbox #(transaction) mbxref; //generator to scoreboard

  event sconext;
  event done;
  int count;

  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref);
  this.mbx=mbx;
  this.mbxref=mbxref;
  tr=new(); 
  endfunction

  task run();
  repeat(count)begin
    assert (tr.randomize)  
    else   $error("[GEN] : RANDOMIZATION FAILED");
    mbx.put(tr.copy); //put a copy of the transaction into the driver mailbox

    mbxref.put(tr.copy);//put a copy of the transaction into the scoreboard mailbox
    tr.display("GEN");
    @(sconext); //Wait for the scoreboard's completion signal

  end
  -> done; //Trigger "done" event when all stimuli are applied

  endtask
endclass

class driver;
  transaction tr;
  mailbox #(transaction) mbx; //receive data from generator
  virtual dff_if vif; // virtual inteface for dut

  function new(mailbox #(transaction) mbx);
   this.mbx=mbx;
  endfunction

  task  reset();
    vif.rst <= 1'b1;
    repeat(5) @(posedge vif.clk);
    vif.rst<= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] :RESET DONE ");
  endtask //

  task run();
   
  forever begin
  mbx.get(tr);
  vif.din <= tr.din;
  @(posedge vif.clk);
  tr.display("DRV");
  vif.din <= 1'b0;
  @(posedge vif.clk);
  end
  endtask

  endclass

  class monitor;
  transaction tr;
  mailbox #(transaction) mbx; //monitor ->scoreboard
  virtual dff_if vif ; //virtual interface for DUT

  function new(mailbox #(transaction) mbx);
  this.mbx=mbx;
  endfunction

  task run();
  tr=new();
  forever begin
  repeat(2) @(posedge vif.clk);
  

  tr.dout =vif.dout;
  mbx.put(tr);
  tr.display("MON");
  end
  endtask
  endclass

  class scoreboard;
  transaction tr; //define a transaction object
  transaction trref; //reference transaction object
  mailbox #(transaction) mbx; //data from driver
  mailbox #(transaction) mbxref; // reference data from genearator
  event sconext; //event to signal completion of scoreboard work

  function new(mailbox #(transaction) mbx ,mailbox #(transaction) mbxref);
  this.mbx=mbx;
  this.mbxref=mbxref;
  endfunction

  task run();
  forever begin
  mbx.get(tr);
  mbxref.get(trref);
  tr.display("SCO");
  trref.display("REF"); //display refernce information
  if(tr.dout == trref.din)
   $display("[SCO] :DATA MATCHED");
  else
   $display("[SCO] :DATA MISMATCHED");
   $display("---------------------------");
   -> sconext;
  end

  endtask
  
endclass

class environment;
   generator gen;
   driver drv;
   monitor mon;
   scoreboard sco;
   event next;

   mailbox #(transaction) gdmbx;   // generator -> driver
   mailbox #(transaction) msmbx;   // monitor -> scoreboard
   mailbox #(transaction) mbxref;  // generator -> scoreboard

   virtual dff_if vif;

   function new(virtual dff_if vif);
      gdmbx   = new();
      mbxref  = new();
      gen     = new(gdmbx, mbxref);
      drv     = new(gdmbx);
      msmbx   = new();
      mon     = new(msmbx);
      sco     = new(msmbx, mbxref);

      this.vif = vif;
      drv.vif  = this.vif;
      mon.vif  = this.vif;
      gen.sconext = next;
      sco.sconext = next;
   endfunction

   task pre_test();
      drv.reset();
   endtask

   task test();
      fork
         gen.run();
         drv.run();
         mon.run();
         sco.run();
      join_any
   endtask

   task post_test();
      wait(gen.done.triggered);
      $finish;
   endtask

   task run();
      pre_test();
      test();
      post_test();
   endtask
endclass


module tb;
  dff_if vif(); //create dut interface
  dff dut(vif); // instantiate DUT

  initial begin
    vif.clk <= 0;
  end

  always #10 vif.clk <= ~vif.clk;

  environment env; //create envionment instance
  initial begin
    env =new(vif);
    env.gen.count=30;
    env.run();
  end

  initial begin
    $dumpfile("dump.vcd"); //Specify the VCD dump file
    $dumpvars; //Dump all variables
  end

endmodule