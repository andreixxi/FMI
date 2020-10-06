--recapitulare 1: lab 1-6; recapitulare 2: lab 7-9

--1. Crea?i un tabel temporar TEMP_TRANZ_PNU, cu datele persistente doar pe durata unei tranzac?ii.
--Acest tabel va con?ine o singur? coloan? x, de tip NUMBER. Introduce?i o înregistrare în tabel.
--Lista?i con?inutul tabelului. Permanentiza?i tranzac?ia ?i lista?i din nou con?inutul tabelului.
create global temporary table temp_tranz_alu(
 x number
 ) on commit delete rows; --se sterge dupa ce am terminat tranzactia

 select * from temp_tranz_alu;
 insert into temp_tranz_alu values(1);
 commit;
 
 
-- 2.Crea?i un tabel temporar TEMP_SESIUNE_PNU, cu datele persistente pe durata sesiunii. Cerin?ele
--sunt cele de la punctul 1. 
create global temporary table temp_sesiune_alu (
 x number
 ) on commit preserve rows; --raman doar la nivel de sesiune(pana ma deconectez)

 select * from temp_sesiune_alu;
 insert into temp_sesiune_alu values(1);
 commit;
 
 
 --3. lab
 
 
 --4.
 drop table temp_sesiune_alu;
 drop table temp_tranz_alu;
 
 
 --5, 6 tema
 
 
-- VIEWS
-- 7. S? se creeze o vizualizare VIZ_EMP30_PNU, care con?ine codul, numele, email-ul ?i salariul
--angaja?ilor din departamentul 30. S? se analizeze structura ?i con?inutul vizualiz?rii. Ce se
--observ? referitor la constrângeri? Ce se ob?ine de fapt la interogarea con?inutului vizualiz?rii ?
--Insera?i o linie prin intermediul acestei vizualiz?ri; comenta?i.
create or replace view viz_emp30_alu
as 
select employee_id, last_name, email, salary from employees
where department_id = 30;

select * from viz_emp30_alu;
select * from user_views;
desc viz_emp30_alu;

insert into viz_emp30_alu values(1000, 'name', 'email', 10000);

-- 8. Modifica?i VIZ_EMP30_PNU astfel încât s? fie posibil? inserarea/modificarea con?inutului tabelului
--de baz? prin intermediul ei. Insera?i ?i actualiza?i o linie prin intermediul acestei vizualiz?ri.
--Obs : Trebuie introduse neap?rat în vizualizare coloanele care au constrângerea NOT NULL în tabelul
--de baz? (altfel, chiar dac? tipul vizualiz?rii permite opera?ii LMD, acestea nu vor fi posibile din cauza
--nerespect?rii constrângerilor NOT NULL). 
desc employees;

create or replace view viz_emp30_alu
as 
select employee_id, last_name, email, salary, hire_date, job_id, department_id from employees
where department_id = 30;

insert into viz_emp30_alu values(1000, 'name', 'email', 10000, sysdate, 'SA_REP', 10);
select * from viz_emp30_alu;

update viz_emp30_alu
set email = 'email - 2'
where employee_id = 119;

rollback;


--11.  
--a) S? se creeze vizualizarea VIZ_EMP_DEP30_PNU, astfel încât aceasta s? includ? coloanele
--vizualiz?rii VIZ_EMP_30_PNU, precum ?i numele ?i codul departamentului. S? se introduc? aliasuri
--pentru coloanele vizualiz?rii. Asigura?i-v? c? exist? constrângerea de cheie extern? între tabelele de
--baz? ale acestei vizualiz?ri. 
create or replace view viz_emp_dep30_alu
as
select employee_id, last_name, email, salary, hire_date, job_id, ve.department_id, department_name 
from viz_emp30_alu ve
join departments d on (d.department_id = ve.department_id);

select * from viz_emp_dep30_alu;


--b) Insera?i o linie prin intermediul acestei vizualiz?ri. 
insert into viz_emp_dep30_alu  (employee_id, last_name, email, salary, hire_date, job_id, department_id)
values (1000, 'test', 'test', 6000, sysdate, 'PU_CLERK', 30);


--c)Care sunt coloanele actualizabile ale acestei vizualiz?ri? Ce fel de tabel este cel ale c?rui
--coloane sunt actualizabile? Insera?i o linie, completând doar valorile corespunz?toare. 
--d) Ce efect are o opera?ie de ?tergere prin intermediul vizualiz?rii viz_emp_dep30_pnu? Comenta?i.
delete from viz_emp_dep30_alu where employee_id = 1000;
select * from viz_emp_dep30_alu;


