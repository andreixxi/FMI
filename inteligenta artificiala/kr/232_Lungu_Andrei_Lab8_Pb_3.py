"""
grupa 232
Lungu Andrei
!!! ALGORITMUL ESTE GRESIT SI INCOMPLET
"""
import time
import copy

class Joc:
    """
    Clasa care defineste jocul. Se va schimba de la un joc la altul.
    """
    NR_LINII = 8
    NR_COLOANE = 8
    SIMBOLURI_JUC = ['X', '0']
    JMIN = None
    JMAX = None
    GOL = '#'
    
    def __init__(self, tabla = None):
        if tabla is not None:
            self.matr = tabla
        else:
            self.matr = [[Joc.GOL for j in range(Joc.NR_COLOANE)] for i in range(Joc.NR_LINII)]
            # piesa alba/ 0
            self.matr[self.NR_LINII // 2 - 1][self.NR_COLOANE // 2 - 1] = self.SIMBOLURI_JUC[1] 
            self.matr[self.NR_LINII // 2][self.NR_COLOANE // 2] = self.SIMBOLURI_JUC[1] 
            # piesa neagra/ x
            self.matr[self.NR_LINII // 2][self.NR_COLOANE // 2 - 1] = self.SIMBOLURI_JUC[0]
            self.matr[self.NR_LINII // 2 - 1][self.NR_COLOANE // 2] = self.SIMBOLURI_JUC[0] 

        
    def inTabla(self, linie, coloana):
        """returneaza true daca pozitia face parte din tabla """
        return 0 <= linie < self.NR_LINII and 0 <= coloana < self.NR_COLOANE
   

    def final(self):
        # castiga jucatorul cu mai multe piese pe tabla
        nr_gol = 0
        nr_max = 0
        nr_min = 0
        
        for i in range(self.NR_LINII):
            for j in range(self.NR_COLOANE):
                if self.matr[i][j] == self.GOL:
                    nr_gol += 1
                    break
        
        # nu mai sunt pozitii libere pe tabla
        if nr_gol == 0:
            for i in range(self.NR_LINII):
                for j in range(self.NR_COLOANE):
                    if self.matr[i][j] == self.JMAX:
                        nr_max += 1
                    else:
                        nr_min += 1
        
            if nr_max > nr_min:
                return self.JMAX
            elif nr_max < nr_min:
                return self.JMIN
            else:
                return 'remiza'
        
        #daca nu s a terminat jocul
        return False

    
    def valid(self, jucator, linie, coloana):
        """verifica daca pozitia data este valida pt a pune o noua piesa
        daca da, returneaza o lista cu extremitatile tuturor liniilor formate"""
        
        juc_opus = Joc.JMIN if jucator == Joc.JMAX else Joc.JMAX
        
        extremitati = []
        
        directii = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]] # (x, y)

        for x, y in directii:
            linie_noua = linie + x
            coloana_noua = coloana + x
            
            if inTabla(linie_noua, coloana_noua):
                #nu pot forma linie pe o caseta goala
                if self.matr[linie_noua][coloana_noua] == self.GOL:
                    continue
                
                #nu pot pune 2 piese de aceeasi culoare una langa alta
                if self.matr[linie_noua][coloana_noua] == jucator:
                    continue
                
                while inTabla(linie_noua, coloana_noua) and self.matr[linie_noua][coloana_noua] == juc_opus:
                    linie_noua += x
                    coloana_noua += y
                
                if inTabla(linie_noua, coloana_noua) and self.matr[linie_noua][coloana_noua] == jucator:
                    extremitati.append([linie_noua, coloana_noua])

        return extremitati
    

    def mutari_posibile(self, jucator):
        """lista mutari posibile"""
        l_mutari = []
        
        for linie in range(self.NR_LINII):
            for coloana in range(self.NR_COLOANE):
                if self.matr[linie][coloana] == self.GOL:
                    extremitati = self.inTabla(jucator, linie, coloana)
                    if extremitati:
                        punct = [linie, coloana]
                        l_mutari.append([punct, extremitati])
                        
        return l_mutari

    
    def semn(x):
        if x < 0:
            return -1
        elif x > 0:
            return 1
        else:
            return 0
    
    
    def mutari(self, jucator, linie, coloana, extremitati):
        """aplica o mutare din lista"""
        
        matr_tabla_noua = copy.deepcopy(self.matr)
        
        for x, y in extremitati:
            directiaX = semn(x - linie)
            directiaY = semn(y - coloana)
            
            linie_noua = linie
            coloana_noua = coloana
            
            while linie_noua != x or coloana_noua != j:
                matr_tabla_noua[linie_noua][coloana_noua] = jucator
                linie_noua += directiaX
                coloana_noua += directiaY
                        
        return Joc(matr_tabla_noua)

    
    def fct_euristica(self, jucator):
        """nr de piese pt fiecare jucator"""
        nr = 0
        for linie in self.matr:
            for piesa in linie:
                if piesa == jucator:
                    nr += 1
        return nr


    def estimeaza_scor(self, adancime):
        t_final = self.final()
        if t_final == Joc.JMAX :
            return (999+adancime)
        elif t_final == Joc.JMIN:
            return (-999-adancime)
        elif t_final == 'remiza':
            return 0
        else:
            return self.fct_euristica()


    def __str__(self):
        sir = '  '
        for nr_col in range(self.NR_COLOANE):
            sir += str(nr_col) + ' '
        sir += '\n'

        for index, linie in enumerate(self.matr):
            sir += str(index) + ' '
            for coloana in linie:
                sir += str(coloana) + ' '
            sir += '\n'
        return sir

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
        self.tabla_joc = tabla_joc
        self.j_curent = j_curent

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
        sir= str(self.tabla_joc) + "(Juc curent: " + self.j_curent + ")\n"
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
        return stare #este intr-un interval invalid deci nu o mai procesez

    stare.mutari_posibile = stare.mutari()

    if stare.j_curent == Joc.JMAX :
        scor_curent = float('-inf')

        for mutare in stare.mutari_posibile:
            #calculeaza scorul
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
    # ?? TO DO:
    # de adagat parametru "pozitie", ca sa nu verifice mereu toata tabla,
    # ci doar linia, coloana, 2 diagonale pt elementul nou, de pe "pozitie"

    final = stare_curenta.tabla_joc.final()
    if(final):
        if (final == "remiza"):
            print("Remiza!")
        else:
            print("A castigat " + final)

        return True

    return False


""" 
def main():
    #initializare algoritm
    raspuns_valid = False
    while not raspuns_valid:
        tip_algoritm = input("Algorimul folosit? (raspundeti cu 1 sau 2)\n 1.Minimax\n 2.Alpha-beta\n ")
        if tip_algoritm in ['1','2']:
            raspuns_valid = True
        else:
            print("Nu ati ales o varianta corecta.")

    # initializare ADANCIME_MAX
    raspuns_valid = False
    while not raspuns_valid:
        n = input("Adancime maxima a arborelui: ")
        if n.isdigit():
            Stare.ADANCIME_MAX = int(n)
            raspuns_valid = True
        else:
            print("Trebuie sa introduceti un numar natural nenul.")


    # initializare jucatori
    [s1, s2] = Joc.SIMBOLURI_JUC.copy()  # lista de simboluri posibile
    raspuns_valid = False
    while not raspuns_valid:
        Joc.JMIN = str(input("Doriti sa jucati cu {} sau cu {}? ".format(s1, s2))).upper()
        if (Joc.JMIN in Joc.SIMBOLURI_JUC):
            raspuns_valid = True
        else:
            print("Raspunsul trebuie sa fie {} sau {}.".format(s1, s2))
    Joc.JMAX = s1 if Joc.JMIN == s2 else s2

    #initializare tabla
    tabla_curenta = Joc()
    print("Tabla initiala")
    print(str(tabla_curenta))

    #creare stare initiala
    stare_curenta = Stare(tabla_curenta, Joc.SIMBOLURI_JUC[0], Stare.ADANCIME_MAX)

    while True :
        mutari = stare_curenta.mutari_posibile(stare_curenta.j_curent)
        
        if not mutari:
            print("Joc terminat")
            print(f"Jucatorul {stare_curenta.jucator_opus} a castigat")
            break
        
        if (stare_curenta.j_curent == Joc.JMIN): #muta jucatorul
            print(stare_curenta)
            print("Introduce mutarea:")
            
            linie = map(int, input("linie= "))
            coloana = map(int, input("coloana= "))
            extremitati = stare_curenta.inTabla(Joc.JMIN, linie, coloana)
            
            if not extremitati:
                print("mutare gresita")
                continue
                
            stare_curenta = stare_curenta.mutari(Joc.JMIN, linie, coloana, extremitati)
    
        else: #jucatorul e JMAX (calculatorul)
        #Mutare calculator
        
            #preiau timpul in milisecunde de dinainte de mutare
            t_inainte = int(round(time.time() * 1000))
            if tip_algoritm == '1':
                stare_actualizata = min_max(stare_curenta)
            else: #tip_algoritm==2
                stare_actualizata = alpha_beta(-5000, 5000, stare_curenta)
            stare_curenta.tabla_joc = stare_actualizata.stare_aleasa.tabla_joc
            print("Tabla dupa mutarea calculatorului")
            print(str(stare_curenta))

            #preiau timpul in milisecunde de dupa mutare
            t_dupa = int(round(time.time() * 1000))
            print("Calculatorul a \"gandit\" timp de " + str(t_dupa - t_inainte) + " milisecunde.")

            if (afis_daca_final(stare_curenta)):
                break

            #S-a realizat o mutare. Schimb jucatorul cu cel opus
            stare_curenta.j_curent = stare_curenta.jucator_opus()


if __name__ == "__main__" :
        main()
"""