#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#define N 4
#define M 5
#define P 3
#define no_threads 4

int m1[M][P], m2[P][N], m3[M][N];

void init(int l, int c, int m[][c]){
	for(int i=0; i<l; i++)
		for(int j=0; j<c; j++)
			m[i][j] = rand()%10;
}

void printm(int l, int c, int m[][c]){
	for(int i=0; i<l; i++){
		for(int j=0; j<c; j++){
			printf("%d ", m[i][j]);
			}
		printf("\n");
	}
	printf("\n");
}

int pas = 0;
void* multiply(void* arg) { 
	int aux = pas++;
	// Each thread computes 1/4th of matrix multiplication 
	for(int i = aux*M/4; i < (aux+1)*M/4; i++){
		for(int j=0; j<N; j++){
			for(int k=0; k<N; k++){
				m3[i][j] += m1[i][k] * m2[k][j];
			}
		}
	}
}

int main(){

	init(M, P, m1);
	init(P, N, m2);
	//init(M, N, m3);

	printm(M, P, m1);
	printm(P, N, m2);
	//printm(M, N, m3);

	pthread_t threads[no_threads];//vector

	for(int i=0; i<no_threads; i++){
		int *p;
		if(pthread_create(&threads[i], NULL, multiply, (void*)(p))){
			perror(NULL);
			return errno;
		}
	}	
	
	for(int i=0; i<no_threads; i++){
		if(pthread_join(threads[i], NULL)){
			perror(NULL);
			return errno;
		}
	}
	
	printm(M, N, m3);
}
//gcc lab6ex2.c -o lab6ex2 -pthread
//./lab6ex2

