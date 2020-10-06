def ecdr(x, y):
    a = y[1] - x[1]
    b = x[0] - y[0]
    c = y[0]*x[1] - x[0]*y[1] 
    return a, b, c

def det(a1, a2, b1, b2):
    return a1*b2 - a2*b1

a = [(1, 1), 
     (5, 5), 
     (3, 3), 
     (1, 4)]
# a = [(1, 1), 
#      (4, 4), 
#      (3, 3), 
#      (7, 7)]

#sorteaza primele 2 puncte, ultimele 2 puncte
a[0:2], a[2:4] = sorted(a[0:2]), sorted(a[2:4])

x1, y1 = a[0][0], a[0][1]
x2, y2 = a[1][0], a[1][1]
x3, y3 = a[2][0], a[2][1]
x4, y4 = a[3][0], a[3][1]

a1, b1, c1 = ecdr(a[0], a[1])
a2, b2, c2 = ecdr(a[2], a[3])
d = det(a1, a2, b1, b2)

if d:
    x = (det(-c1, -c2, b1, b2))/d
    y = (det(a1, a2, -c1, -c2))/d
    ok1 = 0
    ok2 = 0
    if a[0][0] != a[1][0]:
        #P(x, y) se afla pe A1A2
        if x >= min(a[0][0], a[1][0]) and x <= max(a[0][0], a[1][0]) and y >= min(a[0][1], a[1][1]) and y <= max(a[0][1], a[1][1]):
            ok1 = 1
    else: #x1 = x2
        if x == a[0][0] and y >= min(a[0][1], a[1][1]) and y <= max(a[0][1], a[1][1]):
            ok1 = 1
            
    if a[2][0] != a[3][0]:
        #P(x, y) se afla pe A1A2
        if x >= min(a[2][0], a[3][0]) and x <= max(a[2][0], a[3][0]) and y >= min(a[2][1], a[3][1]) and y <= max(a[2][1], a[3][1]):
            ok2 = 1
    else: #x3 = x4
        if x == a[2][0] and y >= min(a[2][1], a[3][1]) and y <= max(a[2][1], a[3][1]):
            ok2 = 1
    if ok1 == 1 and ok2 == 1:
        print("segmentele se intersecteaza in punctul P(", x, y, ")")
    else:
        print("segmentele nu se intersecteaza")
else:
    d1 = det(a1, a2, c1, c2)
    d2 = det(b1, b2, c1, c2)
    if d1 == 0 and d2 == 0:
        rang = 1
    else:
        rang = 2
    if rang == 2:
        print("segmentele nu se intersecteaza")
    else:
#          cazuri
#         (1, 2, 3, 4)
#         (1, 3, 2, 4)
#         (1, 3, 4, 2)
#         (3, 1, 2, 4)
#         (3, 1, 4, 2)
#         (3, 4, 1, 2)

#         rang=1, segmentele au aceeasi lungime
#         a1 a2 a3 a4
        mesaj = "segmentele nu se intersecteaza"
        if x2 < x3:
            print(mesaj)
        else:
            print("segmentele se intersecteaza in punctul P(", x3, y3,")")
#         a1 a3 a2 a4
        if x3 <= x2:
            print("segmentele se intersecteaza in punctul P(", x3, y3,")")
#         a1 a3 a4 a2
        if x3 < x2 and x4 <= x2:
            print("segmentele se intersecteaza in punctul P(", x3, y3,")")
#         a3 a1 a2 a4
        if x1 < x4 and x2 <= x4:
            print("segmentele se intersecteaza in punctul P(", x1, y1,")")
#         a3 a1 a4 a2
        if x3 <= x1 and x4 <= x2:
            print("segmentele se intersecteaza in punctul P(", x1, y1,")")
#         a3 a4 a1 a2
        if x4 == x1:
            print("segmentele se intersecteaza in punctul P(", x1, y1,")")
        else:
            print(mesaj)