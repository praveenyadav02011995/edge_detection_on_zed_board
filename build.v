module build(rst,clk,sin,sout);
  parameter bitsize = 16, length=256;
  input rst,clk;
  input [bitsize-1:0] sin;
  output [bitsize-1:0] sout;
  wire [bitsize-1:0] w1,w2,w3,x1,x2,x3,y1,y2,y3,z1,z2,z3;
  wire [bitsize:0] sumx,sumy;
  wire [15:0] Sumx,Sumy,Sout;
  line_buff #(.bitsize(bitsize),.length(length)) l1(.rst(rst),.clk(clk),.sin(sin),.sout(w1),.x1(x1),.x2(x2),.x3(x3));
  line_buff #(.bitsize(bitsize),.length(length)) l2(.rst(rst),.clk(clk),.sin(w1),.sout(w2),.x1(y1),.x2(y2),.x3(y3));
  line_buff #(.bitsize(bitsize),.length(length)) l3(.rst(rst),.clk(clk),.sin(w2),.sout(w3),.x1(z1),.x2(z2),.x3(z3));
  kernel #(.bitsize(bitsize)) kx(x1,y1,z1,x2,y2,z2,x3,y3,z3,sumx);
  kernel #(.bitsize(bitsize)) ky(x1,x2,x3,y1,y2,y3,z1,z2,z3,sumy);
  assign Sumx={sumx[bitsize],1'b0,sumx[bitsize-1:0],6'd0};
  assign Sumy={sumy[bitsize],1'b0,sumy[bitsize-1:0],6'd0};
  CORDIC_VEC #(.bitsize(16)) grad(clk,Sumx,Sumy,Sout);
  assign sout = Sout[13:6];
  endmodule
