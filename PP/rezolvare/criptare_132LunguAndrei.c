#include <stdio.h>
#include <stdlib.h>

typedef struct
{
    unsigned char r, g, b;
} imagine;

int *xorshift32 (int n, unsigned int *s)
{
    unsigned int r, seed, k;
    seed = 123456789;
    r = seed;
    s = malloc(n * sizeof(unsigned int));
    for(k = 0; k < n; k++)
    {
        r = r ^ r << 13;
        r = r ^ r >> 17;
        r = r ^ r << 5;
        s[k] = r;
    }
    return s;
}

imagine *incarcare_imagine (char *nume_sursa, imagine *L)
{
    FILE *in = fopen(nume_sursa, "rb");
    if (in == NULL)
    {
        printf("nu am gasit imaginea sursa din care citesc");
        return 0;
    }
    unsigned int dim, latime, inaltime;

    fseek(in, 2, SEEK_SET); //sar la octetul 2 din header
    fread(&dim, sizeof(unsigned int), 1, in);
    printf("dimensiunea imaginii in octeti este: %u \n", dim);

    fseek(in, 18, SEEK_SET); //sar la octetul 18 din header
    fread(&latime, sizeof(unsigned int), 1, in);
    fread(&inaltime, sizeof(unsigned int), 1, in);//citesc incepand cu octetul 22
    printf("dimensiunea imaginii in pixeli (latime x inaltime) este: %u x %u \n", latime, inaltime);

    //padding pt o linie
    int padding = (latime % 4 != 0) ? 4 - (3 * latime)%4 : 0;

    fseek(in, 54, SEEK_SET);

    L = malloc(sizeof(imagine) * latime * inaltime);
    unsigned char r, g, b;
    int t=0;
    for(int i=0; i < latime; i++)
    {
        for(int j=0; j < inaltime; j++)
        {
            fread(&b, 1, 1, in);
            fread(&g, 1, 1, in);
            fread(&r, 1, 1, in);

            L[t].b = b;
            L[t].g = g;
            L[t++].r = r;
        }
        fseek(in, padding, SEEK_CUR);
    }

    fclose(in);
    return L;
}

void salveaza_imagine (char *nume_sursa, char *nume_fis, imagine *L)
{
    FILE *in = fopen(nume_sursa, "rb+");
    FILE *out = fopen(nume_fis, "wb+");

    if(in == NULL)
    {
        printf("eroare la deschidere.");
        return ;
    }
    if (out == NULL)
    {
        printf("eroare la deschidere.");
        return ;
    }

    //copiaza octet cu octet headerul
    fseek(in, 0, SEEK_SET);
    for (int i=0; i < 54; i++)
    {
        unsigned char h;
        fread(&h, sizeof(unsigned char), 1, in);
        fwrite(&h, sizeof(unsigned char), 1, out);
        fflush(out);
    }

    unsigned int latime, inaltime;
    fseek(in, 18, SEEK_SET);
    fread(&latime, sizeof(unsigned int), 1, in);
    fread(&inaltime, sizeof(unsigned int), 1, in);

    fseek(in, 54, SEEK_SET);
    for (int i=0; i < latime * inaltime; i++)
    {
        fwrite(&L[i].b, sizeof(unsigned char), 1, out);
        fwrite(&L[i].g, sizeof(unsigned char), 1, out);
        fwrite(&L[i].r, sizeof(unsigned char), 1, out);
        fflush(out);
    }

    fclose(in);
    fclose(out);
}

void swap (int *a, int *b)
{
    int aux = *a;
    *a = *b;
    *b = aux;
}
union numar
{
    unsigned char x[3];
    unsigned int y;
};

