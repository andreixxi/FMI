--1. Definiti un declansator care sa permita lucrul asupra tabelului emp_alu (INSERT, UPDATE,
--DELETE) decât în intervalul de ore 8:00 - 20:00, de luni pân? sâmb?t? (declansator la nivel
--de instructiune).
CREATE OR REPLACE TRIGGER trig1_alu
      BEFORE INSERT OR UPDATE OR DELETE ON emp_alu
BEGIN
     IF (TO_CHAR(SYSDATE, 'D') = 1)  --duminica
     OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 8 AND 20) --ora nu e ok
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'tabelul nu poate fi actualizat');
     END IF;
END;
/
select TO_CHAR(SYSDATE,'HH24') from dual;
select (TO_CHAR(SYSDATE, 'D')) from dual;
delete from emp_alu where employee_id < 102;
rollback;
DROP TRIGGER trig1_alu;

--2 Definiti un declansator prin care sa nu se permita micsorarea salariilor angajatilor din tabelul
--emp_alu (declansator la nivel de linie).
--Varianta 1
CREATE OR REPLACE TRIGGER trig21_alu
      BEFORE UPDATE OF salary ON emp_alu
      FOR EACH ROW -- declansator la nivel de linie deci folosesc for each row
    BEGIN
          IF (:NEW.salary < :OLD.salary) THEN 
                 RAISE_APPLICATION_ERROR(-20002, 'salariul nu poate fi micsorat');
          END IF;
    END;
/

UPDATE emp_alu
SET    salary = salary-100;

DROP TRIGGER trig21_alu;

--Varianta 2
CREATE OR REPLACE TRIGGER trig22_alu
  BEFORE UPDATE OF salary ON emp_alu
  FOR EACH ROW
  WHEN (NEW.salary < OLD.salary)
BEGIN
    RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END;
/

UPDATE emp_alu
SET    salary = salary-100;
DROP TRIGGER trig22_alu;

--3.Creati un declansator care sa nu permita marirea limitei inferioare a grilei de salarizare 1,
--respectiv micsorarea limitei superioare a grilei de salarizare 7 decât daca toate salariile se
--gasesc în intervalul dat de aceste doua valori modificate. Se va utiliza tabelul job_grades_alu
create table job_grades_alu as select * from job_grades;
select * from job_grades_alu;

select min(salary), max(salary)
from emp_alu;

CREATE OR REPLACE TRIGGER trig3_alu
  BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_alu
  FOR EACH ROW
DECLARE
     v_min_sal  emp_alu.salary%TYPE;
     v_max_sal  emp_alu.salary%TYPE;
     exceptie EXCEPTION;
     exceptie1 EXCEPTION;
     exceptie2 EXCEPTION;
BEGIN
      SELECT MIN(salary), MAX(salary)
      INTO   v_min_sal, v_max_sal
      FROM   emp_alu;
      
      IF (:OLD.grade_level=1) AND  (v_min_sal< :NEW.lowest_sal)  -- nu pot pune limita inferioara mai mare decat cel mai prost platit angajat
         THEN RAISE exceptie1;
      END IF;
      
      IF (:OLD.grade_level=7) AND  (v_max_sal> :NEW.highest_sal)  -- nu pot pune limita superioara mai mica decat cel mai bine platit angajat
         THEN RAISE exceptie;
      END IF;
      
      IF (:NEW.lowest_sal > :OLD.highest_sal) OR (:old.lowest_sal > :new.highest_sal)
        then raise exceptie2;
      end if;
      
    EXCEPTION
      WHEN exceptie1 THEN
        RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului(lim_inf)'); 
      WHEN exceptie THEN
        RAISE_APPLICATION_ERROR (-20003, 'Exista salarii care se gasesc in afara intervalului(lim_sup)'); 
      when exceptie2 then
        RAISE_APPLICATION_ERROR (-20003, 'update fara sens'); 
            
END;
/

UPDATE job_grades_alu 
SET    lowest_sal =3000
WHERE  grade_level=1;

UPDATE job_grades_alu
SET    highest_sal =20000  -- :old.grade_level = 7  :old.highest_salary = 99000
WHERE  grade_level=7;     --                           :new.highest_salary = 20000

UPDATE job_grades_alu 
SET    highest_sal =3000
WHERE  grade_level=3;

DROP TRIGGER trig3_alu;

