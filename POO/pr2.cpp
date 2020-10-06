#include <iostream>
#include <cmath>
using namespace std;

class Monom
{
    int grad;
    int coef;
public:
    Monom (); //constructor initializare
    Monom (int, int); //constructor parametrizt
    ~Monom(); //destructor
    Monom (const Monom&); //constructor copiere
    Monom &operator= (const Monom&); //overload =
    friend istream& operator>> (istream&, Monom&); //overload >>
    friend ostream& operator<< (ostream&, Monom&); //overload <<
    int cmmdc (int, int);
    int getCoef ();
    int getGrad ();
    int setMonom (int, int);
};
class Polinom
{
    int nr_monoame;
    Monom *m;
public:
    Polinom(); //constructor
    Polinom (int); //constructor parametrizat
    virtual ~Polinom() = 0; //destructor
    Polinom (const Polinom&); //constructor copiere
    Polinom &operator= (const Polinom&);
    friend istream& operator>> (istream&, Polinom&);
    friend ostream& operator<< (ostream&, Polinom&);
    Monom &operator[] (int);
    int getNr ();
    Monom* getMonom();
};
class Polinom_ireductibil : virtual public Polinom
{
public:
    Polinom_ireductibil();
    ~Polinom_ireductibil();
    Polinom_ireductibil(int);
    Polinom_ireductibil (const Polinom_ireductibil&);
    Polinom_ireductibil &operator= (const Polinom_ireductibil&);
    friend istream& operator>> (istream&, Polinom_ireductibil&);
    friend ostream& operator<< (ostream&, Polinom_ireductibil&);
    int Eisenstein (Polinom_ireductibil);
    int prim (int x);
};
class Polinom_reductibil : virtual public Polinom
{
public:
    Polinom_reductibil();
    ~Polinom_reductibil();
    Polinom_reductibil (int);
    Polinom_reductibil (const Polinom_reductibil&);
    Polinom_reductibil &operator= (const Polinom_reductibil&);
    friend istream& operator>> (istream&, Polinom_reductibil&);
    friend ostream& operator<< (ostream&, Polinom_reductibil&);
};
Monom :: Monom () : grad(0), coef(0)
{
    cout<<"constructor monom\n";
}
Monom :: Monom (int i, int j) : grad(i), coef(j)
{
    cout<<"constructor monom cu param\n";
}
Monom :: ~Monom ()
{
    cout<<"destructor monom\n";
}
int Monom :: getCoef ()
{
    return this->coef;
}
int Monom :: getGrad ()
{
    return this->grad;
}
int Monom :: setMonom (int a, int b)
{
    this->coef = a;
    this->grad = b;
}
Monom :: Monom (const Monom &ob) : grad(ob.grad), coef(ob.coef)
{
    cout<<"constructor copiere monom\n";
}
Monom& Monom :: operator= (const Monom &ob)
{
    if(this != &ob)
    {
        this->grad = ob.grad;
        this->coef = ob.coef;
    }
    return *this;
}
istream& operator>> (istream &in, Monom &ob)
{
    cout<<"coef + grad\n";
    in>>ob.coef>>ob.grad;
    return in;
}
ostream& operator<< (ostream &out, Monom &ob)
{
    out<<ob.coef<<"x^"<<ob.grad<<" ";
    return out;
}
int Monom :: cmmdc (int a, int b)
{
    int c;
    while (b)
    {
        c = a % b;
        a = b;
        b = c;
    }
    return a;
}
Polinom :: Polinom () : nr_monoame(0), m(NULL)
{
    cout<<"constructor polinom\n";
}
Polinom :: Polinom(int nr) : nr_monoame(nr)
{
    cout<<"constructor polinom parametrizat\n";
    this->m = new Monom[this->nr_monoame];
}
Polinom :: ~Polinom ()
{
    cout<<"destructor polinom\n";
    delete[] this->m;
}
Polinom :: Polinom (const Polinom &ob)
{
    this->nr_monoame = ob.nr_monoame;
    delete[] this->m;
    this->m = new Monom [this->nr_monoame];
    for(int i=0; i<ob.nr_monoame; i++)
        this->m[i] = ob.m[i];
}
Polinom& Polinom :: operator= (const Polinom &ob)
{
    if (this != &ob);
    {
        delete[] this->m;
        this->nr_monoame = ob.nr_monoame;
        this->m = new Monom[ob.nr_monoame];
        for(int i=0; i<ob.nr_monoame; i++)
            this->m[i] = ob.m[i];
    }
    return *this;
}
istream& operator>> (istream &in, Polinom &ob)
{
    cout<<"introdu numar monoame\n";
    in>>ob.nr_monoame;
    delete[] ob.m;
    ob.m = new Monom[ob.nr_monoame];
    cout<<"monoamele ordonate crescator dupa grad\n";
    for(int i=0; i<ob.nr_monoame; i++)
        in>>ob.m[i];
    return in;
}
ostream& operator<< (ostream &out, Polinom &ob)
{
    for(int i=0; i<ob.nr_monoame; i++)
        out<<ob.m[i]<<" ";
    out<<endl;
    return out;
}
Monom &Polinom :: operator[] (int idx)
{
    if (idx >= this->nr_monoame || idx < 0)
        cout<<"nu exista pozitia\n";
    else
        return m[idx];
}
int Polinom :: getNr()
{
    return this->nr_monoame;
}
Monom* Polinom :: getMonom()
{
    return this->m;
}
Polinom_ireductibil :: Polinom_ireductibil () : Polinom()
{
    cout<<"constructor pol ireductibil\n";
}
Polinom_ireductibil :: ~Polinom_ireductibil ()
{
    cout<<"destructor pol ireductibil\n";
}
Polinom_ireductibil :: Polinom_ireductibil (int i) : Polinom(i)
{
    cout<<"lista initializare pol ireductibil\n";
}
Polinom_ireductibil :: Polinom_ireductibil (const Polinom_ireductibil &ob) : Polinom(ob)
{
    cout<<"copiere polinom\n";
}
Polinom_ireductibil& Polinom_ireductibil :: operator= (const Polinom_ireductibil &ob)
{
    Polinom :: operator=(ob);
}
istream& operator>> (istream &in, Polinom_ireductibil &ob)
{
    in>>(Polinom&)ob;
    return in;
}
int Polinom_ireductibil :: prim (int x)
{
    for (int d=2; d<=x/2; d++)
        if(x%d == 0)
            return 0;
    return 1;
}
ostream& operator<< (ostream &out, Polinom_ireductibil &ob)
{
    out<<(Polinom&)ob;
    return out;
}
//return 1 daca f este ireductibil, 0 altfel
int Polinom_ireductibil :: Eisenstein (Polinom_ireductibil pol)
{
    int aux = pol[0].cmmdc(abs(pol[0].getCoef()), abs(pol[1].getCoef()));
    int nr = pol.getNr();
    for(int i=2; i < nr && aux != 1; i++)
        aux = pol[i].cmmdc(abs(pol[i].getCoef()), abs(aux));

    if(aux == 1) //coeficientii sunt primi intre ei
    {
        int p_gasit = 0;

        int min_monoame = abs(pol[0].getCoef());
        int nr_monoame = pol.getNr();

        for(int i = 1; i < nr_monoame; i++)
            if(min_monoame > abs(pol[i].getCoef()))
                min_monoame = abs(pol[i].getCoef());

        for (int p=2; p<= min_monoame; p++)
        {
            int prim = 1;
            for(int d=2; d<=p/2; d++)
                if(p % d == 0)
                {
                    prim = 0;
                    break;
                }
            if (prim)
            {
                int ok = 1;
                for(int i=0; i<nr_monoame - 1; i++)
                    if(pol[i].getCoef() % p)
                    {
                        ok = 0;
                        break;
                    }
                int v1 = abs(pol[nr_monoame - 1].getCoef());
                int v2 = abs(pol[0].getCoef());
                if(ok == 1 && v1 % p && v2 % (p * p))
                    p_gasit = 1;
            }
        }
        return p_gasit;
    }
    else
        return 0;
}
Polinom_reductibil :: Polinom_reductibil () : Polinom ()
{
    cout<<"constructor polinom reductibil\n";
}
Polinom_reductibil :: ~Polinom_reductibil ()
{
    cout<<"destructor polinom reductibil\n";
}
Polinom_reductibil :: Polinom_reductibil(int i) : Polinom (i)
{
    cout<<"constructor parametrizat polinom reductibil\n";
}
Polinom_reductibil :: Polinom_reductibil (const Polinom_reductibil &ob) : Polinom(ob)
{
    cout<<"constructor copiere polinom reductibil\n";
}
Polinom_reductibil& Polinom_reductibil:: operator= (const Polinom_reductibil &ob)
{
    Polinom :: operator=(ob);
}
istream& operator>> (istream &in, Polinom_reductibil &ob)
{
    in>>(Polinom&)ob;
    return in;
}
ostream& operator<< (ostream &out, Polinom_reductibil &ob)
{
    out<<(Polinom&)ob<<endl;
    return out;
}

