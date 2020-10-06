#include <stdio.h>
#include <stdlib.h>
#include <math.h>
typedef struct
{
    unsigned char r, g, b;
} imagine;

void grayscale_image(char *nume_fisier_sursa, char *nume_fisier_destinatie)
{
    FILE *fin, *fout;

    printf("nume_fisier_sursa = %s \n", nume_fisier_sursa);

    fin = fopen(nume_fisier_sursa, "rb");
    if(fin == NULL)
    {
        printf("nu am gasit imaginea sursa din care citesc");
        return;
    }

    fout = fopen(nume_fisier_destinatie, "wb+");
    if(fout == NULL)
    {
        printf("nu am putut scrie imaginea");
        return;
    }

    unsigned int latime_img, inaltime_img;

    fseek(fin, 18, SEEK_SET);
    fread(&latime_img, sizeof(unsigned int), 1, fin);
    fread(&inaltime_img, sizeof(unsigned int), 1, fin);

    //copiaza octet cu octet imaginea initiala in cea noua
    fseek(fin, 0, SEEK_SET);
    unsigned char c;
    while(fread(&c, 1, 1, fin) == 1)
    {
        fwrite(&c, 1, 1, fout);
        fflush(fout);
    }
    fclose(fin);

    //calculam padding-ul pentru o linie
    int padding;
    if(latime_img % 4 != 0)
        padding = 4 - (3 * latime_img) % 4;
    else
        padding = 0;

    fseek(fout, 54, SEEK_SET);
    for(int i = 0; i < inaltime_img; i++)
    {
        for(int j = 0; j < latime_img; j++)
        {
            //citesc culorile pixelului
            unsigned char r, g, b;
            fread(&b, sizeof(unsigned char), 1, fout);
            fread(&g, sizeof(unsigned char), 1, fout);
            fread(&r, sizeof(unsigned char), 1, fout);

            //fac conversia in pixel gri
            unsigned char aux = 0.299 * r + 0.587 * g + 0.114 * b;
            r = g = b = aux;
            fseek(fout, -3, SEEK_CUR);
            fwrite(&r, sizeof(unsigned char), 1, fout);
            fwrite(&g, sizeof(unsigned char), 1, fout);
            fwrite(&b, sizeof(unsigned char), 1, fout);
            fflush(fout);
        }
        fseek(fout, padding, SEEK_CUR);
    }

    fclose(fout);
}
imagine **matrice(int lin, int col)
{
    imagine **m = malloc(sizeof(imagine*) * lin);
    if(!m)
        return NULL;
    for(int i=0; i<lin; i++)
    {
        m[i] = malloc(sizeof(imagine) * col);
        if(m[i] == NULL)
        {
            for(int j=0; j<i; j++)
                free(m[j]);
            free(m);
        }
    }
    return m;
}
imagine **incarcare_imagine (char *nume_sursa, imagine **m)
{
    FILE *in = fopen(nume_sursa, "rb");
    if (in == NULL)
    {
        printf("nu am gasit imaginea sursa din care citesc");
        return 0;
    }

    unsigned int latime_img, inaltime_img;

    fseek(in, 18, SEEK_SET);
    fread(&latime_img, sizeof(unsigned int), 1, in);
    fread(&inaltime_img, sizeof(unsigned int), 1, in);
    //padding pt o linie
    int padding = (latime_img % 4 != 0) ? 4 - (3 * latime_img) % 4 : 0;

    m = matrice(inaltime_img, latime_img);

    fseek(in, 54, SEEK_SET);
    unsigned char r, g, b;
    for(int i=0; i < inaltime_img; i++)
    {
        for(int j=0; j < latime_img; j++)
        {
            fread(&b, 1, 1, in);
            fread(&g, 1, 1, in);
            fread(&r, 1, 1, in);
            m[i][j].r = r;
            m[i][j].g = g;
            m[i][j].b = b;
        }
        fseek(in, padding, SEEK_CUR);
    }

    fclose(in);
    return m;
}
void salveaza_imagine (char *nume_sursa, char *nume_fis, imagine **m)
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

    fseek(in, 18, SEEK_SET);
    unsigned int lin, col;
    fread(&col, sizeof(unsigned int), 1, in);
    fread(&lin, sizeof(unsigned int), 1, in);

    fseek(in, 54, SEEK_SET);
    for (int i=0; i < lin; i++)
    {
        for(int j=0; j < col; j++)
        {
            fwrite(&m[i][j].b, sizeof(unsigned char), 1, out);
            fwrite(&m[i][j].g, sizeof(unsigned char), 1, out);
            fwrite(&m[i][j].r, sizeof(unsigned char), 1, out);
            fflush(out);
        }
    }

    fclose(in);
    fclose(out);
}

