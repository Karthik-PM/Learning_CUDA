#include <cstdlib>
#include <stdio.h>
__global__ void vectorAdder(int* A, int* B, int* output, int N){
    for(int i = 0; i < N; i++){
        output[i] = A[i] + B[i];
    }
}

int main(){
    

    // Vectors in CPU
    int *V1, *V2, *output;
    
    // Computed Vector in GPU
    int *V1_GPU, *V2_GPU, *output_GPU;

    int N = 3; // Memory space needed

    // allocating memory in CPU
    V1 = (int*) malloc(sizeof(int) * N);
    V2 = (int*) malloc(sizeof(int) * N);
    output = (int*) malloc(sizeof(int) * N);

    // populating values in the vector
    for(int i = 0; i < N; i++) V1[i] = i;
    for(int i = 0; i < N; i++) V2[i] = i + N;

    // allocating memory for GPU usage
    cudaMalloc((void**) &V1_GPU, sizeof(int) * N);
    cudaMalloc((void**) &V2_GPU, sizeof(int) * N);
    cudaMalloc((void**) &output_GPU, sizeof(int) * N);
    
    // copying the contents of CPU array to GPU array
    cudaMemcpy(V1_GPU, V1, sizeof(int) * N, cudaMemcpyHostToDevice); // host is descibed as the CPU
    cudaMemcpy(V2_GPU, V2, sizeof(int) * N, cudaMemcpyHostToDevice);
    
    // host invoking the Device or Kernel (GPU)
    vectorAdder<<<1, 1>>>(V1_GPU, V2_GPU, output_GPU, N);
    cudaMemcpy(output, output_GPU, sizeof(int) * N, cudaMemcpyDeviceToHost);
    
    // display result
    for(int i = 0; i < N; i++){
        printf("%d ", output[i]);
    }

    // free GPU memory
    cudaFree(V1_GPU);
    cudaFree(V2_GPU);
    cudaFree(output_GPU);

    // free CPU memory
    free(V1);
    free(V2);
    free(output);
    return 0;
}
