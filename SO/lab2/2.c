#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
        if(argc!=3){ //numar gresit de argumente
                perror("error");
                return errno;
        }
        const char *fsrc = argv[1]; //nume fisier sursa
        const char *fdest = argv[2]; //nume fisier destinatie
	
	/*pentru a obtine descriptorul asociat fisierului sursa folosesc functia open care 		deschide fisierul din fsrc pentru citire (O_RDONLY) */
        int src = open(fsrc, O_RDONLY); // open for reading only
        if(src == -1){
                        perror("open src");
                        return 2;
                }

	/*pentru a obtine descriptorul asociat fisierului destinatie folosesc functia open care 	deschide fisierul din fdest pentru scriere (O_WRONLY). Fisierul nu exista in sistem deci  	  adaug flag-ul O_CREAT, cu dreptul de acces S_IRWXU*/
        int dest = open(fdest, O_WRONLY | O_CREAT, S_IRWXU); //open for writing only
        if(dest == -1){
                        perror("dest open");
                        return 3;
                }
	/*creez un buffer de 1024 bytes(fisierele a caror dimensiune depaseste 1024bytes vor fi 	copiate partial*/
        char buf[1024];
        size_t len = sizeof(buf);
        /*
        sau
        size_t len = 1024;
        char* buf = malloc(len);
        */

        size_t nread = read(src, buf, len); //read src
	if(nread < 0) {
	perror("read buf");
	return errno;
	}
        size_t nwrite = write(dest, buf, nread); //write src

        //close src
        close(src);
        //close dest
        close(dest);
	/*optim ar fi fost sa folosesc un while in care cat timp citeam date din sursa scriam in 		destinatie */
}
/* compilare 
gcc 2.c -o 2
./2 foo bar */
