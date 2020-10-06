#include <iostream>
#include <fstream>
#include <cstring>
#include <vector>
#include <typeinfo>

using namespace std;
ifstream f("date.in");
ofstream g("date.out");

class Plata
{
    char* data;
    double suma;
public:
    Plata ();
    Plata (char*, double);
    virtual ~Plata() = 0;
    Plata (const Plata&); //constructor copiere
    Plata &operator= (const Plata&); //overload =
    friend istream& operator>> (istream&, Plata&);
    virtual void afisare (ostream&) const;
    friend ostream& operator<< (ostream&, Plata&);
};
class Card : public Plata
{
    long long nrCard;
public:
    Card ();
    Card (char*, double, long long);
    ~Card ();
    Card (const Card&); //copiere
    Card &operator= (const Card&);
    friend istream& operator>> (istream&, Card&);
    void afisare (ostream&) const;
    friend ostream& operator<< (ostream&, Card&);
};
class Numerar : public Plata
{
public:
    Numerar ();
    ~Numerar();
    Numerar (const Numerar&); //copiere
    Numerar &operator= (const Numerar&);
    friend istream& operator>> (istream&, Numerar&);
    void afisare(ostream&) const;
};
class Cec : public Plata
{
public:
    Cec ();
    ~Cec ();
    Cec (const Cec&); //copiere
    Cec &operator= (const Cec&);
    friend istream& operator>> (istream&, Cec&);
    void afisare(ostream&) const;
    friend ostream& operator<< (ostream&, Cec&);
};

template <class T>
class Gestiune
{
    vector <T*> v;
    static int nrPlati;
public:
    Gestiune ();
    ~Gestiune ();
    static int getNrPlati();
    void operator += (T&);
    void afis();
    Gestiune& operator[] (int);
};

template <>
class Gestiune <Numerar>
{
    vector <Numerar> v;
    static int nrClienti;
public:
    Gestiune ();
    ~Gestiune ();
};

