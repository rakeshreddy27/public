/*
##Readme:##

This program contains the code for edge detection by Canny filter using CUDA.

Steps to compile and execute this on OSC or any cuda capable device with OpenCV library.

1. To Load CUDA :module load cuda
2. To set openCV path: export LD_LIBRARY_PATH=${HOME}/local/opencv/2.4.11/lib  
3. To Compile program: nvcc project.cu -o project -I ${CUDA_HOME}/include -I ${HOME}/local/opencv/2.4.11/include -L ${HOME}/local/opencv/2.4.11/lib -lopencv_core -lopencv_imgproc -lopencv_highgui
4. To execute program: ./project input256.png (file name) 

*/

#include <iostream>
#include <string>
#include <stdio.h>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <cuda.h>
#include <cuda_runtime.h>
#include <math.h>
#define PI 3.14159265
#define LowTh 25
#define HighTh 75
#include "opencv2/imgproc/imgproc.hpp"
#include <time.h>

cv::Mat imageRGBA;
cv::Mat imageGrey;
using namespace cv;
using namespace std;

uchar4        *d_rgbaImage__;
unsigned char *d_greyImage__;

size_t numRows() { return imageRGBA.rows; }
size_t numCols() { return imageRGBA.cols; }


__global__ void rgba_to_greyscale(const uchar4* const rgbaImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{
 
  int offset = numCols * blockIdx.x + threadIdx.x;
  uchar4 rgbpx = *(rgbaImage + offset);
  greyImage[offset] = (unsigned char)(0.299f * rgbpx.x + 0.587f * rgbpx.y + 0.114f * rgbpx.z);
}

__global__ void gaussian_blur(const unsigned char* const inputChannel,
                   unsigned char* const outputChannel,
                   int numRows, int numCols,
                   const float* const filter, const int filterWidth)
{

const int2 thread_2D_pos = make_int2( blockIdx.x * blockDim.x + threadIdx.x,
                                      blockIdx.y * blockDim.y + threadIdx.y);

  const int thread_1D_pos = thread_2D_pos.y * numCols + thread_2D_pos.x;

  if (thread_2D_pos.x >= numCols || thread_2D_pos.y >= numRows)
    return;

   assert(filterWidth % 2 == 1);
  float output = 0.f;
  for (int filterRow = -filterWidth/2; filterRow <= filterWidth/2; ++filterRow) {
    for (int filterCol = -filterWidth/2; filterCol <= filterWidth/2; ++filterCol) {
      int neighbourRow = min(numRows - 1, max(0, thread_2D_pos.y + filterRow));
      int neighbourCol = min(numCols - 1, max(0, thread_2D_pos.x + filterCol));
      int neighbour_1D_pos = neighbourRow * numCols + neighbourCol;
      float neighbour = static_cast<float>(inputChannel[neighbour_1D_pos]);

      int filter_pos = (filterRow + filterWidth/2) * filterWidth + filterCol + filterWidth/2;
      float filter_value = filter[filter_pos];

      output += neighbour * filter_value;
    }
  }
  outputChannel[thread_1D_pos] = output;
}

__global__ void canny_filter(const unsigned char* const inputChannel,
                   unsigned char* const outputChannel, float* outputChannel_gradval,float* outputChannel_gradatan,
                   float* outputChannel_temp,int numRows, int numCols,
                   const float* const filter,const float* const filter_y, const int filterWidth)
{

const int2 thread_2D_pos = make_int2( blockIdx.x * blockDim.x + threadIdx.x,
                                      blockIdx.y * blockDim.y + threadIdx.y);

  const int thread_1D_pos = thread_2D_pos.y * numCols + thread_2D_pos.x;

  if (thread_2D_pos.x >= numCols || thread_2D_pos.y >= numRows)
    return;

   assert(filterWidth % 2 == 1);
  float output_x = 0.f,output_y = 0.f;
  for (int filterRow = -filterWidth/2; filterRow <= filterWidth/2; ++filterRow) {
    for (int filterCol = -filterWidth/2; filterCol <= filterWidth/2; ++filterCol) {
      int neighbourRow = min(numRows - 1, max(0, thread_2D_pos.y + filterRow));
      int neighbourCol = min(numCols - 1, max(0, thread_2D_pos.x + filterCol));
      int neighbour_1D_pos = neighbourRow * numCols + neighbourCol;
      float neighbour = static_cast<float>(inputChannel[neighbour_1D_pos]);

      int filter_pos = (filterRow + filterWidth/2) * filterWidth + filterCol + filterWidth/2;
      float filter_value_x = filter[filter_pos];
      float filter_value_y = filter_y[filter_pos];

      output_x += neighbour * filter_value_x;
      output_y += neighbour * filter_value_y;
	}
  }
 float atanval;
   atanval=atan(abs(output_y)/abs(output_x))+PI/2; 
  
   if (atanval>=0 && atanval<PI/8)
         outputChannel_gradatan[thread_1D_pos]=0;
  else if (atanval>=PI/8 && atanval<3*PI/8)
            outputChannel_gradatan[thread_1D_pos]=1;
  else if (atanval>=3*PI/8 && atanval<5*PI/8) 
           outputChannel_gradatan[thread_1D_pos]=2;
  else if (atanval>=5*PI/8 && atanval<7*PI/8) 
           outputChannel_gradatan[thread_1D_pos]=3;
  else if (atanval>=7*PI/8 && atanval<=PI) 
           outputChannel_gradatan[thread_1D_pos]=0;
  else     outputChannel_gradatan[thread_1D_pos]=0;
  outputChannel_gradval[thread_1D_pos] =  sqrt((output_x*output_x)+(output_y*output_y));
  outputChannel_temp[thread_1D_pos] =  0;
  outputChannel[thread_1D_pos] = 0;
  __syncthreads();
//non maximum suppression
   
    if((outputChannel_gradatan[thread_1D_pos]==2 && (outputChannel_gradval[thread_1D_pos] >= fmax(outputChannel_gradval[thread_2D_pos.y * numCols + thread_2D_pos.x+1],
                                                 outputChannel_gradval[thread_2D_pos.y * numCols + thread_2D_pos.x-1]))) ||
    (outputChannel_gradatan[thread_1D_pos]==3 && (outputChannel_gradval[thread_1D_pos] >= fmax(outputChannel_gradval[thread_2D_pos.y+1 * numCols + thread_2D_pos.x+1],
                                                 outputChannel_gradval[thread_2D_pos.y-1 * numCols + thread_2D_pos.x-1]))) ||
    (outputChannel_gradatan[thread_1D_pos]==0 && (outputChannel_gradval[thread_1D_pos] >= fmax(outputChannel_gradval[thread_2D_pos.y+1 * numCols + thread_2D_pos.x],
                                                 outputChannel_gradval[thread_2D_pos.y-1 * numCols + thread_2D_pos.x]))) ||
    (outputChannel_gradatan[thread_1D_pos]==1 && (outputChannel_gradval[thread_1D_pos] >= fmax(outputChannel_gradval[thread_2D_pos.y-1 * numCols + thread_2D_pos.x+1],
                                                 outputChannel_gradval[thread_2D_pos.y+1 * numCols + thread_2D_pos.x-1]))) ){
          outputChannel_temp[thread_1D_pos]=outputChannel_gradval[thread_1D_pos];   
      } 
   
/*  if(outputChannel_gradval[thread_1D_pos] >= fmax(outputChannel_gradval[thread_2D_pos.y * numCols + thread_2D_pos.x+1],
                                                 outputChannel_gradval[thread_2D_pos.y * numCols + thread_2D_pos.x-1]) ){
          outputChannel_temp[thread_1D_pos]=outputChannel_gradval[thread_1D_pos];   
      }
*/ 
   __syncthreads();
  //double threshold hysteresis
	if(outputChannel_temp[thread_1D_pos]<LowTh){
           outputChannel_gradval[thread_1D_pos]=0;     }
	else if (outputChannel_temp[thread_1D_pos]>=LowTh && outputChannel_temp[thread_1D_pos]<HighTh){
    
       if(   outputChannel_temp[thread_2D_pos.y * numCols + thread_2D_pos.x+1]>=HighTh ||
             outputChannel_temp[thread_2D_pos.y * numCols + thread_2D_pos.x-1]  >=HighTh ||
             outputChannel_temp[thread_2D_pos.y+1 * numCols + thread_2D_pos.x+1]  >=HighTh ||
 	     outputChannel_temp[thread_2D_pos.y-1 * numCols + thread_2D_pos.x-1]  >=HighTh ||
 	     outputChannel_temp[thread_2D_pos.y+1 * numCols + thread_2D_pos.x]  >=HighTh ||
 	     outputChannel_temp[thread_2D_pos.y-1 * numCols + thread_2D_pos.x]  >=HighTh ||
	     outputChannel_temp[thread_2D_pos.y-1 * numCols + thread_2D_pos.x+1]  >=HighTh ||
 	     outputChannel_temp[thread_2D_pos.y+1 * numCols + thread_2D_pos.x-1]  >=HighTh){
             
	outputChannel_gradval[thread_1D_pos]=outputChannel_temp[thread_1D_pos];
           }
             else{  outputChannel_gradval[thread_1D_pos]=0;    }
  
	}
	else {		outputChannel_gradval[thread_1D_pos]=  outputChannel_temp[thread_1D_pos];	} 
	outputChannel[thread_1D_pos] = outputChannel_gradval[thread_1D_pos];
}


void preProcess(uchar4 **inputImage, unsigned char **greyImage,
                uchar4 **d_rgbaImage, unsigned char **d_greyImage,  unsigned char **d_greyImageBlurred,
                 float **h_filter, int *filterWidth, const std::string &filename) {
  //make sure the context initializes ok
  cudaFree(0);

  cv::Mat image;
  image = cv::imread(filename.c_str(), CV_LOAD_IMAGE_COLOR);
  if (image.empty()) {
    std::cerr << "Couldn't open file: " << filename << std::endl;
    exit(1);
  }

  cv::cvtColor(image, imageRGBA, CV_BGR2RGBA);

  //allocate memory for the output
  imageGrey.create(image.rows, image.cols, CV_8UC1);

  //This shouldn't ever happen given the way the images are created
  //at least based upon my limited understanding of OpenCV, but better to check
  if (!imageRGBA.isContinuous() || !imageGrey.isContinuous()) {
    std::cerr << "Images aren't continuous!! Exiting." << std::endl;
    exit(1);
  }

  *inputImage = (uchar4 *)imageRGBA.ptr<unsigned char>(0);
  *greyImage  = imageGrey.ptr<unsigned char>(0);

  const size_t numPixels = numRows() * numCols();
  //allocate memory on the device for both input and output
  cudaMalloc(d_rgbaImage, sizeof(uchar4) * numPixels);
  cudaMalloc(d_greyImage, sizeof(unsigned char) * numPixels);
  cudaMemset(*d_greyImage, 0, numPixels * sizeof(unsigned char)); //make sure no memory is left laying around
 cudaMalloc(d_greyImageBlurred, sizeof(unsigned char) * numRows()*numCols());
  cudaMemset(*d_greyImageBlurred, 0, numRows()*numCols() * sizeof(unsigned char));
  //copy input array to the GPU
  cudaMemcpy(*d_rgbaImage, *inputImage, sizeof(uchar4) * numPixels, cudaMemcpyHostToDevice);

  d_rgbaImage__ = *d_rgbaImage;
  d_greyImage__ = *d_greyImage;

 //now create the filter that they will use
  const int blurKernelWidth = 9;
  const float blurKernelSigma = 2.;

  *filterWidth = blurKernelWidth;

  //create and fill the filter we will convolve with
  *h_filter = new float[blurKernelWidth * blurKernelWidth];

  float filterSum = 0.f; //for normalization

  for (int r = -blurKernelWidth/2; r <= blurKernelWidth/2; ++r) {
    for (int c = -blurKernelWidth/2; c <= blurKernelWidth/2; ++c) {
      float filterValue = expf( -(float)(c * c + r * r) / (2.f * blurKernelSigma * blurKernelSigma));
      (*h_filter)[(r + blurKernelWidth/2) * blurKernelWidth + c + blurKernelWidth/2] = filterValue;
      filterSum += filterValue;
    }
  }

  float normalizationFactor = 1.f / filterSum;

  for (int r = -blurKernelWidth/2; r <= blurKernelWidth/2; ++r) {
    for (int c = -blurKernelWidth/2; c <= blurKernelWidth/2; ++c) {
      (*h_filter)[(r + blurKernelWidth/2) * blurKernelWidth + c + blurKernelWidth/2] *= normalizationFactor;
    }
  }

}

void postProcess(const std::string& output_file, unsigned char* data_ptr, const std::string& input_file) {
  cv::Mat output(numRows(), numCols(), CV_8UC1, (void*)data_ptr);

  //output the image
  cv::imwrite(output_file.c_str(), output);
 Mat src1;
    src1 = imread("output.png", CV_LOAD_IMAGE_COLOR);
    namedWindow( "Cuda image", CV_WINDOW_AUTOSIZE );
    imshow( "Cuda image", src1 );
 
src1 = imread(input_file.c_str(), CV_LOAD_IMAGE_COLOR);
float memsettime;
cudaEvent_t start, stop;
 cudaEventCreate(&start);  cudaEventCreate(&stop);
   cudaEventRecord(start,0);
    Mat gray, edge, draw;
    cvtColor(src1, gray, CV_BGR2GRAY);
Canny( gray, edge, 50, 150, 3); 
   // stop CUDA timer
   cudaEventRecord(stop,0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&memsettime,start,stop);
   printf(" *** OpenCV CPU execution time: %f *** \n", memsettime);
    edge.convertTo(draw, CV_8U);
    namedWindow("opencv", CV_WINDOW_AUTOSIZE);
    imshow("opencv", draw);
 
    waitKey(0);                                       
    
}

void cleanup()
{
  //cleanup
  cudaFree(d_rgbaImage__);
  cudaFree(d_greyImage__);
}

void your_rgba_to_greyscale(const uchar4 * const h_rgbaImage, uchar4 * const d_rgbaImage,
                            unsigned char* const d_greyImage, size_t numRows, size_t numCols)
{

  const dim3 gridSize(numRows, 1, 1);  
  const dim3 blockSize(numCols, 1, 1); 
  rgba_to_greyscale<<<gridSize, blockSize>>>(d_rgbaImage, d_greyImage, numRows, numCols);

  cudaDeviceSynchronize(); cudaGetLastError();

}
void your_gaussian_blur(unsigned char* const d_greyImage,unsigned char* const d_greyImageBlurred, 
                              const size_t numRows, const size_t numCols,
                        const float* const h_filter, const int filterWidth)
{
  
  const dim3 blockSize(32, 32, 1);
  const dim3 gridSize(1 + numCols / blockSize.x, 1 + numRows / blockSize.y, 1);

  int filter_bytes = sizeof(float) * filterWidth * filterWidth;
  float *d_filter;
  cudaMalloc(&d_filter, filter_bytes);
  cudaMemcpy(d_filter, h_filter, filter_bytes, cudaMemcpyHostToDevice);  
  float*  d_blurarray;
   float blurarray[]={2,4,5,4,2, 4,9,12,9,4, 5,12,15,12,5, 4,9,12,9,4, 2,4,5,4,2};
 for(int i = 0; i < 25; i++) {blurarray[i] *= 0.006289308;
 // printf("input filter %f\n",blurarray[i]);
}
    cudaMalloc(&d_blurarray, sizeof(float)*25);
   cudaMemcpy(d_blurarray, blurarray, sizeof(float)*25, cudaMemcpyHostToDevice);
 // gaussian_blur<<<gridSize, blockSize>>>(d_greyImage, d_greyImageBlurred, numRows, numCols, d_blurarray, 25); //*/
   gaussian_blur<<<gridSize, blockSize>>>(d_greyImage, d_greyImageBlurred, numRows, numCols, d_filter, filterWidth);
  cudaDeviceSynchronize(); 
if(cudaSuccess != cudaGetLastError())
     printf("Error in Gaussian !\n");
}

void your_canny(unsigned char* const d_greyImage,unsigned char* const d_greyImageBlurred, 
                              const size_t numRows, const size_t numCols)
{
  
  const dim3 blockSize(32, 32, 1);
  const dim3 gridSize(1 + numCols / blockSize.x, 1 + numRows / blockSize.y, 1);

 
    float*  d_canny_yaxis;
    float* d_canny_xaxis;
    float* d_gradval;
    float* d_gradatan;
    float* d_gradtemp;
  const float h_canny_yaxis[]={-1,-2,-1,0,0,0,1,2,1};
  const float h_canny_xaxis[]={-1,0,1,-2,0,2,-1,0,1};
   
   cudaMalloc(&d_canny_yaxis, sizeof( float)*9);
   cudaMalloc(&d_canny_xaxis, sizeof( float)*9);
  cudaMalloc(&d_gradval, sizeof( float)*numRows*numCols);
  cudaMalloc(&d_gradatan, sizeof( float)*numRows*numCols);
 cudaMalloc(&d_gradtemp, sizeof( float)*numRows*numCols);
  cudaMemset(d_gradval,0,sizeof( float)*numRows*numCols);
  cudaMemset(d_gradatan,0,sizeof( float)*numRows*numCols);
  cudaMemset(d_gradtemp,0,sizeof( float)*numRows*numCols);
   cudaMemcpy(d_canny_xaxis, h_canny_xaxis, sizeof( float)*9, cudaMemcpyHostToDevice); 
   cudaMemcpy(d_canny_yaxis, h_canny_yaxis, sizeof( float)*9, cudaMemcpyHostToDevice);
   
  canny_filter<<<gridSize, blockSize>>>(d_greyImage,d_greyImageBlurred,d_gradval,d_gradatan,d_gradtemp,numRows,numCols,                  d_canny_xaxis,d_canny_yaxis, 3);
  cudaDeviceSynchronize(); 
   if(cudaSuccess != cudaGetLastError())
     printf("Error in Canny!\n");
}

int main(int argc, char **argv) {

  uchar4        *h_rgbaImage, *d_rgbaImage;
  unsigned char *h_greyImage, *d_greyImage, *d_greyImageBlurred;

  std::string input_file;
  std::string output_file;
  std::string reference_file;
  input_file = std::string(argv[1]);
  output_file = "output.png";
  reference_file = "reference.png";
   float gray_time,gaussian_time,canny_time;
   cudaEvent_t start, stop;
  float *h_filter;
  int    filterWidth;
  
  preProcess(&h_rgbaImage, &h_greyImage, &d_rgbaImage, &d_greyImage, &d_greyImageBlurred, &h_filter, &filterWidth,input_file);

   // initialize CUDA timer
   cudaEventCreate(&start);  cudaEventCreate(&stop);
   cudaEventRecord(start,0);
  your_rgba_to_greyscale(h_rgbaImage, d_rgbaImage, d_greyImage, numRows(), numCols());
   // stop CUDA timer
   cudaEventRecord(stop,0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&gray_time,start,stop);
   printf(" *** Grey Scale conversion execution time: %f *** \n", gray_time);
  cudaDeviceSynchronize(); cudaGetLastError();
	size_t numPixels = numRows()*numCols();


 // initialize CUDA timer
   cudaEventCreate(&start);  cudaEventCreate(&stop);
   cudaEventRecord(start,0);
  your_gaussian_blur(d_greyImage, d_greyImageBlurred, numRows(), numCols(), h_filter, filterWidth);
   // stop CUDA timer
   cudaEventRecord(stop,0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&gaussian_time,start,stop);
   printf(" *** Image Blur conversion execution time: %f *** \n", gaussian_time);
  cudaDeviceSynchronize(); cudaGetLastError();
// cudaMemcpy(h_greyImage, d_greyImageBlurred, sizeof(unsigned char) * numPixels, cudaMemcpyDeviceToHost);
 // postProcess(output_file, h_greyImage);
 cudaMemcpy(d_greyImage, d_greyImageBlurred, sizeof(unsigned char) * numPixels, cudaMemcpyDeviceToDevice);
 // initialize CUDA timer
   cudaEventCreate(&start);  cudaEventCreate(&stop);
   cudaEventRecord(start,0);
  your_canny(d_greyImage, d_greyImageBlurred, numRows(), numCols());
   // stop CUDA timer
   cudaEventRecord(stop,0);
   cudaEventSynchronize(stop);
   cudaEventElapsedTime(&canny_time,start,stop);
   printf(" *** Canny conversion execution time: %f *** \n", canny_time);
   printf(" *** Total GPU execution time %f ms ***\n",canny_time+gray_time+gaussian_time);
  cudaDeviceSynchronize(); cudaGetLastError();
/*  */
  cudaMemcpy(h_greyImage, d_greyImageBlurred, sizeof(unsigned char) * numPixels, cudaMemcpyDeviceToHost);
  postProcess(output_file, h_greyImage, input_file);

  cleanup();

  return 0;
}

