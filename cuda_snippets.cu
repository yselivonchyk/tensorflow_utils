// 
// nvcc -arch=sm_70 -o out cuda.cu -run
// !nvprof ./cuda

// Error handling
#include <stdio.h>
#include <assert.h>

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