--4. a. Creati tabelul info_dept_alu cu urm?toarele coloane:
--- id (codul departamentului) – cheie primara;
--- nume_dept (numele departamentului);
--- plati (suma alocat? pentru plata salariilor angajatilor care lucreaz? în departamentul respectiv).
create table info_dept_alu (
            id number(3) primary key,
            nume_dept varchar2(50),
            plati number
            );

--b. Introduceti date în tabelul creat anterior corespunz?toare informatiilor existente în schem?.
insert into info_dept_alu
    (select d.department_id, d.department_name, nvl(sum(salary), 0)
    from employees e, departments d
    where e.department_id(+) = d.department_id
    group by d.department_id, d.department_name);

select * from info_dept_alu 
order by id;
--select * from departments;
--delete from info_dept_alu;

--c. Definiti un declansator care va actualiza automat câmpul plati atunci când se introduce un
--nou salariat, respectiv se sterge un salariat sau se modifica salariul unui angajat.
CREATE OR REPLACE PROCEDURE modific_plati_alu
          (v_codd  info_dept_alu.id%TYPE,
           v_plati info_dept_alu.plati%TYPE) AS
BEGIN
  UPDATE  info_dept_alu
  SET       plati = NVL (plati, 0) + v_plati
  WHERE   id = v_codd;
END;
/

CREATE OR REPLACE TRIGGER trig4_alu
  AFTER DELETE OR UPDATE  OR  INSERT OF salary ON emp_alu
  FOR EACH ROW
BEGIN
      IF DELETING THEN  --deleting 
         -- se sterge un angajat
         modific_plati_alu (:OLD.department_id, -1*:OLD.salary);
      ELSIF UPDATING THEN  --updating
        --se modifica salariul unui angajat
        modific_plati_alu(:OLD.department_id, :NEW.salary - :OLD.salary);  
      ELSE  --inserting
        -- se introduce un nou angajat
        modific_plati_alu(:NEW.department_id, :NEW.salary);
      END IF;
END;
/

SELECT * FROM  info_dept_alu WHERE id=90; --58000 plati

INSERT INTO emp_alu (employee_id, last_name, email, hire_date, 
                     job_id, salary, department_id) 
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);

SELECT * FROM  info_dept_alu WHERE id=90; --60000 plati

UPDATE emp_alu
SET    salary = salary + 1000
WHERE  employee_id=300;

SELECT * FROM  info_dept_alu WHERE id=90; -- 61000 plati

DELETE FROM emp_alu
WHERE  employee_id=300;   

SELECT * FROM  info_dept_alu WHERE id=90; --58000 plati (valoarea initiala, fara angajatul sters anterior)

DROP TRIGGER trig4_alu;

--5.a. Creati tabelul info_emp_alu cu urmatoarele coloane:
--- id (codul angajatului) – cheie primara;
--- nume (numele angajatului);
--- prenume (prenumele angajatului);
--- salariu (salariul angajatului);
--- id_dept (codul departamentului) – cheie externa care refera tabelul info_dept_alu
create table info_emp_alu (
    id number(3) primary key,
    nume varchar2(50),
    prenume varchar2(50),
    salariu number(6),
    id_dept number(3) references info_dept_alu(id)
    );
    
-- b. Introduceti date în tabelul creat anterior corespunz?toare informatiilor existente în schem?.
insert into info_emp_alu
select e.employee_id, e.last_name, e.first_name, e.salary, e.department_id
from employees e;

--c. Creati vizualizarea v_info_alu care va contine informatii complete despre angajati si
--departamentele acestora. Folositi cele dou? tabele create anterior, info_emp_alu, respectiv
--info_dept_alu.
CREATE OR REPLACE VIEW v_info_alu AS
  SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, 
         d.nume_dept, d.plati 
  FROM   info_emp_alu e, info_dept_alu d
  WHERE  e.id_dept = d.id;

-- d. Se pot realiza actualiz?ri asupra acestei vizualiz?ri? Care este tabelul protejat prin cheie?
--Consultati vizualizarea user_updatable_columns.
SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_alu');

