a = 2
cartX = []
cartY = []
# calcul coordonate carteziene dupa formula parametrica 
for t in range(-200, 200):
    x = a * t
    y = a / (1 + t**2)
    
    cartX.append(x)
    cartY.append(y)

# window
Xmin = min(cartX)
Ymin = min(cartY)
Xmax = max(cartX)
Ymax = max(cartY)

# screen size
A = 1500 
B = 700

# transformare conform http://edspi31415.blogspot.com/2012/09/cartesian-coordinates-to-pixel-screen.html
screenX = [(x - Xmin) * A / (Xmax - Xmin) for x in cartX]
screenY = [(y - Ymax) * (-B) / (Ymax - Ymin) for y in cartY]

#scriere intr un fisier
f = open("tema2.html", "w")
f.write('''<svg width="{}" height="{}">\n'''.format(A, B))

# desenez punctele
for item in range(len(screenX)):
    f.write("<circle cx=\"" + str(screenX[item])+ "\" cy=\"" + str(screenY[item]) + "\" r=\"1\" fill=\"red\"/>\n")

# unesc punctele
for item in range(len(screenX) - 1):
    f.write('''<path d="M{} {} {} {}" stroke-width="0.5" stroke="blue"/>\n'''.format(screenX[item], screenY[item], screenX[item+1], screenY[item+1] ))
    
f.write('''</svg>''')
f.close()