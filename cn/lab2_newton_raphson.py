#!/usr/bin/env python
# coding: utf-8

# In[69]:


import matplotlib.pyplot as plt
import numpy as np
import random
from math import sqrt 

def f(x):
    return x**3 -7*(x**2) + 14*x - 6

def fderiv(x):
    return 3 * x**2 - 14 * x + 14

def fd2(x):
    return 6*x - 14

def metoda_newton(f, fderiv, xk_1, epsilon):
    N = 0
    # algoritmul
    xk = xk_1 - f(xk_1) /fderiv(xk_1)
    
    while (abs(xk - xk_1) / abs(xk_1)) >= epsilon:
        xk_1 = xk
        xk = xk_1 - f(xk_1) / fderiv(xk_1)
        N += 1
    return xk, N #n nr iteratii

epsilon = 1e-5 # 10^(-5)
a, b = 0, 4 # intervalul [0,4]

"""rezolv f'(x) = 0 
x1,2 = (7+-sqrt(7))/3
la x0 caut intre a si primul punct unde functia schimba convexitatea (f' = 0) (intervalul 1)
la x1: pt intervalul 2 rezolv f"(x)= 0 pt ca am si concav si convex si obtin x = 14/6 
la x2: caut intre al 2lea punct unde functia schimba convexitatea (f' = 0) si b"""

#aplic metoda
x0, N0 = metoda_newton(f, fderiv, random.uniform(a, (7 - sqrt(7))/3), epsilon)
x1, N1 = metoda_newton(f, fderiv, random.uniform(14/6, (7 + sqrt(7))/3), epsilon) 
x2, N2 = metoda_newton(f, fderiv, random.uniform((7 + sqrt(7))/3, b), epsilon)

#afisare solutii
print(x0, N0, "iteratii")
print(x1, N1, "iteratii")
print(x2, N2, "iteratii")

x = np.linspace(a, b, 50) # Discretizare a intervalului (A,B)/ generare puncte
y = f(x)

plt.figure(0)
plt.plot(x, y, linestyle = '-', linewidth = 3) #desenez graficul functiei

# 0 = f(solutie)
plt.scatter(x0, 0, s=50, c='black', marker='o') #s=size, marker-forma punctelor
plt.scatter(x1, 0, s=50, c='black', marker='o')
plt.scatter(x2, 0, s=50, c='black', marker='o')

plt.legend(['f(x)', 'x_num']) # Adauga legenda

plt.axvline(0, c='black') # Adauga axa OY
plt.axhline(0, c='black') # Adauga axa OX

plt.xlabel('x') # Label pentru axa OX
plt.ylabel('y') # Label pentru axa OY

plt.title('Metoda Newton Raphson') # Titlul figurii

plt.show() # Arata graficul


# In[ ]:




