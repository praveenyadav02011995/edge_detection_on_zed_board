module kernel(x1,y1,z1,x2,y2,z2,x3,y3,z3,sum);
  parameter bitsize = 8;
  input [bitsize-1:0] x1,y1,z1,x2,y2,z2,x3,y3,z3;
  output wire [bitsize:0] sum;
  wire signed [bitsize:0] Sum;
  assign Sum = x1+x2+x2+x3-z1-z2-z2-z3;
  assign sum = Sum[bitsize] ? -Sum : Sum;
endmodule