--e. Definiti un declansator prin care actualizarile ce au loc asupra vizualizarii se propaga
--automat în tabelele de baza (declansator INSTEAD OF). Se considera ca au loc
--urmatoarele actualizari asupra vizualizarii:
--- se adaug? un angajat într-un departament deja existent;
--- se elimin? un angajat;
--- se modific? valoarea salariului unui angajat;
--- se modific? departamentul unui angajat (codul departamentului).
CREATE OR REPLACE TRIGGER trig5_alu
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_alu
    FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        -- inserarea in vizualizare determina inserarea 
        -- in info_emp_alu si reactualizarea in info_dept_alu
        -- se presupune ca departamentul exista
       INSERT INTO info_emp_alu 
       VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
         
       UPDATE info_dept_alu
       SET    plati = plati + :NEW.salariu
       WHERE  id = :NEW.id_dept;
    
    ELSIF DELETING THEN
       -- stergerea unui salariat din vizualizare determina
       -- stergerea din info_emp_alu si reactualizarea in
       -- info_dept_alu
       DELETE FROM info_emp_alu
       WHERE  id = :OLD.id;
         
       UPDATE info_dept_alu
       SET    plati = plati - :OLD.salariu
       WHERE  id = :OLD.id_dept;
    
    ELSIF UPDATING ('salariu') THEN
       /* modificarea unui salariu din vizualizare determina 
          modificarea salariului in info_emp_alu si reactualizarea
          in info_dept_alu    */
            
       UPDATE  info_emp_alu
       SET     salariu = :NEW.salariu
       WHERE   id = :OLD.id;
            
       UPDATE info_dept_alu
       SET    plati = plati - :OLD.salariu + :NEW.salariu
       WHERE  id = :OLD.id_dept;
    
    ELSIF UPDATING ('id_dept') THEN
        /* modificarea unui cod de departament din vizualizare
           determina modificarea codului in info_emp_alu 
           si reactualizarea in info_dept_alu  */  
        UPDATE info_emp_alu
        SET    id_dept = :NEW.id_dept
        WHERE  id = :OLD.id;
        
        UPDATE info_dept_alu
        SET    plati = plati - :OLD.salariu
        WHERE  id = :OLD.id_dept;
            
        UPDATE info_dept_alu
        SET    plati = plati + :NEW.salariu
        WHERE  id = :NEW.id_dept;
      END IF;
END;
/

SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_alu');

SELECT * FROM  info_dept_alu WHERE id=10; -- plati 4400

-- adaugarea unui nou angajat
INSERT INTO v_info_alu 
VALUES (400, 'N1', 'P1', 3000,10, 'Nume dept', 0); -- salariu 3000

SELECT * FROM  info_emp_alu WHERE id=400;
SELECT * FROM  info_dept_alu WHERE id=10; -- 7400 plati

-- modificarea salariului unui angajat
UPDATE v_info_alu
SET    salariu=salariu + 1000
WHERE  id=400;

SELECT * FROM  info_emp_alu WHERE id=400; --4000 salariu
SELECT * FROM  info_dept_alu WHERE id=10; --8400 plati

-- modificarea departamentului unui angajat
SELECT * FROM  info_dept_alu WHERE id=90; --plati 58000

UPDATE v_info_alu
SET    id_dept=90
WHERE  id=400;

SELECT * FROM  info_emp_alu WHERE id=400;
SELECT * FROM  info_dept_alu WHERE id IN (10,90); -- id 10 : plati 4000, 90 : 62000

-- eliminarea unui angajat
DELETE FROM v_info_alu WHERE id = 400;
SELECT * FROM  info_emp_alu WHERE id=400; -- nimic pt ca a fost sters
SELECT * FROM  info_dept_alu WHERE id = 90; -- plati 58000 

DROP TRIGGER trig5_alu;

--6. Defint?i un declansator care sa nu se permita stergerea informatiilor din tabelul emp_alu de
--catre utilizatorul grupaalu. 
select user from dual;

CREATE OR REPLACE TRIGGER trig6_alu
  BEFORE DELETE ON emp_alu
 BEGIN
      IF USER = UPPER('andreilungu15') THEN
         RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
      END IF;
 END;
/
delete from emp_alu;
DROP TRIGGER trig6_alu;

--7 a. Crea?i tabelul audit_alu cu urm?toarele câmpuri:
--- utilizator (numele utilizatorului);
--- nume_bd (numele bazei de date);
--- eveniment (evenimentul sistem);
--- nume_obiect (numele obiectului);
--- data (data producerii evenimentului).
CREATE TABLE audit_alu
   (utilizator     VARCHAR2(30),
    nume_bd        VARCHAR2(50),
    eveniment      VARCHAR2(20),
    nume_obiect    VARCHAR2(30),
    data           DATE);
    
