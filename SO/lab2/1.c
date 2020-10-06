#include <stdio.h>
#include <string.h>
#include <unistd.h> 
int main()
{
//printf("hello world!\n");
        const char *str = "hello world!\n"; //sir constant
        size_t len = strlen(str); //dimensiunea sirului
	write(1, str, len);     /* functie sistem, incearca sa scrie "len" bytes catre obiectul "1" (0 pt sdtin, 1 pt stdout, 2 stderr) din bufferul "str" */
	return 0;
}
