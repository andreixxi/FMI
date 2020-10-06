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

void collatz(int n, int *buf)
{
	buf[0] = n;
	int i = 1;
	while(n!=1){
		if(n%2==0)
			n = n/2;
		else n = 3*n + 1;
		buf[i] = n;
		i++;
		}
}
void print_collatz(int *buf)
{
	for(int i=0; i<sizeof(buf); i++)
		printf("%d ", buf[i]);
	printf("\n");
}
int main(int argc, char *argv[])
{
	if(argc < 2){
        perror("error");
        return errno;
        }

	pid_t pid;
        printf(" \n Starting parent %d ", getpid());

	char shm_name[] = "/myshm";        
        int shm_fd = shm_open(shm_name, O_CREAT| O_RDWR, S_IRUSR|S_IWUSR);
        if(shm_fd < 0){
                perror(NULL);
                return errno;
        }
 	size_t shm_size = 1024 * argc; 
        if(ftruncate(shm_fd, shm_size) == -1) {
                perror(NULL);
                shm_unlink(shm_name);
                return errno;
        }

        for (int i=1; i<argc; i++){
                pid = fork();
                if(pid<0)
                        return errno;	
		//child
                else if(pid == 0){
                        //adresa
                        char *shm_ptr = mmap(0, shm_size, PROT_WRITE, MAP_SHARED, shm_fd, 0);
                        if(shm_ptr == MAP_FAILED) {
                                perror(NULL);
                                shm_unlink(shm_name);
                                return errno;
                        }
			int *buf = (int*)(shm_ptr + (i-1) * 1024);//offset
			int n = atoi(argv[i]);
			collatz(n, buf);
			return 0;
		}
		printf("\n");
	}

	for(int i=1; i<argc; i++){
	wait(NULL);
	printf("Child %d finished \n", getpid());
	}

	char *shm_ptr = mmap(0, shm_size, PROT_READ, MAP_SHARED, shm_fd, 0);
	if(shm_ptr == MAP_FAILED) {
                                perror(NULL);
                                shm_unlink(shm_name);
                                return errno;
                        }

	for(int i=1; i<argc; i++)
		print_collatz((int*)(shm_ptr + (i-1) * 1024));
	shm_unlink(shm_name);
	}