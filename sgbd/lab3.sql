--ex 2
<< principal >> 
DECLARE
    v_client_id       NUMBER(4) := 1600;
    v_client_nume     VARCHAR2(50) := 'N1';
    v_nou_client_id   NUMBER(3) := 500;
BEGIN
    << secundar >>
    DECLARE
        v_client_id         NUMBER(4) := 0;
        v_client_nume       VARCHAR2(50) := 'N2';
        v_nou_client_id     NUMBER(3) := 300;
        v_nou_client_nume   VARCHAR2(50) := 'N3';
    BEGIN
        v_client_id := v_nou_client_id;
        principal.v_client_nume := 
                v_client_nume || ' ' || v_nou_client_nume;
         --pozitia 1
        dbms_output.put_line(v_client_id);
        dbms_output.put_line(v_client_nume);
        dbms_output.put_line(v_nou_client_id);
        dbms_output.put_line(v_nou_client_nume);
    END;
    v_client_id := ( v_client_id * 12 ) / 10;
 --pozitia 2
    dbms_output.put_line(v_client_id);
    dbms_output.put_line(v_client_nume);
    end;
/


VARIABLE g_mesaj VARCHAR2(50)
BEGIN
    :g_mesaj := 'Invat PL/SQL'; -- : pentru variabila de legatura
END;
/
PRINT g_mesaj

begin
    dbms_output.put_line('Invat PL/SQL');
end;
/


--3
variable g_mesaj varchar2(50);
begin
    :g_mesaj := 'Invat pl/sql';
end;
/
print g_mesaj

--var 2
begin
    dbms_output.put_line('invat pl/sql');
end;
/


--4
declare
    v_dep departments.department_name%TYPE;
begin
    select department_name 
    INTO v_dep 
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    GROUP BY department_name
    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                FROM employees
                                group by department_id );
    dbms_output.put_line('Departamentul ' || v_dep);
END;
/


declare
    v_dep departments.department_name%TYPE;
begin
    select department_name 
    INTO v_dep 
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    GROUP BY department_name
    HAVING COUNT(*) = (SELECT min(COUNT(*)) -- < in loc de = pt no data
                                FROM employees
                                group by department_id );
    dbms_output.put_line('Departamentul ' || v_dep);
    exception
        when too_many_rows then
           DBMS_OUTPUT.PUT_LINE('mai multe linii');
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('nicio linie');
END;
/


--5
VARIABLE rezultat VARCHAR2(35)
begin
    select department_name
    into :rezultat
    FROM employees e, departments d 
    WHERE e.department_id = d.department_id
    GROUP BY department_name
    HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                FROM employees
                                group by department_id );
    dbms_output.put_line('Departamentul ' || :rezultat);
END;
/
PRINT rezultat



--6
declare
    v_dep departments.department_name%TYPE;
    v_nr_angajati number(4);
begin
    select department_name, count(*)
    INTO v_dep, v_nr_angajati 
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
    GROUP BY department_name
    HAVING COUNT(*) = (SELECT max(COUNT(*)) -- < in loc de = pt no data
                                FROM employees
                                group by department_id );
    dbms_output.put_line('Departamentul ' || v_dep || ' si are '
                                || v_nr_angajati|| ' angajati');
    exception
        when too_many_rows then
           DBMS_OUTPUT.PUT_LINE('mai multe linii');
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('nicio linie');
END;
/


--7
--punem on la inceput pt a vedea unde si cu ce valoare a fost inlocuita variabila de la tastatura
set verify off
declare
    v_cod employees.employee_id%TYPE:=&p_cod;
    v_bonus NUMBER(8);
    v_salariu_anual NUMBER(8);
BEGIN
    SELECT salary*12 INTO v_salariu_anual
    FROM   employees 
    WHERE  employee_id = v_cod;
    IF v_salariu_anual>=200001
        then v_bonus:=20000;
    ELSIF v_salariu_anual BETWEEN 100001 AND 200000
        then v_bonus := 10000;
    ELSE  v_bonus := 5000;
END IF;
DBMS_OUTPUT.put_line('Bonusul este ' || v_bonus);
END;
/
SET VERIFY ON



--8
declare
    v_cod employees.employee_id%TYPE := &p_cod;
    v_bonus number(8);
    v_salariu_anual NUMBER(8);
BEGIN
    SELECT salary*12 INTO v_salariu_anual
    FROM   employees 
    WHERE  employee_id = v_cod;
    CASE 
        WHEN v_salariu_anual>=200001
            then v_bonus:=20000;
        WHEN v_salariu_anual BETWEEN 100001 AND 200000
            then v_bonus := 10000;
        ELSE
            v_bonus := 5000;
    END CASE;
dbms_output.put_line('Bonusul este ' || v_bonus);
END;
/

--9
--copie employees
create table emp_alu as select * from employees;
select * from emp_alu where employee_id = 80;

--dam valori 
DEFINE p_cod_sal = 180000
define p_cod_dept = 80
define p_procent =20
declare 
    v_cod_sal emp_alu.employee_id%TYPE:= &p_cod_sal;
    v_cod_dept emp_alu.department_id%TYPE := &p_cod_dept;
    v_procent NUMBER(8) := &p_procent;
