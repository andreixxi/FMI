--I. Pachete definite de utilizator
--1. Defini?i un pachet care permite prin intermediul a dou? func?ii calculul num?rului de angaja?i ?i
--suma ce trebuie alocat? pentru plata salariilor ?i a comisioanelor pentru un departament al c?rui
--cod este dat ca parametru.
CREATE OR REPLACE PACKAGE pachet1_alu AS
   FUNCTION  f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
   FUNCTION  f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
END pachet1_alu;
/
CREATE OR REPLACE PACKAGE BODY pachet1_alu AS
   FUNCTION  f_numar(v_dept  departments.department_id%TYPE) 
      RETURN NUMBER IS 
      numar NUMBER;
   BEGIN
      SELECT COUNT(*)
      INTO numar
      FROM   employees
      WHERE  department_id =v_dept;
   RETURN numar;
   END f_numar;

   FUNCTION  f_suma (v_dept  departments.department_id%TYPE) 
      RETURN NUMBER IS
      suma NUMBER;
   BEGIN
      SELECT SUM(salary+salary*NVL(commission_pct,0))
      INTO suma
      FROM employees
      WHERE department_id =v_dept;
   RETURN suma;
   END f_suma;
END pachet1_alu;
/
--apelare sql
SELECT pachet1_alu.f_numar(80)
FROM DUAL;
SELECT pachet1_alu.f_suma(80)
FROM DUAL;

--apelare pl/sql
BEGIN
  DBMS_OUTPUT.PUT_LINE('numarul de salariati este '||
                        pachet1_alu.f_numar(80));
  DBMS_OUTPUT.PUT_LINE('suma alocata este '||
                        pachet1_alu.f_suma(80));
END;
/

--2. Crea?i un pachet ce include ac?iuni pentru ad?ugarea unui nou departament în tabelul dept_*** ?i
--a unui nou angajat (ce va lucra în acest departament) în tabelul emp_***. Procedurile pachetului
--vor fi apelate din SQL, respectiv din PL/SQL. Se va verifica dac? managerul departamentului
--exist? înregistrat ca salariat. De asemenea, se va verifica dac? loca?ia departamentului exist?.
--Pentru inserarea codului salariatului se va utiliza o secven??.  
create sequence sec_alu;
select * from departments;
select * from employees;

CREATE OR REPLACE PACKAGE pachet2_alu AS
   PROCEDURE p_dept (v_codd dept_alu.department_id%TYPE,
                                 v_nume dept_alu.department_name%TYPE,
                                 v_manager dept_alu.manager_id%TYPE,
                                 v_loc dept_alu.location_id%TYPE);
   PROCEDURE p_emp (v_first_name emp_alu.first_name%TYPE,
                                 v_last_name emp_alu.last_name%TYPE,
                                 v_email emp_alu.email%TYPE,
                                 v_phone_number emp_alu.phone_number%TYPE:=NULL, 
                                 v_hire_date emp_alu.hire_date%TYPE :=SYSDATE,     
                                 v_job_id emp_alu.job_id%TYPE,        
                                 v_salary   emp_alu.salary%TYPE :=0,      
                                 v_commission_pct emp_alu.commission_pct%TYPE:=0,
                                 v_manager_id emp_alu.manager_id%TYPE,   
                                 v_department_id emp_alu.department_id%TYPE);

  FUNCTION exista (cod_loc dept_alu.location_id%TYPE, 
                            manager dept_alu.manager_id%TYPE) 
  RETURN NUMBER;
END pachet2_alu;
/

CREATE OR REPLACE PACKAGE BODY pachet2_alu AS

FUNCTION exista(cod_loc dept_alu.location_id%TYPE, 
                        manager dept_alu.manager_id%TYPE)
 RETURN NUMBER  IS 
      rezultat NUMBER:=1;
      rez_cod_loc NUMBER;
      rez_manager NUMBER;
 BEGIN
    SELECT count(*) 
    INTO   rez_cod_loc
    FROM   locations
    WHERE  location_id = cod_loc;
    
    SELECT count(*) 
    INTO   rez_manager
    FROM   emp_alu
    WHERE  employee_id = manager;
    
    IF rez_cod_loc=0 OR rez_manager=0 THEN 
         rezultat:=0;     
    END IF;
RETURN rezultat;
END;

PROCEDURE p_dept(v_codd dept_alu.department_id%TYPE,
                             v_nume dept_alu.department_name%TYPE,
                             v_manager dept_alu.manager_id%TYPE,
                             v_loc dept_alu.location_id%TYPE) IS
