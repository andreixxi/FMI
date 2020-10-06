# grupa 232 Lungu Andrei
import copy
import time
import sys

def valoare(matrice, lin, col):
    """primeste linia si coloana din matrice si returneaza pozitia coresp din reprezentarea tablei
    de ex pt linia 1 coloana 0 va returna 0 (pozitia initiala a cainelui din mijloc)
          pt linia 2 coloana 3 va returna 9
    functioneaza doar pt cazul/tabla de joc de pe wiki"""
    if col == 0:
        return 0
    if col == 1:
        return lin + col
    if col == 2:
        return lin + col + 2
    if col == 3:
        return lin + col + 4
    if col == 4:
        return 10
    
    return None

def functie(matrice, x):
    """primeste o matrice in care este reprezentata tabla de joc cu pozitiile (numerotarea casetelor)
    pentru o anumita valoare din matrice returneaza linia si coloana pe care se afla
    functioneaza doar pt cazul/tabla de joc de pe wiki"""
    rez = None
    if x == 0:
        rez = (1, 0)
    if x in [1, 2, 3]:
        rez = (x-1, 1)
    if x in [4, 5, 6]:
        rez = (x-4, 2)
    if x in [7, 8, 9]:
        rez = (x-7, 3)
    if x == 10:
        rez = (1, 4)
    return rez

directii_caini = [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0)] # nu pot merge inapoi la caini
directii_iepure = [(-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1)]

