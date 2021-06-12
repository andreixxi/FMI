cartX = [2, 3, 2, 2, 2, 3, 4, 5, 6, 6, 6, 5, 6]
cartY = [4, 3, 2, 0, -2, -5, -5, -5, -2, 0, 2, 3, 4]
    
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
screenX = [x + 10 for x in screenX] 
screenY = [x + 10 for x in screenY]

#scriere intr un fisier
f = open("ex3.html", "w")
f.write('''<svg width="{}" height="{}">\n'''.format(A+20, B+20))

# desenez punctele
for item in range(len(screenX)):
    f.write("<circle cx=\"" + str(screenX[item])+ "\" cy=\"" + str(screenY[item]) + "\" r=\"2\" fill=\"red\"/>\n")

# unesc punctele
for item in range(len(screenX)-1):
    f.write('''<path d="M{} {} {} {}" stroke-dasharray="5,5" stroke="blue"/>\n'''.format(screenX[item], screenY[item], screenX[item+1], screenY[item+1] ))
 

 # trasare curbe 
colors = ['green', 'purple', 'orange', 'black']
i = 0
for item in range(0, len(screenX)-3 , 3):
    f.write('''<path d="M{} {} C{} {}, {} {}, {} {}" stroke-width="1" stroke="{}" fill="transparent"/>\n'''\
        .format(screenX[item], screenY[item], screenX[item+1], screenY[item+1],screenX[item+2], screenY[item+2],\
                   screenX[item+3], screenY[item+3], colors[i]))
    i += 1

f.write('''<path d="M{} {} {} {}" stroke-width="1" stroke="red"/>\n'''.format(screenX[0], screenY[0], screenX[-1], screenY[-1] ))    

f.write('''</svg>''')
f.close()