--b. Defini?i un declansator care sa introduca date în acest tabel dupa ce utilizatorul a folosit o
--comanda LDD (declansator sistem - la nivel de schema). 
CREATE OR REPLACE TRIGGER trig7_alu
      AFTER CREATE OR DROP OR ALTER ON SCHEMA -- on schema, la nivel de schema
BEGIN
      INSERT INTO audit_alu
      VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, 
              SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_alu ON info_emp_alu(nume);
DROP INDEX ind_alu;

SELECT * FROM audit_alu;

DROP TRIGGER trig7_alu;

--8. Defini?i un declan?ator care s? nu permit? modificarea:
--- valorii salariului maxim astfel încât acesta s? devin? mai mic decât media tuturor salariilor;
--- valorii salariului minim astfel încât acesta s? devin? mai mare decât media tuturor salariilor.
--Observa?ie:
--În acest caz este necesar? men?inerea unor variabile în care s? se re?in? salariul minim,
--salariul maxim, respectiv media salariilor. Variabilele se definesc într-un pachet, iar apoi pot
--fi referite în declan?ator prin nume_pachet.nume_variabila. 
--Este necesar s? se defineasc? doi declan?atori:
--- un declan?ator la nivel de comand? care s? actualizeze variabilele din pachet.
--- un declan?ator la nivel de linie care s? realizeze verificarea condi?iilor.
select * 
from emp_alu
where salary = (select min(salary) from emp_alu); --2100

select avg(salary) --6461....
from emp_alu;

-- o prima varianta (gresita)
create or replace trigger trig5_alu
before update of salary on emp_alu
for each row
declare
    minim emp_alu.salary%type;
    maxim emp_alu.salary%type;
    media emp_alu.salary%type;
begin
    select min(salary), max(salary), avg(salary)
    into minim, maxim, media
    from emp_alu;
    
    if (:old.salary = minim) and (:new.salary > media)
        then raise_application_error(-20001, 'acet salariu depaseste valoarea medie');
    elsif (:old.salary = maxim) and (:new.salary < media)
        then raise_application_error(-20001, 'acet salariu este sub valoarea medie');
    end if;
end;
/
update emp_alu
set salary = salary + 5000
where salary = (select min(salary) from emp_alu); --mutating table, problema apare de la select(intorc infromatii si fac modificari(update) in aceeasi tabela)

--merge, dar in prcatica(in industrie) nu este utila
create or replace trigger trig5_alu
before update of salary on emp_alu
for each row
declare
    minim emp_alu.salary%type;
    maxim emp_alu.salary%type;
    media emp_alu.salary%type;
begin
    select min(salary), max(salary), avg(salary)
    into minim, maxim, media
    from EMPLOYEES;
    
    if (:old.salary = minim) and (:new.salary > media)
        then raise_application_error(-20001, 'acet salariu depaseste valoarea medie');
    elsif (:old.salary = maxim) and (:new.salary < media)
        then raise_application_error(-20001, 'acet salariu este sub valoarea medie');
    end if;
end;
/
update emp_alu
set salary = salary + 5000
where salary = (select min(salary) from emp_alu); 



CREATE OR REPLACE PACKAGE pachet_alu
AS
	smin emp_alu.salary%type;
	smax emp_alu.salary%type;
	smed emp_alu.salary%type;
END pachet_alu;
/

CREATE OR REPLACE TRIGGER trig81_alu    --declanasator la nivel de COMANDA care sa actualizeze variabilele din pachet
BEFORE UPDATE OF salary ON emp_alu     -- comanda update
BEGIN
      SELECT MIN(salary), AVG(salary), MAX(salary)
      INTO pachet_alu.smin, pachet_alu.smed, pachet_alu.smax
      FROM emp_alu;
END;
/

CREATE OR REPLACE TRIGGER trig82_alu    --declanasator la nivel de LINIE care s? realizeze verificarea conditiilor.
BEFORE UPDATE OF salary ON emp_alu
FOR EACH ROW  --la nivel de linie
BEGIN
    IF(:OLD.salary=pachet_alu.smin) AND (:NEW.salary>pachet_alu.smed) 
       THEN RAISE_APPLICATION_ERROR(-20001,'Acest salariu depaseste valoarea medie');
    ELSIF (:OLD.salary= pachet_alu.smax) AND (:NEW.salary<  pachet_alu.smed) 
       THEN RAISE_APPLICATION_ERROR(-20001,'Acest salariu este sub valoarea medie');
    END IF;
