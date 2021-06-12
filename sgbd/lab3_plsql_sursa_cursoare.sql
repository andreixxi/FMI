--lab 3 PLSQL

--1 Ob?ine?i pentru fiecare departament numele acestuia ?i num?rul de angaja?i, într-una din
--urm?toarele forme (cursor explicit)
--cu case pt afisare serioasa
SELECT department_name nume, COUNT(employee_id) nr, 'in ' ||department_name || ' lucreaza ' || count(employee_id) || ' angajati '  
            FROM   departments d, employees e
            WHERE  d.department_id=e.department_id(+) --outer join pt depart fara angajati, (+) unde nu exista inf (exista dept dar nu am angajati)
            GROUP BY department_name; 
/

DECLARE
      v_nr    number(4);
      v_nume  departments.department_name%TYPE;
      CURSOR c IS
            SELECT department_name nume, COUNT(employee_id) nr  
            FROM   departments d, employees e
            WHERE  d.department_id=e.department_id(+) --outer join pt depart fara angajati, (+) unde nu exista inf (exista dept dar nu am angajati)
            GROUP BY department_name; 
BEGIN
      OPEN c; --deschidere
      LOOP
          FETCH c INTO v_nume, v_nr; --incarcare
          EXIT WHEN c%NOTFOUND; --verific daca mai sunt linii de procesat
          IF v_nr=0 THEN
             DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' nu lucreaza angajati');
          ELSIF v_nr=1 THEN
               DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' lucreaza un angajat');
          ELSE
             DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' lucreaza '|| v_nr||' angajati');
         END IF;
     END LOOP;
     CLOSE c; --inchidere
END;
/

--2. Rezolva?i exerci?iul 1 men?inând informa?iile din cursor în colec?ii. Comenta?i. Procesa?i toate
--liniile din cursor, înc?rcând la fiecare pas câte 5 linii.
DECLARE
      TYPE   tab_nume IS TABLE OF departments.department_name%TYPE; --declarare tipuri
      TYPE   tab_nr IS TABLE OF NUMBER(4);
      t_nr   tab_nr; -- colectie 
      t_nume tab_nume;  -- colectie
      CURSOR c IS
            SELECT department_name nume, COUNT(employee_id) nr  
            FROM   departments d, employees e
            WHERE  d.department_id=e.department_id(+)
            GROUP BY department_name; 
BEGIN
      OPEN c;
      FETCH c  BULK COLLECT INTO t_nume, t_nr;
      CLOSE c;
      
      FOR i IN t_nume.FIRST..t_nume.LAST LOOP
              IF t_nr(i)=0 THEN
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)||
                                   ' nu lucreaza angajati');
              ELSIF t_nr(i)=1 THEN
                   DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume(i)||
                                   ' lucreaza un angajat');
              ELSE
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume(i)||
                                   ' lucreaza '|| t_nr(i)||' angajati');
             END IF;
      END LOOP;
END;
/

--3. Rezolva?i exerci?iul 1 folosind un ciclu cursor.
DECLARE
  CURSOR c IS
        SELECT department_name nume, COUNT(employee_id) nr 
        FROM   departments d, employees e
        WHERE  d.department_id=e.department_id(+)
        GROUP BY department_name; 
BEGIN
      FOR i in c LOOP --iterare prin cursor, fiecare linie pe rand
              IF i.nr=0 THEN
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                                   ' nu lucreaza angajati');
              ELSIF i.nr=1 THEN
                   DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
                                   ' lucreaza un angajat');
              ELSE
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                                   ' lucreaza '|| i.nr||' angajati');
             END IF;
     END LOOP;
END;
/

--4. Rezolva?i exerci?iul 1 folosind un ciclu cursor cu subcereri. 
-- recomandat pt cereri simple/ nu ft complicate 
BEGIN
    -- i ia fiecare informatie din select 
      FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
                    FROM   departments d, employees e
                    WHERE  d.department_id=e.department_id(+)
                    GROUP BY department_name) LOOP
              IF i.nr=0 THEN
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                                   ' nu lucreaza angajati');
              ELSIF i.nr=1 THEN
                   DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume ||
                                   ' lucreaza un angajat');
              ELSE
                 DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                                   ' lucreaza '|| i.nr||' angajati');
             END IF;
     END LOOP;
END;
/

