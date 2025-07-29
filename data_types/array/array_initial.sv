
module tb;
  // unique 
  int arr1[2]='{1,2};
  
  // repetiton
  int arr2[2]='{2{3}};
  
  //default
  int arr3[2]='{default :6};
  
  //uninitialise
  int arr4[2];
  
  initial begin
    $display("element of arr1 :%0p",arr1);
    $display("element of arr2 :%0p",arr2);
    $display("element of arr3 :%0p",arr3);
    $display("element of arr4 :%0p",arr4);
    
    
  end
  
endmodule