END;
/

SELECT AVG(salary)
FROM   emp_alu;

UPDATE emp_alu 
SET    salary=10000 
WHERE  salary=(SELECT MIN(salary) FROM emp_alu);

UPDATE emp_alu 
SET    salary=1000 
WHERE  salary=(SELECT MAX(salary) FROM emp_alu);

DROP TRIGGER trig81_alu;
DROP TRIGGER trig82_alu;



--ex supl
-- S? se creeze un trigger check_sal_alu care garanteaz? ca, ori de câte ori un angajat nou este
--introdus în tabelul EMP_alu sau atunci când este modificat salariul sau codul job-ului unui
--angajat, salariul se încadreaz? între minimul si maximul salariior corespunz?toare job-ului
--respectiv. Se vor exclude angajatii AD_PRES.
create or replace trigger check_sal_alu
before insert or update of salary, job_id on emp_alu
for each row
declare
    minim employees.salary%type;
    maxim employees.salary%type;
begin
    select min_salary, max_salary
    into minim, maxim
    from JOBS
    where job_id = :old.job_id;
    
    if ((:new.salary < minim) or (:new.salary > maxim)) and :old.job_id != 'AD_PRES'
        then raise_application_error(-20001, 'acest salariu nu se incadreaza in limita corespunzatoare jobului');
    end if;
end;
/
UPDATE emp_alu 
SET    salary=10000 
WHERE  job_id = 'AD_VP';

update emp_alu
set job_id = 'IT_PROG'
where employee_id = 119;

rollback;

select * from jobs
wHERE  job_id = 'AD_VP'; 
select * from employees
wHERE  job_id = 'AD_VP'; 
select * from employees;
select * from jobs;



--varianta gabi
CREATE TABLE emp_min_max AS (
    SELECT
        job_id,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary
    FROM emp_alu
    GROUP BY job_id
);
select * from emp_min_max;

select * from emp_alu;

CREATE OR REPLACE TRIGGER check_sal_1
BEFORE UPDATE OF salary ON emp_alu -- la nivel de comanda
BEGIN
    UPDATE emp_min_max e
    SET min_salary = (SELECT MIN(salary) FROM emp_alu WHERE job_id = e.job_id),
        max_salary = (SELECT MAX(salary) FROM emp_alu WHERE job_id = e.job_id);
END;
/

CREATE OR REPLACE TRIGGER check_sal_2
BEFORE UPDATE OF salary ON emp_alu
FOR EACH ROW   -- la nivel de linie
WHEN (NEW.job_id != 'AD_PRES')
DECLARE
    job_min_salary NUMBER;
    job_max_salary NUMBER;
BEGIN
        SELECT min_salary, max_salary
        INTO job_min_salary, job_max_salary
        FROM emp_min_max
        WHERE job_id = :NEW.job_id;

        IF (:NEW.salary < job_min_salary) OR (:NEW.salary > job_max_salary) THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nu este permisa modificarea');
        END IF;
END;
/
UPDATE emp_alu 
SET    salary=10000 
WHERE  job_id = 'AD_VP';

update emp_alu
set job_id = 'IT_PROG'
where employee_id = 119;

rollback;

---exerctii
--1. Definiti un declansator care s? permit? stergerea informatiilor din tabelul dept_alu decât dac?
--utilizatorul este SCOTT.
create table dept_alu as select * from departments;
select * from dept_alu;

create or replace trigger ex1
before delete on dept_alu
for each row
begin
      IF USER != UPPER('scott') THEN
         RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
      END IF;
end;
/
delete from dept_alu;


--2. Creati un declansator prin care s? nu se permit? m?rirea comisionului astfel încât s? dep?seasc?
--50% din valoarea salariului. 
create or replace trigger ex2
before update of commission_pct on emp_alu
for each row
begin
    if :new.commission_pct > 0.5 then
        RAISE_APPLICATION_ERROR(-20000, 'comisionul este prea mare');
    end if;
end;
/
update emp_alu
set commission_pct = 0.51;
rollback;

--3. a. Introduce?i în tabelul info_dept_alu coloana numar care va reprezenta pentru fiecare
--departament num?rul de angaja?i care lucreaz? în departamentul respectiv. Popula?i cu date
--aceast? coloan? pe baza informa?iilor din schem?.
ALTER TABLE info_dept_alu
ADD numar number;