Plata :: Plata () : data(NULL), suma(0)
{
    cout<<"constructor plata\n";
}
Plata :: Plata (char* date, double sum)
{
    cout<<"constructor parametrizat plata\n";
    this->suma = sum;
    this->data = new char[strlen(date) + 1];
    strcpy(this->data, date);
}
Plata :: ~Plata ()
{
    cout<<"destructor plata\n";
    delete[] this->data;
}
Plata :: Plata (const Plata &ob)
{
    cout<<"constructor copiere plata\n";
    this->suma = ob.suma;
    delete[] this->data;
    this->data = new char[strlen(ob.data) + 1];
    strcpy(this->data, ob.data);
}
Plata& Plata :: operator= (const Plata& ob)
{
    cout<<"operator= plata\n";
    if(this != &ob)
    {
        this->suma = ob.suma;
        delete[] this->data;
        this->data = new char[strlen(ob.data) + 1];
        strcpy(this->data, ob.data);
    }
    return *this;
}
istream& operator>> (istream& in, Plata& ob)
{
    cout<<"introdu data si suma\n";
    char *p = new char[100];
    in>>p;
    delete[] ob.data;
    ob.data = new char [strlen(p) + 1];
    strcpy(ob.data, p);
    delete[] p;
    in>>ob.suma;
    try
    {
        if(isdigit(ob.data[0]) == 0) //primul caracter din data nu e cifra
            throw -1;
        if(ob.suma < 0)
            throw 21.21;
    }
    catch (int a)
    {
        cout<<"data gresita\n";
    }
    catch (float a)
    {
        cout<<"suma de faliment\n";
    }
    return in;
}
void Plata :: afisare (ostream& out) const
{
    out<<data<<" "<<suma<<endl;
}
ostream& operator<< (ostream& out, Plata& ob)
{
    ob.afisare(out);
    return out;
}
Card :: Card () : Plata(), nrCard(0)
{
    cout<<"constructor card\n";
}
Card :: Card (char*data, double sum, long long nr) : Plata (data, sum), nrCard(nr)
{
    cout<<"constructor parametrizat card\n";
}
Card :: ~Card ()
{
    cout<<"destructor card\n";
}
Card :: Card (const Card& ob) : Plata(ob)
{
    cout<<"constructor copiere card\n";
    this->nrCard = ob.nrCard;
}
Card& Card :: operator= (const Card& ob)
{
    cout<<"operator= card\n";
    if(this != &ob)
    {
        Plata :: operator=(ob);
        this->nrCard = ob.nrCard;
    }
    return *this;
}
istream& operator>> (istream& in, Card& c)
{
    in>>(Plata&)c;
    cout<<"introdu nr card\n";
    in>>c.nrCard;
    return in;
}
void Card :: afisare (ostream& out) const
{
    Plata :: afisare(out);
    out<<nrCard<<endl;
}
ostream& operator<< (ostream&out, Card& c)
{
    c.afisare(out);
    return out;
}
Numerar :: Numerar () : Plata()
{
    cout<<"constructor numerar\n";
}
Numerar :: ~Numerar()
{
    cout<<"destructor numerar\n";
}
Numerar :: Numerar (const Numerar& ob) : Plata(ob)
{
    cout<<"constructor copiere numerar\n";
}
Numerar& Numerar :: operator= (const Numerar& ob)
{
    cout<<"operator= numerar\n";
    if(this != &ob)
        Plata :: operator=(ob);
    return *this;
}
istream& operator>> (istream& in,  Numerar& ob)
{
    in>>(Plata&)ob;
    return in;
}
void Numerar :: afisare (ostream& out) const
{
    Plata :: afisare(out);
}
ostream& operator<< (ostream& out, Numerar& ob)
{
    ob.afisare(out);
    return out;
}
Cec :: Cec () : Plata ()
{
    cout<<"constructor cec\n";
}
Cec :: ~Cec ()
{
    cout<<"destrcutor cec\n";
}
Cec :: Cec (const Cec& ob) : Plata(ob)
{
    cout<<"constructor copiere cec\n";
}
Cec& Cec :: operator= (const Cec& ob)
{
    cout<<"operator= cec\n";
    if(this != &ob)
        Plata :: operator=(ob);
    return *this;
}
istream& operator>> (istream& in, Cec& ob)
{
    in>>(Plata&)ob;
    return in;
}
void Cec :: afisare (ostream& out) const
{
    Plata :: afisare(out);
}
ostream& operator<< (ostream& out, Cec& ob)
{
    ob.afisare(out);
    return out;
}
template <class T>
Gestiune <T> :: Gestiune ()
{
    nrPlati++;
}
template <class T>
Gestiune <T> :: ~Gestiune ()
{

}
template <class T>
int Gestiune <T> :: getNrPlati()
{
    return nrPlati;
}
template <class T>
void Gestiune <T> :: operator += (T& ob)
{
    nrPlati++;
    v.push_back(&ob);
}
template <class T>
void Gestiune <T> :: afis()
{
    for(int i=0; i<nrPlati; i++)
        cout<<*v[i]<<endl;
}
template <class T>
Gestiune <T>& Gestiune <T> :: operator[] (int i)
{
    return v[i];
}
Gestiune  <Numerar> :: Gestiune ()
{
    nrClienti++;
}
Gestiune <Numerar> :: ~Gestiune ()
{

}
template <class T>
int Gestiune <T> :: nrPlati = 0;
int Gestiune <Numerar> :: nrClienti = 0;
int main ()
{
    Gestiune <Plata> p;
    Gestiune <Numerar> pn;

    int nr;
    cout<<"introdu numar plati\n";
    cin>>nr;
    for(int i=0; i<nr; i++)
    {
        cout<<"introdu optiune:\n1 pt card\n2 pt numerar\n3 pt cec\n";
        int op;
        cin>>op;
        try
        {
            if(op<0 || op>3)
                throw -1;
        }
        catch (int a)
        {
            cout<<"nu exista optiunea\n";
        }
        switch (op)
        {
        case 1 :
        {
            cout<<"citire card\n";
            Card *c = new Card();
            cin>>*c;
            p += *c;
        }
        break;
        case 2 :
        {
            cout<<"citire numerar\n";
            Numerar *n = new Numerar();
            cin>>*n;
            p += *n;
        }
        break;
        case 3 :
        {
            cout<<"citire cec\n";
            Cec *c = new Cec();
            cin>>*c;
            p += *c;
        }
        break;
        }
    }
    p.afis();

    Plata *p1 = new Card;
    Plata *p2 = new Numerar;
    Plata *p3 = new Cec;

    Card *card;
    Numerar *num;
    Cec *cec;

    card = dynamic_cast<Card*>(p1);
    if (card == 0) cout<<"null ptr card\n";
    num = dynamic_cast<Numerar*>(p2);
    if (num == 0) cout<<"null ptr numerar\n";
    cec = dynamic_cast<Cec*>(p3);
    if (cec == 0) cout<<"null ptr cec\n";

    Plata *a;
    Card *b = static_cast<Card*>(a);
    Numerar *c = static_cast<Numerar*>(a);
    Cec *d = static_cast<Cec*>(a);

    // static_cast<Type*>(ptr); //la clase derivate; nu e obligatoriu sa avem functii virtuale
    //Cec *c2 = static_cast <Plata*> (*p1); //la compilare
    //dynamic_cast <Type*> (ptr); //obligatoriu o metoda virtuala
    //D *pd3 = dynamic_cast <D*> (pb2); //la executie, greu de controlat*/
}
