#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/wait.h>
int main ()
{
        pid_t pid = fork(); //creare proces
        if (pid<0)
                return errno;
	//child
        else if (pid == 0){
                printf("My PID=%d, child PID=%d\n", getppid(), getpid());
                char *argv[] = {"ls", NULL};
		/*pe prima pozitie se afla calea absoluta(!!) catre program urmata de argumente. 			lista se incheie cu null*/
                execve("/bin/ls", argv, NULL);//afisare fisiere director curent
                perror(NULL);
                }
	//parent
        else if (pid > 0){
              	wait(NULL); //asteapta finalizarea executiei unui proces fiu
                }
	printf("Child %d finsihed\n", pid);
}
