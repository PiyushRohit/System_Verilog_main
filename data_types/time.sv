`timescale 1ns/1ps
 module tb;
   time fixedtime=0;
   realtime real_time=0;
   initial begin
     #12.43;
     fixedtime=$time;
     real_time=$realtime;
     $display(" the current fix simulation time :%0t ",fixedtime);
     $display("the current real simulation time :%0t ",real_time);
     
   end
  
 endmodule