BEGIN
   IF exista(v_loc, v_manager)=0 THEN 
       DBMS_OUTPUT.PUT_LINE('Nu s-au introdus date coerente pentru tabelul dept_alu');
   ELSE
     INSERT INTO dept_alu -- creez departamentul nou
          (department_id,department_name,manager_id,location_id)
     VALUES (v_codd, v_nume, v_manager, v_loc);
   END IF;
 END p_dept;

PROCEDURE p_emp  (v_first_name emp_alu.first_name%TYPE,
                         v_last_name emp_alu.last_name%TYPE,
                         v_email emp_alu.email%TYPE,
                         v_phone_number emp_alu.phone_number%TYPE:=null, 
                         v_hire_date emp_alu.hire_date%TYPE :=SYSDATE,     
                         v_job_id emp_alu.job_id%TYPE,        
                         v_salary emp_alu.salary %TYPE :=0,      
                         v_commission_pct emp_alu.commission_pct%TYPE:=0,
                         v_manager_id emp_alu.manager_id%TYPE,   
                         v_department_id  emp_alu.department_id%TYPE)
AS
 BEGIN
     INSERT INTO emp_alu -- adaug un angajat nou
     VALUES (sec_alu.NEXTVAL, v_first_name, v_last_name, v_email,
            v_phone_number,v_hire_date, v_job_id, v_salary,
            v_commission_pct, v_manager_id,v_department_id);
END p_emp;
END pachet2_alu;
/

-- apelare SQL  
-- eroare, nu exista angajat cu id 2090
EXECUTE pachet2_alu.p_dept(50,'Economic',2090,2000);
EXECUTE pachet2_alu.p_dept(50,'Economic',200,2000);

SELECT * FROM dept_alu WHERE department_id=50;

-- => setez valoarea argumentului
EXECUTE pachet2_alu.p_emp('f','l','e',v_job_id=>'j',v_manager_id=>200,v_department_id=>50);

SELECT * FROM emp_alu WHERE job_id='j';

ROLLBACK;

--apel pl/sql
BEGIN
   pachet2_alu.p_dept(50,'Economic',99,2000);
   pachet2_alu.p_emp('f','l','e',v_job_id=>'j',v_manager_id=>200,v_department_id=>50);
END;
/

SELECT * FROM emp_alu WHERE job_id='j';
ROLLBACK;

--3. Defini?i un pachet cu ajutorul c?ruia s? se ob?in? salariul maxim înregistrat pentru salaria?ii care
--lucreaz? într-un anumit ora? ?i lista salaria?ilor care au salariul mai mare sau egal decât acel
--maxim. Pachetul va con?ine un cursor ?i un subprogram func?ie. 
CREATE  OR REPLACE PACKAGE pachet3_alu AS
   CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE; 
   FUNCTION  f_max  (v_oras  locations.city%TYPE) RETURN NUMBER;
END pachet3_alu;
/

CREATE OR REPLACE PACKAGE BODY pachet3_alu AS

CURSOR c_emp(nr NUMBER) RETURN employees%ROWTYPE  
      IS
      SELECT * 
      FROM employees 
      WHERE salary >= nr; 

FUNCTION  f_max (v_oras  locations.city%TYPE) RETURN NUMBER  IS
      maxim  NUMBER;
BEGIN
     SELECT  MAX(salary) 
     INTO    maxim  
     FROM    employees e, departments d, locations l
     WHERE   e.department_id=d.department_id 
             AND d.location_id=l.location_id 
             AND UPPER(city)=UPPER(v_oras);
    RETURN  maxim;
END f_max;
END pachet3_alu;
/

DECLARE
  oras    locations.city%TYPE:= 'Toronto';
  val_max NUMBER;
  lista   employees%ROWTYPE;
BEGIN
   val_max :=  pachet3_alu.f_max(oras); -- salariul maxim din orasul respectiv
   FOR v_cursor IN pachet3_alu.c_emp(val_max) LOOP
      DBMS_OUTPUT.PUT_LINE(v_cursor.last_name||' '||
                           v_cursor.salary);   
   END LOOP;
END;
/

--4.Defini?i un pachet care s? con?in? o procedur? prin care se verific? dac? o combina?ie specificat?
--dintre câmpurile employee_id ?i job_id este o combina?ie care exist? în tabelul employees. 

CREATE OR REPLACE  PACKAGE pachet4_alu IS
  PROCEDURE p_verific 
      (v_cod employees.employee_id%TYPE,
       v_job   employees.job_id%TYPE);
  CURSOR c_emp RETURN employees%ROWTYPE;  
END pachet4_alu;
/

CREATE OR REPLACE PACKAGE BODY pachet4_alu IS

