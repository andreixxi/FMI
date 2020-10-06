#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>

int f(int n) {
        if(n != 1) {
		if(n%2 == 0) {
			printf("%d ", n);
                        return f(n/2);
                        }
                if(n%2 == 1) {
                        printf("%d ", n);
                        return f(3*(n)+1);
                        }
                }
        else printf("%d", 1);
}
int main (int argc, char* argv[])
{
	//numar gresit de argumente
        if(argc != 2) {
        perror("error");
        return errno;
        }
        int n = atoi(argv[1]); //transform in int primul argument

        pid_t pid = fork(); //creare proces nou
        if (pid<0)
                return errno;
	//child
        else if (pid == 0) {
                printf("%d: ", n);
                int rez = f(n); //collatz
                printf("\nchild %d finished\n", getpid());
                }
	//parent
        else if (pid > 0) {
                wait(NULL); //asteptare finalizare executie proces fiu
                }
}
