//Lungu Andrei grupa 132
#include <iostream>
#include <vector>
using namespace std;
class Aeroport
{
protected:
    string denumire;
    int an;
    string cod; // ?
    static int numar_zbor;
    string oras_dest;
    string data;
    float ora;
    float durata;
    int regim;
    vector<string> destinatii;
    string operator_turism;
    float diferenta;
public:
    Aeroport()
    {
        numar_zbor++;
    }
    Aeroport(string d, int a, string c, string od, string da, float o, float du, int r, vector<string> de, string op, float dif) :
        denumire(d), an(a), cod(c), oras_dest(od), data(da), ora(o), durata(du), regim(r), destinatii(de)
    {
        if(regim == 1)
        {
            operator_turism = op;
            diferenta = dif;
        }
    }
    ~Aeroport()
    {
        numar_zbor--;
    }
    virtual void citire(istream& in)
    {
        cout<<"introdu denumirea\n";
        in>>denumire;
        cout<<"introdu anul infiintarii\n";
        in>>an;
        cout<<"introdu codul ICAO/IATA\n";
        in>>cod;
        cout<<"introdu orasul destinatie\n";
        in>>oras_dest;
        cout<<"introdu data (zilunaan)\n";
        in>>data;
        cout<<"introdu ora si durata\n";
        in>>ora>>durata;
        cout<<"ofera regim de charter?\n1.da\n0.nu\n";
        in>>regim;
        if(regim == 1)
        {
            cout<<"introdu operator turism(fara spatiu)\n";
            in>>operator_turism;
            cout<<"introdu diferenta aferenta\n";
            in>>diferenta;
        }
        cout<<"introdu numar conexiuni\n";
        int nr;
        in>>nr;
        if(nr)
        {
            cout<<"introdu conexiunile\n";
            for(int i=0; i<nr; i++)
            {
                string dest;
                in>>dest;
                destinatii.push_back(dest);
            }
        }
    }
    virtual void afisare(ostream& out)
    {
        out<<"denumire: "<<denumire<<endl<<"an: "<<an<<endl;
        out<<"cod: "<<cod<<endl;
        out<<"orasul destinatie: "<<oras_dest<<endl;
        out<<"data, ora si durata:\n"<<data<<"; "<<ora<<"; "<<durata<<endl;
        if(regim == 1)
            out<<"ofera regim de charter\noperatorul de turism este "<<operator_turism<<", iar diferenta este "<<diferenta<<endl;
        else
            out<<"nu ofera regim de charter\n";
        out<<"destinatiile sunt: ";
        for (int i=0; i<destinatii.size(); i++)
            out<<destinatii[i]<<" ";
        out<<endl;
    }
    friend istream& operator>>(istream& in, Aeroport& a)
    {
        a.citire(in);
        return in;
    }
    friend ostream& operator<<(ostream& out, Aeroport& a)
    {
        a.afisare(out);
        return out;
    }
    string get_oras() const
    {
        return oras_dest;
    }
    string get_data() const
    {
        return data;
    }
};
class lowcost : public Aeroport
{
    float cost_kg;
    float cantitate;
public:
    lowcost() : Aeroport() {}
    lowcost(string d, int a, string c, string od, string da, float o, float du, int r, vector<string> de, string op, float dif, float ck, float ca) :
        Aeroport(d, a, c, od, da, o, du, r, de, op, dif), cost_kg(ck), cantitate(ca) {}
    ~lowcost() {}
    void citire(istream& in)
    {
        Aeroport::citire(in);
        cout<<"introdu cost per kg\n";
        in>>cost_kg;
        cout<<"introdu cantitatea\n";
        in>>cantitate;
    }
    void afisare(ostream& out)
    {
        Aeroport::afisare(out);
        cout<<"cost/kg: "<<cost_kg<<endl<<"cantitate: "<<cantitate<<endl;
    }
};
class Linie : public Aeroport
{
    int escale;
    vector<string> oras_escala;
public:
    Linie() : Aeroport() {}
    ~Linie() {}
    Linie(string d, int a, string c, string od, string da, float o, float du, int r, vector<string> de, string op, float dif, int e,
          vector<string> oescala) : Aeroport(d, a, c, od, da, o, du, r, de, op, dif), escale(e), oras_escala(oescala) {}
    void citire(istream& in)
    {
        Aeroport::citire(in);
        cout<<"introdu 1 daca ofera zboruri cu escala, 0 altfel\n";
        in>>escale;
        if(escale == 1)
        {
            cout<<"introdu numarul de escale\n";
            int nr;
            in>>nr;
            for(int i=0; i<nr; i++)
            {
                string oras;
                in>>oras;
                oras_escala.push_back(oras);
            }
        }
    }
    void afisare(ostream& out)
    {
        Aeroport::afisare(out);
        if(escale == 1)
        {
            out<<"ofera zboruri cu escala in: ";
            for(int i=0; i<oras_escala.size(); i++)
                out<<oras_escala[i]<<" ";
            out<<endl;
        }
        else
            out<<"nu ofera zboruri cu escala\n";
    }
    int get_escale() const
    {
        return escale;
    }
    vector<string> get_oras_escala() const
    {
        return oras_escala;
    }
};
template<class T>
class Avion
{
    vector<T*> v;
public:
    Avion() {}
    ~Avion()
    {
        for(int i=0; i<v.size(); i++)
            delete v[i];
    }
    Avion& operator+= (Avion& a)
    {
        v.push_back(a);
    }
    void afisare_loc(string nume)
    {
        for(int i=0; i<v.size(); i++)
        {
            if(v[i].get_oras() == nume) //orasul destinatie este cel cautat
                cout<<v[i]<<endl;
            if(Linie* l = dynamic_cast<Linie*>(v[i])) //zborul este de linie
                if(v[i].get_escale() == 1) //are escale
                {
                    vector<string> temp = v[i].get_oras_escala();
                    for(int j=0; j<temp.size(); j++)
                        if(nume == temp[j]) //una dintre escale este loc cautat
                            cout<<temp[j]<<endl;
                }
        }
    }
};
int Aeroport :: numar_zbor = 0;
int main()
{
    vector<Linie> vector_linie;
    vector<lowcost> vector_lc;
    cout<<"introdu numarul de companii\n";
    int nr;
    cin>>nr;
    for(int i=0; i<nr; i++)
    {
        cout<<"introdu 1 pt zbor linie, 0 pt zbor lowcost\n";
        int x;
        cin>>x;
        if(x == 1)
        {
            Linie* l = new Linie;
            cin>>*l;
            vector_linie.push_back(*l);
        }
        if(x == 0)
        {
            lowcost* l =new lowcost;
            cin>>*l;
            vector_lc.push_back(*l);
        }
    }
    cout<<"\nafisare companii de linie\n";
    for(int i=0; i<vector_linie.size(); i++)
        cout<<vector_linie[i]<<endl;
    cout<<"\nafisare companii lowcost\n";
    for(int i=0; i<vector_lc.size(); i++)
        cout<<vector_lc[i]<<endl;

    cout<<"\nzboruri otopeni 1 sept 2019\n";
    for(int i=0; i<vector_linie.size(); i++)
        if(vector_linie[i].get_data() == "1septembrie2019")
            cout<<vector_linie[i]<<endl;
    for(int i=0; i<vector_lc.size(); i++)
        if(vector_lc[i].get_data() == "1septembrie2019")
            cout<<vector_lc[i]<<endl;

    /*cout<<"\nintrodu localitatea cautata\n";
    string loc;
    cin>>loc;
    for(int i=0; i<vector_linie.size(); i++)
    {
        if(vector_linie[i].get_oras() == loc)
            cout<<vector_linie[i]<<endl;
        if(vector_linie[i].get_escale()) // are escale
        {
            vector<string> temp = vector_linie[i].get_oras_escala();
            for(int j=0; j<temp.size(); j++)
                if(temp[j] == loc)
                    cout<<temp[j]<<endl;
        }
    }*/


    /*vector<Avion>vec;
    cout<<"introdu numarul de companii\n";
    int nr;
    cin>>nr;
    for(int i=0; i<nr; i++)
    {
        cout<<"introdu 1 pt zbor linie, 0 pt zbor lowcost\n";
        int x;
        cin>>x;
        if(x == 1)
        {
            Linie* l = new Linie;
            vec += l;
        }
        if(x == 0)
        {
            lowcost* l =new lowcost;
            vec += l;
        }
    }
    string localitate;
    cout<<"introdu numele localitatii cautate\n";
    cin>>localitate;
    vec::afisare_loc(localitate);*/
}