typedef struct coord
{
    int x, y, cifra;
    float c;
} coord;

coord *template_matching (char *nume_img, char *nume_sablon, float prag, coord *vector, int *nr, int cifra)
{
    FILE *f = fopen(nume_img, "rb+");
    if(f == NULL)
    {
        printf("eroare1");
        return 0;
    }

    FILE *g = fopen(nume_sablon, "rb+");
    if(g == NULL)
    {
        printf("eroare2");
        return 0;
    }

    unsigned int latime_img, inaltime_img;
    fseek(f, 18, SEEK_SET);
    fread(&latime_img, sizeof(unsigned int), 1, f);
    fread(&inaltime_img, sizeof(unsigned int), 1, f);
    imagine **I = incarcare_imagine(nume_img, I);
    if(I == NULL)
    {
        printf("eroare alocare img");
        return 0;
    }

    unsigned int latime_sab, inaltime_sab;
    fseek(g, 18, SEEK_SET);
    fread(&latime_sab, sizeof(unsigned int), 1, g);
    fread(&inaltime_sab, sizeof(unsigned int), 1, g);
    imagine **S = incarcare_imagine(nume_sablon, S);
    if(S == NULL)
    {
        printf("eroare alocare sablon");
        return 0;
    }

    int n = inaltime_sab * latime_sab;
    //sablon
    float sm = 0;
    for(int i=0; i<inaltime_sab; i++)
        for(int j=0; j<latime_sab; j++)
            sm += S[i][j].r;
    sm /= n;

    float dev_std_sab = 0;
    for(int i=0; i<inaltime_sab; i++)
        for(int j=0; j<latime_sab; j++)
            dev_std_sab += ((S[i][j].r - sm) * (S[i][j].r - sm));
    dev_std_sab /= (n-1);
    dev_std_sab = sqrt(dev_std_sab);

    for(int j=0; j<latime_img - latime_sab; j++)
        for(int i=0; i<inaltime_img - inaltime_sab; i++)
        {
            float corelatie = 0, sm2 = 0, dev_std_img = 0;

            for(int l=0; l<latime_sab; l++)
                for(int k=0; k<inaltime_sab; k++)
                    sm2 += I[i+k][j+l].r;
            sm2 /= n;

            for(int l=0; l<latime_sab; l++)
                for(int k=0; k<inaltime_sab; k++)
                    dev_std_img += (I[i+k][j+l].r - sm2) * (I[i+k][j+l].r - sm2);
            dev_std_img /= (n-1);
            dev_std_img = sqrt(dev_std_img);

            for(int l=0; l<latime_sab; l++)
                for(int k=0; k<inaltime_sab; k++)
                    corelatie += ((I[i+k][j+l].r - sm2) * (S[k][l].r - sm)) / (dev_std_img * dev_std_sab);
            corelatie /= n;
            if(corelatie > prag)
            {
                vector[*nr].x = j;
                vector[*nr].y = i;
                vector[*nr].c = corelatie;
                vector[*nr].cifra = cifra;
                (*nr)++;
            }
        }
    return vector;
}