--5. Ob?ine?i primii 3 manageri care au cei mai mul?i subordona?i. Afi?a?i numele managerului,
--respectiv num?rul de angaja?i.
--a. Rezolva?i problema folosind un cursor explicit.
--b. Modifica?i rezolvarea anterioar? astfel încât s? ob?ine?i primii 4 manageri care îndeplinesc
--condi?ia. Observa?i rezultatul ob?inut ?i specifica?i dac? la punctul a s-a ob?inut top 3
--manageri? 
DECLARE
      v_cod    employees.employee_id%TYPE;
      v_nume   employees.last_name%TYPE;
      v_nr     NUMBER(4);
      CURSOR c IS
      -- daca nu puneam max(last_name) trebuia sa pun si last_name la group by
            SELECT   sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
            FROM     employees sef, employees ang
            WHERE    ang.manager_id = sef.employee_id
            GROUP BY sef.employee_id
            ORDER BY nr DESC; -- ordonez rezultatul desc dupa nr de angajati
BEGIN
      OPEN c;
        LOOP
              FETCH c INTO v_cod, v_nume, v_nr;
              EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND; --ies dupa 3 linii SAU cand a terminat
              DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod || 
                                   ' avand numele ' || v_nume || 
                                   ' conduce ' || v_nr||' angajati');
        END LOOP;
      CLOSE c;
END;
/

-- 5 modificat
DECLARE
      v_cod    employees.employee_id%TYPE;
      v_nume   employees.last_name%TYPE;
      v_nr     NUMBER(4);
      CURSOR c IS
      -- daca nu puneam max(last_name) trebuia sa pun si last_name la group by
            SELECT   sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
            FROM     employees sef, employees ang
            WHERE    ang.manager_id = sef.employee_id
            GROUP BY sef.employee_id
            ORDER BY nr DESC; -- ordonez rezultatul desc dupa nr de angajati
      v_contor number(4);
      v_nr_anterior number(4);
BEGIN
        OPEN c;
        v_contor := 1;
        LOOP
              FETCH c INTO v_cod, v_nume, v_nr;
              if v_nr != v_nr_anterior then
                    v_contor := v_contor + 1;
             end if;
              v_nr_anterior := v_nr;
              EXIT WHEN v_contor > 3 OR c%NOTFOUND; 
              DBMS_OUTPUT.PUT_LINE(c%rowcount || ' Pozitia ' || v_contor || ': Managerul '|| v_cod || 
                                   ' avand numele ' || v_nume || 
                                   ' conduce ' || v_nr||' angajati');
        END LOOP;
      CLOSE c;
END;
/


--6. Rezolva?i exerci?iul 5 folosind un ciclu cursor.
DECLARE
      CURSOR c IS
            SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                     count(*) nr
            FROM     employees sef, employees ang
            WHERE    ang.manager_id = sef.employee_id
            GROUP BY sef.employee_id
            ORDER BY nr DESC;
BEGIN
      FOR i IN c LOOP
              EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || 
                                   ' avand numele ' || i.nume || 
                                   ' conduce '|| i.nr||' angajati');
      END LOOP;
END;
/

-- 6
DECLARE
      CURSOR c IS
            SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                     count(*) nr
            FROM     employees sef, employees ang
            WHERE    ang.manager_id = sef.employee_id
            GROUP BY sef.employee_id
            ORDER BY nr DESC;
      v_contor number(4);
      v_nr_anterior number(4);
BEGIN
    v_contor := 1;
      FOR i IN c LOOP
             if i.nr != v_nr_anterior then
                    v_contor := v_contor + 1;
             end if;
             v_nr_anterior := i.nr;
              EXIT WHEN v_contor>3 OR c%NOTFOUND; -- c%ROWCOUNT>3
              DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || 
                                   ' avand numele ' || i.nume || 
                                   ' conduce '|| i.nr||' angajati');
      END LOOP;
END;
/

--7/ Rezolva?i exerci?iul 5 folosind un ciclu cursor cu subcereri.
DECLARE
    top number(1):= 0; 
BEGIN
      FOR i IN (SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
                         count(*) nr
                FROM     employees sef, employees ang
                WHERE    ang.manager_id = sef.employee_id
                GROUP BY sef.employee_id
                ORDER BY nr DESC) 
      LOOP
              DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || 
                                   ' avand numele ' || i.nume || 
                                   ' conduce '|| i.nr||' angajati');
              Top := top+1;
              EXIT WHEN top=3;
      END LOOP;
END;
/

