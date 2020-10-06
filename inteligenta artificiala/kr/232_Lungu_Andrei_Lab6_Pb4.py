#!/usr/bin/env python
# coding: utf-8

# In[16]:


# Lungu Andrei 232 
""" definirea problemei """
class Nod:
    #de calculat euristica 
    def __init__(self, info, h = None, scop = None, N = None):
        #info este o lista de forma [i, j], unde i = numar linie, j = nr coloana
        self.info = info
        if h is not None:
            self.h = h
        else:
            """pt a calcula h:
               verific daca elevul curent si elevul scop se afla pe acelasi rand:
               -daca da, calculez dist folosind dist manhattan(nu tin cont de suparati sau locuri libere)
               -daca nu, calculez distanta pana la banca n-1/ n pt a putea transmite biletul la randul alaturat, 
                apoi dist manhattan"""
            
            self.h = 0
            rand_dest = scop[1] // 2 #randul unde trb sa ajunga mesajul
            rand_curr = info[1] // 2
            
            if rand_curr != rand_dest:
                if rand_curr < N-2: #nu se afla in ultimele 2 randuri(banci)
                    self.h += N - 2 - info[0] #distanta pana la randul n-2 (penultimul)
                    poz = N - 2
                else:
                    poz = info[0]
            else:
                poz = info[0]
                
            self.h += abs(poz - scop[0]) + abs(info[1] - scop[1])

            
    def __str__ (self):
        return "({}, h={})".format(self.info, self.h)

    def __repr__ (self):
        return f"({self.info}, h={self.h})"


class Arc:
    def __init__(self, capat, varf, cost):
        self.capat = capat
        self.varf = varf
        self.cost = cost

class Problema:
    def __init__(self):
        self.elevi = []
        self.eleviSup = {}
        self.mesaj = []
        self.noduri = []
        
        with open('date.in', 'r') as fin:
            sup = 0
            mes = 0
            
            for line in (fin):
                wordList = line.split()
                if wordList[0] != 'suparati' and sup == 0:
                    self.elevi.append(wordList)
                else:
                    sup = 1
                if wordList[0] != 'mesaj:' and wordList[0] != 'suparati' and sup == 1:
                    self.eleviSup[wordList[0]] = wordList[1] #dictionar cu elevii suparati
                else:
                    mes = 1
                if wordList[0] == 'mesaj:':
                    self.mesaj.append(wordList[1:]) #de forma ['elev1', '->', 'elev2']
                
        #pozitia emitatorului  
        emit = self.mesaj[0][0]
        i, j = self.pozitie(emit) 
        self.noduri.append(Nod([i, j], float('inf')))
        
        #pozitia receptorului 
        rec = self.mesaj[0][2]
        i, j = self.pozitie(rec) 
        self.noduri.append(Nod([i, j], 0))
        
        self.nod_start = self.noduri[0] #de tip Nod
        self.nod_scop = self.noduri[1].info #info
        
        self.N = len(self.elevi) # nr de banci(linii)
        
        #nodurile pt ceilalti elevi
        for i in range(self.N):
            for j in range(6): #cate 2 elevi pe 3siruri
                if [i, j] == self.nod_start.info or [i, j] == self.nod_scop:
                    continue
                else:
                    self.noduri.append(Nod([i, j], scop = self.nod_scop, N = self.N))
                

    def pozitie(self, elev):
        #returneaza pozitia elevului elev
        for i in range(len(self.elevi)):
            for j in range(6):
                if self.elevi[i][j] == elev:
                    return i, j
        return None
    
        
    def cauta_nod_nume(self, info):
        """Stiind doar informatia "info" a unui nod,
        trebuie sa returnati fie obiectul de tip Nod care are acea informatie,
        fie None, daca nu exista niciun nod cu acea informatie."""
        ### TO DO ... DONE
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

    problema=None   # atribut al clasei


    def __init__(self, nod_graf, parinte=None, g=0, f=None):
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
        ### TO DO ... DONE
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
        ### TO DO ... DONE
        l_succesori = []
        n = self.problema.N
        elevi = self.problema.elevi
        i = self.nod_graf.info[0]
        j = self.nod_graf.info[1]
        directii = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        
        for d in directii:
            i2 = i + d[0]
            j2 = j + d[1]
            #sa nu iasa din banci
            if i2 < 0 or j2 < 0 or i2 >= n or j2 >= 6: #maxim n linii, 6 COLOANE (3 siruri de banci a cate 2 elevi)
                continue
            if j2 // 2 != j // 2 and i < n-2: # nu sunt in ultimele 2 banci, deci nu pot da biletul
                continue
            if elevi[i2][j2] == 'liber':
                continue
            if elevi[i][j] in self.problema.eleviSup: 
                if elevi[i2][j2] == self.problema.eleviSup[elevi[i][j]]:
                    continue
            succ = self.problema.cauta_nod_nume([i2, j2])
            l_succesori.append((succ, 1))
        return l_succesori
    

    #se modifica in functie de problema
    def test_scop(self):
        return self.nod_graf.info == self.problema.nod_scop


    def __str__ (self):
        parinte=self.parinte if self.parinte is None else self.parinte.nod_graf.info
        return f"({self.nod_graf}, parinte={parinte}, f={self.f}, g={self.g})"