CURSOR c_emp  RETURN employees%ROWTYPE  IS
       SELECT *
       FROM   employees;

PROCEDURE p_verific(v_cod   employees.employee_id%TYPE,
                    v_job   employees.job_id%TYPE)
                IS
                  gasit BOOLEAN:=FALSE;
                  lista employees%ROWTYPE;
                BEGIN
                      OPEN c_emp;
                      LOOP
                            FETCH c_emp INTO lista;
                            EXIT WHEN c_emp%NOTFOUND;
                            IF lista.employee_id=v_cod  AND lista.job_id=v_job   
                               THEN  gasit:=TRUE;
                            END IF;
                      END LOOP;
                      CLOSE c_emp;
                      IF gasit=TRUE THEN 
                         DBMS_OUTPUT.PUT_LINE('combinatia data exista');
                      ELSE  
                         DBMS_OUTPUT.PUT_LINE('combinatia data nu exista');
                      END IF;
                END p_verific;
END pachet4_alu;
/
   
EXECUTE pachet4_alu.p_verific(200,'AD_ASST');

--II. Pachete predefinite
--1
--1.1
DECLARE
-- paramentrii de tip OUT pt procedura GET_LINE
   linie1 VARCHAR2(255);
   stare1 INTEGER;
   linie2 VARCHAR2(255);
   stare2 INTEGER;
   linie3 VARCHAR2(255);
   stare3 INTEGER;

v_emp  employees.employee_id%TYPE;
v_job  employees.job_id%TYPE;
v_dept employees.department_id%TYPE;

BEGIN
  SELECT employee_id, job_id, department_id
  INTO   v_emp,v_job,v_dept
  FROM   employees
  WHERE  last_name='Lorentz';

-- se introduce o linie in buffer fara caracter 
-- de terminare linie
   DBMS_OUTPUT.PUT(' 1 '||v_emp|| ' ');

-- se incearca extragerea liniei introdusa 
-- in buffer si starea acesteia
   DBMS_OUTPUT.GET_LINE(linie1,stare1); 

-- se depune informatie pe aceeasi linie in buffer
   DBMS_OUTPUT.PUT(' 2 '||v_job|| ' ');

-- se inchide linia depusa in buffer si se extrage 
-- linia din buffer
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.GET_LINE(linie2,stare2); 

-- se introduc informatii pe aceeasi linie 
-- si se afiseaza informatia
   DBMS_OUTPUT.PUT_LINE(' 3 ' ||v_emp|| ' '|| v_job);
   DBMS_OUTPUT.GET_LINE(linie3,stare3); 

-- se afiseaza ceea ce s-a extras
   DBMS_OUTPUT.PUT_LINE('linie1 = '|| linie1||
                        '; stare1 = '||stare1);
   DBMS_OUTPUT.PUT_LINE('linie2 = '|| linie2||
                        '; stare2 = '||stare2);
   DBMS_OUTPUT.PUT_LINE('linie3 = '|| linie3||
                        '; stare3 = '||stare3);
END;
/ 

--1.2
DECLARE
-- parametru de tip OUT pentru NEW_LINES  
-- tablou de siruri de caractere
   linii DBMS_OUTPUT.CHARARR;
-- paramentru de tip IN OUT pentru NEW_LINES
   nr_linii INTEGER;

 v_emp  employees.employee_id%TYPE;
 v_job  employees.job_id%TYPE;
 v_dept employees.department_id%TYPE;

BEGIN
  SELECT employee_id, job_id, department_id
  INTO   v_emp,v_job,v_dept
  FROM   employees
  WHERE  last_name='Lorentz';

-- se mareste dimensiunea bufferului 
   DBMS_OUTPUT.ENABLE(1000000);
   DBMS_OUTPUT.PUT(' 1 '||v_emp|| ' ');
   DBMS_OUTPUT.PUT(' 2 '||v_job|| ' ');
   DBMS_OUTPUT.NEW_LINE;
   DBMS_OUTPUT.PUT_LINE(' 3 ' ||v_emp|| ' '|| v_job);
   DBMS_OUTPUT.PUT_LINE(' 4 ' ||v_emp|| ' '|| v_job||' ' ||v_dept);
-- se afiseaza ceea ce s-a extras
   nr_linii := 4;
   DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
   DBMS_OUTPUT.put_line('In buffer sunt '|| nr_linii ||' linii');
   FOR i IN 1..nr_linii LOOP
       DBMS_OUTPUT.put_line(linii(i));
   END LOOP;

