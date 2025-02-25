module tb;
  parameter bitsize = 8, length = 256*256;
  integer i,f;
  reg  rst,clk;
  reg [bitsize-1:0] data[0:length-1],sin,s;
  wire [bitsize-1:0] sout;
  build #(.bitsize(bitsize)) dut(rst,clk,sin,sout);
  always #5 clk = ~clk;
initial
 begin   
    $dumpfile("image.vcd"); 
    $dumpvars(0);
 end

  initial
  begin
    f = $fopen("output.txt","w");
    rst=0;
    clk=0;
    sin=0;
    $readmemh("data.txt",data);
    driving_reset();
    for(i=0;i<length+17;i=i+1)
    begin
      if(i<length)
      begin
      s = data[i];
      drive_input();
      end
      if(i>16) save_output();
    end
    $finish;
    $fclose(f);  
  end
task automatic driving_reset;
   begin
     $display("Driving the reset");
     @ (negedge clk)
     rst = 0;
     @ (negedge clk)
     rst = 1;
     @ (negedge clk)
     rst = 0;
   end
 endtask
 task automatic drive_input;
    begin
      $display("%d",i);
      @ (negedge clk)
      sin = s;
    end
  endtask
  task automatic save_output;
    begin
      @(posedge clk)
        $fwrite(f,"%x\n",sout);
      end
    endtask
endmodule
