# Lungu Andrei 232 

import time
from math import sqrt


""" definirea problemei """
class Nod:
    def __init__(self, info, h = None, scop = None, N = None):
        # info este o lista de forma [i, j], unde i = numar linie, j = nr coloana
        # in clasa sunt maxim N linii, 6 coloane de elevi
        self.info = info 
        if h is not None:
            self.h = h
        else:
            """pt a calcula h:
               verific daca elevul curent si elevul scop/final se afla pe acelasi rand:
               -daca da, calculez dist folosind dist manhattan(nu tin cont de suparati sau locuri libere)
               -daca nu, calculez distanta pana la banca n-1/ n (ultimele 2 banci) pt a putea transmite biletul la randul 
               alaturat, apoi dist manhattan"""
            
            self.h = 0
            rand_dest = scop[1] // 2 # coloana de banci unde trb sa ajunga mesajul
            rand_curr = info[1] // 2 # coloana de banci unde se afla elevul curent
                                     # adica elevul aflat pe coloana 5 in matrice (ultima, consider numerotarea de la 0 la 
                                     # 5 inclusiv) se afla pe coloana de banci 2 
            
            if rand_curr != rand_dest: # daca nu se afla pe aceeasi coloana de banci
                if info[0] < N - 2: # elevul curent nu se afla in ultimele 2 randuri(banci, adica linii in matrice)
                    self.h += N - 2 - info[0] # distanta pana la randul n-2 (penultimul)
                    poz = N - 2 # in poz retin linia de unde poate fi trimis biletul catre elevul scop
                                # penultima daca nu se afla in ultimele 2 linii
                else: 
                    poz = info[0] # fie penultima, fie ultima (elevul curent se afla in ultimele 2 linii din matrice)
                                  # (nu se modifica fata de linia elevului curent)
            else:
                poz = info[0]  # daca se afla pe aceeasi coloana de banci, linia ramane cea actuala

                
#             info/poz(x1, y1) ;;;  scop(x2, y2) 
            self.h += abs(poz - scop[0]) + abs(info[1] - scop[1])  #*** Pentru a calcula distanta dintre punctele A(x1, y1) 
                                                                   # si B(x2, y2) vom aplica formula: |x1 – x2| + |y1 – y2|


        
            # self.h += sqrt((scop[0] - poz) ** 2 + (scop[1] - info[1]) ** 2)   #***
                # sqrt((x2 - x1) ^ 2 + (y2 - y1)^2)  # euclidian distance 
                
            # self.h += (scop[0] - poz) ** 2 + (scop[1] - info[1]) ** 2        #***
#             (x2-x1)^2 + (y2-y1)^2 - patratul distantei euclidiene nu este o euristica buna pentru ca o sa supraestimeze
#                                     distanta, fapt ce duce la alegerea unui drum care nu este optim, 
#                                     deci nu este nici admisibila




class Problema:
    def __init__(self, fileName):
        self.elevi = [] # lista cu elevii din clasa
        self.eleviSup = {} # dictionar cu elevii suparati
        self.mesaj = [] # de forma ['elev1', '->', 'elev2'], unde elev1 este colegul care a auzit de farsa, 
                        # elev2 este victima
        self.noduri = [] # lista cu obiecte de tip Nod([i, j], scop = self.nod_scop, N = self.N)
                         # i, j - pozitia in matrice
        
        
        # citire date
        with open(fileName, 'r') as fin:
            sup = 0
            mes = 0
            
            for line in (fin):
                wordList = line.split()
                if wordList[0] != 'suparati' and sup == 0: # citesc asezarea in banci 
                    self.elevi.append(wordList)
                else: # am ajuns la identificatorul 'suparati'
                    sup = 1
                if wordList[0] != 'mesaj:' and wordList[0] != 'suparati' and sup == 1:
                    #dictionar cu elevii suparati
                    elev1 = wordList[0]
                    elev2 = wordList[1]
                    
                    # setdefault() method returns the value of a key (if the key is in dictionary).
                    # If not, it inserts key with a value to the dictionary.
                    # This will start an empty list if the key is not present and then fill it.
                    self.eleviSup.setdefault(elev1, []).append(elev2)
                    self.eleviSup.setdefault(elev2, []).append(elev1)
                else: # am ajuns la mesaj
                    mes = 1
                if wordList[0] == 'mesaj:':
                    self.mesaj.append(wordList[1:]) # de forma ['elev1', '->', 'elev2']
                
       
        emit = self.mesaj[0][0] # numele emitatorului
        i, j = self.pozitie(emit)  # pozitia emitatorului  
        self.noduri.append(Nod([i, j], float('inf'))) # adaug nodul, costul este infinit
        
        
        rec = self.mesaj[0][2] # numele receptorului
        i, j = self.pozitie(rec) # pozitia receptorului 
        self.noduri.append(Nod([i, j], 0)) # adaug nod
        
        self.nod_start = self.noduri[0] # de tip Nod
        self.nod_scop = self.noduri[1].info # !!info
        
        self.N = len(self.elevi) # nr de elevi
        
        #nodurile pt ceilalti elevi
        for i in range(self.N): 
            for j in range(6): #cate 3 banci de 2 elevi
                if [i, j] == self.nod_start.info or [i, j] == self.nod_scop: 
                    continue
                else:
                    self.noduri.append(Nod([i, j], scop = self.nod_scop, N = self.N))
            
            
    def pozitie(self, elev):
        # returneaza pozitia elevului elev
        for i in range(len(self.elevi)):
            for j in range(6):
                if self.elevi[i][j] == elev:
                    return i, j
        return None
    
        
    def cauta_nod_nume(self, info):
        """Stiind doar informatia "info" a unui nod,
        trebuie sa returnati fie obiectul de tip Nod care are acea informatie,
        fie None, daca nu exista niciun nod cu acea informatie."""
        
        # info este de tip [i, j] cu pozitia in clasa
        for nod in self.noduri:
            if nod.info == info:
                return nod
        return None



