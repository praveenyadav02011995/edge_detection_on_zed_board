#include <hls_video.h>
//#include <stdint.h>
#include <ap_int.h>

void conv(ap_uint<8> image_in[1080*1920],ap_uint<8> image_out[1080*1920]){
#pragma HLS DATAFLOW
#pragma HLS INTERFACE s_axilite port=return bundle=CTRL_BUS
#pragma HLS INTERFACE m_axi depth=2073600 port=image_out offset=slave bundle=CRTL_BUS
#pragma HLS INTERFACE m_axi depth=2073600 port=image_in offset=slave bundle=CRTL_BUS

   const char coefficients[3][3] = { {-1,-2,-1},
                                     { 0, 0, 0},
                                     { 1, 2, 1} };

   hls::Mat<1080,1920,HLS_8UC1> src;
   hls::Mat<1080,1920,HLS_8UC1> dst;
   hls::AXIM2Mat<1920,ap_uint<8>,1080,1920,HLS_8UC1>(image_in,src);
   hls::Window<3,3,char> kernel;
   for (int i=0;i<3;i++){
      for (int j=0;j<3;j++){
         kernel.val[i][j]=coefficients[i][j];
      }
   }
   hls::Point_<int> anchor = hls::Point_<int>(-1,-1);
   hls::Filter2D(src,dst,kernel,anchor);
   hls::Mat2AXIM<1920,ap_uint<8>,1080,1920,HLS_8UC1>(dst,image_out);
}
