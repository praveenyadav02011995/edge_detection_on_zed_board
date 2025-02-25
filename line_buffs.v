module line_buff(rst,clk,sin,sout,x1,x2,x3);
  parameter bitsize = 8,length=480;
  input rst, clk;
  input [bitsize-1:0] sin;
  output [bitsize-1:0] sout;
  output [bitsize-1:0] x1,x2,x3;
  // Generate Block for the line buffer
  genvar k,i;
  generate
    for(k=0;k<length;k=k+1)
    begin : buff
      reg [bitsize-1:0] b;
    end
  endgenerate
  generate
    for(i=0;i<length-1;i=i+1)
    begin
    always @(posedge clk)
      begin
        buff[i+1].b <= rst?'b0:buff[i].b;
      end
    end
  endgenerate
  always @(posedge clk)
      begin
        buff[0].b <= rst?'b0:sin;
      end
  assign sout = buff[length-1].b;
  assign x1 = buff[0].b;
  assign x2 = buff[1].b;
  assign x3 = buff[2].b;
endmodule