begin
    update emp_alu
    SET
        department_id = v_cod_dept,
        salary = salary + ( salary * v_procent / 100 )
    WHERE
        employee_id = v_cod_sal;
    --cate randuri sunt modificate
    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    ELSE
        dbms_output.put_line('Actualizare realizata');
    END IF;

END;
/
ROLLBACK;



--10
select  last_day(sysdate) - sysdate from dual;
select  (sysdate) +1 from dual;

create table zile_alu (id number,
            data date,
            nume_zi varchar2(30)
            );
            
declare
    contor NUMBER(6) := 1;
    v_data DATE;
    maxim NUMBER(2) := last_day(sysdate) - sysdate;
begin
    loop
        v_data := sysdate+contor;
        INSERT INTO zile_alu VALUES (
        contor,
        v_data,
        to_char(v_data, 'Day')
    );
        contor := contor + 1;
        EXIT WHEN contor > maxim;
END LOOP;
END;
/

select * from zile_alu;
delete from zile_alu;

--11
declare
    contor NUMBER(6) := 1;
    v_data DATE;
    maxim NUMBER(2) := last_day(sysdate) - sysdate;
begin
    while contor <= maxim 
    LOOP 
            v_data := sysdate+contor;
            INSERT INTO zile_alu VALUES (
            contor,
            v_data,
            to_char(v_data, 'Day')
        );
        contor := contor + 1;
    END loop;
END;
/
select * from zile_alu;


--12
declare
    v_data DATE;
    maxim NUMBER(2) := last_day(sysdate) - sysdate;
begin
    for contor in 1..maxim 
    LOOP
        v_data := sysdate+contor;
        INSERT INTO zile_alu VALUES (
                            contor,
                            v_data,
                            to_char(v_data, 'Day')
    );
    END loop;
END;
/


--13
declare
    i POSITIVE := 1;
    max_loop CONSTANT POSITIVE := 10;
begin
    loop
        i := i+1;
        IF i> max_loop then 
            dbms_output.put_line('in loop i=' || i);
            GOTO urmator;
        END IF;
    END  loop;
        << urmator >>
        i := 1;
        dbms_output.put_line('dupa loop i=' || i);
END;
/


--var 2
declare
    i POSITIVE := 1;
    max_loop CONSTANT positive := 10;
begin
    i := 1;
    loop
        i := i + 1;
        dbms_output.put_line('in loop i=' || i);
        EXIT WHEN i > max_loop;
END LOOP;
    i := 1;
    dbms_output.put_line('dupa loop i=' || i);
END;
/


----------------------------
--EXERCITII
--1
declare
    numar NUMBER(3) := 100;
    mesaj1 VARCHAR2(255) := 'text 1';
    mesaj2 VARCHAR2(255) := 'text 2';
begin
                    --sub-bloc
                    declare
                        numar NUMBER(3) := 1;
                        mesaj1 VARCHAR2(255) := 'text 2';
                        mesaj2 VARCHAR2(255) := 'text 3';
                    begin
                        numar := numar + 1;
                        mesaj2 := mesaj2 || ' adaugat in sub-bloc';
                    END;
    numar := numar + 1;
    mesaj1 := mesaj1 || ' adaugat un blocul principal';
    mesaj2 := mesaj2 || ' adaugat in blocul principal';
END;


/*
a)Valoarea variabilei numar în subbloc este: 2
b)Valoarea variabilei mesaj1 în subbloc este: text 2
c)Valoarea variabilei mesaj2 în subbloc este: text 3 adaugat in sub-bloc
d)Valoarea variabilei numar în bloc este: 101
e)Valoarea variabilei mesaj1 în bloc este:  text 1 adaugat un blocul principal
f)Valoarea variabilei mesaj2 în bloc este:  text 2 adaugat un blocul principal
*/


----- ex 2
--a
--zile cu imprumuturi
select book_date, count(1)
from rental
group by book_date;

--toate zilele din luna 
select to_char(to_date('01-OCT-20', 'dd-MM-yy') + level - 1)
from dual 
connect by level <= 31;

select octombrie.book_date, nvl(zile_cu_imprumut.numar, 0) nr_imprumuturi
from (
        select to_date(book_date) book_date, count(1) numar
        from rental
        group by book_date
        ) zile_cu_imprumut
right join ( 
        select to_char(to_date('01-OCT-20', 'dd-MM-yy') + level - 1) book_date
        from dual 
        connect by level <= 31
        ) octombrie
on zile_cu_imprumut.book_date = octombrie.book_date
order by book_date;


--b
create table octombrie_alu (
    id number primary key,
    data date not null unique
);
COMMIT;

select * from octombrie_alu;

declare
    ziua date := '01-OCT-20';
begin
    for i in 1..31 loop
        insert into octombrie_alu 
        values (i, ziua);
        ziua := ziua + 1;
      end loop;  
end;
select * from octombrie_alu;

select data, nvl(numar, 0)
from octombrie_alu
left join (
    select to_date(book_date) data, count(1) numar
    from rental
    group by book_date
    )
    using (data)
    order by data;