""" Sfarsit definire problema """


""" Clase folosite in algoritmul A* """

class NodParcurgere:
    """O clasa care cuprinde informatiile asociate unui nod din listele open/closed
        Cuprinde o referinta catre nodul in sine (din graf)
        dar are ca proprietati si valorile specifice algoritmului A* (f si g).
        Se presupune ca h este proprietate a nodului din graf

    """

    problema = None   # atribut al clasei


    def __init__(self, nod_graf, parinte = None, g = 0, f = None):
        self.nod_graf = nod_graf    # obiect de tip Nod
        self.parinte = parinte      # obiect de tip Nod
        self.g = g      # costul drumului de la radacina pana la nodul curent
        if f is None :
            self.f = self.g + self.nod_graf.h 
        else:
            self.f = f


    def drum_arbore(self):
        """
            Functie care calculeaza drumul asociat unui nod din arborele de cautare.
            Functia merge din parinte in parinte pana ajunge la radacina
        """
        nod_c = self
        drum = [nod_c]
        while nod_c.parinte is not None :
            drum = [nod_c.parinte] + drum
            nod_c = nod_c.parinte
        return drum


    def contine_in_drum(self, nod):
        """
            Functie care verifica daca nodul "nod" se afla in drumul dintre radacina si nodul curent (self).
            Verificarea se face mergand din parinte in parinte pana la radacina
            Se compara doar informatiile nodurilor (proprietatea info)
            Returnati True sau False.

            "nod" este obiect de tip Nod (are atributul "nod.info")
            "self" este obiect de tip NodParcurgere (are "self.nod_graf.info")
        """
        nod_c = self
        while nod_c.parinte is not None :
            if nod.info == nod_c.nod_graf.info:
                return True
            nod_c = nod_c.parinte
        return False


    #se modifica in functie de problema
    def expandeaza(self):
        """Pentru nodul curent (self) parinte, trebuie sa gasiti toti succesorii (fiii)
        si sa returnati o lista de tupluri (nod_fiu, cost_muchie_tata_fiu),
        sau lista vida, daca nu exista niciunul.
        (Fiecare tuplu contine un obiect de tip Nod si un numar.)
        """

        l_succesori = []
        n = self.problema.N    # nr elevi
        elevi = self.problema.elevi # lista cu elevii din fisier
        i = self.nod_graf.info[0] # linia unde se afla elevul curent 
        j = self.nod_graf.info[1] # coloana unde se afla elevul curent 
        directii = [(1, 0), (0, 1), (-1, 0), (0, -1)] 
        
        for d in directii:
            i2 = i + d[0]
            j2 = j + d[1]
            
            # verific sa nu iasa din banci
            # n linii, 6 COLOANE (3 siruri de banci a cate 2 elevi)
            if i2 < 0 or j2 < 0 or i2 >= n or j2 >= 6: 
                continue
                
            # nu sunt pe aeeasi coloana de banci si nici in ultimele 2 banci, deci nu pot da biletul de pe un rand pe altul    
            if j2 // 2 != j // 2 and i < n-2: 
                continue
                
            # nu dau biletul unui loc liber    
            if elevi[i2][j2] == 'liber':
                continue
                
            # verific ca elevii sa nu fie suparati     
            if elevi[i][j] in self.problema.eleviSup: 
                if elevi[i2][j2] in self.problema.eleviSup[elevi[i][j]]:
                    continue
                    
            # dupa ce am verificat cazurile in care nu pot trimite biletul, caut numele elevului stiindu i noua pozitia i2,j2
            succ = self.problema.cauta_nod_nume([i2, j2]) #obiect de tip Nod care are info [i2, j2](pozitia)
            l_succesori.append((succ, 1)) # pun in lista, costul este 1
        return l_succesori
    

    #se modifica in functie de problema
    def test_scop(self):
        # verific daca informatia din nodul curent coincide cu scopul (la nod_scop am retinut info in class Problema)
        return self.nod_graf.info == self.problema.nod_scop



