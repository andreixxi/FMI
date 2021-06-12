--lab 4 PLSQL
SELECT *
FROM USER_OBJECTS
WHERE OBJECT_TYPE IN ('PROCEDURE','FUNCTION');

--1 Definiti un subprogram prin care s? obtineti salariul unui angajat al c?rui nume este specificat.
--Tratati toate exceptiile ce pot fi generate.
--Apelati subprogramul pentru urm?torii angajati: Bell, King, Kimball.
--Rezolvati problema folosind o functie local?.
DECLARE
     v_nume employees.last_name%TYPE := Initcap('&p_nume');   -- initcap face majuscula prima litera 
      FUNCTION f1 RETURN NUMBER IS
        salariu employees.salary%type; 
     BEGIN
            SELECT salary INTO salariu 
            FROM   employees
            WHERE  Initcap(last_name) = v_nume;
            RETURN salariu; -- VITAL 
      EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
            WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu numele dat');
            WHEN OTHERS THEN
                 DBMS_OUTPUT.PUT_LINE('Alta eroare!');
      END f1;
BEGIN
      DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1);
        EXCEPTION
          WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE
                    || ' si mesajul = ' || SQLERRM);
END;
/
--Bell, King, Kimball

--2 Rezolvati exercitiul 1 folosind o functie stocat?
CREATE OR REPLACE FUNCTION f2_alu
  (v_nume employees.last_name%TYPE DEFAULT 'Bell')    
RETURN NUMBER IS
    salariu employees.salary%type; 
BEGIN
        SELECT salary INTO salariu 
        FROM   employees
        WHERE  last_name = v_nume;
        RETURN salariu;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
        WHEN TOO_MANY_ROWS THEN
           RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
END f2_alu;
/
-- metode de apelare
-- bloc plsql
BEGIN
     DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_alu);
END;
/
BEGIN
      DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_alu('King'));
END;
/

-- SQL
  SELECT f2_alu FROM DUAL;
  SELECT f2_alu('King') FROM DUAL;
  
-- SQL*PLUS CU VARIABILA HOST
  VARIABLE nr NUMBER
  EXECUTE :nr := f2_alu('Bell');
  PRINT nr
  
  
  
-- 3  procedura locala
-- varianta 1
DECLARE
      v_nume employees.last_name%TYPE := Initcap('&p_nume');   
      PROCEDURE p3 IS 
          salariu employees.salary%TYPE;
          BEGIN
            SELECT salary INTO salariu 
            FROM   employees
            WHERE  last_name = v_nume;
            DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
          
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
            WHEN TOO_MANY_ROWS THEN
               DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu numele dat');
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('Alta eroare!');
     END p3;
BEGIN
    p3;
END;
/

-- varianta 2
DECLARE
      v_nume employees.last_name%TYPE := Initcap('&p_nume');  
      v_salariu employees.salary%type;
      PROCEDURE p3(salariu OUT employees.salary%type) IS --salariu out 
          BEGIN
            SELECT salary INTO salariu 
            FROM   employees
            WHERE  last_name = v_nume;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele dat');
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele dat');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
      END p3;
BEGIN
      p3(v_salariu); -- v_salariu = salariu OUT de la declarare
      DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/
 
--4 procedura stocata
-- varianta 1
CREATE OR REPLACE 
    PROCEDURE p4_alu(v_nume employees.last_name%TYPE)
  IS 
      salariu employees.salary%TYPE;
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| salariu);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p4_alu;
/

-- metode apelare
-- 1. Bloc PLSQL
BEGIN
  p4_alu('Bell');
END;
/

-- 2. SQL*PLUS
EXECUTE p4_alu('Bell');
EXECUTE p4_alu('King');
EXECUTE p4_alu('Kimball');

-- varianta 2
CREATE OR REPLACE PROCEDURE 
       p4_alu(v_nume IN employees.last_name%TYPE,
               salariu OUT employees.salary%type) IS 
  BEGIN
    SELECT salary INTO salariu 
    FROM   employees
    WHERE  last_name = v_nume;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
    WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
    WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
  END p4_alu;
/

-- metode apelare
-- Bloc PLSQL
DECLARE
   v_salariu employees.salary%type;
BEGIN
  p4_alu('Bell',v_salariu);
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| v_salariu);
END;
/

-- SQL*PLUS
VARIABLE v_sal NUMBER
EXECUTE p4_alu ('Bell',:v_sal)
PRINT v_sal

--5 Creati o procedur? stocat? care primeste printr-un parametru codul unui angajat si returneaz?
--prin intermediul aceluiasi parametru codul managerului corespunz?tor acelui angajat (parametru de tip IN OUT)
VARIABLE ang_man NUMBER
BEGIN
    :ang_man:=200;
END;
/

CREATE OR REPLACE PROCEDURE p5_alu  (nr IN OUT NUMBER) IS 
BEGIN
 SELECT manager_id INTO nr
 FROM employees
 WHERE employee_id = nr;