""" Algoritmul A* """


def str_info_noduri(l):
    """
        o functie folosita strict in afisari - poate fi modificata in functie de problema
    """
#     sir = "["
#     for x in l:
#         sir += str(x) + "  "
#     sir += "]"
#     return sir

    sir = ""
    n = len(l)
    for t in range(n):
        i = l[t].nod_graf.info[0] #linia
        j = l[t].nod_graf.info[1] #coloana
        sir += problema.elevi[i][j] + " "
        
        if t+1 < n:
            #pozitia urm elev
            iDest = l[t+1].nod_graf.info[0]
            jDest = l[t+1].nod_graf.info[1]
            
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


def afis_succesori_cost(l):
    """
        o functie folosita strict in afisari - poate fi modificata in functie de problema
    """
    sir = ""
    for (x, cost) in l:
        sir += "\nnod: "+str(x)+", cost arc:"+ str(cost)
    return sir


def in_lista(l, nod):
    """
        lista "l" contine obiecte de tip NodParcurgere
        "nod" este de tip Nod
    """
    for i in range(len(l)):
        if l[i].nod_graf.info == nod.info:
            return l[i]
    return None


def a_star():
    """
        Functia care implementeaza algoritmul A-star
    """
    ### TO DO ... DONE

    rad_arbore = NodParcurgere(NodParcurgere.problema.nod_start)
    open = [rad_arbore]  # open va contine elemente de tip NodParcurgere
    closed = []  # closed va contine elemente de tip NodParcurgere

    while len(open) > 0 :
        #print(str_info_noduri(open))    # afisam lista open
        nod_curent = open.pop(0)    # scoatem primul element din lista open
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
                    nod_parcg_vechi = in_lista(open, nod_succesor)

                    if nod_parcg_vechi is not None: # "nod_succesor" e in open
                        # daca f-ul calculat pentru drumul actual este mai bun (mai mic) decat
                        #      f-ul pentru drumul gasit anterior (f-ul nodului aflat in lista open)
                        # atunci scot nodul din lista open
                        #       (pentru ca modificarea valorilor f si g imi va strica sortarea listei open)
                        # actualizez parintele, g si f
                        # si apoi voi adauga "nod_nou" in lista open (la noua pozitie corecta in sortare)
                        if (f_succesor < nod_parcg_vechi.f):
                            open.remove(nod_parcg_vechi)
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
                    while i < len(open):
                        if open[i].f < nod_nou.f:
                            i += 1
                        else:
                            while i < len(open) and open[i].f == nod_nou.f and open[i].g > nod_nou.g:
                                i += 1
                            break

                    open.insert(i, nod_nou)


    print("\n------------------ Concluzie -----------------------")
    if len(open) == 0:
        print("Lista open e vida, nu avem drum de la nodul start la nodul scop")
    else:
        print("Drum de cost minim: " + str_info_noduri(nod_curent.drum_arbore()))





if __name__ == "__main__":
    problema = Problema()
    NodParcurgere.problema = problema
    a_star()


# In[73]:


# with open('date.in', 'r') as fin:
#     elevi = []
#     eleviSup = []
#     mesaj = []
#     sup = 0
#     mes = 0
#     for line in (fin):
#         wordList = line.split()
#         if wordList[0] != 'suparati' and sup == 0:
#             elevi.append(wordList)
#         else:
#             sup = 1
#         if wordList[0] != 'mesaj:' and wordList[0] != 'suparati' and sup == 1:
#             eleviSup.append(wordList)
#         else:
#             mes = 1
#         if wordList[0] == 'mesaj:':
#             mesaj.append(wordList[1:])


# In[80]:


# print(*elevi, sep = '\n')
# print(*eleviSup, sep = '\n')
# print(*mesaj, sep = '\n')
# mesaj[0][0]

