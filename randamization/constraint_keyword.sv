// Code your testbench here
// or browse Examples
class generator ;
  randc bit[3:0] a,b;
   int y;
  /* constraint data_a {a>3 ;a <8;};
  constraint data_b {b==3;};
  endclass
  */
  
  /*constraint data { // range from which values need to be selected
    a inside {[0:8],[10:13],15};
    b inside {[3:11]};
                   
  };*/
  
  constraint data {  //range to be skipped
    !(a inside {[3:7]});
    !(b inside {[10:15]});
    
  }
  
endclass

  module tb;
    
    generator g;
    int i=0;
    int status;
      
      initial begin
        g =new();
        for( i=0;i<=10;i++) begin
          
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
  