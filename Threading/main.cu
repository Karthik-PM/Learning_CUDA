#include <bits/stdc++.h>
#include <cstdio>
#include <cstdlib>
#include <cuda.h>
#include <stdlib.h>
#include <ctime>
__global__ void vectorAddition(int* V1, int* V2, int* output, int count){
    int id = blockIdx.x * blockDim.x + threadIdx.x; 

    if(id < count){
        output[id] = V1[id] + V2[id];
    }
}

void display(int * A, int count){
    for(int i = 0; i < count; i++){
        std::cout << A[i] << "\n";
    }
}
int main(){
    srand(time(NULL));
    int count = 1000;
    int *h_a, *h_b, *h_output;

    // Allocating space in CPU space
    h_a = (int*) malloc(sizeof(int) * count);
    h_b = (int*) malloc(sizeof(int) * count);
    h_output = (int*) malloc(sizeof(int) * count);

    // Assigning input array or vectors
    for(int i = 0; i < count; i++){
        h_a[i] = rand() % 1000;
        h_b[i] = rand() % 1000;
    } 
    int *d_a, *d_b, *d_output;
    
    // Allocating memory in GPU space
    if(cudaMalloc(&d_a, sizeof(int) * count) != cudaSuccess){
        std::cout << "Error Allocating Memory In GPU\n";
    }

    if(cudaMalloc(&d_b, sizeof(int) * count) != cudaSuccess){
        std::cout << "Error Allcating Memory In GPU\n";
    }
    
    if(cudaMalloc(&d_output, sizeof(int) * count) != cudaSuccess){
        std::cout << "Error Allcating Memory In GPU\n";
    }

    // copying input contents from CPU to GPU
    if(cudaMemcpy(d_a, h_a, sizeof(int) * count, cudaMemcpyHostToDevice) != cudaSuccess){
        std::cout << "Error copying values from CPU to GPU\n";
    }

    if(cudaMemcpy(d_b, h_b, sizeof(int) * count, cudaMemcpyHostToDevice) != cudaSuccess){
        std::cout << "Error copying values from CPU to GPU\n";
    }
    // copying result to CPU from GPU
    vectorAddition<<<count / 256 + 1, 256>>>(d_a, d_b, d_output, count);
    if(cudaMemcpy(h_output, d_output, sizeof(int) * count, cudaMemcpyDeviceToHost) != cudaSuccess){
        std::cout << "Error copying result from GPU to CPU memory\n";
    }
    display(h_output, count);
    // displaying result
    free(h_a);
    free(h_b);
    free(h_output);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_output);
    return 0;
}
