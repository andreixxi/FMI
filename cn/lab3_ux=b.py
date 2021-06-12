#!/usr/bin/env python
# coding: utf-8
import numpy as np

#np.sum cu axis = 0 face suma pe coloane, axis = 1 pe linii
u = np.array([[2., -1., -2.], 
            [0., 4., 4.],
            [0., 0., 1.]])

n = np.shape(u)[0] # linii
n2 = np.shape(u)[1] # coloane

I = np.array([[1., 0., 0.], 
             [0., 1., 0.], 
             [0., 0., 1.]])
c = np.array([[-1.], 
              [8.], 
              [1.]])
x = np.array([[float('nan')], 
              [float('nan')], 
              [float('nan')]])
epsilon = 10**(-14)
# print(U)
# print(I)
# print(B)
if np.linalg.det(u) > epsilon:
    print("\nvarianta cu for")
    print("matricea este inversabila", np.linalg.det(u), ">", epsilon)
    
    for k in range(n-1, -1, -1):
        suma = 0
        for j in range(k+1, n):
            suma = suma + (u[k][j]*x[j])
        x[k] = (c[k] - suma) / u[k][k]
            
    print("solutia este\n", x)
    print(u@x) # inmultire matrice
    
    print("------------\nvarianta cu np.dot")
    x = np.array([[float('nan')], 
                  [float('nan')], 
                  [float('nan')]])
    
    for k in range(n-1, -1, -1):
        x[k] = (c[k] - np.dot(u[k][k+1 : ], x[k+1 : ])) / u[k][k]
            
    print("solutia este\n", x)
    print(u@x) # inmultire matrice