--8 -- cursor explicit
DECLARE
      v_x     number(4) := &p_x;
      v_nr    number(4);
      v_nume  departments.department_name%TYPE;

      CURSOR c (paramentru NUMBER) IS
            SELECT department_name nume, COUNT(employee_id) nr  
            FROM   departments d, employees e
            WHERE  d.department_id=e.department_id
            GROUP BY department_name
            HAVING COUNT(employee_id) > paramentru; 
BEGIN
      OPEN c(v_x);
      LOOP
          FETCH c INTO v_nume,v_nr;
          EXIT WHEN c%NOTFOUND;
          DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||
                               ' lucreaza '|| v_nr||' angajati');
     END LOOP;
     CLOSE c;
END;
/

-- var 2 -- ciclu cursor
DECLARE
     v_x     number(4) := &p_x;
     CURSOR c (paramentru NUMBER) IS
            SELECT department_name nume, COUNT(employee_id) nr 
            FROM   departments d, employees e
            WHERE  d.department_id=e.department_id
            GROUP BY department_name
            HAVING COUNT(employee_id)> paramentru; 
BEGIN
  FOR i in c(v_x) LOOP
     DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                           ' lucreaza '|| i.nr||' angajati');
  END LOOP;
END;
/

--var 3 -- ciclu cursor cu subcereri
DECLARE
     v_x     number(4) := &p_x;
 BEGIN
      FOR i in (SELECT department_name nume, COUNT(employee_id) nr 
                FROM   departments d, employees e
                WHERE  d.department_id = e.department_id
                GROUP BY department_name 
                HAVING COUNT(employee_id) > v_x) 
      LOOP
         DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||
                               ' lucreaza '|| i.nr||' angajati');
      END LOOP;
END;
/

--9
seelct * from emp_alu
where employee_id < 120 for update;
seelct * from emp_alu
where employee_id < 130 for update skip locked;

create table emp_prof as select * from employees;

SELECT last_name, hire_date, salary
FROM   emp_prof
WHERE  TO_CHAR(hire_date, 'yyyy') = 2000;

DECLARE
      CURSOR c IS
            SELECT *
            FROM   emp_prof
            WHERE  TO_CHAR(hire_date, 'YYYY') = 2000
            FOR UPDATE OF salary NOWAIT;
BEGIN
      FOR i IN c  LOOP
            UPDATE  emp_prof
            SET     salary = salary + 1000
            WHERE CURRENT OF c;
      END LOOP;
END;
/

SELECT last_name, hire_date, salary
FROM   emp_prof
WHERE  TO_CHAR(hire_date, 'yyyy') = 2000;

ROLLBACK;

--10
--varianta 1 - cursor parametrizat/// ciclu cursor cu subcereri
BEGIN
      FOR v_dept IN (SELECT department_id, department_name
                     FROM   departments
                     WHERE  department_id IN (10,20,30,40))
      LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_id || '  ' || v_dept.department_name);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            
            FOR v_emp IN (SELECT last_name
                          FROM   employees
                          WHERE  department_id = v_dept.department_id)
            LOOP
                DBMS_OUTPUT.PUT_LINE (v_emp.last_name);
            END LOOP;
      END LOOP;
END;
/ 

--cursor explicit
DECLARE 
    cursor c is 
             SELECT department_id, department_name
              FROM   departments
              WHERE  department_id IN (10,20,30,40);
    cursor ang(cod departments.department_id%type) is
            select last_name
            FROM   employees
             WHERE  department_id = cod;
    v_id departments.department_id%type;
    v_nume departments.department_name%type;
    v_last_name employees.last_name%type;
BEGIN
      open c;
      loop
            fetch c into v_id, v_nume;
            exit when c%notfound;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_id || '  ' || v_nume);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            open ang(v_id);
            loop
                    fetch ang into v_last_name;
                    exit when ang%notfound;
                    DBMS_OUTPUT.PUT_LINE (v_last_name);
            end loop;
            close ang;
      end loop;
      close c;
END;
/

-- ciclu cursor
declare
    cursor c is 
             SELECT department_id, department_name
              FROM   departments
              WHERE  department_id IN (10,20,30,40);
    cursor ang(cod departments.department_id%type) is
            select last_name nume
            FROM   employees
             WHERE  department_id = cod;
begin
    for dept in c loop
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||dept.department_id || '  ' || dept.department_name);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            for a in ang(dept.department_id) loop
                DBMS_OUTPUT.PUT_LINE (a.nume);
            end loop;
    end loop;
end;
/


