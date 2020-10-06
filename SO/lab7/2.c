#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <pthread.h>
#include <semaphore.h>

#define N 5

pthread_mutex_t mtx;
sem_t sem;
int S = 1; 
int counter = 0;

void barrier_point() {
	//obtin mutex (lock); inchidere mutex
	pthread_mutex_lock(&mtx);

	counter++;
	if(counter == N) {
		//verific daca sunt blocate threads de semafor si elibereaza threadul care asteapta de cel mai mult timp
		for(int i=0; i < counter - 1; i++) 
			sem_post(&sem); //S++

		pthread_mutex_unlock(&mtx);//deschidere mutex
		counter = 0;
	}	
	
	pthread_mutex_unlock(&mtx);//deschidere mutex
	if(sem_wait(&sem)) 
		perror(NULL);
}


void* tfun(void* v) {
	int *tid = (int*)v; //numarul threadului pornit

	printf("%d reached the barrier\n", *tid);
	barrier_point();
	printf("%d passed the barrier\n", *tid);

	free(tid);
	return NULL;
}

int main() 
{
	//0 pt ca nu folosesc semaforul in cadrul mai multor procese
	if(sem_init(&sem, 0, S)) {
		perror(NULL);
		return errno;
	}

	pthread_t* thr = malloc(N * sizeof(pthread_t));
	for(int i=0; i< N; i++) {
		int* aux = malloc(sizeof(int));
		*aux = i;
		//initializare thread prin aplicarea functiei tfun ce primeste ca parametru aux
		if(pthread_create(&thr[i], NULL, tfun, aux)) {
			perror(NULL);
			return errno;
		}
	}

	//join
	for(int i=0; i< N; i++)
		if(pthread_join(thr[i], NULL)) {
			perror(NULL);
			return errno;
		}
	
}