class Joc:
    JMIN = None
    JMAX = None
    SIMBOLURI_JUC = ['c', 'i']
    NIMIC = '#' # nu pot muta aici 
    GOL = '*'
    NR_COLOANE = 5
    NR_LINII = 3
    
    def __init__(self, param = None):
        if param == 'afisare':
            self.tabla = [
                [self.NIMIC, 1, 4, 7, self.NIMIC],
                [0, 2, 5, 8, 10], 
                [self.NIMIC, 3, 6, 9, self.NIMIC]
            ]
        else:
            self.tabla = [
                [self.NIMIC, 'c', self.GOL, self.GOL, self.NIMIC],
                ['c', self.GOL, self.GOL, self.GOL, 'i'], 
                [self.NIMIC, 'c', self.GOL, self.GOL, self.NIMIC]
            ]
            self.pozitii = [0, 1, 3, 10] # primele 3 pozitii sunt pentru caini, ultima pentru iepure 
        
                 
    def mutari(self, jucator):
        """lista succesori"""
        l_mutari = []
        contor = 0
        
        for linie in range(self.NR_LINII):
            for coloana in range(self.NR_COLOANE):
                
                directii = None
                
                # caut pozitia unde se afla cainii/ iepurele
                if self.tabla[linie][coloana] == jucator and jucator == 'c': # este caine
                    directii = directii_caini
                elif self.tabla[linie][coloana] == jucator and jucator == 'i': # iepure
                    directii = directii_iepure

                if directii is not None: # am gasit un caine/ iepure
                    contor += 1 # ma opresc cand am gasit toate animalele
                    for directie in directii: # verific toate directiile posibile 
                        linie2 = linie + directie[0] 
                        coloana2 = coloana + directie[1]

                        if 0 <= linie2 < self.NR_LINII and 0 <= coloana2 < self.NR_COLOANE: # nu ies din matrice
                            if self.tabla[linie2][coloana2] == self.NIMIC: # '#' ajung intr un colt (unde nu este permis)
                                continue

                            if self.tabla[linie2][coloana2] == self.GOL: # '*' pozitia este libera 
                                matr_tabla_noua = copy.deepcopy(self.tabla) # copiez starea actuala
                                
                                if jucator == 'c': # la caini verific anumite miscari
                                    val1 = valoare(matr_tabla_noua, linie, coloana) # pozitia de dinainte de mutare
                                    val2 = valoare(matr_tabla_noua, linie2, coloana2) # pozitia de dupa mutare
                                    
                                    # verific directiile unde un caine nu se poate misca (de ex, de la 2 la 4) 
                                    if (val1 == 2 and val2 == 4) or (val1 == 2 and val2 == 6) \
                                    or (val1 == 4 and val2 == 8) or (val1 == 6 and val2 == 8):
                                        continue
                                    
                                matr_tabla_noua[linie2][coloana2] = jucator
                                matr_tabla_noua[linie][coloana] = self.GOL # se elibereaza pozitia 
                                l_mutari.append(Joc(matr_tabla_noua)) # adaug in lista
                            else: # nu este libera pozitia, verific alta mutare
                                continue
                        else: # iese din matrice, verific alta mutare
                            continue
                else: # nu am gasit un animal, merg la urm pozitie in matrice
                    continue
                if contor == 4:  # am calculat succesorii pentru toate animalele, nu mai are rost sa caut mai departe 
                    break
            if contor == 4:
                break
                
        return l_mutari
    
    def mutariPosibile(self, first, tip):
        """primeste pozitia initiala si tipul animalului (c sau i)
        calculeaza si returneaza lista de mutari valide
        functia este folosita in main pentru a valida mutarea jucatorului"""
        
        listaMutariPosibile = []
        directii = None
        if tip == 'c':
            directii = directii_caini
        else:
            directii = directii_iepure
         
        # o matrice auxiliara unde caut pozitia 'first', comparatiile vor fi in self.tabla(tabla curenta a jocului)
        matrice = [
                [self.NIMIC, 1, 4, 7, self.NIMIC],
                [0, 2, 5, 8, 10], 
                [self.NIMIC, 3, 6, 9, self.NIMIC]
            ]
        linie, coloana = functie(matrice, first) # returneaza linia si coloana corespunzatoare valorii first
        
        for directie in directii:
            linie2 = linie + directie[0]
            coloana2 = coloana + directie[1]

            if 0 <= linie2 < self.NR_LINII and 0 <= coloana2 < self.NR_COLOANE: # nu ies din matrice
                if self.tabla[linie2][coloana2] == self.NIMIC: # '#' ajung intr un colt (unde nu este permis)
                    continue
        
                if self.tabla[linie2][coloana2] == self.GOL: # '*' pozitia este libera 

                    val1 = first # pozitia de dinainte de mutare
                    val2 = valoare(matrice, linie2, coloana2) # pozitia de dupa mutare
                    if tip == 'c': # la caini verific anumite miscari
                        # verific directiile unde un caine nu se poate misca (de ex, de la 2 la 4) 
                        if (val1 == 2 and val2 == 4) or (val1 == 2 and val2 == 6) \
                        or (val1 == 4 and val2 == 8) or (val1 == 6 and val2 == 8):
                            continue
                    
                    listaMutariPosibile.append(val2) # pozitia unde pot face o mutare
                    
        return listaMutariPosibile
            
        
    def final(self):
        rez = False
        pozitieIepure = self.pozitii[-1] # ultima pozitia e a iepurelui
        pozitiiCaini = self.pozitii[:-1] # pozitiile cainelui(primele 3/ fara ultima)

        if pozitieIepure == 10 and set(pozitiiCaini) == {7, 8, 9}: # iepurele este incoltit
            rez = 'c'
        
        coordIepure = functie(self.tabla, pozitieIepure) # tuplu cu linia si coloana unde se afla iepurele
        ok = 1 # presupun ca a scapat iepurele
        for pozitie in pozitiiCaini:
            coordCaine = functie(self.tabla, pozitie) # tuplu cu linia si coloana unde se afla cainele
            if coordIepure[1] > coordCaine[1]: # iepurele inca se afla in fata unui caine (minim), nu a scapat inca
                ok = 0
                break
        
        if ok == 1: # iepurele a scapat
            rez = 'i'
        
        return rez
          
        
    def __str__(self):
        sir = '  '
        
        for nr_col in range(1, self.NR_COLOANE - 1):
            sir += (' '.join([str(self.tabla[0][nr_col])]) + '-')
        sir = sir[:-1] # sterg ultima cratima
        sir += '\n'
        
        sir += (''.join(' /' + '|' + '\\' + '|' + '/' + '|' + '\\' + '\n'))

        for nr_col in range(self.NR_COLOANE):
            sir += (' '.join([str(self.tabla[1][nr_col])]) + '-')
        sir = sir[:-1] # sterg ultima cratima
        sir += '\n'
        
        sir += (''.join(' \\' + '|' + '/' + '|' + '\\' + '|' + '/' + '\n  '))

        for nr_col in range(1, self.NR_COLOANE - 1):
            sir += (' '.join([str(self.tabla[2][nr_col])]) + '-')
        sir = sir[:-1]  
        
        return sir
    
    
    def estimeaza_scor(self, adancime):
        t_final = self.final()
        if t_final == Joc.JMAX :
            return (99 + adancime)
        elif t_final == Joc.JMIN:
            return (-99 - adancime)
        else:
            # TO DO.... 
            pozCaini = self.pozitii[:-1]
            pozIepure = self.pozitii[-1]
            linieI, coloanaI = functie(self.tabla, pozIepure) # linia si coloana unde se afla iepurele
            
            # suma distantelor pana castiga jucatorul; 
            # de ex iepurele trebuie sa ajunga cat mai aproape de coloana 0
            # cainii cat mai aproape de coloana 3
            suma = 4 - coloanaI
            
            #parcurg pozitiile la caini
            for poz in pozCaini:
                linieC, coloanaC = functie(self.tabla, poz) # linia si col unde se afla cainele de pe caseta 'poz'
                suma += coloanaC
            
            return suma
        
        #    metoda 2