--Varianta 2 – expresii cursor
DECLARE
      TYPE refcursor IS REF CURSOR;
      CURSOR c_dept IS
                SELECT department_name, CURSOR (SELECT last_name 
                                                   FROM   employees e
                                                   WHERE  e.department_id = d.department_id)
                FROM   departments d
                WHERE  department_id IN (10,20,30,40);
      v_nume_dept   departments.department_name%TYPE;
      v_cursor      refcursor; -- cursor in cursor
      v_nume_emp    employees.last_name%TYPE;
BEGIN
      OPEN c_dept;
      LOOP --pt fiecare departament
            FETCH c_dept INTO v_nume_dept, v_cursor;
            EXIT WHEN c_dept%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_nume_dept);
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            LOOP --pt fiecare angajat
                  FETCH v_cursor INTO v_nume_emp;
                  EXIT WHEN v_cursor%NOTFOUND;
                  DBMS_OUTPUT.PUT_LINE (v_nume_emp);
            END LOOP;
      END LOOP;
      CLOSE c_dept;
END;
/

--11
-- atentie la rezultat
DECLARE
        TYPE emp_tip IS REF CURSOR RETURN employees%ROWTYPE; -- cursor dinamic
  -- sau 
  -- TYPE   emp_tip IS REF CURSOR;
      v_emp     emp_tip;   -- cursor dinamic
      v_optiune NUMBER := &p_optiune;
      v_ang    employees%ROWTYPE; --introducem informatia la afisare 
BEGIN
       IF v_optiune = 1 THEN
             OPEN v_emp FOR SELECT * 
                            FROM employees;
       ELSIF v_optiune = 2 THEN
             OPEN v_emp FOR  SELECT * 
                             FROM employees 
                             WHERE salary BETWEEN 10000 AND 20000;
       ELSIF v_optiune = 3 THEN
             OPEN v_emp FOR SELECT * 
                            FROM employees 
                            WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
       ELSE
            DBMS_OUTPUT.PUT_LINE('Optiune incorecta');  
       END IF; -- am terminat de incarcat informatia
       
       LOOP
              FETCH v_emp into v_ang;
              EXIT WHEN v_emp%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE(v_emp%ROWCOUNT || '. ' || v_ang.last_name);
       END LOOP;
       
       DBMS_OUTPUT.PUT_LINE('Au fost procesate '||v_emp%ROWCOUNT  || ' linii');
       CLOSE v_emp; -- inchid cursorul
END;
/

--12
DECLARE
      TYPE  empref IS REF CURSOR; 
      v_emp empref; -- cursor
      v_nr  INTEGER := &n;
      v_id employees.employee_id%type;
      v_sal employees.salary%type;
      v_pct employees.commission_pct%type;
BEGIN
      OPEN v_emp FOR 
        'SELECT employee_id, salary, commission_pct ' ||
        'FROM employees WHERE salary > :bind_var'
         USING v_nr;
         -- introduceti liniile corespunzatoare rezolvarii problemei
         LOOP
            fetch v_emp into v_id, v_sal, v_pct;
            EXIT WHEN v_emp%NOTFOUND;
            if v_pct is null then 
                DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_sal);
            else
                DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_sal || ' ' || v_pct);
            end if;
         end LOOP;
     CLOSE v_emp;
END;
/

--1. Pentru fiecare job (titlu – care va fi afi?at o singur? dat?) ob?ine?i lista angaja?ilor (nume ?i
--salariu) care lucreaz? în prezent pe jobul respectiv. Trata?i cazul în care nu exist? angaja?i care
--s? lucreze în prezent pe un anumit job. Rezolva?i problema folosind:
--a. cursoare clasice
--b. ciclu cursoare
--c. ciclu cursoare cu subcereri
--d. expresii cursor
select job_title, last_name, salary
from employees e, jobs j
where e.job_id(+) = j.job_id;
/
--a. cursor clasic
declare
    cursor c is 
        select job_title, last_name, salary
        from employees e, jobs j
        where e.job_id(+) = j.job_id;
    v_title  jobs.job_title%TYPE;
    v_name employees.last_name%type;
    v_sal employees.salary%type;
    v_title_ant jobs.job_title%TYPE;
