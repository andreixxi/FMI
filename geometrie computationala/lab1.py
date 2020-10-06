#include <iostream>
#include <fstream>
using namespace std;
ifstream f("date.in");
int main()
{
    float x1, y1, z1, x2, y2, z2, x3, y3, z3;
    float a;
    f>>x1>>y1>>z1;
    f>>x2>>y2>>z2;
    f>>x3>>y3>>z3;
    /*1 2 3
    2 1 -1
    0 3 7
    */
    //a1 != a2
    if(x1 != x2 || y1 != y2 || z1 != z2)
    {
        int ok = 1;
        if (x2 - x1)
        {
            a = (x3 - x1) / (x2 - x1);

            if (y2 - y1)
                if (y3 - y1 != a *(y2 - y1))
                    ok = 0;
                else if (y1 == y2)
                    if (y1 != y3)
                        ok = 0;

            if (z2 - z1)
                if (z3 - z1 != a *(z2 - z1))
                    ok = 0;
                else if (z1 == z2)
                    if (z1 != z3)
                        ok = 0;

        }
        else if (y2 - y1)
        {
            {
                a = (y3 - y1) / (y2 - y1);

                if (x2 - x1)
                    if (x3 - x1 != a *(x2 - x1))
                        ok = 0;
                    else if (x1 == x2)
                        if (x1 != x3)
                            ok = 0;

                if (z2 - z1)
                    if (z3 - z1 != a *(z2 - z1))
                        ok = 0;
                    else if (z1 == z2)
                        if (z1 != z3)
                            ok = 0;

            }
        }
        else if (z2 - z1)
        {
            {
                a = (z3 - z1) / (z2 - z1);

                if (x2 - x1)
                    if (x3 - x1 != a *(x2 - x1))
                        ok = 0;
                    else if (x1 == x2)
                        if (x1 != x3)
                            ok = 0;

                if (y2 - y1)
                    if (y3 - y1 != a *(y2 - y1))
                        ok = 0;
                    else if (y1 == y2)
                        if (y1 != y3)
                            ok = 0;

            }
        }
        if (ok)
        {
            cout<<"punctele sunt coliniare, o combinatie afina este A3 = "<<1-a<<"A1 + "<<a<<"A2";
        }
        else cout<<"punctele nu sunt coliniare";
    }
    //a1 == a2
    else if(x1 == x2 && y1 == y2 && z1 == z2)
        cout<<"punctele sunt coliniare, o combinatie este A2 = 1 * A1 + 0 * A3";
   /* //a1 == a3
    else if(x1 == x3 && y1 == y3 && z1 == z3)
        cout<<"punctele sunt coliniare, o combinatie este A3 = 1 * A1 + 0 * A2";*/
    //a2 == a3
    else if(x2 == x3 && y2 == y3 && z2 == z3)
        cout<<"punctele sunt coliniare, o combinatie este A3 = 1 * A2 + 0 * A1";
}