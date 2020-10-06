#include <iostream>
#include <fstream>
using namespace std;
ifstream f ("date.in");
class Lista;
class Numar;
class Fractie;
class Nod
{
    int info, size;
    Nod *next;
public:
    Nod ();
    ~Nod();
    Nod (Nod*);
    void operator= (const Nod*);
    int getInfo ();
    int getSize();
    Nod *getNext ();
    friend class Lista;
    friend class Numar;
    friend class Fractie;
};

class Lista
{
    Nod *prim, *ultim;
public:
    Lista();
    ~Lista();
    Lista(Lista*);
    void addSf (int);
    void addInc (int);
    Nod* getPrim ();
    void operator= (const Lista*);
    friend class Numar;
    friend class Fractie;
};
class Numar
{
    Lista *L;
public:
    Numar();
    Numar(Lista*);
    ~Numar();
    friend istream &operator>> (istream&, Numar*);
    friend ostream &operator<< (ostream&, Numar*);
    Numar *operator+ (const Numar*);
    void operator= (const Numar*);
    void deleteList ();
    Numar *operator- (Numar*);
    Numar *operator* (Numar*);
    Numar *operator/ (Numar*);
    Numar *addInt (int);
    Numar *multiply (int);
    int getLength ();
    int cmp(Numar*, Numar*);
    Numar *copyNumar(Numar*);
    Numar* operator% (Numar*);
    Numar* Euclid (Numar*, Numar*);
    friend class Fractie;
};
class Fractie
{
    char semn;
    Numar *numarator, *numitor;
public:
    Fractie();
    ~Fractie();
    Fractie(Numar*, Numar*);
    friend istream &operator>> (istream&, Fractie*);
    friend ostream &operator<< (ostream&, Fractie*);
    Fractie* operator+ (Fractie*);
    Fractie* operator- (Fractie*);
    Fractie* operator* (Fractie*);
    Fractie* operator/ (Fractie*);
    void operator= (Fractie*);
    Fractie* ireductibila (Fractie*);
};
int main ()
{

    Lista *L1 = new Lista;
    Numar *numarator1 = new Numar(L1);
    Lista *L2 = new Lista;
    Numar *numitor1 = new Numar(L2);
    Fractie *fr1 = new Fractie(numarator1, numitor1);
    f>>fr1;
    fr1->ireductibila(fr1);
    cout<<fr1;

    Lista *L3 = new Lista;
    Numar *numarator2 = new Numar(L3);
    Lista *L4 = new Lista;
    Numar *numitor2 = new Numar(L4);
    Fractie *fr2 = new Fractie (numarator2, numitor2);
    f>>fr2;
    cout<<fr2;
    return 0;

    /* Lista *L1 = new Lista;
     Numar *n1 = new Numar(L1);
     f>>n1;
     cout<<n1;

     int k = 87;
     Lista *a = new Lista;
     Numar *aux = new Numar(a);
     aux = n1->multiply(k); // aux = n1 * k
     cout<<"numarul inmultit cu "<<k<<" are valoarea "<<aux;

     Lista *L2 = new Lista;
     Numar *n2 = new Numar(L2);
     f>>n2;
     cout<<n2;

     Lista *L3 = new Lista;
     Numar *s = new Numar(L3);
     s = *n1 + n2;
     cout<<"suma este "<<s;

     Lista *L4 = new Lista;
     Numar *p = new Numar(L4);
     p = *n1 * n2;
     cout<<"produsul este "<<p;

     Lista *L5 = new Lista;
     Numar *dif = new Numar(L5);
     //!!! N1>N2
     dif = *n1 - n2;
     cout<<"diferenta este "<<dif;

     Lista *L6 = new Lista;
     Numar *cat = new Numar(L6);
     cat = *n1 / n2;
     cout<<"catul este "<<cat;

     Lista *L7 = new Lista;
     Numar *rest = new Numar(L7);
     rest = *n1 % n2;
     cout<<"restul este "<<rest;*/
}
void Nod :: operator= (const Nod* n)
{
    this->info = n->info;
    this->next = n->next;
}
Nod :: Nod() //constructor
{
    info = 0;
    size = 0;
    next = NULL;
}
Nod :: ~Nod() //destructor
{
    delete this->next;
}
Nod :: Nod (Nod *p)
{
    this->info = p->info;
    this->size = p->size;
    this->next = p->next;
}
Lista :: Lista()
{
    prim = ultim = NULL;
}
void Lista :: operator= (const Lista* L)
{
    if(this != L)
    {
        this->prim = L->prim;
        this->ultim = L->ultim;
        for(Nod *p = L->prim; p != NULL; p = p->next)
            this->addInc(p->info);
    }
}
Lista :: ~Lista ()
{
    delete this->prim;
    delete this->ultim;
}
Lista :: Lista (Lista *p)
{
    this->prim = p->prim;
    this->ultim = p->ultim;
}
Fractie :: Fractie ()
{
    semn = '+';
    this->numarator = 0;
    this->numitor = 0;//this->numarator + 1; //=1 ?
}
Numar :: Numar (Lista *List)
{
    // this->L = List;
    Nod *p = List->prim;
    while (p)
    {
        this->L->addInc(p->info);
        p = p->next;
    }
}
void Lista :: addInc(int x)
{
    Nod *p = new Nod;
    p -> info = x;
    p -> size ++;
    p -> next = prim;
    prim = p;
}
void Lista :: addSf (int x)
{
    Nod *p = new Nod;
    p->info = x;
    p->size ++;
    p->next = NULL;
    if (this->prim == NULL)
    {
        prim = p;
        ultim = prim;
    }
    else
    {
        ultim->next = p;
        ultim = p;
    }
}
istream &operator>> (istream &in, Numar *nr)
{
    int x;
    // char semn;
    //in>>semn;
    in>>x;
    while (x != -1) //nr se termina cand se introduce -1
    {
        nr->L->addInc(x);
        in>>x;
    }
    return in;
}
istream &operator>> (istream &in, Fractie *fr)
{
    char semn;
    in>>semn;
    in>>fr->numarator;
    in>>fr->numitor;
    return in;
}
Nod* Lista :: getPrim ()
{
    return this->prim;
}
int Nod :: getInfo ()
{
    return this->info;
}
int Nod :: getSize ()
{
    return this->size;
}
int Numar :: getLength ()
{
    int length = 0;
    Nod *p = this->L->prim;
    while (p)
    {
        length++;
        p = p->next;
    }
    return length;
}
Numar :: ~Numar ()
{
    this->deleteList();
}
void Numar :: deleteList ()
{
    Nod *p = this->L->prim;
    while (p->next != NULL)
    {
        Nod *q = p;
        p = p->next;
        delete q;
    }
}
Numar *Numar :: operator- (Numar *nr2)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);

    Nod *p1 = this->L->prim;
    Nod *p2 = nr2->L->prim;
    int c = 0, s;
    while (p1 || p2)
    {
        if (p1 && p2)
        {
            if(p1->info +c >= p2->info)
            {
                s = p1->info + c - p2->info;
                c = 0;
            }
            else
            {
                s = p1->info + c +10 - p2->info;
                c = -1;
            }
            p1 = p1->next;
            p2 = p2->next;
        }
        else if (p1 && p2 == NULL)
        {
            if(p1->info >= 1)
            {
                s = p1->info + c;
                c = 0;
            }
            else
            {
                if (c)
                {
                    s = p1->info + 10 + c;
                    c = -1;
                }
                else
                    s = p1->info;
            }
            p1 = p1->next;
        }
        rezultat->L->addInc(s);
    }
    return rezultat;
}
Nod* Nod :: getNext ()
{
    return this->next;
}
ostream &operator<< (ostream &out, Numar *nr)
{
    Nod *p = nr->L->getPrim();
    while(p)
    {
        int data = p->getInfo();
        out<<data;
        p = p->getNext();
    }
    //out<<endl;
    return out;
}
ostream &operator<< (ostream &out, Fractie *fr)
{
    out<<fr->semn;
    out<<fr->numarator;
    out<<"/";
    out<<fr->numitor;
    out<<endl;
    return out;
}
void Numar :: operator= (const Numar *nr)
{
    if(this != nr)
    {
        for (Nod *p = nr->L->prim; p != NULL; p = p->next)
            this->L->addInc(p->info);
    }
}
Numar *Numar :: operator+ (Numar const *nr2)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    int t = 0, x;
    Nod *p1 = this->L->prim;
    Nod *p2 = nr2->L->prim;
    while (p1 && p2)
    {
        x = (p1->info + p2->info + t)%10;
        rezultat->L->addInc(x);
        t = (p1->info + p2->info + t)/10;
        p1 = p1->next;
        p2 = p2->next;
    }
    while (p1)
    {
        x = (p1->info + t)%10;
        rezultat->L->addInc(x);
        t = (p1->info + t)/10;
        p1 = p1->next;
    }
    while (p2)
    {
        x = (p2->info + t)%10;
        rezultat->L->addInc(x);
        t = (p2->info + t)/10;
        p2 = p2->next;
    }
    if(t)
        rezultat->L->addInc(t);
    return rezultat;
}/*
Numar *Numar :: addInt (int k)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    int x, t = 0;
    Nod *p = this->L->prim;
    while(p)
    {
        x = (t + p->info + k)%10;
        rezultat->L->addInc(x);
        t = (t + p->info + k)/10;
        p = p->next;
    }
    if (t)
        rezultat->L->addInc(t);
    return rezultat;
}*/
Numar *Numar :: multiply (int k)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    int x, t = 0;
    Nod *p1 = this->L->prim;
    while (p1)
    {
        x = (t + p1->info * k)%10;
        rezultat->L->addInc(x);
        t = (t + p1->info * k)/10;
        p1 = p1->next;
    }
    if(t)
        rezultat->L->addInc(t);
    return rezultat;
}
Numar *Numar :: operator* (Numar *nr2)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    Lista *aux = new Lista;
    Numar *rez2 = new Numar(aux);
    int t = 1;
    Nod *p2 = nr2->L->prim;
    while (p2)
    {
        rez2 = this->multiply(p2->info * t);
        cout<<"rez2 "<<rez2;
        rezultat = *rezultat + rez2;
        cout<<"rezultat "<<rezultat;
        t *= 10;
        p2 = p2->next;
    }
    return rezultat;
}
Numar* Numar :: copyNumar (Numar *n)
{
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    Nod *p = n->L->prim;
    while (p)
    {
        rezultat->L->addSf(p->info);
        p = p->next;
    }
    return rezultat;
}
int Numar :: cmp(Numar *a, Numar *b)
{
    if(a->getLength() != b->getLength())
        if(a->getLength() > b->getLength())
            return 1;
        else
            return 0;
    else
    {
        Nod *p1 = a->L->prim;
        Nod *p2 = b->L->prim;
        while(p1 && p2)
        {
            if(p1->info > p2->info)
                return 1;
            else if (p1->info < p2->info)
                return 0;
            else
            {
                p1 = p1->next;
                p2 = p2->next;
            }
        }
        return 2;
    }
}
Numar* Numar :: operator/ (Numar *nr2)
{
    if(nr2->L->ultim == nr2->L->prim && nr2->L->ultim->info == 0)
    {
        cout<<"imposibil de impartit la 0 ";
        return 0;
    }
    long long aux = 0;
    while (this - nr2)
    {
        aux++;
        *this = *this - nr2;
    }
    Lista *L = new Lista;
    Numar *rezultat = new Numar(L);
    while (aux)
    {
        rezultat->L->addInc(aux % 10);
        aux /= 10;
    }
    return rezultat;
}
Numar* Numar :: operator% (Numar *nr2)
{
    if(nr2->L->ultim == nr2->L->prim && nr2->L->ultim->info == 0)
    {
        cout<<"imposibil de impartit la 0 ";
        return 0;
    }
    Lista *L = new Lista;
    Numar *r = new Numar(L);
    r = this;
    while (r - nr2)
        *r = *r - nr2;
    return r;
}
Numar* Numar :: Euclid (Numar *n1, Numar *n2)
{
    Lista *L = new Lista;
    Numar *c = new Numar(L);
    while (n2)
    {
        c = *n1 % n2;
        n1 = n2;
        n2 = c;
    }
    return n1;
}
Fractie :: ~Fractie ()
{
    this->numarator->deleteList();
    this->numitor->deleteList();
}
Fractie :: Fractie (Numar *a, Numar *b)
{
    this->numarator->copyNumar(a);
    this->numitor->copyNumar(b);
}
Fractie *Fractie :: operator+ (Fractie *nr2)
{
    Fractie *r = new Fractie;
    r->numarator = *(*this->numarator * nr2->numitor) + (*this->numitor * nr2->numarator);
    r->numitor = *this->numitor * nr2->numitor;
    return r;
}
Fractie *Fractie :: operator- (Fractie *nr2)
{
    Fractie *r = new Fractie;
    r->numarator = *(*this->numarator * nr2->numitor) - (*this->numitor * nr2->numarator);
    r->numitor = *this->numitor * nr2->numitor;
    return r;
}
Fractie *Fractie :: operator* (Fractie *nr2)
{
    Fractie *r = new Fractie;
    r->numarator = *this->numarator * nr2->numarator;
    r->numitor = *this->numitor * nr2->numitor;
    return r;
}
void Fractie :: operator= (Fractie *nr)
{
    if (this != nr)
    {
        for (Nod *p = nr->numarator->L->prim; p != NULL; p = p->next)
            this->numarator->L->addInc(p->info);
        for (Nod *p = nr->numitor->L->prim; p != NULL; p = p->next)
            this->numitor->L->addInc(p->info);
    }
}
Fractie *Fractie :: operator/ (Fractie *nr2)
{
    Fractie *r = new Fractie;
    r->numarator = *this->numarator * nr2->numitor;
    r->numitor = *this->numitor * nr2->numarator;
    return r;
}
Fractie *Fractie ::  ireductibila (Fractie *fr)
{
    Lista *L = new Lista;
    Numar* cmmmdc = new Numar(L);
    cmmmdc -> Euclid(fr->numarator, fr->numitor);
    Fractie *r = new Fractie;
    r->numarator = *fr->numarator / cmmmdc;
    r->numitor = *fr->numitor / cmmmdc;
    return r;
}