begin
    OPEN c; --deschidere
    FETCH c INTO v_title, v_name, v_sal; --incarcare
    DBMS_OUTPUT.PUT_LINE(v_title);
    DBMS_OUTPUT.PUT_LINE('-------');
    DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
    v_title_ant := v_title;
      LOOP
          FETCH c INTO v_title, v_name, v_sal; --incarcare
          if v_title_ant != v_title then 
               DBMS_OUTPUT.new_line;
               DBMS_OUTPUT.PUT_LINE(v_title);
               DBMS_OUTPUT.PUT_LINE('-------');
         end if;
         v_title_ant := v_title;
        
         EXIT WHEN c%NOTFOUND; --verific daca mai sunt linii de procesat
          IF v_name is null  THEN
             DBMS_OUTPUT.PUT_LINE('nu lucreaza niciun angajat pe acest post');
             DBMS_OUTPUT.PUT_LINE('-------');
             DBMS_OUTPUT.new_line;
          ELSE
             DBMS_OUTPUT.PUT_LINE(v_name || ' ' || v_sal);
         END IF;
     END LOOP;
     CLOSE c; --inchidere
end;
/


--- varianta bianca
DECLARE
    CURSOR cur_job IS (
                            SELECT job_id, job_title
                            FROM jobs
                            );
    CURSOR cur_emp IS (
                            SELECT last_name, salary, job_id
                            FROM employees);
                    
    v_job_id jobs.job_id%TYPE;
    v_job_id_emp jobs.job_id%TYPE;
    v_job_title jobs.job_title%TYPE;
    v_name employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    emps number(5) := 0;
BEGIN
    OPEN cur_job;
    LOOP
        emps := 0;
        FETCH cur_job INTO v_job_id, v_job_title;
        EXIT WHEN cur_job%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Jobul cu titlul ' || v_job_title || ' are angajatii:');
        OPEN cur_emp;
            EXIT WHEN cur_emp%NOTFOUND;
            LOOP
                FETCH cur_emp INTO v_name, v_salary, v_job_id_emp;
                EXIT WHEN cur_emp%NOTFOUND;
                if v_job_id_emp=v_job_id then
                DBMS_OUTPUT.PUT_LINE('Angajatul cu numele ' || v_name || ' are salariul ' || v_salary);
                emps := emps + 1;
                end if;
            end loop;
        if emps = 0 then dbms_output.put_line('nu sunt angajati');
        end if;
        CLOSE cur_emp;
        DBMS_OUTPUT.PUT_LINE(' ');
    end loop;
    CLOSE cur_job;
END;
/


-- b ciclu cursor (var profa)
DECLARE
    CURSOR c_jobs IS (
                            SELECT job_id, job_title
                            FROM JOBS
                             );
    CURSOR c_emp IS (
                            SELECT job_id, last_name, salary
                            FROM EMPLOYEES e
                            );
    emps NUMBER(5) := 0;
