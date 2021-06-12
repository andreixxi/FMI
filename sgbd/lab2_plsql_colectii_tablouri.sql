--lungu andrei 332
--ex 1
declare
    x NUMBER(1) := 5;
    y x%TYPE := NULL;
begin
    if x <> y 
        THEN DBMS_OUTPUT.PUT_LINE ('valoare <> null este = true');
    ELSE 
        DBMS_OUTPUT.PUT_LINE ('valoare <> null este != true');
    END IF;

    x := NULL;
    IF x = y
        then dbms_output.put_line('null = null este = true');
    else 
        dbms_output.put_line('null = null este != true');
    END IF;
END;
/
--valoare <> null este != true
--null = null este != true


--ex 2
--record e ca struct in C
--a
declare
type emp_record is record 
            (cod employees.employee_id%TYPE, 
            salariu employees.salary%TYPE, 
            job employees.job_id%TYPE );
v_ang emp_record; --declarat obligatoriu
    begin 
        v_ang.cod := 700;
        v_ang.salariu := 9000;
        v_ang.job := 'SA_MAN';
    dbms_output.put_line('Angajatul cu codul '
                         || v_ang.cod
                         || ' si jobul '
                         || v_ang.job
                         || ' are salariul '
                         || v_ang.salariu);

END;
/

--b
--
--* SELECT employee_id, salary, job_id
--* INTO v_ang.cod, v_ang.salariu, v_ang.job
--* FROM employees
--* WHERE employee_id = 101;*/
declare
type emp_record is record 
            (cod employees.employee_id%TYPE, 
            salariu employees.salary%TYPE, 
            job employees.job_id%TYPE );
v_ang emp_record; --declarat obligatoriu o variabila de tip emp_record
BEGIN
    SELECT employee_id, salary, job_id
    INTO v_ang
    FROM employees
    WHERE employee_id = 101;
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod ||
     ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/


--c
--create table emp_alu as select * from employees;
declare
type emp_record is record 
            (cod employees.employee_id%TYPE, 
            salariu employees.salary%TYPE, 
            job employees.job_id%TYPE );
v_ang emp_record; --declarat obligatoriu
BEGIN
    DELETE FROM emp_alu
    WHERE employee_id=100
    RETURNING employee_id, salary, job_id 
    INTO v_ang;
    DBMS_OUTPUT.PUT_LINE ('Angajatul cu codul '|| v_ang.cod ||
     ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/
select * from emp_alu;
ROLLBACK;


--3
DECLARE
    v_ang1 employees%ROWTYPE;
    v_ang2 employees%ROWTYPE;
BEGIN
    -- sterg angajat 100 si mentin in variabila linia stearsa
    DELETE FROM emp_alu
    WHERE employee_id = 100
    RETURNING employee_id, first_name, last_name, email, phone_number,
    hire_date, job_id, salary, commission_pct, manager_id,
    department_id
    INTO v_ang1;
    
    -- inserez in tabel linia stearsa
    INSERT INTO emp_alu
    VALUES v_ang1;
    
    -- sterg angajat 101
    DELETE FROM emp_alu
    WHERE employee_id = 101;
    
    -- obtin datele din tabelul employees
    SELECT *
    INTO v_ang2
    FROM employees
    WHERE employee_id = 101;
    
    -- inserez o linie oarecare in emp_alu
    INSERT INTO emp_alu
    VALUES(1000,'FN','LN','E',null,sysdate, 'AD_VP',1000, null,100,90);
    
    -- modific linia adaugata anterior cu valorile variabilei v_ang2
    UPDATE emp_alu
    SET ROW = v_ang2
    WHERE employee_id = 1000;
END;
/
rollback;
select * from emp_alu where employee_id in (100,101,1000);


--4 
DECLARE
     TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
     t tablou_indexat;
BEGIN
    -- punctul a
     FOR i IN 1..10 LOOP
         t(i) := i;
     END LOOP;
     
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: '); --nr
     FOR i IN t.FIRST..t.LAST LOOP --afisare elemente
         DBMS_OUTPUT.PUT(t(i) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE; --linie noua
     
    -- punctul b
     FOR i IN 1..10 LOOP
         IF i mod 2 = 1 
             THEN t(i) := null; --fac null valorile impare
         END IF;
     END LOOP;
     
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     FOR i IN t.FIRST..t.LAST LOOP
         DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
     
    -- punctul c
     t.DELETE(t.first);
     t.DELETE(5,7); --sterg de la 5 la 7
     t.DELETE(t.last);
     
     DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
     ' si valoarea ' || nvl(t(t.first),0));
    DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
     ' si valoarea ' || nvl(t(t.last),0));
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) 
          THEN DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
       END IF;
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
     
    -- punctul d
     t.delete;
     DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/