--  nr_linii := 4;
--  DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
--  DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii ||' linii');
--   FOR i IN 1..nr_linii LOOP
--       DBMS_OUTPUT.put_line(linii(i));
--   END LOOP;
--
---- DBMS_OUTPUT.disable;
---- DBMS_OUTPUT.enable;
----  
---- nr_linii := 4;
---- DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
---- DBMS_OUTPUT.put_line('Acum in buffer sunt '|| nr_linii ||' linii');
END;
/ 


--2 Pachetul DBMS_JOB
CREATE OR REPLACE PROCEDURE marire_salariu_alu
     (id_angajat emp_alu.employee_id%type,
      valoare    number)
IS
BEGIN
  UPDATE emp_alu
  SET    salary = salary + valoare
  WHERE  employee_id = id_angajat; 
END;
/

--Varianta 1

VARIABLE nr_job NUMBER

BEGIN
 DBMS_JOB.SUBMIT(
    -- intoarce numarul jobului, printr-o variabila de legatura
    JOB => :nr_job,   
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_alu(100, 1000);', 
    
    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

SELECT salary FROM emp_alu WHERE employee_id = 100;
-- asteptati 10 de secunde
SELECT salary FROM emp_alu WHERE employee_id = 100;

-- numarul jobului
PRINT nr_job;

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_alu WHERE employee_id = 100;
BEGIN
   -- presupunand ca jobul are codul 1 atunci:
   DBMS_JOB.RUN(job => 1);
END;
/
SELECT salary FROM emp_alu WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(job=>1);
END;
/

SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

UPDATE emp_alu
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;

--Varianta 2

CREATE OR REPLACE PACKAGE pachet_job_alu
IS
  nr_job NUMBER;
  FUNCTION obtine_job RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE body pachet_job_alu
IS
  FUNCTION obtine_job RETURN NUMBER IS
  BEGIN
    RETURN nr_job;
  END;
END;
/

BEGIN
 DBMS_JOB.SUBMIT(
    --intoarve numarul jobului, printr-o variabila de legatura
    JOB => pachet_job_alu.nr_job,    
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_alu(100, 1000);', 

    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_alu.obtine_job;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_alu WHERE employee_id = 100;
BEGIN
   DBMS_JOB.RUN(JOB => pachet_job_alu.obtine_job);
END;
/
SELECT salary FROM emp_alu WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(JOB=>pachet_job_alu.obtine_job);
END;
/
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_alu.obtine_job;

UPDATE emp_alu
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;

--3. Pachetul UTL_FILE
--TEMA: urmati pasii spcificati in suportul de curs si rulati codul pe calculatorul personal


--Exemplu: Mentinem rezultatele unei comenzi SELECT intr-un fisier.

CREATE OR REPLACE PROCEDURE scriu_fisier_alu
                                                                     (director VARCHAR2,
                                                                      fisier VARCHAR2)
IS
      v_file UTL_FILE.FILE_TYPE;
      CURSOR cursor_rez IS
             SELECT department_id departament, SUM(salary) suma
             FROM employees
             GROUP BY department_id
             ORDER BY SUM(salary);
      v_rez cursor_rez%ROWTYPE;
BEGIN
     v_file:=UTL_FILE.FOPEN(director, fisier, 'w');
     UTL_FILE.PUTF(v_file, 'Suma salariilor pe departamente \n Raport generat pe data  ');
     UTL_FILE.PUT(v_file, SYSDATE);
     UTL_FILE.NEW_LINE(v_file);
     OPEN cursor_rez;
     LOOP
         FETCH cursor_rez INTO v_rez;
         EXIT WHEN cursor_rez%NOTFOUND;
         UTL_FILE.NEW_LINE(v_file);
         UTL_FILE.PUT(v_file, v_rez.departament);
         UTL_FILE.PUT(v_file, '         ');
         UTL_FILE.PUT(v_file, v_rez.suma);
     END LOOP;
     CLOSE cursor_rez;
     UTL_FILE.FCLOSE(v_file);
END;
/

SQL> EXECUTE scriu_fisier('F:\','test.txt');


--EXERCI?II
--1. Defini?i un pachet care s? permit? gestiunea angaja?ilor companiei. Pachetul va con?ine:
--a. o procedur? care determin? ad?ugarea unui angajat, dându-se informa?ii complete despre
--acesta:
--- codul angajatului va fi generat automat utilizându-se o secven??;
--- informa?iile personale vor fi date ca parametrii (nume, prenume, telefon, email);
--- data angaj?rii va fi data curent?;
--- nu va avea comision; (0 la inserare
CREATE OR REPLACE PACKAGE pachet_ex1 AS
   FUNCTION  intoarce_job (v_nume jobs.job_title%TYPE) 
        RETURN jobs.job_id%type;
    FUNCTION intoarce_dept (v_nume departments.department_name%type)
        RETURN departments.department_id%type;
    FUNCTION intoarce_mngr (v_nume employees.last_name%type,
                                        v_pren employees.first_name%type)
        RETURN employees.employee_id%type; 
    FUNCTION intoarce_sal (v_job_id employees.job_id%type,
                                    v_dept_id employees.department_id%type)
        RETURN employees.salary%type;
    PROCEDURE adauga_angajat(v_nume employees.last_name%type, 
                                          v_pren employees.first_name%type, 
                                          v_email employees.email%type,
                                          v_telefon employees.phone_number%type, 
                                          v_nume_mng employees.last_name%type, 
                                          v_pren_mng employees.first_name%type,
                                          v_nume_dep departments.department_name%type, 
                                          v_titlu_job jobs.job_title%type);
END pachet_ex1;
/

CREATE OR REPLACE PACKAGE BODY pachet_ex1 AS
   FUNCTION  intoarce_job(v_nume jobs.job_title%TYPE)  --- codul jobului va fi ob?inut cu ajutorul unei func?ii stocate în pachet, dându-se ca
      RETURN jobs.job_id%type IS                            --parametru numele acesteia. 
      cod_job jobs.job_id%type;
   BEGIN
        select job_id
        into cod_job
        from jobs
        where lower(job_title) = lower(v_nume);
        return cod_job;
   END intoarce_job;
   
    FUNCTION intoarce_dept(v_nume departments.department_name%type)
       RETURN departments.department_id%type is      --- codul departamentului va fi ob?inut cu ajutorul unei func?ii stocate în pachet, dându-se
       dept_id departments.department_id%type;          --ca parametru numele acestuia;
       begin
           select department_id
           into dept_id
           from departments
           where lower(department_name) = lower(v_nume);
           return dept_id;
       end intoarce_dept;
       
       FUNCTION intoarce_mngr (v_nume employees.last_name%type, v_pren employees.first_name%type)
       RETURN employees.employee_id%type is  --- codul managerului se va ob?ine cu ajutorul unei func?ii stocate în pachet care va avea ca
            mng_id employees.employee_id%type;   --parametrii numele ?i prenumele managerului);
        begin
            select employee_id
            into mng_id
            from employees
            where lower(last_name) = lower(v_nume) and lower(first_name) = lower(v_pren);
            return mng_id;
        end intoarce_mngr;
        
        FUNCTION intoarce_sal (v_job_id employees.job_id%type, v_dept_id employees.department_id%type)
         RETURN employees.salary%type is   --- salariul va fi cel mai mic salariu din departamentul respectiv, pentru jobul respectiv (se
            sal_minim employees.salary%type;   --vor ob?ine cu ajutorul unei func?ii stocate în pachet);
        begin
            select min(salary)
            into sal_minim
            from employees
            where lower(job_id) = lower(v_job_id)
            and department_id = v_dept_id;
            return sal_minim;
        end intoarce_sal;
        
         PROCEDURE adauga_angajat(v_nume employees.last_name%type, 
                                          v_pren employees.first_name%type, 
                                          v_email employees.email%type,
                                          v_telefon employees.phone_number%type, 
                                          v_nume_mng employees.last_name%type, 
                                          v_pren_mng employees.first_name%type,
                                          v_nume_dep departments.department_name%type, 
                                          v_titlu_job jobs.job_title%type) 
          IS
            cod_job jobs.job_id%type;
            cod_dep departments.department_id%type;
            cod_mng employees.employee_id%type;
            sal_min employees.salary%type;
        begin
            cod_job := intoarce_job(v_titlu_job);
            cod_dep := intoarce_dept(v_nume_dep);
            cod_mng := intoarce_mngr(v_nume_mng, v_pren_mng);
            sal_min := intoarce_sal(cod_job, cod_dep);
            
            insert into emp_alu 
            values (sec_alu.nextval, v_pren, v_nume, v_email, v_telefon, sysdate, cod_job, sal_min, 0, cod_mng, cod_dep);
        end adauga_angajat;
end pachet_ex1;
/

SELECT pachet_ex1.intoarce_job('President') FROM DUAL;
select pachet_ex1.intoarce_dept('administration') from dual;
select pachet_ex1.intoarce_mngr('king', 'steven') from dual;
select pachet_ex1.intoarce_sal('it_prog', 60) from dual;
/
begin
       pachet_ex1.adauga_angajat('nume', 'prenume', 'email', '12345', 'King', 'Steven', 'Sales', 'Sales Manager');
end;
/
select * from emp_alu;
