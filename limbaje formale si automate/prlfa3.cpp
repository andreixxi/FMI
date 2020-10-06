#include <iostream>
#include <stack>

using namespace std;

int main ()
{
    //l = a^2n b^p c^n , n, p > 1
    string w;
    cin>>w;

    stack <char> s;
    int top = 0;
    int oka = 0, okb = 0, okc = 0;
    int n = w.size();

    for(int i = 0; i < n; i++)
    {
        if(w[i] == 'a' || w[i] == 'b' || w[i] == 'c')
        {
            if(w[i] == 'a' && w[i-1] != 'b' && w[i-1] != 'c')
            {
                s.push(w[i]);
                top++;
                if(top == 2)
                    oka = 1;
            }
            if(w[i] != 'a' && w[i] == 'b' && w[i-1] != 'c')
            {
                s.push(w[i]);
                top++;
                okb = 1;
            }
            if(w[i] != 'a' && w[i] != 'b' && w[i] == 'c' && w[i-1] != 'a')
            {
                s.push(w[i]);
                top++;
                okc = 1;
            }
        }
        else
        {
            oka = okb = okc = 0;
            break;
        }
    }

    int ctrc = 0, ctra = 0;
    if(oka && okb && okc && top == n)
    {
        while(!s.empty())
        {
            if(s.top() == 'c')
            {
                s.pop();
                ctrc++;
                top--;
            }
            if (s.top() == 'b')
            {
                s.pop();
                top--;
            }
            if(s.top() == 'a')
            {
                s.pop();
                ctra++;
                top--;
            }
        }
    }

    if(top == 0 && oka && okb && okc && ctra && ctra == 2 * ctrc)
        cout<<"cuvant acceptat";
    else
        cout<<"cuvant neacceptat";
}