void colour (int nr, imagine **I, coord *detectii)
{
    for (int t=0; t<nr; t++)
    {
        if(detectii[t].cifra == 0)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 255;
                I[i][detectii[t].x].g = 0;
                I[i][detectii[t].x].b = 0;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 255;
                I[i][detectii[t].x + 11].g = 0;
                I[i][detectii[t].x + 11].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 255;
                I[detectii[t].y][i].g = 0;
                I[detectii[t].y][i].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 255;
                I[detectii[t].y + 15][i].g = 0;
                I[detectii[t].y + 15][i].b = 0;
            }
        }
        if(detectii[t].cifra == 1)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 255;
                I[i][detectii[t].x].g = 255;
                I[i][detectii[t].x].b = 0;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 255;
                I[i][detectii[t].x + 11].g = 255;
                I[i][detectii[t].x + 11].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 255;
                I[detectii[t].y][i].g = 255;
                I[detectii[t].y][i].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 255;
                I[detectii[t].y + 15][i].g = 255;
                I[detectii[t].y + 15][i].b = 0;
            }
        }
        if(detectii[t].cifra == 2)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 0;
                I[i][detectii[t].x].g = 255;
                I[i][detectii[t].x].b = 0;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 0;
                I[i][detectii[t].x + 11].g = 255;
                I[i][detectii[t].x + 11].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 0;
                I[detectii[t].y][i].g = 255;
                I[detectii[t].y][i].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 0;
                I[detectii[t].y + 15][i].g = 255;
                I[detectii[t].y + 15][i].b = 0;
            }
        }
        if(detectii[t].cifra == 3)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 0;
                I[i][detectii[t].x].g = 255;
                I[i][detectii[t].x].b = 255;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 0;
                I[i][detectii[t].x + 11].g = 255;
                I[i][detectii[t].x + 11].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 0;
                I[detectii[t].y][i].g = 255;
                I[detectii[t].y][i].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 0;
                I[detectii[t].y + 15][i].g = 255;
                I[detectii[t].y + 15][i].b = 255;
            }
        }
        if(detectii[t].cifra == 4)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 255;
                I[i][detectii[t].x].g = 0;
                I[i][detectii[t].x].b = 255;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 255;
                I[i][detectii[t].x + 11].g = 0;
                I[i][detectii[t].x + 11].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 255;
                I[detectii[t].y][i].g = 0;
                I[detectii[t].y][i].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 255;
                I[detectii[t].y + 15][i].g = 0;
                I[detectii[t].y + 15][i].b = 255;
            }
        }
        if(detectii[t].cifra == 5)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 0;
                I[i][detectii[t].x].g = 0;
                I[i][detectii[t].x].b = 255;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 0;
                I[i][detectii[t].x + 11].g = 0;
                I[i][detectii[t].x + 11].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 0;
                I[detectii[t].y][i].g = 0;
                I[detectii[t].y][i].b = 255;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 0;
                I[detectii[t].y + 15][i].g = 0;
                I[detectii[t].y + 15][i].b = 255;
            }
        }
        if(detectii[t].cifra == 6)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 192;
                I[i][detectii[t].x].g = 192;
                I[i][detectii[t].x].b = 192;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 192;
                I[i][detectii[t].x + 11].g = 192;
                I[i][detectii[t].x + 11].b = 192;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 192;
                I[detectii[t].y][i].g = 192;
                I[detectii[t].y][i].b = 192;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 192;
                I[detectii[t].y + 15][i].g = 192;
                I[detectii[t].y + 15][i].b = 192;
            }
        }
        if(detectii[t].cifra == 7)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 255;
                I[i][detectii[t].x].g = 140;
                I[i][detectii[t].x].b = 0;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 255;
                I[i][detectii[t].x + 11].g = 140;
                I[i][detectii[t].x + 11].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 255;
                I[detectii[t].y][i].g = 140;
                I[detectii[t].y][i].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 255;
                I[detectii[t].y + 15][i].g = 140;
                I[detectii[t].y + 15][i].b = 0;
            }
        }
        if(detectii[t].cifra == 8)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 128;
                I[i][detectii[t].x].g = 0;
                I[i][detectii[t].x].b = 128;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 128;
                I[i][detectii[t].x + 11].g = 0;
                I[i][detectii[t].x + 11].b = 128;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 128;
                I[detectii[t].y][i].g = 0;
                I[detectii[t].y][i].b = 128;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 128;
                I[detectii[t].y + 15][i].g = 0;
                I[detectii[t].y + 15][i].b = 128;
            }
        }
        if(detectii[t].cifra == 9)
        {
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x].r = 128;
                I[i][detectii[t].x].g = 0;
                I[i][detectii[t].x].b = 0;
            }
            for (int i=detectii[t].y; i<detectii[t].y + 11; i++)
            {
                I[i][detectii[t].x + 11].r = 128;
                I[i][detectii[t].x + 11].g = 0;
                I[i][detectii[t].x + 11].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y][i].r = 128;
                I[detectii[t].y][i].g = 0;
                I[detectii[t].y][i].b = 0;
            }
            for (int i=detectii[t].x; i<detectii[t].x + 15; i++)
            {
                I[detectii[t].y + 15][i].r = 128;
                I[detectii[t].y + 15][i].g = 0;
                I[detectii[t].y + 15][i].b = 0;
            }
        }
    }
}
int cmp (const void *a, const void *b)
{
    struct coord *ia = (struct coord *)a;
    struct coord *ib = (struct coord *)b;
    if(ia->c == ib->c)
        return 0;
    if(ia->c > ib->c)
        return -1;
    return 1;
}