-- ex 3
/*Defini?iun  bloc  anonim  în  care s? se determine num?rul 
de filme  (titluri)  împrumutate  de  un membru al c?rui nume
este introdus de la tastatur?. Trata?iurm?toarele dou? 
situa?ii: nu exist? nici un membru cu numedat; exist? mai mul?i 
membrii cu acela?i nume.*/
select * from title_copy;

select * 
from rental
where member_id = 101
order by title_id;

--nr total imprumutir(chiar daca a luat copii diferite pt acelasi film)
select count(*)
from rental
where member_id = 101
order by title_id;

--
select count(distinct title_id)
from rental
where member_id = 101
order by title_id;


select member_id, count(distinct title_id)
from rental
group by member_id;


declare
    numele member.last_name%type := '&input';
    rental_id number;
    rental_count number(2);
begin    
    select member_id
    into rental_id
    from member m
    where lower(m.last_name) = lower(numele);

    select count(distinct title_id)
    into rental_count
    from rental r, member m
    where r.member_id = m.member_id
    and lower(m.last_name) = lower(numele);
    
  DBMS_OUTPUT.PUT_LINE(rental_count || ' filme imprumutate de ' || numele);
    
    exception
        when no_data_found then DBMS_OUTPUT.PUT_LINE('no data found');
        when too_many_rows then DBMS_OUTPUT.PUT_LINE('too many rows');
end;
/


-- ex 4
declare
    numele member.last_name%type := '&input';
    rental_id number;
    rental_count number(2);
    total_filme number;
    procentaj_imprumutat number;
begin    
    select member_id
    into rental_id
    from member m
    where lower(m.last_name) = lower(numele);

    select count(distinct title_id)
    into rental_count
    from rental r, member m
    where r.member_id = m.member_id
    and lower(m.last_name) = lower(numele);
    
  DBMS_OUTPUT.PUT_LINE(rental_count || ' filme imprumutate de ' || numele);
    
    select count(*) --nr total de filme
    into total_filme
    from title;
    
    procentaj_imprumutat := rental_count / total_filme; -- filme imprumutate / total
    if procentaj_imprumutat >= 0.75 then
          DBMS_OUTPUT.PUT_LINE('Categoria 1');
    elsif procentaj_imprumutat >= 0.5 then
             DBMS_OUTPUT.PUT_LINE('Categoria 2');
    elsif procentaj_imprumutat >= 0.25 then
            DBMS_OUTPUT.PUT_LINE('Categoria 3');
    else 
        DBMS_OUTPUT.PUT_LINE('Categoria 4');
    end if;
    
    exception
        when no_data_found then DBMS_OUTPUT.PUT_LINE('no data found');
        when too_many_rows then DBMS_OUTPUT.PUT_LINE('too many rows');
end;
/


-- ex 5.
create table member_alu as
select * from member;

select * from member_alu;

alter table member_alu --adaug coloana
add discount number;


declare
    cod_membru number := '&input'; --id dat de la tastatura
    rental_count number(2); --nr titluri imprumtuate
    total_filme number;
    procentaj_imprumutat number;
    discount_nou number;
begin    
    
    select count(distinct title_id)
    into rental_count
    from rental r, member m
    where r.member_id = m.member_id
    and m.member_id = cod_membru; --are acelasi id
    
  DBMS_OUTPUT.PUT_LINE(rental_count || ' filme imprumutate de persoana cu id-ul ' || cod_membru);
    
    select count(*) --nr total de filme
    into total_filme
    from title;
    
    procentaj_imprumutat := rental_count / total_filme; -- filme imprumutate / total
    if procentaj_imprumutat >= 0.75 then 
          discount_nou := 0.1;
          DBMS_OUTPUT.PUT_LINE('Categoria 1');
    elsif procentaj_imprumutat >= 0.5 then
            discount_nou := 0.05;
            DBMS_OUTPUT.PUT_LINE('Categoria 2');
    elsif procentaj_imprumutat >= 0.25 then
            discount_nou := 0.03;
            DBMS_OUTPUT.PUT_LINE('Categoria 3');
    else 
        discount_nou := 0;
        DBMS_OUTPUT.PUT_LINE('Categoria 4');
    end if;
    
    if discount_nou != 0 then
        update member_alu
        set discount = discount_nou
        where member_id = cod_membru;
        DBMS_OUTPUT.PUT_LINE('discountul este ' || discount_nou);
    else
        DBMS_OUTPUT.PUT_LINE('nu am facut update pt discount');
    end if;
    
    
    if SQL%rowcount > 0 
        then DBMS_OUTPUT.PUT_LINE('Discount adaugat pt membrul ' || cod_membru);
    else 
        DBMS_OUTPUT.PUT_LINE('Nu s a facut update');
    end if;
    
    exception
        when no_data_found then DBMS_OUTPUT.PUT_LINE('no data found');
        when too_many_rows then DBMS_OUTPUT.PUT_LINE('too many rows');
end;
/

select * from member_alu;
select * from member_alu where member_id = 110;