--12. S? se creeze vizualizarea VIZ_DEPT_SUM_PNU, care con?ine codul departamentului ?i pentru
--fiecare departament salariul minim, maxim si media salariilor. Ce fel de vizualizare se ob?ine
--(complexa sau simpla)? Se poate actualiza vreo coloan? prin intermediul acestei vizualiz?ri? 
create or replace view viz_dept_sum_alu (dept_id, min_sal, max_sal, avg_sal)
as select department_id, min(salary), max(salary), avg(salary) 
from employees
group by department_id;

select * from viz_dept_sum_alu;

update viz_dept_sum_alu 
set avg_sal = 10000; --data manipulation operation not legal on this view (vizualizare compusa)
  
  
--III. Definirea secven?elor 
--20. Crea?i o secven?? pentru generarea codurilor de departamente, SEQ_DEPT_PNU. Secven?a va
--începe de la 200, va cre?te cu 10 de fiecare dat? ?i va avea valoarea maxim? 10000, nu va cicla ?i
--nu va înc?rca nici un num?r înainte de cerere. 
create sequence seq_dept_alu
increment by 10
start with 300
maxvalue 10000
nocycle
nocache;

drop sequence seq_dept_alu;

--21. S? se selecteze informa?ii despre secven?ele utilizatorului curent (nume, valoare minim?, maxim?,
--de incrementare, ultimul num?r generat). 
select * from user_sequences;


--22. Crea?i o secven?? pentru generarea codurilor de angaja?i, SEQ_EMP_PNU. 
create sequence seq_emp_alu
increment by 1;-- to do


--24. S? se insereze câte o inregistrare nou? în EMP_PNU ?i DEPT_PNU utilizând cele 2 secven?e
--create. 
create sequence seq_dept_alu
increment by 10
start with 300
maxvalue 10000
nocycle
nocache;

select * from dept_alu;

--nextval incrementeaza valoarea secventei-trb macar o data executat 
insert into dept_alu
values (seq_dept_alu.nextval, 'test', null, 1700);

select seq_dept_alu.currval from dual; --returneaza val curenta fara a o incrementa
select seq_dept_alu.nextval from dual;


--IV. Definirea indec?ilor
--27. S? se creeze un index (normal, neunic) IDX_EMP_LAST_NAME_PNU, asupra coloanei last_name
--din tabelul emp_pnu
create index idx_emp_last_name_alu on emp_alu(last_name);
select * from employees where last_name = 'King';


--28. alter table ..  constrangeri de tip unique/ primary key(employee_id) pt automat, manual ca mai sus


--V. Clustere 
--33. Crea?i un cluster denumit angajati_pnu având cheia denumit? angajat ?i dimensiunea 512 bytes.
--Extensia ini?ial? alocat? cluster-ului va avea dimensiunea 100 bytes, iar urm?toarele extensii alocate
--vor avea dimensiunea de 50 bytes. Pentru a specifica dimensiunile în kilobytes sau megabytes se
--foloseste K, respectiv M (de exemplu, 100K sau 100M).
CREATE CLUSTER angajati_alu
(angajat NUMBER(6))
SIZE 512
STORAGE (initial 100 next 50); 


--34. Defini?i un index pe cheia cluster-ului.
CREATE INDEX idx_angajati_alu ON CLUSTER angajati_alu; 


--35.Ad?uga?i cluster-ului urm?toarele trei tabele:
--? tabelul ang_1_pnu care va con?ine angaja?ii având salariul mai mic decât 5000;
--? tabelul ang_2_pnu care va con?ine angaja?ii având salariul intre 5000 ?i 10000;
--? tabelul ang_3_pnu care va con?ine angaja?ii având salariul mai mare decât 10000. 
CREATE TABLE ang_1_alu
CLUSTER angajati_alu(employee_id)
AS SELECT * FROM employees WHERE salary < 5000; 

CREATE TABLE ang_2_alu
CLUSTER angajati_alu(employee_id)
AS SELECT * FROM employees WHERE salary >= 5000 and salary <= 10000; 

CREATE TABLE ang_3_alu
CLUSTER angajati_alu(employee_id)
AS SELECT * FROM employees WHERE salary > 10000; 


--36. Afi?a?i informa?ii despre cluster-ele create de utilizatorul current (USER_CLUSTERS). 
select * from USER_CLUSTERS;


--37. Afi?a?i numele cluster-ului din care face parte tabelul ang_3_pnu (USER_TABLES). 
select * from user_tables;


--38. Elimina?i tabelul ang_3_pnu din cluster. 
drop table ang_3_alu;

--39 ok
select * from user_tables;


--41
DROP CLUSTER nume_cluster
INCLUDING TABLES
CASCADE CONSTRAINTS; 


--VI. Definirea sinonimelor 
--tema hehehehehehehehehe

--VII. Definirea vizualiz?rilor materializate 