int main ()
{
    /* Monom m;
     cin>>m;
     cout<<m<<endl;
     Monom m2(4,3);
     cout<<m2<<endl;
     Monom m3 = m2;
     cout<<m3<<endl;
     Monom m4;
     m4 = m;
     cout<<m4<<endl; */

    Polinom_ireductibil pi;
    cin>>pi;
    cout<<pi;
    if(pi.getNr() == 1)
        cout<<"polinom ireductibil";
    else if (pi.getNr() == 3)
    {
        //ec de grad 2
        if(pi[0].getGrad() == 0 && pi[1].getGrad() == 1 && pi[2].getGrad() == 2)
        {
            float delta = ( pi[1].getCoef() * pi[1].getCoef() ) - ( 4 * pi[0].getCoef() * pi[2].getCoef() );
            if(delta >= 0) //ec are sol reale
            {
                int x1 = ( -pi[1].getCoef() + sqrt(delta) ) / (2 * pi[2].getCoef());
                int x2 = ( -pi[1].getCoef() - sqrt(delta) ) / (2 * pi[2].getCoef());

                cout<<pi[2].getCoef()<<" * (x * "<<x1<<") * (x * "<<x2<<")"<<endl;
            }
            else
                cout<<"polinom ireductibil \n";
        }
    }
        else
        cout<<"criteriul: "<<pi.Eisenstein(pi)<<endl;


        Polinom_ireductibil p2 (3);
        for(int i=0; i<3; i++)
            p2[i].setMonom(i+1, i+2);
        cout<<p2;

        /* Polinom *p;
        cin>>*p;

        int n;
        Polinom* v[n];
        cin>>n;
        for(int i=0; i<n; i++)
        {
        cout<<"1 pt polinom red, 2 pt ired";
        int x;
        cin>>x;
        Monom m(1,4);
        if(x == 1)
            v[i] = new Polinom_reductibil(4,&num);
        else v[i] = new Polinom_ireductibil();
        }
        for(int i=0; i<n; i++)
        {
            cin>>(*v[i]);
            cout<<"polinom"<<v[i]<<" ";
        }
        // cout<<p.Eisenstein(p)<<endl;
        Polinom_ireductibil &p2(7,&m);
        for(int i=0; i<7; i++)
                p2[i].setMonom(i+3, i+1); // coef + grad
        cout<<p2;
         Polinom_ireductibil p2 (7, m);
         cout<<p2;
        */
    }