BEGIN
        FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            
            emps := 0;
            
            FOR j in c_emp LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    DBMS_OUTPUT.PUT_LINE(j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        
        END LOOP;

END;
/

-- c. ciclu cursor cu subcereri
declare
    emps NUMBER(5) := 0;
begin
    FOR i in (SELECT job_id, job_title 
                FROM jobs) loop 
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            for j in (SELECT job_id, last_name, salary
                            FROM EMPLOYEES e) loop
                 IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    DBMS_OUTPUT.PUT_LINE(j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        END LOOP;   
end;
/

--d. expresii cursor
declare
    type refcursor is ref cursor;
    cursor c_jobs is 
                    SELECT job_title, cursor (SELECT last_name, salary
                                                            FROM EMPLOYEES e
                                                            where e.job_id = j.job_id)
                    FROM JOBS j;
    v_cursor refcursor;            
    v_job_title jobs.job_title%type; 
    emps number := 0;
    v_last_name employees.last_name%type;
    v_salary employees.salary%type;
begin
    open c_jobs;
    loop --pt fiecare job
        fetch c_jobs into v_job_title, v_cursor;
        exit when c_jobs%notfound;
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
        DBMS_OUTPUT.PUT_LINE (v_job_title);
        DBMS_OUTPUT.PUT_LINE('-----');
        emps := 0;
        loop -- pt fiecare anagajat
            fetch v_cursor into v_last_name, v_salary;
            exit when v_cursor%notfound;
            emps := emps + 1;
            DBMS_OUTPUT.PUT_LINE(v_last_name || ' ' ||v_salary);
        end loop;
        if emps = 0 then 
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
        end if;
        DBMS_OUTPUT.NEW_LINE;
     END LOOP;   
    close c_jobs;
end;
/
--
--2. Modifica?i exerci?iul anterior astfel încât s? ob?ine?i ?i urm?toarele informa?ii:
--- un num?r de ordine pentru fiecare angajat care va fi resetat pentru fiecare job
--- pentru fiecare job
--o num?rul de angaja?i
--o valoarea lunar? a veniturilor angaja?ilor 
DECLARE
    CURSOR c_jobs IS (
                            SELECT job_id, job_title
                            FROM JOBS
                             );
    CURSOR c_emp IS (
                            SELECT job_id, last_name, salary
                            FROM EMPLOYEES e
                            );
    emps NUMBER(5) := 0;
    avg_sal number(10, 2);
    emps_total number(5) := 0;
    sal_total number (10, 2) := 0;
BEGIN
        FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            avg_sal := 0;
            FOR j in c_emp LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    avg_sal := avg_sal + j.salary;
                    DBMS_OUTPUT.PUT_LINE(emps || '  ' || j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            emps_total := emps_total + emps; --nr total angjaati
            sal_total := sal_total + avg_sal; --salariu total
            if emps <> 0 then
                DBMS_OUTPUT.PUT_LINE('Nr angajati : ' || emps);
                DBMS_OUTPUT.PUT_LINE('valoarea lunara a veniturilor angajatilor '|| avg_sal);
                 avg_sal := avg_sal / emps;
                DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| avg_sal); 
            end if;
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('indiferent de job');
    DBMS_OUTPUT.PUT_LINE('numarul total de angajati ' || emps_total);
    DBMS_OUTPUT.PUT_LINE('valoarea total? lunar? a veniturilor angajatilor '|| sal_total);
    sal_total := sal_total / emps_total;
    DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| sal_total); 
END;
/


--3. Modificati exercitiul anterior astfel încât s? obtineti suma total? alocat? lunar pentru plata
--salariilor si a comisioanelor tuturor angajatilor, iar pentru fiecare angajat cât la sut? din aceast?
--sum? câstig? lunar. 
select * from employees;
DECLARE
    CURSOR c_jobs IS (
                            SELECT job_id, job_title
                            FROM JOBS
                             );
    CURSOR c_emp IS (
                            SELECT job_id, last_name, salary, commission_pct
                            FROM EMPLOYEES e
                            );
    emps NUMBER(5) := 0;
    avg_sal number(10, 2);
    emps_total number(5) := 0;
    sal_total number (10, 2) := 0;
    sal_with_comm_pct number(10, 2) := 0;
    total_sal_with_comm_pct number(10, 2) := 0;
    salariu number(5) := 0;
    contor number := 0;
BEGIN
        FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            avg_sal := 0;
            FOR j in c_emp LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    avg_sal := avg_sal + j.salary;
--                    if j.commission_pct is not null then
                        sal_with_comm_pct := sal_with_comm_pct +  j.salary + j.salary * nvl(j.COMMISSION_PCT,0);
--                    end if;
                    DBMS_OUTPUT.PUT_LINE(emps || '  ' || j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            emps_total := emps_total + emps; --nr total angjaati
            sal_total := sal_total + avg_sal; --salariu total
            if emps <> 0 then
                DBMS_OUTPUT.PUT_LINE('Nr angajati : ' || emps);
                DBMS_OUTPUT.PUT_LINE('valoarea lunara a veniturilor angajatilor '|| avg_sal);
                 avg_sal := avg_sal / emps;
                DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| avg_sal); 
            end if;
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('indiferent de job');
    DBMS_OUTPUT.PUT_LINE('numarul total de angajati ' || emps_total);
    DBMS_OUTPUT.PUT_LINE('valoarea total? lunar? a veniturilor angajatilor '|| sal_total);
    sal_total := sal_total / emps_total;
    DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| sal_total); 
    DBMS_OUTPUT.PUT_LINE('suma total? alocat? lunar pentru plata salariilor si a comisioanelor tuturor angajatilor ' || sal_with_comm_pct);
    DBMS_OUTPUT.PUT_LINE('------------modificare ex 3 ----------');
    FOR j in c_emp LOOP
        contor := contor + 1;
        salariu := j.salary + j.salary * nvl(j.commission_pct, 0);
        DBMS_OUTPUT.PUT_LINE(contor || '.anagajatul ' || j.last_name || ' castiga lunar ' || round(salariu /  sal_with_comm_pct, 3) || '% din suma ' || sal_with_comm_pct);
    end loop;
END;
/


