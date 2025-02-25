module CORDIC_VEC(clk,x_in,y_in,r);
  // Defining the i/o  
  parameter bitsize = 16;
  input [bitsize-1:0] x_in,y_in;
  input clk;
  reg [bitsize-1:0] theta_out;
  output [bitsize-1:0] r;
  wire [2*bitsize-1:0] rbuff;

  // Generating a list of wires
  genvar k;
  generate
    for(k = 0; k < bitsize; k = k + 1)
    begin : w
      wire [bitsize-1:0] m,n,p,deltheta;
    end
  endgenerate
  // Generating the pipelined structure
  genvar i;
  generate
    for(i = 0; i<bitsize;i=i+1)
    begin : PIPES 
      if(i==0)
        PIP_BLOC #(.bitsize(bitsize),.i(i))BLOC(.clk(clk),.theta_in(16'h0000),.x_in(x_in),.y_in(y_in),.theta_out(w[i].p),.x_out(w[i].m),.y_out(w[i].n),.deltheta(w[i].deltheta));
      else if(i==15)
        PIP_BLOC #(.bitsize(bitsize),.i(i))BLOC(.clk(clk),.theta_in(w[i-1].p),.x_in(w[i-1].m),.y_in(w[i-1].n),.theta_out(w[i].p),.x_out(w[i].m),.y_out(w[i].n),.deltheta(w[i].deltheta));
      else  
      PIP_BLOC #(.bitsize(bitsize),.i(i))BLOC(.clk(clk),.theta_in(w[i-1].p),.x_in(w[i-1].m),.y_in(w[i-1].n),.theta_out(w[i].p),.x_out(w[i].m),.y_out(w[i].n),.deltheta(w[i].deltheta));
    end
  endgenerate
    always @ (posedge clk)
    begin
      theta_out <= w[15].p;
    end
    assign w[0].deltheta = 16'b0011001001000100;
    assign w[1].deltheta = 16'b0001110110101100;
    assign w[2].deltheta = 16'b0000111110101110;
    assign w[3].deltheta = 16'b0000011111110101;
    assign w[4].deltheta = 16'b0000001111111111;
    assign w[5].deltheta = 16'b0000001000000000;
    assign w[6].deltheta = 16'b0000000100000000;
    assign w[7].deltheta = 16'b0000000010000000;
    assign w[8].deltheta = 16'b0000000001000000;
    assign w[9].deltheta = 16'b0000000000100000;
    assign w[10].deltheta = 16'b0000000000010000;
    assign w[11].deltheta = 16'b0000000000001000;
    assign w[12].deltheta = 16'b0000000000000100;
    assign w[13].deltheta = 16'b0000000000000010;
    assign w[14].deltheta = 16'b0000000000000001;
    assign w[15].deltheta = 16'b0000000000000000;
    // Correcting the factor
    assign r = rbuff[2*bitsize-3:2*bitsize-18];
    assign rbuff = (w[15].m*16'h26dd);
endmodule

module PIP_BLOC(clk,theta_in,x_in,y_in,theta_out,x_out,y_out,deltheta);
  parameter i = 0;
  parameter bitsize = 16;
  input clk;
  input [bitsize-1:0] theta_in,x_in,y_in,deltheta;
  output reg [bitsize-1:0] theta_out,x_out,y_out;
  reg [bitsize-1:0] theta,x,y;
  wire [bitsize-1:0] x_shift,y_shift;
  // Control signals for a block
  assign y_sign = y[bitsize-1];
  //assign x_shift = x >>> i;
  //assign y_shift = y >>> i;
  shifter #(.i(i),.bitsize(bitsize)) s1(x,x_shift);
  shifter #(.i(i),.bitsize(bitsize)) s2(y,y_shift);
  // Input registers
  always @ (posedge clk)
  begin
    x <= x_in;
    y <= y_in;
    theta <= theta_in;
  end
  // Defining the register for x
  always @ (*)
  begin
    if(~y_sign)
      x_out <= x + y_shift;
    else
      x_out <= x - y_shift;
  end
  // Defining the register for y
  always @ (*)
  begin
    if(~y_sign)
      y_out <= y - x_shift;
    else
      y_out <= y + x_shift;
  end
  // Defining the theta module
  always @ (*)
  begin
    if(~y_sign)
      theta_out <= theta + deltheta;
    else
      theta_out <= theta - deltheta;
  end
endmodule

module shifter(In,Out);
  parameter i=0;
  parameter bitsize=8;
  input [bitsize-1:0] In;
  output reg [bitsize-1:0] Out;
  integer k,j=i;
  always@(*)
  begin
    for(k=0;k<bitsize;k=k+1)
    begin
      if(k+j>bitsize-1)
        Out[k] = In[bitsize-1];
      else
        Out[k] = In[k+j];
    end
  end
endmodule
