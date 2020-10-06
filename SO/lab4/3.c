#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>

void f(int n) {
	printf("%d: %d ", n, n);
        while(n != 1) {
        	if (n%2==0)
                        n = n/2;
                else 
                        n = 3 * n + 1;
                printf("%d ", n);
                }
	printf("\n");
}

int main (int argc, char*argv[])
{
        int size = argc;
	//array with input numbers 
        int *vector = (int*)malloc(size * sizeof(int));
        for (int i=1; i<size; i++)
        vector[i] = atoi(argv[i]); 

	//wrong input
        if (argc < 2) { 
	perror("error");
        return errno;
	}

	printf("Starting parent %d\n", getpid());
	pid_t pid;
	for (int i=1; i<size; i++){
	 	pid = fork(); //proces fiu
		if (pid<0)
		        return errno;
		//child
		else if (pid == 0){        
			f(vector[i]); //collatz pt v[i]
			printf("Done Parent %d Me %d\n", getppid(), getpid());
			return 0;
		        }	
	
	}
	//asteptare finalizare executie proces fiu
	for (int i=1; i<size; i++){
		wait(NULL);
	}
	
}