#             maxi = 0
#             for poz in pozCaini:
#                 linieC, coloanaC = functie(self.tabla, poz)
#                 if coloanaC > maxi:
#                     maxi = coloanaC          
#             return coloanaI + maxi # suma dintre coloana iepurelui si cea mai indepartata coloana a cainilor
            

class Stare:
    """
    Clasa folosita de algoritmii minimax si alpha-beta
    Are ca proprietate tabla de joc
    Functioneaza cu conditia ca in cadrul clasei Joc sa fie definiti JMIN si JMAX (cei doi jucatori posibili)
    De asemenea cere ca in clasa Joc sa fie definita si o metoda numita mutari() care ofera lista cu
    configuratiile posibile in urma mutarii unui jucator
    """

    ADANCIME_MAX = None

    def __init__(self, tabla_joc, j_curent, adancime, parinte=None, scor=None):
        self.tabla_joc = tabla_joc # atribut de tip Joc => tabla_joc.tabla
        self.j_curent = j_curent   # simbol jucator curent

        #adancimea in arborele de stari
        self.adancime = adancime

        #scorul starii (daca e finala) sau al celei mai bune stari-fiice (pentru jucatorul curent)
        self.scor = scor

        #lista de mutari posibile din starea curenta
        self.mutari_posibile = []

        #cea mai buna mutare din lista de mutari posibile pentru jucatorul curent
        self.stare_aleasa = None
        

    def jucator_opus(self):
        if self.j_curent == Joc.JMIN:
            return Joc.JMAX
        else:
            return Joc.JMIN

    def mutari(self):
        l_mutari = self.tabla_joc.mutari(self.j_curent)
        juc_opus = self.jucator_opus()
        l_stari_mutari = [Stare(mutare, juc_opus, self.adancime - 1, parinte = self) for mutare in l_mutari]

        return l_stari_mutari


    def __str__(self):
        sir = str(self.tabla_joc) + "(Juc curent: " + self.j_curent + ")\n"
        return sir

""" Algoritmul MinMax """