imagine *criptare (char *cale_init, char *cale_crip, char *fis_txt, imagine *P)
{
    FILE *f = fopen(cale_init, "rb+");
    FILE *g = fopen(cale_crip, "wb+");
    FILE *h = fopen(fis_txt, "r");

    if(f == NULL)
    {
        printf("eroare la deschidere cale init.");
        return 0;
    }
    if (g == NULL)
    {
        printf("eroare la deschidere cale crip .");
        return 0;
    }
    if(h == NULL)
    {
        printf("eroare la deschidere fis txt.");
        return 0;
    }

    //copiaza octet cu octet headerul
    fseek(f, 0, SEEK_SET);
    for (int i=0; i < 54; i++)
    {
        unsigned char pixel;
        fread(&pixel, sizeof(unsigned char), 1, f);
        fwrite(&pixel, sizeof(unsigned char), 1, g);
        fflush(g);
    }

    union numar key;
    fscanf(h, "%u", &key.y);

    unsigned int latime, inaltime;
    fseek(f, 18, SEEK_SET);
    fread(&latime, sizeof(unsigned int), 1, f);
    fread(&inaltime, sizeof(unsigned int), 1, f);

    unsigned int *R = xorshift32(2 * latime * inaltime - 1, R); //secventa

    unsigned int *p = malloc((latime * inaltime) * sizeof(unsigned int));

    for(unsigned int k=0; k < latime * inaltime; k++)
        p[k] = k;

    for(unsigned int k = latime * inaltime - 1; k >= 1; k--) //permutarea
    {
        unsigned int r = R[k] % k; //0<=r<k
        swap(&p[r], &p[k]);
    }
    //permutare pixeli imagine
    for(int i = 0; i < inaltime * latime ; i++)
    {
        P[p[i]].r = P[i].r;
        P[p[i]].g = P[i].g;
        P[p[i]].b = P[i].b;

        fwrite(&P[i].b, sizeof(unsigned char), 1, g);
        fwrite(&P[i].g, sizeof(unsigned char), 1, g);
        fwrite(&P[i].r, sizeof(unsigned char), 1, g);
        fflush(g);
    }
    //criptare pixeli imagine
    fseek(f, 54, SEEK_SET);
    fseek(g, 54, SEEK_SET);
    P[0].b = key.x[0] ^ P[0].b ^ R[inaltime * latime];
    P[0].g = key.x[1] ^ P[0].g ^ R[inaltime * latime];
    P[0].r = key.x[2] ^ P[0].r ^ R[inaltime * latime];

    fwrite(&P[0].b, sizeof(unsigned char), 1, g);
    fwrite(&P[0].g, sizeof(unsigned char), 1, g);
    fwrite(&P[0].r, sizeof(unsigned char), 1, g);
    fflush(g);

    for(int i = 1; i < inaltime * latime ; i++)
    {
        P[i].b = P[i-1].b ^ P[i].b ^ R[inaltime * latime + i];
        P[i].g = P[i-1].g ^ P[i].g ^ R[inaltime * latime + i];
        P[i].r = P[i-1].r ^ P[i].r ^ R[inaltime * latime + i];

        fwrite(&P[i].b, sizeof(unsigned char), 1, g);
        fwrite(&P[i].g, sizeof(unsigned char), 1, g);
        fwrite(&P[i].r, sizeof(unsigned char), 1, g);
        fflush(g);
    }

    fclose(f);
    fclose(g);
    fclose(h);

    free(R);
    free(p);
    return P;
}

imagine *decriptare (char *cale_init, char *cale_crip, char *fis_txt, imagine *C)
{
    FILE *f = fopen(cale_init, "rb+");
    FILE *g = fopen(cale_crip, "wb+");
    FILE *h = fopen(fis_txt, "r");

    if(f == NULL)
    {
        printf("eroare la deschidere cale init.");
        return 0;
    }
    if(g == NULL)
    {
        printf("eroare la deschidere cale crip.");
        return 0;
    }
    if(h == NULL)
    {
        printf("eroare la deschidere fis txt.");
        return 0;
    }

    //copiaza octet cu octet headerul
    fseek(f, 0, SEEK_SET);
    for (int i=0; i < 54; i++)
    {
        unsigned char pixel;
        fread(&pixel, sizeof(unsigned char), 1, f);
        fwrite(&pixel, sizeof(unsigned char), 1, g);
        fflush(g);
    }

    union numar key;
    fscanf(h, "%u", &key.y);
    // fscanf(h, "%u", &key.y); //actualizez pt a 2a valoare

    unsigned int latime, inaltime;
    fseek(f, 18, SEEK_SET);
    fread(&latime, sizeof(unsigned int), 1, f);
    fread(&inaltime, sizeof(unsigned int), 1, f);

    unsigned int *R = xorshift32(2 * latime * inaltime - 1, R); //secventa

    unsigned int *p = malloc((latime * inaltime) * sizeof(unsigned int));
    unsigned int *v = malloc((latime * inaltime) * sizeof(unsigned int));

    for(unsigned int k=0; k < latime * inaltime; k++)
        p[k] = k;

    for(unsigned int k = latime * inaltime - 1; k >= 1; k--) //permutarea
    {
        unsigned int r = R[k] % k; //0<=r<k
        swap(&p[r], &p[k]);
    }
    for(unsigned int k = latime * inaltime - 1; k >= 1; k--) //inversa permutarii
        v[p[k]] = k;

    imagine *E = malloc(latime * inaltime * sizeof(imagine));

    E[0].b = key.x[0] ^ C[0].b ^ R[latime * inaltime];
    E[0].g = key.x[1] ^ C[0].g ^ R[latime * inaltime];
    E[0].r = key.x[2] ^ C[0].r ^ R[latime * inaltime];

    for (int k = 1; k < latime * inaltime; k++)
    {
        E[k].b = C[k-1].b ^ C[k].b ^ R[latime * inaltime + k];
        E[k].g = C[k-1].g ^ C[k].g ^ R[latime * inaltime + k];
        E[k].r = C[k-1].r ^ C[k].r ^ R[latime * inaltime + k];
    }

    imagine *D = malloc(latime * inaltime * sizeof(imagine));

    fseek(g, 54, SEEK_SET);
    for(int i = 0; i < inaltime * latime; i++)
    {
        D[v[i]].b = E[i].b;
        D[v[i]].g = E[i].g;
        D[v[i]].r = E[i].r;

        fwrite(&D[i].r, sizeof(unsigned char), 1, g);
        fwrite(&D[i].g, sizeof(unsigned char), 1, g);
        fwrite(&D[i].b, sizeof(unsigned char), 1, g);
        fflush(g);
    }

    fclose(f);
    fclose(g);
    fclose(h);

    free(p);
    free(R);
    free(v);
    free(C);
    free(E);
    return D;
}

