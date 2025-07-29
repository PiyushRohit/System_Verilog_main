
module tb;
  int arr[9];
  int i=0;
  
  initial begin
    for(i=0;i<10;i++)begin 
      arr[i]=i;
    end
    
    $display("element of arr :%0p",arr);  
  end
  
  /*
  initial begin
  foreach(arr[j])begin 
    arr[j]=j;
    $display("%0d :",arr[j]);
  end
  end*/
  
  /*
  initial begin
    repeat(10)begin
      arr[i]=i;
      i++;
    end  
    
    $display("%0p ",arr);
  end
  */
  
  
  
endmodule