""" Algoritmul A* """


def str_info_noduri(l):
    """
        o functie folosita strict in afisari - poate fi modificata in functie de problema
    """

    sir = ""
    n = len(l)
    for idx in range(n): # pt fiecare element din lista 
        i = l[idx].nod_graf.info[0] # linia
        j = l[idx].nod_graf.info[1] # coloana
        sir += problema.elevi[i][j] + " " # afisez numele elevului
        
        if idx + 1 < n: #nu am ajuns la ultimul elev
            #pozitia urm elev
            iDest = l[idx + 1].nod_graf.info[0] # linia urmatoare 
            jDest = l[idx + 1].nod_graf.info[1] # coloana urmatore
            
            #pt randuri diferite (siruri de banci dif, de ex sirul de la geam si cel de la mijloc)
            if jDest//2 != j//2:
                if jDest//2 < j//2:  # biletul se deplaseaza spre stanga de pe un rand de banci pe altul cu <<
                    sir += '<< ' 
                else:        # biletul se deplaseaza spre dreapta de pe un rand de banci pe altul cu >>
                    sir += '>> '
            #se afla pe acelasi rand
            else: 
                if j < jDest:   #biletul se deplaseaza spre dr de pe acelasi rand
                    sir += '> ' 
                elif j > jDest: #biletul se deplaseaza spre stg de pe acelasi rand
                    sir += '< '
                elif i > iDest: #biletul se deplaseaza in sus de pe acelasi rand
                    sir += '^ '
                else:           #biletul se deplaseaza in jos de pe acelasi rand
                    sir += 'v '
    return sir


def in_lista(l, nod):
    """
        lista "l" contine obiecte de tip NodParcurgere
        "nod" este de tip Nod
        verific daca nod se afla in l
    """
    for i in range(len(l)):
        if l[i].nod_graf.info == nod.info:
            return l[i]
    return None