--5
DECLARE
     TYPE tablou_indexat IS TABLE OF emp_alu%ROWTYPE INDEX BY BINARY_INTEGER; 
     t tablou_indexat;
BEGIN
    -- stergere din tabel si salvare in tablou
     DELETE FROM emp_alu
     WHERE ROWNUM <= 2
     RETURNING employee_id, first_name, last_name, email, phone_number,
     hire_date, job_id, salary, commission_pct, manager_id,
     department_id
     BULK COLLECT INTO t; --returnez mai multe linii deci folosesc bulk collect
     
    --afisare elemente tablou
     DBMS_OUTPUT.PUT_LINE (t(1).employee_id ||' ' || t(1).last_name);
     DBMS_OUTPUT.PUT_LINE (t(2).employee_id ||' ' || t(2).last_name);
    
    --inserare cele 2 linii in tabel
     INSERT INTO emp_alu VALUES t(1);
     INSERT INTO emp_alu VALUES t(2);
 END;
/


--6
DECLARE
     TYPE tablou_imbricat IS TABLE OF NUMBER;
     t tablou_imbricat := tablou_imbricat(); --nu are nimic in el; initializare cu ajutorul constructorului
BEGIN
    -- punctul a
     FOR i IN 1..10 LOOP
         t.extend;
         t(i):=i;
     END LOOP;
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
    
     FOR i IN t.FIRST..t.LAST LOOP
         DBMS_OUTPUT.PUT(t(i) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
     
     -- punctul b
     FOR i IN 1..10 LOOP
         IF i mod 2 = 1 
            THEN t(i):=null;
        END IF;
     END LOOP;
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     
     FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
     
    -- punctul c
     t.DELETE(t.first);
     t.DELETE(5,7);
     t.DELETE(t.last);
     DBMS_OUTPUT.PUT_LINE('Primul element are indicele ' || t.first ||
     ' si valoarea ' || nvl(t(t.first),0));
     DBMS_OUTPUT.PUT_LINE('Ultimul element are indicele ' || t.last ||
     ' si valoarea ' || nvl(t(t.last),0));
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     
     FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) 
        THEN DBMS_OUTPUT.PUT(nvl(t(i), 0)|| ' ');
        END IF;
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
     
    -- punctul d
     t.delete;
     DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/


--7
DECLARE
    TYPE tablou_imbricat IS TABLE OF CHAR(1);
    t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
     i INTEGER;