def min_max(stare):

    if stare.adancime == 0 or stare.tabla_joc.final() :
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    #calculez toate mutarile posibile din starea curenta
    stare.mutari_posibile = stare.mutari()

    #aplic algoritmul minimax pe toate mutarile posibile (calculand astfel subarborii lor)
    mutari_scor = [min_max(mutare) for mutare in stare.mutari_posibile]

    if stare.j_curent == Joc.JMAX :
        #daca jucatorul e JMAX aleg starea-fiica cu scorul maxim
        stare.stare_aleasa = max(mutari_scor, key = lambda x: x.scor)
    else:
        #daca jucatorul e JMIN aleg starea-fiica cu scorul minim
        stare.stare_aleasa = min(mutari_scor, key = lambda x: x.scor)

    stare.scor = stare.stare_aleasa.scor
    return stare



def alpha_beta(alpha, beta, stare):
    if stare.adancime == 0 or stare.tabla_joc.final() :
        stare.scor = stare.tabla_joc.estimeaza_scor(stare.adancime)
        return stare

    if alpha >= beta:
        return stare # este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX :
        scor_curent = float('-inf')

        for mutare in stare.mutari_posibile:
            # calculeaza scorul
            stare_noua = alpha_beta(alpha, beta, mutare)

            if (scor_curent < stare_noua.scor):
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor
            if(alpha < stare_noua.scor):
                alpha = stare_noua.scor
                if alpha >= beta:
                    break

    elif stare.j_curent == Joc.JMIN :
        scor_curent = float('inf')

        for mutare in stare.mutari_posibile:
            stare_noua = alpha_beta(alpha, beta, mutare)

            if (scor_curent > stare_noua.scor):
                stare.stare_aleasa = stare_noua
                scor_curent = stare_noua.scor

            if(beta > stare_noua.scor):
                beta = stare_noua.scor
                if alpha >= beta:
                    break

    stare.scor = stare.stare_aleasa.scor

    return stare

def afis_daca_final(stare_curenta):
    final = stare_curenta.tabla_joc.final()
    if final:
#         if (final == "remiza"):
#             print("Remiza!")
#         else:
        print("A castigat " + final)
            
        return True
        
    return False

    