coord *eliminare (coord *D, int nr, coord *sad, int t)
{
    qsort(D, nr, sizeof(coord), cmp);
    sad = (coord*)malloc(nr * sizeof(coord));
    t = 0;
    int arie = 11 * 15;
    for (int i=0; i<nr-1; i++)
        for(int j=i+1; j<nr; j++)
        {
            float suprapunere = 0;
            coord c, b;
            int aria_int = 0, L1 = 0, L2 = 0;
            if(D[i].x > D[j].x  &&  D[i].y < D[j].y)
            {
                c.y = D[i].y + 15;
                c.x = D[i].x - 11;
                b.y = c.y;
                b.x = D[j].x;
                L1 = b.y - D[j].y;
                L2 = b.x - c.x;
            }
            if(D[i].x < D[j].x  &&  D[i].y < D[j].y)
            {
                c.y = D[j].y;
                c.x = D[j].y - D[i].y;
                b.y = c.y;
                b.x = D[i].x;
                L1 = b.x - c.x;
                L2 = b.y - D[i].y;
            }
            if (D[i].x < D[j].x  &&  D[i].y > D[j].y)
            {
                c.y = D[j].y + 15;
                c.x = D[j].x - 11;
                b.y = c.y;
                b.x = D[i].x;
                L1 = b.y - D[i].y;
                L2 = b.x - c.x;
            }
            if (D[i].x > D[j].x  &&  D[i].y > D[j].y)
            {
                c.y = D[i].y + 11;
                c.x = D[j].x;
                b.y = c.y;
                b.x = D[i].x - 15;
                L1 = c.y - D[i].y;
                L2 = c.x - b.x;
            }
            if(D[i].y == D[j].y  &&  D[i].x > D[j].x)
            {
                L1 = 11;
                b.y = D[i].y;
                b.x = D[i].x - 15;
                L2 = D[j].x - b.x;
            }
            if(D[i].y == D[j].y  &&  D[i].x < D[j].x)
            {
                L1 = 11;
                b.y = D[i].y;
                b.x = D[j].x - 15;
                L2 = D[i].x - b.x;
            }
            if(D[i].y > D[j].y  &&  D[i].x == D[j].x)
            {
                L1 = 15;
                b.y = D[j].y + 11;
                b.x = D[i].x;
                L2 = b.y - D[i].y;
            }
            if(D[i].y < D[j].y  &&  D[i].x == D[j].x)
            {
                L1 = 15;
                b.y = D[i].y + 11;
                b.x = D[i].x;
                L2 = b.y - D[j].y;
            }
            if(D[i].y == D[j].y  &&  D[i].x == D[j].x)
            {
                L1 = 15;
                L2 = 11;
            }
            aria_int = L1 * L2;
            suprapunere = (float)(aria_int / (2 * arie - aria_int));
            if(suprapunere <= 0.2)
                sad[t++] = D[j];
        }
    free(D);
    sad = realloc(sad, t * sizeof(coord));
    return sad;
}
int main ()
{
    char nume_img_sursa[] = "test.bmp";
    char nume_img_grayscale[] = "test_grayscale.bmp";
    char nume_sab[10][12] = {"cifra0.bmp", "cifra1.bmp", "cifra2.bmp", "cifra3.bmp", "cifra4.bmp", "cifra5.bmp", "cifra6.bmp", "cifra7.bmp", "cifra8.bmp", "cifra9.bmp" };
    char nume_sab_grayscale[10][22] = {"cifra0_grayscale.bmp", "cifra1_grayscale.bmp", "cifra2_grayscale.bmp", "cifra3_grayscale.bmp", "cifra4_grayscale.bmp",
                                       "cifra5_grayscale.bmp", "cifra6_grayscale.bmp", "cifra7_grayscale.bmp", "cifra8_grayscale.bmp", "cifra9_grayscale.bmp"
                                      };
    char nume_tmp1[] = "template_matching.bmp";
    char nume_tmp2[] = "template_matching_clean.bmp";
    float prag = 0.5;

    grayscale_image(nume_img_sursa, nume_img_grayscale);//fac imaginea gri

    for(int i=0; i<10; i++)
        grayscale_image(nume_sab[i], nume_sab_grayscale[i]); //fac fiecare sablon gri

    imagine **I = incarcare_imagine(nume_img_grayscale, I);
    coord *v = (coord*)malloc(3000 * sizeof(coord));
    if(v == NULL)
    {
        printf("nu pot aloca");
        return 0;
    }
    int nr = 0;
    for(int i=0; i<10; i++)
        v = template_matching(nume_img_grayscale, nume_sab_grayscale[i], prag, v, &nr, i);
    v = realloc(v, nr * sizeof(coord));
    colour(nr, I, v);
    salveaza_imagine(nume_img_grayscale, nume_tmp1, I);

    //not working :( sad ending
    imagine **TM = incarcare_imagine(nume_tmp1, TM);
    int nr2 = 0;
    coord *nappeun = eliminare(v, nr, nappeun, nr2);
    colour(nr2, TM, nappeun);
    salveaza_imagine(nume_tmp1, nume_tmp2, TM);

    free(v);
    free(nappeun);
}
