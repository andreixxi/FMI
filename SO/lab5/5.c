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
	buf[1] = n;
	int i = 2;
	while(n!=1){
		if(n%2==0)
			n = n/2;
		else n = 3*n + 1;
		buf[i] = n;
		i++;
	}
	buf[0] = i; //nr de valori collatz pt n

}
void print_collatz(int *buf)
{	//afisare vector
	printf("%d: ", buf[1]);
	for(int i=1; i<buf[0]; i++)
		printf("%d ", buf[i]);
	printf("\n");
}
int main(int argc, char *argv[])
{
	//numar insuficient de argumente
	if(argc < 2){
		perror("error");
		return errno;
	}
	
	//numele obiectului de memorie partajata, NU o cale in sistemul de fisiere
	char shm_name[] = "/myshm";        

	/*creare obiect de memorie partajata. daca ob nu exista este creat -> O_CREAT, deschis
	pentru citire si scriere -> O_RDWR; drepturi asupra lui are doar utilizatorul care l-a creat -> S_IRUSR|S_IWUSR */
	/*shm_fd este un descriptor */ 
	int shm_fd = shm_open(shm_name, O_CREAT| O_RDWR, S_IRUSR|S_IWUSR);
	if(shm_fd < 0){
		perror(NULL);
		return errno;
	}

	/*definesc dimensiunea cu ajutorul functiei de sistem ftruncate care scruteaza sau mareste obiectul asociat descriptorului conform noii dimensiuni primite in al doilea argument (de la 0 bytes la 1024 */
	size_t shm_size = 1024 * argc; 
	if(ftruncate(shm_fd, shm_size) == -1) {
		perror(NULL);
		shm_unlink(shm_name); //sterge obiectul creat cu shm_open(), ce are denumirea shm_name
		return errno;
	}

	printf("Starting parent %d\n", getpid());
	for (int i=1; i<argc; i++){
		pid_t pid = fork(); //creare proces
		if(pid<0){
                        fprintf(stderr,"Fork failed");
			return errno;	
		}
		//child
		else if(pid == 0) {
			/* memoria partajata se incarca in spatiul procesului cu ajutorul functiei de sistem mmap. 0 = adresa la care sa fie incarcata in proces(se foloseste 0 pt a lasa kernelul sa decida); 
shm_size = dimensiunea memoriei incarcate; 
drept de acces -> de scriere (PROT_WRITE); 
MAP_SHARED = flag, indica tipul de memorie, modificarile facute de proces sunt vizibile si in celelalte;  
shm_fd = descriptor obiect de memorie
0 = offset; locul in obiectul de memorie de la care sa fie incarcat in spatiul procesului */			
/*adresa shm_ptr indica spre toata zona de memorie(shm_size) aferenta descriptorului shm_fd care va fi scrisa(PROT_WRITE) si impartita cu restul proceselor (MAP_SHARED)*/
			char *shm_ptr = mmap(0, shm_size, PROT_WRITE, MAP_SHARED, shm_fd, 0);
			if(shm_ptr == MAP_FAILED) {
				perror(NULL);
				shm_unlink(shm_name); /*sterge obiectul creat cu shm_open(), ce are denumirea shm_name*/
				return errno;
			}
			int *buf = (int*)(shm_ptr + (i-1) * 1024);//offset 1024, 2*1024, 3*1024.. 
			int n = atoi(argv[i]); //transform in int argumentul de pe poz i
			collatz(n, buf); //aplic collatz
			printf("Done parent %d Me %d  \n", getppid(), getpid());
			return 0;
		}
	}
	
	//asteptare finalizare executie proces fiu
	for(int i=1; i<argc; i++){
		wait(NULL);
	}

	/*adresa shm_ptr indica spre toata zona de memorie(shm_size) aferenta descriptorului shm_fd care va fi citita(PROT_READ) si impartita cu restul proceselor (MAP_SHARED)*/
	char *shm_ptr = mmap(0, shm_size, PROT_READ, MAP_SHARED, shm_fd, 0);
	if(shm_ptr == MAP_FAILED) {
		perror(NULL);
		shm_unlink(shm_name);
		return errno;
	}

	//afisare 
	for(int i=1; i<argc; i++)
		print_collatz((int*)(shm_ptr + (i-1) * 1024));

	shm_unlink(shm_name);//stergere obiect shm_name, creat cu shm_open()
	munmap(shm_ptr, shm_size); //elibereaza zona de memorie incarcata; shm_size = 1024 * argc
}
/*rulare
gcc 5.c -o 5 -lrt
./5 9 16 25 36 */
