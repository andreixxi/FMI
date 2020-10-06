#include <sys/types.h>
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <string.h>

/*structura cu adresa de inceput a matricei, nr de linii si coloane*/
typedef struct  {
	int **m;
	int rows, cols;
	} matrix;

/*nr liniei din m1, nr coloanei din m2 */
typedef struct {
	int i, j, r2; //r2 dimensiune comuna
	matrix *m1, *m2, *rez;
} mult_thread;

/*aloca o matrice de r * c */
matrix* m_alloc (int r, int c){
	matrix* m = malloc(sizeof(matrix));
	m->rows = r;
	m->cols = c;
	
	m->m = malloc(r * sizeof(int*));
	for(int i=0; i<r; i++)
		m->m[i] = malloc(c * sizeof(int));
	return m;
}

/*stergere matrice*/
void free_m(matrix *m) {
	for(int i=0; i<m->rows; i++)
		free(m->m[i]);
	free(m);
}

/*afisare matrice*/
void afis(matrix *mat) {
	int i, j;
	for (i = 0; i < mat->rows; i++)
	{
		for (j = 0; j < mat->cols; j++)
			printf("%d ", mat->m[i][j]);
		printf("\n");
	}
	printf("\n");
}

/*generare matrice cu valori random*/
void generare_mat(matrix *mat) {
	int i, j;
	//mat->m_alloc(r,c);
	for (i = 0; i < mat->rows; i++)
		for (j = 0; j < mat->cols; j++)
			mat->m[i][j] = rand() % 10;
}

void *Produs(void *v) {
	mult_thread *vaux = (mult_thread *)v; //struct
	int i = vaux->i; //linia
	int j = vaux->j; //coloana
	int p = vaux->r2; //dimensiunea comuna
	int** M1 = vaux->m1->m;//adresa m1
	int** M2 = vaux->m2->m; //m2
	int** R = vaux->rez->m; //matricea rezultat
	int k;
	for (k = 0; k < p; ++k)
	{
		R[i][j] += M1[i][k] * M2[k][j];
	}
}

int main(int argc, char *argv[])
{
	if (argc != 5) {
		printf("nr gresit de arg");
		return 0;
	}
	int r1 = atoi(argv[1]); //linii m1
	int c1 = atoi(argv[2]); //col m1
	int r2 = atoi(argv[3]); //inii m2
	int c2 = atoi(argv[4]); //col m2
	
	//nu pot inmulti 
	if (c1 != r2) {
		printf("date gresite\n");
		return 0;
	}

	//alcoare matrici
	matrix* m1 = m_alloc(r1, c1);
	matrix* m2 = m_alloc(r2, c2);
	matrix* rez = m_alloc(r1, c2);
	
	//generare valori random pt m1 si m2
	generare_mat(m1);
	generare_mat(m2);
	
	//afisare
	afis(m1);
	afis(m2);
	
	//alocare vector de threads
	pthread_t* thr = malloc((r1 * c2) * sizeof(pthread_t));
	int z=0;
	for (int i = 0; i < r1; i++)
		for(int j=0; j < c2; j++) {
			mult_thread *v = malloc(sizeof(mult_thread));
			v->i = i;
			v->j = j;
			v->r2 = r2;
			v->m1 = m1;
			v->m2 = m2;
			v->rez = rez;
			//initializare thread prin aplicarea functiei Produs cu parametrul v
			if (pthread_create(&thr[z++], NULL, Produs, v)) {
				perror(NULL);
				return errno;
			}
		}

	/*join threads; asteptare executie thread cu pthread_join*/
	for (int i = 0; i < z; i++) //lista de pthread
		if (pthread_join(thr[i], NULL)) {
			perror(NULL);
			return errno;
		}

	//afisare matrice
	afis(rez);
	
	//stergere
	free(m1);
	free(m2);
	free(rez);
	return 0;
}