--4. Modificati exercitiul anterior astfel încât s? obtineti pentru fiecare job primii 5 angajati care
--câstig? cel mai mare salariu lunar. Specificati dac? pentru un job sunt mai putin de 5 angajati. 
select * from employees;
DECLARE
    CURSOR c_jobs IS (
                            SELECT job_id, job_title
                            FROM JOBS
                             );
    CURSOR c_emp IS (
                            SELECT job_id, last_name, salary, commission_pct
                            FROM EMPLOYEES e
                            );
    CURSOR top5 is (
                            SELECT job_id, last_name, salary, commission_pct
                            FROM EMPLOYEES
                            )
                            order by salary desc;
    emps NUMBER(5) := 0;
    avg_sal number(10, 2);
    emps_total number(5) := 0;
    sal_total number (10, 2) := 0;
    sal_with_comm_pct number(10, 2) := 0;
    total_sal_with_comm_pct number(10, 2) := 0;
    salariu number(5) := 0;
    contor number := 0;
    
    type name_ is table of employees.last_name%type;
    type salarii is table of employees.salary%type;
    v_nume name_ := name_(5);
    v_salarii salarii := salarii(5);
BEGIN
        FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            avg_sal := 0;
            FOR j in c_emp LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    avg_sal := avg_sal + j.salary;
--                    if j.commission_pct is not null then
                        sal_with_comm_pct := sal_with_comm_pct +  j.salary + j.salary * nvl(j.COMMISSION_PCT,0);
--                    end if;
                    DBMS_OUTPUT.PUT_LINE(emps || '  ' || j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            emps_total := emps_total + emps; --nr total angjaati
            sal_total := sal_total + avg_sal; --salariu total
            if emps <> 0 then
                DBMS_OUTPUT.PUT_LINE('Nr angajati : ' || emps);
                DBMS_OUTPUT.PUT_LINE('valoarea lunara a veniturilor angajatilor '|| avg_sal);
                 avg_sal := avg_sal / emps;
                DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| avg_sal); 
            end if;
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('indiferent de job');
    DBMS_OUTPUT.PUT_LINE('numarul total de angajati ' || emps_total);
    DBMS_OUTPUT.PUT_LINE('valoarea total? lunar? a veniturilor angajatilor '|| sal_total);
    sal_total := sal_total / emps_total;
    DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| sal_total); 
    DBMS_OUTPUT.PUT_LINE('suma total? alocat? lunar pentru plata salariilor si a comisioanelor tuturor angajatilor ' || sal_with_comm_pct);
    
    DBMS_OUTPUT.PUT_LINE('------------modificare ex 3 ----------');
    FOR j in c_emp LOOP
        contor := contor + 1;
        salariu := j.salary + j.salary * nvl(j.commission_pct, 0);
        DBMS_OUTPUT.PUT_LINE(contor || '.anagajatul ' || j.last_name || ' castiga lunar ' || round(salariu /  sal_with_comm_pct, 3) || '% din suma ' || sal_with_comm_pct);
    end loop;
     
      DBMS_OUTPUT.PUT_LINE('------------modificare ex 4----------');
      FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            FOR j in top5 LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    v_nume.extend;
                    v_salarii.extend;
                    v_nume(emps) := j.last_name;
                    v_salarii(emps) := j.salary;
                end if;
            end loop;
            if emps < 5 then 
                DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' sunt mai putin de 5 angajati'); 
            else 
                 v_nume.trim(v_nume.count - 5);
                v_salarii.trim(v_salarii.count - 5);
                 DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' primii 5 cei mai bine platiti angajati sunt' );
                 for k in v_nume.first..v_nume.last loop
                    DBMS_OUTPUT.PUT_LINE(v_nume(k) || ' ' || v_salarii(k));
                 end loop;
            end if;
    end loop;
END;
/

--5. Modifica?i exerci?iul anterior astfel încât s? ob?ine?i pentru fiecare job top 5 angaja?i. Dac?
--exist? mai mul?i angaja?i care respect? criteriul de selec?ie care au acela?i salariu, atunci ace?tia
--vor ocupa aceea?i pozi?ie în top 5.
DECLARE
    CURSOR c_jobs IS (
                            SELECT job_id, job_title
                            FROM JOBS
                             );
    CURSOR c_emp IS (
                            SELECT job_id, last_name, salary, commission_pct
                            FROM EMPLOYEES e
                            );
    CURSOR top5 is (
                            SELECT job_id, last_name, salary, commission_pct
                            FROM EMPLOYEES
                            )
                            order by salary desc;
    emps NUMBER(5) := 0;
    avg_sal number(10, 2);
    emps_total number(5) := 0;
    sal_total number (10, 2) := 0;
    sal_with_comm_pct number(10, 2) := 0;
    total_sal_with_comm_pct number(10, 2) := 0;
    salariu number(5) := 0;
    contor number := 0;
    
    type name_ is table of employees.last_name%type;
    type salarii is table of employees.salary%type;
    v_nume name_ := name_();
    v_salarii salarii := salarii();
    sal_ant employees.salary%type;
    idx number := 0;
