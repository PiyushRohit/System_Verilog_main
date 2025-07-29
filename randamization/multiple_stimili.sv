
class generator ;
  rand bit[3:0] a,b;
   int y;
  constraint data{a>16 ;}
  endclass
  
  module tb;
    
    generator g;
    int i=0;
    int status;
      
      initial begin
       
        for( i=0;i<10;i++) begin
          g =new();
          /*if(!g.randomize()) begin
            $display("randomization failed at %0t :$time");
            $finish();
          end */
          
          assert(g.randomize()) else
            begin
              $display(" randomization failed at %0t ",$time);
              $finish;
            end
          
          $display("the value of a:%0d and b:%0d",g.a,g.b);
          #10;
        end
        
        
        
      end
    
  endmodule
  