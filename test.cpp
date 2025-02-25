#include <hls_opencv.h>
//#include <stdint.h>
#include <ap_int.h>
#include <stdio.h>
#include <malloc.h>

using namespace cv;
void conv(ap_uint<8> * image_in, ap_uint<8> * image_out);
int main(){
   Mat im = imread("test.jpg",CV_LOAD_IMAGE_GRAYSCALE);
   //ap_uint<8> image_in[1080*1920];
   //ap_uint<8> image_out[1080*1920];

   ap_uint<8>  *image_in;
   ap_uint<8>  *image_out;
   image_in = (ap_uint<8>  *)malloc(1080*1920* sizeof(ap_uint<8> ));
   image_out = (ap_uint<8>  *)malloc(1080*1920* sizeof(ap_uint<8> ));

   memcpy(image_in,im.data,sizeof(ap_uint<8>)*1080*1920);
   conv(image_in,image_out);
   Mat out = Mat(1080,1920,CV_8UC1,image_out);
   namedWindow("test");
   imshow("test",out);
   waitKey(0);

 return 0;
}
