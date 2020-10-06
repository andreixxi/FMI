#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h> 
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <pthread.h>

char *strrev(char *str){
    char c, *front, *back;

    if(!str || !*str) //sir vid
        return str;
    for(front = str, back = str + strlen(str) - 1; front < back; front++, back--) {
        c = *front;
	*front = *back;
	*back = c;
    }
    return str;
}

void *
reverse(void *v){
	char *str = (char*)v;
	char *str2 = strrev(str);
	return NULL;
}

int main (int argc, char*argv[])
{
	//numar gresit de argumente
	if(argc != 2) {
             return errno;
	}

	//sirul pe care vreau sa-l inversez
        char* my_str = argv[1];
	pthread_t thr;//thread/ fir de executie
	/* initializeaza un thread prin apelarea functiei reverse cu argumente oferite de my_str (diferit fata de procesele create cu fork(), un thread porneste executie de la o functie data)*/
	if(pthread_create(&thr, NULL, reverse, my_str)) { //null-atribut implicit setat de sistemul de operare(dimensiunea stivei, securitate (?)
		perror(NULL);
		return errno;
	}

	//&result = NULL; adresa
	//asteptare finalizare executie thread; asteapta explicit thread-ul din variabila thr
	if(pthread_join(thr, NULL)) {
		perror(NULL);
		return errno;
	}
	
	printf("%s\n", my_str);	
	//compilare 
	//cc lab6.c -o lab6 -pthread
	//./lab6 hello
	
}
