#include<stdio.h>
#include<bits/stdc++.h>
#include<cuda_runtime.h>
#include<time.h>

using namespace std;

#define width 32

__global__ void optMult(int* a, int* b, int* ans,int m,int n, int p)
{
    __shared__ int tileA[width][width], tileB[width][width];

    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    int tx = threadIdx.x, ty = threadIdx.y;
    int temp_sum = 0;
    tileA[ty][tx] = 0, tileB[ty][tx] = 0;

    for(int i=0;i<(p+width-1)/width;i++)
    {
        if(row < m &&  (tx + i*width) < p)
            tileA[ty][tx] = a[row*p + i*width + tx];
        else
            tileA[ty][tx] = 0;

        if(col < n && (ty + i*width) < p)
            tileB[ty][tx] = b[col + (ty + i*width)*n ];
        else
            tileB[ty][tx] = 0;

        __syncthreads();

        for(int i=0;i<width;i++)
            temp_sum += tileA[ty][i]*tileB[i][tx];
    }

    if((row<m)&&(col<n))
    {
        ans[row*n + col] = temp_sum;
    }
}

void init(int* a,int* b,int m,int n,int p)
{
    for(int i=0;i<m;i++)
    {   
        for(int j=0;j<p;j++)
            *(a+i*p+j) = 1;
    }

    for(int i=0;i<p;i++)
    {   
        for(int j=0;j<n;j++)
             *(b+i*n+j) = 2;
    }
   
}

int main()
{
    int *h_a, *h_b, *h_c; 
    int *d_a, *d_b, *d_c; 
    
    int m,p,n;

    m = 4, p = 2, n = 4; 

    size_t bytes_a = m*p*sizeof(int);
    size_t bytes_b = n*p*sizeof(int);
    size_t bytes_c = m*n*sizeof(int);

    h_a = (int*)malloc(bytes_a);
    h_b = (int*)malloc(bytes_b);
    h_c = (int*)malloc(bytes_c);

    init(h_a,h_b,m,n,p);

    cudaMalloc(&d_a,bytes_a);
    cudaMalloc(&d_b,bytes_b);
    cudaMalloc(&d_c,bytes_c);

    int block_size = 32;
    int grid_size = (int)ceil((float)64/block_size);

    dim3 grid(grid_size,grid_size);
    dim3 threads(block_size,block_size);

    cudaMemcpy(d_a,h_a,bytes_a,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,h_b,bytes_b,cudaMemcpyHostToDevice);
    cudaMemcpy(d_c,h_c,bytes_c,cudaMemcpyHostToDevice);

    optMult<<<grid,threads>>> (d_a,d_b,d_c,m,n,p);

    cudaMemcpy(h_c,d_c,bytes_c,cudaMemcpyDeviceToHost);

    for(int i=0;i<m;i++)
    {
        for(int j=0;j<n;j++)
            cout<<*(h_c+i*n+j)<<" ";
        cout<<"\n";
    }
    
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    free(h_a);
    free(h_b);
    free(h_c);

    return 0;
}
