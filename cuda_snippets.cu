// 
// nvcc -arch=sm_70 -o out cuda.cu -run
// !nvprof ./cuda

// GDB debug:
// # nvcc -g -G -gencode ...
// #cuda-gdb
// >>file runnable
// >>break 
// >>break student_func.cu:compact
// >>run param1 param2

// Nsight Eclipse cuda debugging run
// https://github.com/AK-ayush/nsight-for-remote-gpu-server
// server: docker pull kayush206/ssh-docker
// server: nvidia-docker run -d -p <port>:22 kayush206/ssh-docker

// Error handling
#include <stdio.h>
#include <assert.h>

__global__
void add(int* A, int* B, int* C, int N){
  int x = blockDim.x*blockIdx.x+threadIdx.x;
  int y = blockDim.y*blockIdx.y+threadIdx.y;
  int idx = y*N+x;
}

dim3 grid(32, 32, 1);
dim3 block(N/32+1, N/32+1, 1);
add<<<grid, block>>>(dA, dB, dC, N);

inline cudaError_t checkCuda(cudaError_t result)
{
  if (result != cudaSuccess) {
    fprintf(stderr, "CUDA Runtime Error: %s\n", cudaGetErrorString(result));
    assert(result == cudaSuccess);
  }
  return result;
}
checkCuda( cudaDeviceSynchronize() );

errSync  = cudaGetLastError();
errAsync = cudaDeviceSynchronize(); // Wait for the GPU to finish
if (errSync  != cudaSuccess) { printf("Sync  error: %s\n", cudaGetErrorString(errSync) ); }
if (errAsync != cudaSuccess) { printf("Async error: %s\n", cudaGetErrorString(errAsync)); }


// Properties
int deviceId;
cudaGetDevice(&deviceId);                 
cudaDeviceProp props;
cudaGetDeviceProperties(&props, deviceId);
computeCapabilityMajor = props.major;
computeCapabilityMinor = props.minor;
multiProcessorCount = props.multiProcessorCount;
warpSize = props.warpSize;

cudaDeviceGetAttribute(&smemSize, cudaDevAttrMaxSharedMemoryPerBlock, devId);
cudaDeviceGetAttribute(&numProcs, cudaDevAttrMultiProcessorCount, devId);

int dev_count; cudaGetDeviceCount(&dev_count);


//atomic ops
atomicAdd(&a[i], 1);


// memory usage
cudaMallocManaged(&a, size);
cudaMemPrefetchAsync(a, size, deviceId);
cudaMemPrefetchAsync(a, size, cudaCpuDeviceId);
cudaFree(a);

cudaMalloc(); // on default GPU
cudaMallocDevice();
cudaMallocHost(); cudaFreeHost();
cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
cudaMemcpyAsync(d_a, h_a, size, cudaMemcpyHostToDevice, steram);


//streams
cudaStream_t stream;
cudaStreamCreate(&stream);
kernel<<<nblocks, nthreads, 0, stream>>>(); 
cudaStreamDestroy(stream); // will keep going until ops are complete