END p5_alu;
/

EXECUTE p5_alu (:ang_man) --se modifica la fiecare rulare 
PRINT ang_man

--6. Declarati o procedur? local? care are parametrii:
--- rezultat (parametru de tip OUT) de tip last_name din employees;
--- comision (parametru de tip IN) de tip commission_pct din employees, initializat cu NULL;
--- cod (parametru de tip IN) de tip employee_id din employees, initializat cu NULL.
--Dac? comisionul nu este NULL atunci în rezultat se va memora numele salariatului care are
--comisionul respectiv. În caz contrar, în rezultat se va memora numele salariatului al c?rui cod are
--valoarea dat? în apelarea procedurii.
DECLARE
    nume employees.last_name%TYPE;
    PROCEDURE p6 (rezultat OUT employees.last_name%TYPE,
                          comision IN  employees.commission_pct%TYPE:=NULL,
                          cod      IN  employees.employee_id%TYPE:=NULL) 
     IS
     BEGIN
         IF (comision IS NOT NULL) THEN
            SELECT last_name 
            INTO rezultat
            FROM employees
            WHERE commission_pct = comision;
            DBMS_OUTPUT.PUT_LINE('numele salariatului care are comisionul ' 
                                ||comision||' este '||rezultat);
         ELSE 
            SELECT last_name 
            INTO rezultat
            FROM employees
            WHERE employee_id = cod;
            DBMS_OUTPUT.PUT_LINE('numele salariatului avand codul ' ||cod||' este '||rezultat);
         END IF;
    END p6;

BEGIN
  p6(nume,0.4); -- un sng angajat cu comision 0.4, urm sunt echivalente in cazul asta 
--  p6(nume,0.4, null);
-- p6(nume,0.4, 200);
  p6(nume, cod=>200); -- => e un fel de egal, urm este echivalent
--  p6(nume, null, 200); 
END;
/

--7. overloading
--Definiti dou? functii locale cu acelati nume (overload) care s? calculeze media salariilor astfel:
--- prima functie va avea ca argument codul departamentului, adic? functia calculeaz? media
--salariilor din departamentul specificat;
--- a doua functie va avea dou? argumente, unul reprezentând codul departamentului, iar cel?lalt
--reprezentând job-ul, adic? functia va calcula media salariilor dintr-un anumit departament si
--care apartin unui job specificat.
DECLARE
      medie1 NUMBER(10,2);
      medie2 NUMBER(10,2);
      FUNCTION medie (v_dept employees.department_id%TYPE) 
      RETURN NUMBER IS
        rezultat NUMBER(10,2);
      BEGIN
            SELECT AVG(salary) 
            INTO   rezultat 
            FROM   employees
            WHERE  department_id = v_dept;
            RETURN rezultat;
     END;
  ------------------------------------- overloading/ nr diferiti de parametri
      FUNCTION medie (v_dept employees.department_id%TYPE,
                              v_job employees.job_id %TYPE) 
        RETURN NUMBER IS
        rezultat NUMBER(10,2);
      BEGIN
            SELECT AVG(salary) 
            INTO   rezultat 
            FROM   employees
            WHERE  department_id = v_dept AND job_id = v_job;
            RETURN rezultat;
      END;
BEGIN
      medie1:=medie(80);
      DBMS_OUTPUT.PUT_LINE('Media salariilor din departamentul 80' 
          || ' este ' || medie1);
      medie2 := medie(80,'SA_MAN');
      DBMS_OUTPUT.PUT_LINE('Media salariilor managerilor din'
          || ' departamentul 80 este ' || medie2);
END;
/

select * from employees where department_id = 80;
select * from employees where department_id = 80 and job_id = 'SA_MAN';

--8 Calculati recursiv factorialul unui num?r dat (recursivitate).
CREATE OR REPLACE FUNCTION factorial_alu(n NUMBER) 
 RETURN INTEGER 
 IS
 BEGIN
  IF (n=0) THEN RETURN 1;
  ELSE RETURN n*factorial_alu(n-1);
  END IF;
END factorial_alu;
/
declare
    n number :=&tast;
begin
    DBMS_OUTPUT.PUT_LINE('factorial ' ||to_char(n) || '!= ' || factorial_alu(n));
end;
/

--9. Afisati numele si salariul angajatilor al c?ror salariu este mai mare decât media tuturor
--salariilor. Media salariilor va fi obtinut? prin apelarea unei functii stocate
CREATE OR REPLACE FUNCTION medie_alu 
RETURN NUMBER 
IS 
rezultat NUMBER;
BEGIN
  SELECT AVG(salary) INTO  rezultat
  FROM   employees;
  RETURN rezultat;
END;
/
SELECT last_name,salary
FROM   employees
WHERE  salary >= medie_alu;

