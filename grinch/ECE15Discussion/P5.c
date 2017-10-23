// Janani Kalyanam
// jkalyana@ucsd.edu
// 12/15/2014
#include <stdio.h>
#include <stdlib.h>

FILE *input;

int **allocate_int_matrix(int);
void read_int_matrix(int**,int);
void print_int_matrix(int**,int);
void rotate_int_matrix(int**,int);
int main()
{
	int **A, n;
	
	if((input = fopen("input6.dat","r")) == NULL)
	{
		printf("File could not be opened!\n");
	}
	
	fscanf(input, "%d", &n);
	A = allocate_int_matrix(n);
	if(A == NULL)
	{
		printf("Not enough memory!\n");
		return 1;
	}

	read_int_matrix(A,n);
	printf("Original matrix: \n");
	print_int_matrix(A,n);	
	rotate_int_matrix(A,n);
	printf("Rotated clockwise: \n");
	print_int_matrix(A,n);
	return 0;
}

int **allocate_int_matrix(int n)
{
	int **A, *p, i, j;
	p = (int *)malloc(n*n*sizeof(int));
	A = (int **)malloc(n*sizeof(int*));
	j = 0;
	for(i = 0; i < n; i++)
	{
		A[i] = &p[j];
		j+=n;
	}

	return A;
}

void read_int_matrix(int **A, int n)
{
	int i,j;
	for(i = 0; i < n; i++)
	{
		for(j = 0; j < n; j++)
		{
			fscanf(input, "%d", &A[i][j]);
		}
	}
	
	return;
}

void print_int_matrix(int **A, int n)
{
	int i,j;
	for(i = 0; i < n; i++)
	{
		for(j = 0; j < n; j++)
		{
			if(j == n-1)
				printf("%d\n",A[i][j]);
			else
				printf("%d ", A[i][j]);
		}
	}
	return;
}

void rotate_int_matrix(int **A, int N)
{
	int i, temp;
	
	temp = A[0][0];
	for(i = 0; i < N-1; i++)
		A[i][0] = A[i+1][0];
	for(i = 0; i < N-1; i++)
		A[N-1][i] = A[N-1][i+1];
	for(i = N-1; i > 0; i--)
		A[i][N-1] = A[i-1][N-1];
	for(i = N-1; i > 0; i--)
		A[0][i] = A[0][i-1];
	A[0][1] = temp;

	return;
}
