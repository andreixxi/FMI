//reuniune
#include <fstream>
#include <iostream>
#include <cstring>
using namespace std;
ifstream f("date.in");
ofstream g("d.out");
int delta1[15000][26], delta2[15000][26];
int Q1[15000], n1, nr1, q01, F1[15000], nrStariFinale1, nrTranzitii1, nrCuvinte1;
int Q2[15000], n2, nr2, q02, F2[15000], nrStariFinale2, nrTranzitii2, nrCuvinte2;
char lit1[100], lit2[100];
void read (int Q1[15000], int &n1, int &nr1, int &q01, int F1[15000], int &nrStariFinale1, int &nrTranzitii1, int nrCuvinte)
{
    f>>n1; //numar stari
    for(int i=0; i<n1; i++)
        f>>Q1[i];//stari

    f>>nr1; //nr litere
    for(int i=0; i<nr1; i++)
        f>>lit1[i];//literele

    f>>q01; //stare initiala

    f>>nrStariFinale1;

    for(int i=0; i<nrStariFinale1; i++)
        f>>F1[i]; //starile finale

    f>>nrTranzitii1;
    for(int i=0; i<nrTranzitii1; i++)
    {
        int a, c;
        char b;
        f>>a>>b>>c; //tranzitiile
        delta1[a][b-'0'] = c; //matricea
    }
    string s;
    f>>nrCuvinte;
    for(int i=0; i<nrCuvinte; i++)
        f>>s;
}
void display(int Q1[15000], int n1, int nr1, int q01, int F1[15000], int nrStariFinale1, int nrTranzitii1)
{
    g<<n1<<endl;
    for(int i=0; i<n1; i++)
        g<<Q1[i]<<" ";
    g<<endl;
    g<<nr1;
    g<<endl;
    for(int i=0; i<nr1; i++)
        g<<lit1[i]<<" ";
    g<<endl;
    g<<q01;
    g<<endl;
    g<<nrStariFinale1;
    g<<endl;
    for(int i=0; i<nrStariFinale1; i++)
        g<<F1[i]<<" ";
    g<<endl;
    g<<nrTranzitii1;
    g<<endl;
    for (int i=0; i<n1; i++)
        for(int j=0; j<nr1; j++)
            if(delta1[Q1[i]][lit1[j]-'0'])
                g<<Q1[i]<<" "<<lit1[j]<<" "<<delta1[Q1[i]][lit1[j]-'0']<<" \n";
    g<<endl;

}
int main ()
{
    read(Q1, n1, nr1, q01, F1, nrStariFinale1, nrTranzitii1, nrCuvinte1);
    display(Q1, n1, nr1, q01, F1, nrStariFinale1, nrTranzitii1);
    read(Q2, n2, nr2, q02, F2, nrStariFinale2, nrTranzitii2, nrCuvinte2);
    display(Q2, n2, nr2, q02, F2, nrStariFinale2, nrTranzitii2);

}