if __name__ == "__main__":
    
    #initializare algoritm
    raspuns_valid = False
    while not raspuns_valid:
        tip_algoritm = input("Algorimul folosit? (raspundeti cu 1 sau 2)\n 1.Minimax\n 2.Alpha-beta\n ")
        if tip_algoritm in ['1','2']:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")
           
    # initializare nivel dificultate + adancime arbore
    raspuns_valid = False
    while not raspuns_valid:
        nivel_dificultate = input("Nivel dificultate dorit? (raspundeti cu 1, 2 sau 3)\n1.Incepator\n2.Mediu\n3.Avansat\n")
        if nivel_dificultate in ['1', '2', '3']:
            raspuns_valid = True
            Stare.ADANCIME_MAX = 3 * int(nivel_dificultate) 
        else:
            print("Nu ati ales o varianta corecta.")
    
    # initializare jucatori
    [s1, s2] = Joc.SIMBOLURI_JUC.copy()  # lista de simboluri posibile
    raspuns_valid = False
    while not raspuns_valid:
        Joc.JMIN = str(input("Doriti sa jucati cu {} sau cu {}? ".format(s1, s2))) # human player
        if (Joc.JMIN in Joc.SIMBOLURI_JUC):
            raspuns_valid = True
        else:
            print("Raspunsul trebuie sa fie {} sau {}.".format(s1, s2))
    Joc.JMAX = s1 if Joc.JMIN == s2 else s2
    
    # tabla pt mutari
    tabla_goala = Joc('afisare')
    
    # initializare tabla
    tabla_curenta = Joc()
    
    # creare stare initiala
    stare_curenta = Stare(tabla_curenta, Joc.SIMBOLURI_JUC[0], Stare.ADANCIME_MAX) #simboluri_juc[0] -> cainii muta primii
    
    # mutare jucator
    before = -1 
    after = -1 
    while True:
        if (stare_curenta.j_curent == Joc.JMIN): # muta jucatorul
            
            print("Numerotare")
            print(str(tabla_goala)) # pt a alege de unde muta 
            print(str(stare_curenta)) # configuratia tablei
            
            #preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))
            
            raspuns_valid = False
            while not raspuns_valid:
                try:
                    pozitii_initiale = None
                    
                    if Joc.JMIN == 'c':
                        pozitii_initiale = stare_curenta.tabla_joc.pozitii[:-1] # pozitiile cainilor
                    else: 
                        pozitii_initiale = [stare_curenta.tabla_joc.pozitii[-1]] # pozitia iepurelui
                    
                    print("Alege animalul pe care il muti.", pozitii_initiale)
                    before = int(input("Introdu numarul pe care se afla animalul."))
                    
                    if before in pozitii_initiale: # am introdus o pozitie corecta
                        # functia mutariPosibile() primeste pozitia initiala si tipul animalului (c sau i)
                        # calculeaza si returneaza lista de mutari valide
                        alegeriPosibile = stare_curenta.tabla_joc.mutariPosibile(before, Joc.JMIN)  
                        print("Alege locul unde il muti. Poti muta in urmatoarele casete: ", alegeriPosibile)
                        after = int(input("Introdu numarul unde vrei sa muti."))
                        if after in alegeriPosibile:
                            raspuns_valid = True
                        elif after == "exit":
                            #afisare scor ...
                            break
                        else:
                            print("Nu este o mutare valida.")
                    elif before == "exit":
                        #afisare scor ...
                        break
                    else:
                        print("Nu ai ales bine animalul.")
                except ValueError:
                     print("Numarul animalului trebuie sa fie un numar intreg.")
                        
            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print("Jucatorul a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")    
            
            # dupa iesirea din while sigur am valide atat pozitia initiala cat si cea dupa mutare
            # deci pot plasa simbolul pe "tabla de joc"     
            linie, coloana = functie(stare_curenta.tabla_joc.tabla, before) # linia si coloana piesei inainte de mutare
            linie2, coloana2 = functie(stare_curenta.tabla_joc.tabla, after) # dupa mutare
            
            stare_curenta.tabla_joc.tabla[linie2][coloana2] = Joc.JMIN # fac mutarea
            stare_curenta.tabla_joc.tabla[linie][coloana] = Joc.GOL # eliberez caseta
            
            # actualizare pozitii dupa mutare
            if Joc.JMIN == 'c':
                for i in range(3): # primele 3 pozitii pentru caini
                    if stare_curenta.tabla_joc.pozitii[i] == before:
                        stare_curenta.tabla_joc.pozitii[i] = after
#                         break
            else: # este iepure
                stare_curenta.tabla_joc.pozitii[-1] = after # ultima valoare din vector este pt iepure
            
            #afisarea starii jocului in urma mutarii utilizatorului
            print("\nTabla dupa mutarea jucatorului")
            print(str(stare_curenta))
            
            # testez daca jocul a ajuns intr-o stare finala
            # si afisez un mesaj corespunzator in caz ca da
            if (afis_daca_final(stare_curenta)):
                break
                
            #S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = stare_curenta.jucator_opus()    
            
        else: #jucatorul e JMAX (calculatorul)
            #Mutare calculator

            # print("Tabla inainte de mutarea calculatorului")
            # print(str(stare_curenta))
            #preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))
            if tip_algoritm == '1':
                stare_actualizata = min_max(stare_curenta)
            else: 
                stare_actualizata = alpha_beta(-500, 500, stare_curenta)
                
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc ## nu se actualizeaza, nu face mutarea
            # de actualizat pozitiile animaleor dupa mutarea calculatorului
             
            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))
            
            # preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print("Calculatorul a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")
            
            if (afis_daca_final(stare_curenta)):
                break
                
            #S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = stare_curenta.jucator_opus()