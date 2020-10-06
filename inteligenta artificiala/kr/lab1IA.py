#pb1
n = int(input("n= "))
l = []
for i in range(n):
    x = int(input("x= "))
    l.append(x)
maxi = max(l)
while maxi in l:
    l.remove(maxi)
if l:
    maxi2 = max(l)
    print("max1", maxi)
    print("max2", maxi2)
else:
    print("imposibil")


#pb2
s1 = input("s1= ")
s2 = input("s2= ")
if len(s1) != len(s2):
    print("sirurile nu sunt anagrame")
else:
    for char in s1:
        if char in s2:
            s2 = s2.replace(char, '', 1) #sterge litera
if not s2:
    print("sirurile sunt anagrame")
else:
    print("sirurile nu sunt anagrame")


#pb3
string = input("string= ") #Langa o cabana, stand pe o banca, un bacan a spus un banc bun.
word = input("word= ") #bacan
string = [s.strip(',.;:?!') for s in string.split(" ")]
string
for w in string:
    if set(word) == set(w):
        print(w)


#pb4
#a
string = input("string= ")
s = f"sirul are {len(string)} caractere"
print(s)

def function(string):
    list_ = []
    for word in string:
        for char in word:
            if not char.isalnum() and char != '-':
                list_.append(char)
    return list_
#b
def function2(string):
    list_ = []
    for word in string:
        if not word.isalnum() and word != '-':
                list_.append(word)
    return list_

l = function2(string)
print("lista", l)

#c
def listToString(s):  
    str1 = ""  
    for ele in s:  
        str1 += ele   
    return str1 

l = listToString(l) #list to string
string = [s.strip(l).lower() for s in string.split(" ")]
print(string)

#d
for word in string:
    if word.endswith("ul"): #ultimele 2 litere sunt ul
        print(word)
        
#e
listC = []
for word in string:
    if word.find('-') != -1:
        listC.append(word)
print("lista cuvinte cu cratima ", listC)