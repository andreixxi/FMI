#include <fstream>
#include <iostream>
#include <cstring>
using namespace std;
ifstream f("date.in");
ofstream g("date.out");
int delta[15000][26];
int Q[15000], n, nr, q0, F[15000], nrStariFinale, nrTranzitii, nrCuvinte, Q2[15000], F2[15000];
char lit[100];
int main ()
{
    f>>n; //numar stari

    for(int i=0; i<n; i++)
        f>>Q[i];//stari

    f>>nr; //nr litere
    for(int i=0; i<nr; i++)
        f>>lit[i];//literele

    for(int i=0; i<n; i++)
        for(int j=0; j<nr; j++)
            delta[i][j] = -1;

    f>>q0; //stare initiala

    f>>nrStariFinale;

    for(int i=0; i<nrStariFinale; i++)
        f>>F[i]; //starile finale

    f>>nrTranzitii;

    Q[n++] = -1; //starea in plus

    for(int i=0; i<nrTranzitii; i++)
    {
        int a, c;
        char b;
        f>>a>>b>>c; //tranzitiile
        delta[a][b-'0'] = c; //matricea
    }

    for(int i=0; i<n; i++)
        for(int j=0; j<nr; j++)
            if(delta[i][j] == -1)
                delta[i][j] = Q[n];

    for(int i=0; i<nr; i++)
        delta[n][lit[i] - '0'] = Q[n];

    //nefinale in finale
    for(int i=0; i < n; i++)
        for(int j=0; j<nr; j++)
        if (Q[i] != F[j]) //nu este finala la automatul dat
            F2[i] = Q[i];

    f>>nrCuvinte;
    for(int i=0; i<nrCuvinte; i++)
    {
        string w;
        f>>w;
        int q = q0, ok =0;
        for(int i=0; i<w.length(); i++)
            q = delta[q][w[i]-'0'];

        for(int i=0; i < n - nrStariFinale; i++)
            if(q == F2[i])
                ok =1;
        if(ok)
            g<<"DA";
        else
            g<<"NU";
        g<<endl;
    }
}