-- exercitii
--1.Creati tabelul info_*** cu urm?toarele coloane:
--- utilizator (numele utilizatorului care a initiat o comand?)
--- data (data si timpul la care utilizatorul a initiat comanda)
--- comanda (comanda care a fost initiat? de utilizatorul respectiv)
--- nr_linii (num?rul de linii selectate/modificate de comand?)
--- eroare (un mesaj pentru exceptii).
drop table info_alu;
create table info_alu ( utilizator varchar2(50),
                                data  varchar2(20), --TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS')
                                comanda varchar2(20),
                                nr_linii number,
                                eroare varchar2(50)
                                );
select * from info_alu;                     


--2. Modificati functia definit? la exercitiul 2, respectiv procedura definit? la exercitiul 4 astfel încât
--s? determine inserarea în tabelul info_*** a informatiile corespunz?toare fiec?rui caz
--determinat de valoarea dat? pentru parametru:
--- exist? un singur angajat cu numele specificat;
--- exist? mai multi angajati cu numele specificat;
--- nu exist? angajati cu numele specificat. 
CREATE OR REPLACE PROCEDURE ex2_alu
    (v_nume employees.last_name%TYPE)    
 IS
    salariu employees.salary%type; 
    nr number;
BEGIN
        SELECT max(salary), count(*) numar
        INTO salariu, nr
        FROM employees
        WHERE last_name = v_nume;
        
        if nr = 1 then        --nu a fost eroare
            insert  INTO info_alu
            values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda', nr, 'fara eroare');
        elsif nr = 0 then    -- eroare no_Data_found
             insert  INTO info_alu
             values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda', nr, 'Nu exista angajati cu numele dat');
        elsif nr > 1 then    -- TOO_MANY_ROWS
             insert  INTO info_alu
             values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda', nr, 'Exista mai multi angajati cu numele dat');
        else                    -- others
            insert  INTO info_alu
            values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda', nr, 'Alta eroare!');
        end if;
END ex2_alu;
/
begin
        ex2_alu ('Bell');
        ex2_alu('Kimball');
        ex2_alu('King');
end;
/
commit;
select * from info_alu;

--3. Definiti o functie stocat? care determin? num?rul de angajati care au avut cel putin 2 joburi
--diferite si care în prezent lucreaz? într-un oras dat ca parametru. Tratati cazul în care orasul dat
--ca parametru nu exist?, respectiv cazul în care în orasul dat nu lucreaz? niciun angajat. Inserati
--în tabelul info_*** informatiile corespunz?toare fiec?rui caz determinat de valoarea dat? pentru
--parametru. 
select employee_id, count(employee_id) as nr
from job_history j, departments d, locations l
where j.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
group by employee_id
order by employee_id;

select count(employee_id) as nr
from job_history j
--, departments d, locations l
--where j.department_id = d.department_id
--and d.location_id = l.location_id
--and l.city = 'Seattle'
group by employee_id
order by employee_id;

select * from job_history;
select * from departments;
select * from locations;

create or replace function ex3_alu
    (v_oras locations.city%type DEFAULT 'Seattle')
return number is
    numar_ang_2jobs number;
    begin
            select count(count(employee_id)) 
            into numar_ang_2jobs
            from job_history j, departments d, locations l
            where j.department_id = d.department_id
            and d.location_id = l.location_id
            and l.city = v_oras
            group by employee_id;
            return numar_ang_2jobs;
            
            --nu face if deloc
            if numar_ang_2jobs > 0 then
                insert  INTO info_alu
                values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', numar_ang_2jobs, 'fara eroare');
            elsif numar_ang_2jobs = 0 then
                insert  INTO info_alu
                values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 0, 'nu exista orasul');
            else 
                insert  INTO info_alu
                values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 0, ' alta eroare');
            end if;
    end ex3_alu;
/

declare 
    nr number;
    oras locations.city%type default 'Seattle';
begin
   DBMS_OUTPUT.PUT_LINE('nr de ang cu cel putin 2 joburi in seattle este ' || ex3_alu(oras));
    if ex3_alu(oras) > 0 then 
        insert  INTO info_alu
        values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 1, 'fara eroare');
    elsif ex3_alu(oras) = 0 then
            insert  INTO info_alu
            values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 0, 'nu exista orasul');
            end if;
            
    oras := 'orasel';
     DBMS_OUTPUT.PUT_LINE('nr de ang cu cel putin 2 joburi in orasel este ' || ex3_alu(oras));       
     if ex3_alu(oras) > 0 then 
        insert  INTO info_alu
        values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 1, 'fara eroare');
    elsif ex3_alu(oras) = 0 then
            insert  INTO info_alu
            values (user, TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS'), 'comanda cautare', 0, 'nu exista orasul');
            end if;
end;
/
select * from info_alu;
delete info_alu;

select count(count(employee_id)) as nr
from job_history j
, departments d, locations l
where j.department_id = d.department_id
and d.location_id = l.location_id
and l.city = 'Seattle'
group by employee_id
order by employee_id;