BEGIN
        FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            avg_sal := 0;
            FOR j in c_emp LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    avg_sal := avg_sal + j.salary;
--                    if j.commission_pct is not null then
                        sal_with_comm_pct := sal_with_comm_pct +  j.salary + j.salary * nvl(j.COMMISSION_PCT,0);
--                    end if;
                    DBMS_OUTPUT.PUT_LINE(emps || '  ' || j.last_name || ' ' || j.salary);
                END IF;
            END LOOP;
            emps_total := emps_total + emps; --nr total angjaati
            sal_total := sal_total + avg_sal; --salariu total
            if emps <> 0 then
                DBMS_OUTPUT.PUT_LINE('Nr angajati : ' || emps);
                DBMS_OUTPUT.PUT_LINE('valoarea lunara a veniturilor angajatilor '|| avg_sal);
                 avg_sal := avg_sal / emps;
                DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| avg_sal); 
            end if;
            IF emps = 0 THEN
              DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe acest post');
            END IF;
            DBMS_OUTPUT.NEW_LINE;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('indiferent de job');
    DBMS_OUTPUT.PUT_LINE('numarul total de angajati ' || emps_total);
    DBMS_OUTPUT.PUT_LINE('valoarea total? lunar? a veniturilor angajatilor '|| sal_total);
    sal_total := sal_total / emps_total;
    DBMS_OUTPUT.PUT_LINE('valoarea medie a veniturilor angajatilor '|| sal_total); 
    DBMS_OUTPUT.PUT_LINE('suma total? alocat? lunar pentru plata salariilor si a comisioanelor tuturor angajatilor ' || sal_with_comm_pct);
    DBMS_OUTPUT.PUT_LINE('------------modificare ex 3 ----------');
    FOR j in c_emp LOOP
        contor := contor + 1;
        salariu := j.salary + j.salary * nvl(j.commission_pct, 0);
        DBMS_OUTPUT.PUT_LINE(contor || '.anagajatul ' || j.last_name || ' castiga lunar ' || round(salariu /  sal_with_comm_pct, 3) || '% din suma ' || sal_with_comm_pct);
    end loop;
      DBMS_OUTPUT.PUT_LINE('------------modificare ex 4----------');
      FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            v_nume  := name_();
            v_salarii  := salarii();
            FOR j in top5 LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                     if emps <= 5 then 
                        v_nume.extend;
                        v_salarii.extend;
                        v_nume(emps) := j.last_name;
                        v_salarii(emps) := j.salary;
                     end if;
                end if;
            end loop;
            if emps < 5 then 
                DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' sunt mai putin de 5 angajati'); 
            else 
                 DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' primii 5 cei mai bine platiti angajati sunt' );
                 for k in v_nume.first..v_nume.last loop
                    DBMS_OUTPUT.PUT_LINE(v_nume(k) || ' ' || v_salarii(k));
                 end loop;
            end if;
    end loop;
    DBMS_OUTPUT.PUT_LINE('------------modificare ex 5----------');
     FOR i in c_jobs LOOP
            DBMS_OUTPUT.PUT_LINE('-------------------------------------');
            DBMS_OUTPUT.PUT_LINE (i.job_title);
            DBMS_OUTPUT.PUT_LINE('-----');
            emps := 0;
            v_nume  := name_();
            v_salarii  := salarii();
            idx := 0;
            FOR j in top5 LOOP
                IF i.job_id = j.job_id THEN
                    emps := emps + 1;
                    if j.salary != sal_ant then 
                        idx := idx + 1;
                    end if;
                    sal_ant := j.salary;
                      if idx <= 5 then
                        v_nume.extend;
                        v_salarii.extend;
                        v_nume(emps) := j.last_name;
                        v_salarii(emps) := j.salary;
                    end if;
                end if;
            end loop;
            if emps < 5 then 
                DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' sunt mai putin de 5 angajati'); 
            else 
                 DBMS_OUTPUT.PUT_LINE('pt jobul ' || i.job_id || ' primii 5 cei mai bine platiti angajati sunt' );
                 DBMS_OUTPUT.PUT_LINE('nr angajati ' || v_nume.count);
                 for k in v_nume.first..v_nume.last loop
                    DBMS_OUTPUT.PUT_LINE(v_nume(k) || ' ' || v_salarii(k));
                 end loop;
            end if;
    end loop;
    
END;
/