select * from info_emp_alu;
select * from info_dept_alu;

declare
    cursor c is   select id_dept, count(*) nr_ang
                        from info_emp_alu
                        group by id_dept;
begin
    for linie in c loop    
        --DBMS_OUTPUT.PUT_LINE('dept ' || linie.id_dept || ' are ' || linie.nr_ang || ' angajati');
        update info_dept_alu
        set numar = linie.nr_ang
        where id = linie.id_dept;
    end loop;
end;
/

select * from info_dept_alu;


-- b. Defini?i un declan?ator care va actualiza automat aceasta coloana în func?ie de actualiz?rile
--realizate asupra tabelului info_emp_alu.
create or replace trigger ex3b
after delete or insert or update on info_emp_alu
begin
    update info_dept_alu i
    set numar = (
            select count(1)
            from info_emp_alu
            where id_dept = i.id
            );
end;
/

delete from info_emp_alu
where id = 100;

select * from info_emp_alu;
select * from info_dept_alu order by id;
rollback;

--4. Definiti un declansator cu ajutorul c?ruia s? se implementeze restrictia conform c?reia într-un
--departament nu pot lucra mai mult de 45 persoane (se vor utiliza doar tabelele emp_alu si
--dept_alu f?r? a modifica structura acestora).
select * from emp_alu;

--- in practica nu e utila varianta
create or replace trigger trig4_alu
before insert or update --of department_id
on emp_alu
for each row
declare
    nr_ang number;
begin
    select count(1) 
    into nr_ang
    from emp_alu
    where :new.department_id = department_id;
    
    if nr_ang >= 45 
        then raise_application_error(-20000, 'Deja sunt 45 de angajati');
    end if;
end;
/

-- V?d ce departamente sunt deja pline
SELECT department_id, COUNT(*) AS num_emps
FROM emp_alu
GROUP BY department_id
HAVING COUNT(*) >= 45;

-- Nu o s? m? lase: prea mul?i angaja?i
INSERT INTO emp_alu (employee_id, department_id)
VALUES (1234, 50);

--insert cu values nu vede tabela ca mutating (pt ca afecteaza o singura coloana)
INSERT INTO emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
VALUES (300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50);

--mutating
insert into emp_alu
select * from employees where department_id =50;

--mutating
insert into emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
select 300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50
from dual;

select * from emp_alu where department_id = 50;


--varianta buna, recomandata !!!!! 
create or replace package ex4_alu
as
    type tip_rec is record
        (dept_id emp_alu.department_id%type,
        nr number(3));
    type tip_ind is table of tip_rec  -- table of tip_rec record -> un tablout mai complex 
            index by pls_integer; --tablou indexat
    t tip_ind;
    contor number(2) := 0;
end;
/

create or replace trigger trig_41_alu
before insert or update of department_id
on emp_alu
begin
    ex4_alu.contor := 0;
    
    select department_id, count(*)
    bulk collect into ex4_alu.t
    from emp_alu
    group by department_id;
end;
/
create or replace trigger trig_42_alu
before insert or update of department_id
on emp_alu
for each row
begin
    for i in 1..ex4_alu.t.last loop
        if ex4_alu.t(i).dept_id = :new.department_id and ex4_alu.t(i).nr + ex4_alu.contor >= 45
            then raise_application_error(-20000, 'Deja sunt 45 de angajati');
        end if;
    end loop;
    
    ex4_alu.contor := ex4_alu.contor + 1; --numara de cate ori se incearca sa se faca insertul
end;
/

-- se activeaza triggerul pe toate cazurile
INSERT INTO emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
VALUES (300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50);

insert into emp_alu
select * from employees where department_id =50;

insert into emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
select 300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50
from dual;

insert into emp_alu
select * from employees where department_id =80;
rollback;
select * from emp_alu where department_id = 80;

--5. a. Pe baza informatiilor din schem? creati si populati cu date urm?toarele dou? tabele:
--- emp_test_alu (employee_id – cheie primar?, last_name, first_name, department_id);
--- dept_test_alu (department_id – cheie primar?, department_name).
create table
emp_test_alu (employee_id number primary key,
                last_name varchar2(50),
                first_name varchar2(50),
                department_id number);
