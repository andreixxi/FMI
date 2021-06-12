import matplotlib.pyplot as plt
import numpy as np

def f(x):
    return x**3 -7*(x**2) + 14*x - 6

epsilon = 1e-5 # 10^(-5)
a, b = 0, 4 # intervalul [0,4]

def metoda_bisectiei (f, a, b, epsilon):
    #calculez f de capete
    fa = f(a)
    fb = f(b)

    #semnele trb sa fie diferite
    assert fa*fb < 0

    #mijlocul intervalului initial
    xnum = (a + b) / 2

    #nr iteratii
    N = int(np.floor(np.log2((b-a)/epsilon) - 1))

    #algoritmul
    for i in range(N):
        fx = f(xnum)
        if fx == 0: #am gasit valoarea cautata, ies
            break
        elif f(a) * fx < 0:
            b = xnum
        else:
            a = xnum
        xnum = (a + b) / 2

    return xnum

#caut pe intervalele date
intervals = [(0., 1.), (1., 3.2), (3.2, 4.)]
solutii = []
for i, intv in enumerate(intervals):
    ai = intv[0]
    bi = intv[1]
    x_num = metoda_bisectiei(f, ai, bi, epsilon)
    print("x" + str(i) +"=", x_num)
    solutii.append(x_num)

x = np.linspace(a, b, 50) # Discretizare a intervalului (A,B)/ generare puncte
y = f(x)

 
plt.figure(0)
plt.plot(x, y, linestyle = '-', linewidth = 3) #desenez graficul functiei

# 0 = f(solutie)
plt.scatter(solutii, [0] * len(solutii), s=50, c='black', marker='o') #s=size, marker-forma punctelor

plt.legend(['f(x)', 'x_num']) # Adauga legenda

plt.axvline(0, c='black') # Adauga axa OY
plt.axhline(0, c='black') # Adauga axa OX

plt.xlabel('x') # Label pentru axa OX
plt.ylabel('y') # Label pentru axa OY

plt.title('Metoda Bisectiei') # Titlul figurii

plt.show() # Arata graficul