void chi (char *nume, imagine *C)
{
    FILE *f = fopen(nume, "rb+");
    if(f == NULL)
    {
        printf("eroare la deschidere");
        return ;
    }

    unsigned int latime, inaltime;
    fseek(f, 18, SEEK_SET);
    fread(&latime, sizeof(unsigned int), 1, f);
    fread(&inaltime, sizeof(unsigned int), 1, f);

    double frecv = latime * inaltime / 256;

    int *fr = malloc(256 * sizeof(int));
    int *fg = malloc(256 * sizeof(int));
    int *fb = malloc(256 * sizeof(int));
    for(int i=0; i<256; i++)
        fr[i] = fg[i] = fb[i] = 0;

    fseek(f, 54, SEEK_SET);
    for(int i=0; i<latime * inaltime; i++)
    {
        fr[C[i].r]++;
        fg[C[i].g]++;
        fb[C[i].b]++;
    }

    float chi_b = 0, chi_g = 0, chi_r = 0;
    for(int i=0; i<=255; i++)
    {
        chi_b += ((fb[i] - frecv) * (fb[i] - frecv) / frecv);
        chi_g += ((fg[i] - frecv) * (fg[i] - frecv) / frecv);
        chi_r += ((fr[i] - frecv) * (fr[i] - frecv) / frecv);
    }
    printf("R: %f\nG: %f\nB: %f\n", chi_r, chi_g, chi_b);
    free(fr);
    free(fg);
    free(fb);
}
int main()
{
    char *nume_sursa = malloc(20 * sizeof(char));
    char *criptat = malloc(20 * sizeof(char));
    char *txt = malloc(20 * sizeof(char));
    char *decriptat = malloc(20 * sizeof(char));

    printf("Numele fisierului care contine imaginea sursa: ");
    fgets(nume_sursa, 20, stdin);
    nume_sursa[strlen(nume_sursa) - 1] = '\0';

    printf("Numele fisierului care contine cheia secreta: ");
    fgets(txt, 20, stdin);
    txt[strlen(txt) - 1] = '\0';

    printf("Numele fisierului in care criptez imaginea: ");
    fgets(criptat, 20, stdin);
    criptat[strlen(criptat) - 1] = '\0';

    printf("Numele fisierului in care decriptez imaginea: ");
    fgets(decriptat, 20, stdin);
    decriptat[strlen(decriptat) - 1] = '\0';

    imagine *P = incarcare_imagine(nume_sursa, P);
    printf("imagine normala:\n");
    chi(nume_sursa, P);

    P = criptare (nume_sursa, criptat, txt, P);
    salveaza_imagine(nume_sursa, criptat, P);
    printf("imagine criptata:\n");
    chi(criptat, P);

    P = decriptare(criptat, decriptat, txt, P);
    salveaza_imagine(criptat, decriptat, P);
    printf("imagine decriptata:\n");
    chi(decriptat, P);
}