create table 
dept_test_alu (department_id number primary key,
                department_name varchar2(50));
                
insert into emp_test_alu
        (select employee_id, last_name, first_name, department_id from employees);
insert into dept_test_alu
    (select department_id, department_name from departments);
    
--b. Definiti un declansator care va determina stergeri si modific?ri în cascad?:
--- stergerea angajatlor din tabelul emp_test_*** dac? este eliminat departamentul acestora
--din tabelul dept_test_***;
--- modificarea codului de departament al angajatilor din tabelul emp_test_*** dac?
--departamentul respectiv este modificat în tabelul dept_test_***


--6 a. Crea?i un tabel cu urm?toarele coloane:
--- user_id (SYS.LOGIN_USER);
--- nume_bd (SYS.DATABASE_NAME);
--- erori (DBMS_UTILITY.FORMAT_ERROR_STACK);
--- data. 
CREATE TABLE tabelex6
   (user_id     VARCHAR2(100),
    nume_bd    VARCHAR2(100),
    erori     VARCHAR2(100),
    data           DATE);
    
--b. Defini?i un declan?ator care s? introduc? date în acest tabel dup? ce utilizatorul a folosit o
--comand? LDD (declan?ator sistem - la nivel de schem?). 
CREATE OR REPLACE TRIGGER trig_ex6_alu
AFTER SERVERERROR
ON DATABASE
BEGIN
    INSERT INTO tabelex6
    VALUES (
        SYS.LOGIN_USER,
        SYS.DATABASE_NAME,
        DBMS.FORMAT_ERROR_STACK,
        SYSDATE
    );
END;
/




--ex 4 camelia Defini?i un declan?ator cu ajutorul c?ruia s? se implementeze restric?ia conform c?reia într-un
--departament nu pot lucra mai mult de 45 persoane (se vor utiliza doar tabelele emp_*** ?i
--dept_*** f?r? a modifica structura acestora).
CREATE OR REPLACE PACKAGE pachet
AS
    TYPE tip_rec is RECORD (dept emp_alu.department_id%type,
                                        nr number(3));
    TYPE tip_ind is table of tip_rec INDEX BY PLS_INTEGER;
    t tip_ind;
    --contor NUMBER(2) := 0;
END;
/

CREATE OR REPLACE TRIGGER trig41_alu
BEFORE INSERT OR UPDATE OF department_id ON emp_alu
BEGIN
        --pachet.contor := 0;
        select department_id, count(1)
        bulk collect into pachet.t
        from emp_alu
        group by department_id;
END;
/


CREATE OR REPLACE TRIGGER trig42_alu
BEFORE INSERT OR UPDATE OF department_id ON emp_alu
FOR EACH ROW
BEGIN
        for i in 1..pachet.t.last loop
            if pachet.t(i).dept = :NEW.department_id then
                 pachet.t(i).nr := pachet.t(i).nr + 1;
                 if pachet.t(i).nr>=45 then
                     RAISE_APPLICATION_ERROR(-20000, 'Deja exista prea multi angajati');
                 end if;
            end if;
        end loop;
END;
/

INSERT INTO emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
VALUES (300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50);

insert into emp_alu
select * from employees where department_id =50;

insert into emp_alu (employee_id,last_name, email, hire_date, job_id, department_id)
select 300, 'Test', 'Test@gmail.com', sysdate, 'SA_MAN', 50
from dual;

insert into emp_alu
select * from employees where department_id =80;
rollback;
select * from emp_alu where department_id = 80;

----- ex 5 corina
--ex5
drop table dept_test;
create table dept_test as (select department_id, department_name from departments);

select * from dept_test;

drop table emp_test;
create table emp_test as (select employee_id, last_name, first_name, department_id from employees);

select * from emp_test;

create or replace trigger trigger_5
after delete or update on dept_test
for each row
begin
    if deleting then
        delete from emp_test
        where department_id = :old.department_id;
    elsif updating then
        update emp_test e
        set e.department_id = :new.department_id
        where e.department_id = :old.department_id;
    end if;
end;
/

delete from dept_test where department_id = 60;

select * from emp_test;

ALTER TABLE emp_test
ADD PRIMARY KEY (employee_id);

ALTER TABLE dept_test
ADD PRIMARY KEY (department_id);

ALTER TABLE emp_test
ADD FOREIGN KEY (department_id) REFERENCES dept_test(department_id)
ON DELETE CASCADE;

