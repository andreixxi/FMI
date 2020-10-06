#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <pthread.h>

#define MAX_RESOURCES 5
int available_resources = MAX_RESOURCES;

pthread_mutex_t mtx; //declarata global

int increase_count(int count) {
	//obtin mutex (lock); inchidere mutex
	pthread_mutex_lock(&mtx); 

	//incepe zona critica
	available_resources += count;
	printf("released %d resources %d remaining\n", count, available_resources);
	//se termina zona critica

	//deschidere mutex
	pthread_mutex_unlock(&mtx);
	return 0;
}

int decrease_count(int count) {
	//obtin mutex (lock); inchidere mutex
	pthread_mutex_lock(&mtx);

	//incepe zona critica
	//nu am resurse suficiente
	if(available_resources < count) {
		pthread_mutex_unlock(&mtx); //deschidere mutex
		return -1;
		}
	available_resources -= count;
	printf("got %d resources %d remaining\n", count, available_resources);
	//se termina zona critica

	//deschidere mutex
	pthread_mutex_unlock(&mtx);
	return 0;
}

void* modify_count(void* v) {
	int count = *(int*)v;
	if(decrease_count(count) != -1) //pot sa folosesc resurse
		increase_count(count);
	return NULL;
}


int main() 
{
	printf("MAX_RESOURCES=%d\n", MAX_RESOURCES);
	//initializare mutex
	if(pthread_mutex_init(&mtx, NULL)) {
		perror(NULL);
		return errno;
		}

	pthread_t* thr = malloc((available_resources) * sizeof(pthread_t));
	for(int i=0; i<available_resources; i++) {
		int* value = malloc(sizeof(int));
		//nr de resurse folosit de fiecare thread
		*value = rand() % 5;
		//initializare thread prin aplicarea functiei modify_count ce primeste ca parametru value
		if(pthread_create(&thr[i], NULL, modify_count, value)) {
			perror(NULL);
			return errno;
			}
	}
	
	//join threads, asteptare executie thread
	for(int i=0; i<available_resources; i++) {
		if(pthread_join(thr[i], NULL)) {
			perror(NULL);
			return errno;
		}
	}

	pthread_mutex_destroy(&mtx);
}