BEGIN
     i := t.FIRST;
    WHILE i <= t.LAST LOOP
         DBMS_OUTPUT.PUT(t(i));
         i := t.NEXT(i); --urm valoare unde exista indice
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
     i := t.LAST;
    WHILE i >= t.FIRST LOOP
         DBMS_OUTPUT.PUT(t(i));
         i := t.PRIOR(i); --indicele precedent care exista 
     END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
     t.delete(2);
     t.delete(4);
     
    i := t.FIRST;
    WHILE i <= t.LAST LOOP
         DBMS_OUTPUT.PUT(t(i));
         i := t.NEXT(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    
     i := t.LAST;
    WHILE i >= t.FIRST LOOP
         DBMS_OUTPUT.PUT(t(i));
         i := t.PRIOR(i);
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--8
DECLARE
     TYPE vector IS VARRAY(20) OF NUMBER;
     t vector:= vector();
BEGIN
    -- punctul a
     FOR i IN 1..10 LOOP
         t.extend; 
         t(i):=i;
     END LOOP;
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     FOR i IN t.FIRST..t.LAST LOOP
         DBMS_OUTPUT.PUT(t(i) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
    -- punctul b
     FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN 
            t(i):=null;
        END IF;
     END LOOP;
     DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente: ');
     FOR i IN t.FIRST..t.LAST LOOP
        DBMS_OUTPUT.PUT(nvl(t(i), 0) || ' ');
     END LOOP;
     DBMS_OUTPUT.NEW_LINE;
    -- punctul c
    -- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!!
    -- din vectori nu se pot sterge elemente individuale!!!
    -- punctul d
     t.delete;
     DBMS_OUTPUT.PUT_LINE('Tabloul are ' || t.COUNT ||' elemente.');
END;
/


--9
CREATE OR REPLACE TYPE subordonati_alu AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE manageri_alu (cod_mgr NUMBER(10),
                                        nume VARCHAR2(20),
                                        lista subordonati_alu);
DECLARE
     v_sub subordonati_alu:= subordonati_alu(100,200,300);
     v_lista manageri_alu.lista%TYPE;
BEGIN
     INSERT INTO manageri_alu
     VALUES (1, 'Mgr 1', v_sub);
     INSERT INTO manageri_alu
     VALUES (2, 'Mgr 2', null);
    
     INSERT INTO manageri_alu
     VALUES (3, 'Mgr 3', subordonati_alu(400,500));
    
     SELECT lista
     INTO v_lista
     FROM manageri_alu
     WHERE cod_mgr=1;
    
     FOR j IN v_lista.FIRST..v_lista.LAST loop
         DBMS_OUTPUT.PUT_LINE (v_lista(j));
     END LOOP;
END;
/
SELECT * FROM manageri_alu;
DROP TABLE manageri_alu;
DROP TYPE subordonati_alu;


--10
--Crea?i tabelul emp_test_alu cu coloanele employee_id ?i last_name din tabelul employees.
--Ad?uga?i în acest tabel un nou câmp numit telefon de tip tablou imbricat. Acest tablou va men?ine
--pentru fiecare salariat toate numerele de telefon la care poate fi contactat. Insera?i o linie nou? în
--tabel. Actualiza?i o linie din tabel. Afi?a?i informa?iile din tabel. ?terge?i tabelul ?i tipul.
CREATE TABLE emp_test_alu AS
 SELECT employee_id, last_name 
 FROM employees
 WHERE ROWNUM <= 2;
 select * from emp_test_alu;
 
CREATE OR REPLACE TYPE tip_telefon_alu IS TABLE OF VARCHAR(12);
/
ALTER TABLE emp_test_alu
ADD (telefon tip_telefon_alu)
NESTED TABLE telefon STORE AS tabel_telefon_alu;

select * from emp_test_alu;


INSERT INTO emp_test_alu
VALUES (500, 'XYZ',tip_telefon_alu('074XXX', '0213XXX', '037XXX'));
select * from emp_test_alu;

UPDATE emp_test_alu
SET telefon = tip_telefon_alu('073XXX', '0214XXX')
WHERE employee_id=100;
select * from emp_test_alu;

SELECT a.employee_id, b.*
FROM emp_test_alu a, TABLE (a.telefon) b;--cu table afisez informatiile

DROP TABLE emp_test_alu;
DROP TYPE tip_telefon_alu;


--11. ?terge?i din tabelul emp_alu salaria?ii având codurile men?inute într-un vector.
--Obs. Comanda FORALL permite ca toate liniile unei colec?ii s? fie transferate simultan printr-o
--singur? opera?ie. Procedeul este numit bulk bind.
--FORALL index IN lim_inf..lim_sup
-- comanda_sql;
drop table emp_alu;
create table emp_alu as select * from employees;
--var 1
DECLARE
     TYPE tip_cod IS VARRAY(5) OF NUMBER(3);
     coduri tip_cod := tip_cod(205, 206);
BEGIN
     FOR i IN coduri.FIRST..coduri.LAST LOOP
         DELETE FROM emp_alu
         WHERE employee_id = coduri (i);
     END LOOP;
END;
/
SELECT employee_id FROM emp_alu;
ROLLBACK;


--Varianta 2, accesul se face o sng data la baza de date, mai rapid
DECLARE
     TYPE tip_cod IS VARRAY(20) OF NUMBER;
     coduri tip_cod := tip_cod(205,206);
BEGIN
     FORALL i IN coduri.FIRST..coduri.LAST
         DELETE FROM emp_alu
     WHERE employee_id = coduri (i);
END;
/
SELECT employee_id FROM emp_alu;
ROLLBACK;




------------- exercitii
--1. Men?ine?i într-o colec?ie codurile celor mai prost pl?ti?i 5 angaja?i care nu câ?tig? comision. Folosind aceast?
--colec?ie m?ri?i cu 5% salariul acestor angaja?i. Afi?a?i valoarea veche a salariului, respectiv valoarea nou? a
--salariului.
select employee_id, salary 
from  (    
            select employee_id, salary 
            from emp_alu
            where commission_pct is null
            order by salary
            )
where rownum <=5;

declare
    type tip_cod is varray(5) of emp_alu.employee_id%type; --declar tipul vectorului, number = emp_id
    coduri tip_cod; --declar o variabila de acest tip
    type tip_salariu is varray(5)of emp_alu.salary%type;
    salarii tip_salariu;
    salariu emp_alu.salary%type;
begin
    select employee_id, salary
    bulk collect into coduri, salarii --introduc mai multe valori intr un vector
    from  (    
            select employee_id, salary 
            from emp_alu
            where commission_pct is null
            order by salary
            )
    where rownum <=5;

        --update salariu + afisari
        for i in coduri.first..coduri.last loop
            DBMS_OUTPUT.PUT_LINE('Angajatul cu codul ' || coduri(i) || ' are salariul vechi ' ||salarii(i));
            update emp_alu
            set salary = salary + 0.05 * salary
            where employee_id = coduri(i);
            salarii(i) := salarii(i) + 0.05 * salarii(i);
            DBMS_OUTPUT.PUT_LINE('Angajatul cu codul ' || coduri(i) || ' are salariul nou ' ||salarii(i));
        end loop;
        
end;
/
rollback;


--2.
--tabel imbricat
create or replace type tip_orase_alu is table of varchar2(100);
/
create table excursie_alu (
            cod_excursie number(4),
            denumire varchar2(20),
            status varchar2(20)
        );
        
alter table excursie_alu
add (orase tip_orase_alu)
nested table orase store as table_orase_alu;

--a
insert into excursie_alu    
values (0, 'Ex_0', 'disponibila', 
        tip_orase_alu('oras1', 'oras2')
        );
        
declare
    v_orase tip_orase_alu := tip_orase_alu('oras1', 'oras2', 'oras3');
begin
    for i in 1..5 loop
        insert into excursie_alu    
        values (i, 'Ex_'||i, 'disponibila', v_orase);
    end loop;
end;
/
select * from excursie_alu;

-------b
--- ad?uga?i un ora? nou în list?, ce va fi ultimul vizitat în excursia respectiv?;
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_ex;
    v_orase tip_orase_alu;
    oras_t varchar2(20) := 'orasNou';
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;

    v_orase.extend;
    v_orase(v_orase.last) := oras_t;
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
      --afisare orase pt excursia cu codul cod_exc
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/
select * from excursie_alu;

 -- ad?uga?i un ora? nou în list?, ce va fi al doilea ora? vizitat în excursia respectiv?;
declare
    cod_exc excursie_alu.cod_excursie%type := &c_ex;
    v_orase tip_orase_alu;
    oras_t varchar2(20) := 'altOrasNou';
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    v_orase.extend;
    for i in reverse v_orase.next(2)..v_orase.last loop  
        v_orase(i) := v_orase(i-1);
    end loop;
    v_orase(2) := oras_t;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    --afisare dupa update
     for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/
rollback;
select * from excursie_alu;


--- inversa?i ordinea de vizitare a dou? dintre ora?e al c?ror nume este specificat;
declare
    cod_exc excursie_alu.cod_excursie%type := &c_ex;
    v_orase tip_orase_alu;
    oras1 varchar2(20) :='oras1';
    oras2 varchar2(20) :='oras2';
    v_idx1 number;
    v_idx2 number;
    v_aux varchar2(20);
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    -- retin indexul oraselor cautate ('oras1', 'oras2')
    for i in v_orase.first..v_orase.last loop
        if v_orase(i) = oras1 then 
            v_idx1 := i;
        elsif v_orase(i) = oras2 then 
            v_idx2 := i;
        end if;
    end loop;
    
    --swap
    v_aux := v_orase(v_idx1);
    v_orase(v_idx1) := v_orase(v_idx2);
    v_orase(v_idx2) := v_aux;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    --afisare dupa update
     for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/


--- elimina?i din list? un ora? al c?rui nume este specificat.
declare
    cod_exc excursie_alu.cod_excursie%type := &c_ex;
    v_orase tip_orase_alu;
    v_oras_eiminat varchar2(20) := 'oras3';
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    -- sterg orasele de pe pozitia i al caror nume este cel cautat
    for i in v_orase.first..v_orase.last loop
        if v_orase(i) = v_oras_eiminat then
            v_orase.delete(i); 
        end if;
    end loop;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    --afisare dupa update
     for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/


--c . Pentru o excursie al c?rui cod este dat, afi?a?i num?rul de ora?e vizitate, respectiv numele ora?elor.
declare
    cod_exc excursie_alu.cod_excursie%type := &c_ex;
    v_orase tip_orase_alu;
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    dbms_output.put_line('Numarul de orase vizitate este ' || v_orase.count);
    dbms_output.put_line('Numele oraselor ');
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/

--d. Pentru fiecare excursie afi?a?i lista ora?elor vizitate.
declare
    v_orase tip_orase_alu;
    type tip_cod is varray(6) of excursie_alu.cod_excursie%type;
    coduri tip_cod;
begin
    select cod_excursie
    bulk collect into coduri
    from excursie_alu;
    
    for i in coduri.first..coduri.last loop
        --selectez orasele pt excursia cu codul coduri(i)
        select orase
        into v_orase
        from excursie_alu
        where cod_excursie = coduri(i);
        
        --afisare orase pt excursia cu codul coduri(i)
        dbms_output.put_line('Excursia cu codul '|| coduri(i) || ' are orasele ' );
        for j in v_orase.first..v_orase.last loop
            dbms_output.put_line(v_orase(j));
        end loop;
    end loop;
end;
/

--e. Anula?i excursiile cu cele mai pu?ine ora?e vizitate
declare
    v_minim number := 99999;
begin
--actualizare nr minim orase
    for i in (select orase from excursie_alu) loop
        if i.orase.count < v_minim then
            v_minim := i.orase.count;
        end if;
    end loop;
    
    for i in (select cod_excursie, orase from excursie_alu) loop
        if i.orase.count = v_minim then --are nr minim de orase
            update excursie_alu
            set status = 'anulata:('
            where cod_excursie = i.cod_excursie;
        end if;
    end loop;
end;    
/
select * from excursie_alu;


--3. Rezolva?i problema anterioar? folosind un alt tip de colec?ie studiat.
--varray
drop table excursie_alu;
/
create or replace type tip_orase_alu is varray(10) of varchar2(100);
/
create table excursie_alu (
            cod_excursie number(4),
            denumire varchar2(20),
            status varchar2(20),
            orase tip_orase_alu
        );
        
--a. Insera?i 5 înregistr?ri în tabel. 
insert into excursie_alu    
values (0, 'Ex_0', 'disponibila', tip_orase_alu('oras1', 'oras2'));

declare
    v_orase tip_orase_alu := tip_orase_alu('oras1', 'oras2', 'oras3');
begin
    for i in 1..5 loop
        insert into excursie_alu    
        values (i, 'Ex_'||i, 'disponibila', v_orase);
    end loop;
end;
/
commit;
select * from excursie_alu;

-- b. Actualiza?i coloana orase pentru o excursie specificat?:
--- ad?uga?i un ora? nou în list?, ce va fi ultimul vizitat în excursia respectiv?;
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_e;
    v_orase tip_orase_alu;
    oras_t varchar2(20) := 'orasNou';
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    --adaug orasul la final
    v_orase.extend;
    v_orase(v_orase.count) := oras_t;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/
select * from excursie_alu;

--
--ad?uga?i un ora? nou în list?, ce va fi al doilea ora? vizitat în excursia respectiv?;
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_e;
    v_orase tip_orase_alu;
    oras_t varchar2(20) := 'AltOrasNou';
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    v_orase.extend;
    for i in reverse v_orase.first + 2..v_orase.last loop
        v_orase(i) := v_orase(i-1);
    end loop;
    v_orase(2) := oras_t;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/


--inversa?i ordinea de vizitare a dou? dintre ora?e al c?ror nume este specificat;
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_e;
    v_orase tip_orase_alu;
    oras1 varchar2(20) := 'oras1';
    oras2 varchar2(20) := 'oras2';
    v_idx1 number;
    v_idx2 number;
    v_aux varchar2(20);
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    for i in v_orase.first..v_orase.last loop
        if v_orase(i) = oras1 then
            v_idx1 := i;
        elsif v_orase(i) = oras2 then
            v_idx2 := i;
        end if;
    end loop;
    
    v_aux := v_orase(v_idx1);    
    v_orase(v_idx1) := v_orase(v_idx2);
    v_orase(v_idx2) := v_aux;
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/

--- elimina?i din list? un ora? al c?rui nume este specificat.
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_e;
    v_orase tip_orase_alu;
    v_oras_eiminat varchar2(20) := 'oras1';
    v_idx number;
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    --!!! nu merge cu delete(i), deci mai intai retin pozitia orasului
    for i in v_orase.first..v_orase.last loop
        if v_orase(i) = v_oras_eiminat then
            v_idx := i;
        end if;
    end loop;
    
    for i in v_idx..v_orase.last-1 loop
        v_orase(i) := v_orase(i+1); 
    end loop;
    
    v_orase.trim; --sterg ultimul element(null)
    
    update excursie_alu
    set orase = v_orase
    where cod_excursie = cod_exc;
    
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/

--c. Pentru o excursie al c?rui cod este dat, afi?a?i num?rul de ora?e vizitate, respectiv numele ora?elor
declare 
    cod_exc excursie_alu.cod_excursie%type := &c_e;
    v_orase tip_orase_alu;
begin
    select orase
    into v_orase
    from excursie_alu
    where cod_excursie = cod_exc;
    
    dbms_output.put_line('Numarul de orase vizitate este ' || v_orase.count);
    dbms_output.put_line('Numele oraselor ');
    for i in v_orase.first..v_orase.last loop
        dbms_output.put_line(v_orase(i));
    end loop;
end;
/

--d. Pentru fiecare excursie afi?a?i lista ora?elor vizitate.
begin
    for i in (select cod_excursie, orase from excursie_alu) loop
        dbms_output.put_line('Excursia cu codul '|| i.cod_excursie || ' are orasele ' );
        for j in 1.. i.orase.count loop
            dbms_output.put_line(i.orase(j));
        end loop;
    end loop;
end;
/

--e. Anula?i excursiile cu cele mai pu?ine ora?e vizitate.
declare
    v_minim number := 99999;
begin
--actualizare nr minim orase
    for i in (select orase from excursie_alu) loop
        if i.orase.count < v_minim then
            v_minim := i.orase.count;
        end if;
    end loop;
    
    for i in (select cod_excursie, orase from excursie_alu) loop
        if i.orase.count = v_minim then --are nr minim de orase
            update excursie_alu
            set status = 'anulata:('
            where cod_excursie = i.cod_excursie;
        end if;
    end loop;
end;    
/

select * from excursie_alu;