def a_star(inputFile, outputFile):
    """
        Functia care implementeaza algoritmul A-star
    """
        
    rad_arbore = NodParcurgere(NodParcurgere.problema.nod_start)
    open_ = [rad_arbore]  # open_ va contine elemente de tip NodParcurgere
    closed = []  # closed va contine elemente de tip NodParcurgere

    while len(open_) > 0 :
        nod_curent = open_.pop(0)    # scoatem primul element din lista open_
        closed.append(nod_curent)   # si il adaugam la finalul listei closed

        #testez daca nodul extras din lista open este nod scop (si daca da, ies din bucla while)
        if nod_curent.test_scop():
            break

        l_succesori = nod_curent.expandeaza()   # contine tupluri de tip (Nod, numar)
        for (nod_succesor, cost_succesor) in l_succesori:
            # "nod_curent" este tatal, "nod_succesor" este fiul curent

            # daca fiul nu e in drumul dintre radacina si tatal sau (adica nu se creeaza un circuit)
            if (not nod_curent.contine_in_drum(nod_succesor)):

                # calculez valorile g si f pentru "nod_succesor" (fiul)
                g_succesor = nod_curent.g + cost_succesor # g-ul tatalui + cost muchie(tata, fiu)
                f_succesor = g_succesor + nod_succesor.h # g-ul fiului + h-ul fiului

                #verific daca "nod_succesor" se afla in closed
                # (si il si sterg, returnand nodul sters in nod_parcg_vechi
                nod_parcg_vechi = in_lista(closed, nod_succesor)

                if nod_parcg_vechi is not None: # "nod_succesor" e in closed
                    # daca f-ul calculat pentru drumul actual este mai bun (mai mic) decat
                    #      f-ul pentru drumul gasit anterior (f-ul nodului aflat in lista closed)
                    # atunci actualizez parintele, g si f
                    # si apoi voi adauga "nod_nou" in lista open
                    if (f_succesor < nod_parcg_vechi.f):
                        closed.remove(nod_parcg_vechi)  # scot nodul din lista closed
                        nod_parcg_vechi.parinte = nod_curent # actualizez parintele
                        nod_parcg_vechi.g = g_succesor  # actualizez g
                        nod_parcg_vechi.f = f_succesor  # actualizez f
                        nod_nou = nod_parcg_vechi   # setez "nod_nou", care va fi adaugat apoi in open

                else :
                    # daca nu e in closed, verific daca "nod_succesor" se afla in open
                    nod_parcg_vechi = in_lista(open_, nod_succesor)

                    if nod_parcg_vechi is not None: # "nod_succesor" e in open
                        # daca f-ul calculat pentru drumul actual este mai bun (mai mic) decat
                        #      f-ul pentru drumul gasit anterior (f-ul nodului aflat in lista open)
                        # atunci scot nodul din lista open
                        #       (pentru ca modificarea valorilor f si g imi va strica sortarea listei open)
                        # actualizez parintele, g si f
                        # si apoi voi adauga "nod_nou" in lista open (la noua pozitie corecta in sortare)
                        if (f_succesor < nod_parcg_vechi.f):
                            open_.remove(nod_parcg_vechi)
                            nod_parcg_vechi.parinte = nod_curent
                            nod_parcg_vechi.g = g_succesor
                            nod_parcg_vechi.f = f_succesor
                            nod_nou = nod_parcg_vechi

                    else: # cand "nod_succesor" nu e nici in closed, nici in open
                        nod_nou = NodParcurgere(nod_graf=nod_succesor, parinte=nod_curent, g=g_succesor)
                        # se calculeaza f automat in constructor

                if nod_nou:
                    # inserare in lista sortata crescator dupa f
                    # (si pentru f-uri egale descrescator dupa g)
                    i=0
                    while i < len(open_):
                        if open_[i].f < nod_nou.f:
                            i += 1
                        else:
                            while i < len(open_) and open_[i].f == nod_nou.f and open_[i].g > nod_nou.g:
                                i += 1
                            break

                    open_.insert(i, nod_nou)
        
    
    with open(outputFile, 'w') as fout:
        fout.write("------------------ Concluzie -----------------------\n")
        fout.write("Pentru fisierul " + inputFile + " ")
        if len(open_) == 0:
            emitator = NodParcurgere.problema.mesaj[0][0]
            receptor = NodParcurgere.problema.mesaj[0][2]
            
            if emitator == receptor:
                fout.write("starea initiala este si finala.")
            else:
                fout.write("lista open e vida, nu avem drum de la nodul start la nodul scop. (prietenul nu scapa de farsa)")
        else:
            fout.write("drumul de cost minim este:\n" + str_info_noduri(nod_curent.drum_arbore())) 





if __name__ == "__main__":
    
    
    inputList = ['232_Lungu_Andrei_Lab6_Pb4_input_1.txt', \
                 '232_Lungu_Andrei_Lab6_Pb4_input_2.txt',\
                 '232_Lungu_Andrei_Lab6_Pb4_input_3.txt',\
                 '232_Lungu_Andrei_Lab6_Pb4_input_4.txt']
    outputList = ['output_1.txt', 'output_2.txt', 'output_3.txt', 'output_4.txt']
    n = 4
    for item in range(n):
        inputFile = inputList[item]
        outputFile = outputList[item]

        #preiau timpul in milisecunde de dinainte de algoritm
        t_inainte = int(round(time.time() * 1000))

        problema = Problema(inputFile)
        NodParcurgere.problema = problema
        a_star(inputFile, outputFile)

        #preiau timpul in milisecunde de dupa algoritm
        t_dupa = int(round(time.time() * 1000))

        with open(outputFile, "a") as fout:
            fout.write("\nAlgoritmul a durat: " + str(t_dupa - t_inainte) + " milisecunde\n")
    
# In input4.txt lista open e vida, nu avem drum de la nodul start la nodul scop.
# Mesajul trebuie sa ajunga de la ionel la elena. Ionel poate sa i dea biletul alinei sau lui george, insa george si ionel 
# sunt suparati intre ei, la fel si alina si ionel, deci biletul ramane blocat inca de la inceput
# Asezarea in banci a primelor 2 linii este urm:
# ionel alina teo eliza carmen monica
# george diana bob liber nadia mihai