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
 
 
 --5. S? se creeze un tabel temporar angajati_azi_pnu. Sesiunea fiec?rui utilizator care se ocup? de
--angaj?ri va permite stocarea în acest tabel a angaja?ilor pe care i-a recrutat la data curent?. La
--sfâr?itul sesiunii, aceste date vor fi ?terse. Se aloc? spa?iu acestui tabel la creare ? 
create global temporary table angajati_azi_alu
on commit preserve rows -- La sfâr?itul sesiunii, datele vor fi ?terse
as select last_name, department_id, employee_id
from employees
where hire_date = sysdate;

select * from angajati_azi_alu;

-- 6   Insera?i o nou? înregistrare în tabelul angajati_azi_pnu. Incerca?i actualizarea tipului de date al
--coloanei last_name a tabelului angajati_azi_pnu.
insert into angajati_azi_alu
values ('nume', 500, 21); 
select * from angajati_azi_alu;

desc angajati_azi_alu; 
alter table angajati_azi_alu
MODIFY (last_name VARCHAR2(30)); -- era 25 

 
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
where employee_id = 118;

rollback;


-- 9.  S? se creeze o vizualizare, VIZ_EMPSAL50_PNU, care contine coloanele cod_angajat, nume,
--email, functie, data_angajare si sal_anual corespunz?toare angaja?ilor din departamentul 50.
--Analiza?i structura ?i con?inutul vizualiz?rii. 
create view viz_empsal50_alu as 
    select employee_id, last_name, email, job_id, hire_date, salary * 12 as salariu_anual
    from employees
    where department_id = 50;
select * from viz_empsal50_alu;
desc viz_empsal50_alu;


-- 10. a) Insera?i o linie prin intermediul vizualiz?rii precedente. Comenta?i.
--? virtual column not allowed here
insert into viz_empsal50_alu values(2000, 'nume', 'email', 'job_id', sysdate, 80000);
select * from viz_empsal50_alu;

-- b) Care sunt coloanele actualizabile ale acestei vizualiz?ri?

-- c) Insera?i o linie specificând valori doar pentru coloanele actualizabile.

-- d) Analiza?i con?inutul vizualiz?rii viz_empsal50_pnu ?i al tabelului emp_pnu. 
select * from viz_empsal50_alu;
select * from emp_alu;


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
  

--13. Modifica?i vizualizarea VIZ_EMP30_PNU astfel încât s? nu permit? modificarea sau inserarea de
--linii ce nu sunt accesibile ei. Vizualizarea va selecta ?i coloana department_id. Da?i un nume
--constrângerii ?i reg?si?i-o în vizualizarea USER_CONSTRAINTS din dic?ionarul datelor. Încerca?i s?
--modifica?i ?i s? insera?i linii ce nu îndeplinesc condi?ia department_id = 30. 
select * from viz_emp30_alu;

create or replace view viz_emp30_alu 
as select employee_id, last_name, email, salary, department_id
from employees
where department_id = 30
with check option constraint viz_emp30_alu_constraint;

select * from user_constraints
where constraint_name = upper('viz_emp30_alu_constraint');

desc viz_emp30_alu;
insert into viz_emp30_alu
values (400, 'nume', 'email', 20000, 50);


--14. a) Defini?i o vizualizare, VIZ_EMP_S_PNU, care s? con?in? detalii despre angaja?ii corespunz?tori
--departamentelor care încep cu litera S. Se pot insera/actualiza linii prin intermediul acestei
--vizualiz?ri? În care dintre tabele? Ce se întâmpl? la ?tergerea prin intermediul vizualiz?rii?
create view viz_emp_s_alu
as select * from employees e
where ( select department_name 
      from departments
      where department_id = e.department_id
      ) like 'S%';
select * from departments order by department_name;
-- dep_id = 80, 150, 50 
select * from viz_emp_s_alu;

-- b) Recrea?i vizualizarea astfel încât s? nu se permit? nici o opera?ie asupra tabelelor de baz? prin
--intermediul ei. Încerca?i s? introduce?i sau s? actualiza?i înregistr?ri prin intermediul acestei vizualiz?ri. 
create or replace view viz_emp_s_alu
as select * from employees e
where ( select department_name 
      from departments
      where department_id = e.department_id
      ) like 'S%'
with read only;

select * from viz_emp_s_alu;

update viz_emp_s_alu
set email = 'email - 2'
where employee_id = 120;


-- 15. S? se consulte informa?ii despre vizualiz?rile utilizatorului curent. Folosi?i vizualizarea dic?ionarului
--datelor USER_VIEWS (coloanele VIEW_NAME ?i TEXT).
--Obs: Coloana TEXT este de tip LONG a?a c? trebuie utilizat? comanda SET LONG n (din SQL*Plus)
--pentru a seta num?rul de caractere afi?ate în cazul select?rii unei coloane de tip LONG. 
select * from user_views;


-- 16.S? se selecteze numele, salariul, codul departamentului ?i salariul maxim din departamentul din
--care face parte, pentru fiecare angajat. Este necesar? o vizualizare inline? 
select last_name, salary, department_id, max(salary)
from employees
group by last_name, salary, department_id;


--17. S? se creeze o vizualizare VIZ_SAL_PNU, ce con?ine numele angaja?ilor, numele
--departamentelor, salariile ?i loca?iile (ora?ele) pentru to?i angaja?ii. Eticheta?i sugestiv coloanele.
--Considera?i ca tabele de baz? tabelele originale din schema HR. Care sunt coloanele actualizabile? 
create view viz_sal_alu 
as select last_name, -- last_name as 'nume' --- from keyword not found where expected :|
          department_name,
          salary, 
          city
from employees
join departments using (department_id)
join locations using (location_id);


--18. S? se creeze vizualizarea V_EMP_PNU asupra tabelului EMP_PNU care con?ine codul, numele,
--prenumele, email-ul ?i num?rul de telefon ale angaja?ilor companiei. Se va impune unicitatea
--valorilor coloanei email ?i constrângerea de cheie primar? pentru coloana corespunz?toare codului
--angajatului.
--Obs: Constrângerile asupra vizualiz?rilor pot fi definite numai în modul DISABLE NOVALIDATE.
--Aceste cuvinte cheie trebuie specificate la declararea constrângerii, nefiind permis? precizarea
--altor st?ri.
CREATE VIEW viz_emp_alu (
        employee_id, 
        first_name,
        last_name, 
        email UNIQUE DISABLE NOVALIDATE, 
        phone_number,
        CONSTRAINT pk_viz_emp_alu PRIMARY KEY (employee_id) DISABLE NOVALIDATE
        )
AS SELECT employee_id, first_name, last_name, email, phone_number
FROM emp_alu;


--19. S? se adauge o constrângere de cheie primar? asupra vizualiz?rii viz_emp_s_pnu (alter view). 
alter view viz_emp_s_alu 
add primary key (employee_id) disable novalidate;


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
create sequence seq_emp_alu;


--23. S? se modifice toate liniile din EMP_PNU (dac? nu mai exist?, îl re-creea?i), regenerând codul
--angaja?ilor astfel încât s? utilizeze secven?a SEQ_EMP_PNU ?i s? avem continuitate în codurile
--angaja?ilor. 
drop table emp_alu;
create table emp_alu as select * from employees;
update emp_alu
set employee_id = seq_emp_alu.nextval;
select * from emp_alu;

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


--25. S? se selecteze valorile curente ale celor 2 secven?e. 
select seq_dept_alu.currval from dual;
select seq_emp_alu.currval from dual;


-- 26. ?terge?i secven?a SEQ_DEPT_PNU. 
drop sequence seq_dept_alu;


--IV. Definirea indec?ilor
--27. S? se creeze un index (normal, neunic) IDX_EMP_LAST_NAME_PNU, asupra coloanei last_name
--din tabelul emp_pnu
create index idx_emp_last_name_alu on emp_alu(last_name);
select * from employees where last_name = 'King';


--28.S? se creeze indec?i unici asupra codului angajatului (employee_id) ?i asupra combina?iei
--last_name, first_name, hire_date prin dou? metode (automat ?i manual).
--Obs : Pentru metoda automat? impune?i constrângeri de cheie primar? asupra codului angajatului ?i
--constrângere de unicitate asupra celor 3 coloane. Este recomandabil? aceast? metod?.  
--alter table ..  constrangeri de tip unique/ primary key(employee_id) pt automat, manual ca mai sus
create unique index idx_emp_alu on emp_alu(employee_id);
alter table emp_alu
add primary key (employee_id)
add unique (last_name, first_name, hire_date);


--29. Crea?i un index neunic asupra coloanei department_id din EMP_PNU pentru a eficientiza join-urile
--dintre acest tabel si DEPT_PNU. 
create index idx_dept_id_alu on emp_alu(department_id);


--30. Prespupunând c? se fac foarte des c?utari case insensitive asupra numelui departamentului ?i
--asupra numelui angajatului, defini?i doi indec?i baza?i pe expresiile UPPER(department_name),
--respectiv LOWER(last_name). 
create index idx_dep_name_alu on dept_alu(upper(department_name));
create index idx_last_name_alu on emp_alu(lower(last_name));


--31. S? se selecteze din dic?ionarul datelor numele indexului, numele coloanei, pozi?ia din lista de
--coloane a indexului ?i proprietatea de unicitate a tuturor indec?ilor defini?i pe tabelele EMP_PNU ?i
--DEPT_PNU. 
select index_name, column_name, column_position, uniqueness
from user_indexes
join user_ind_columns
using(index_name)
where user_indexes.table_name in ('EMP_ALU', 'DEPT_ALU');


--32.Elimina?i indexul de la exerci?iul 27. 
drop index idx_emp_last_name_alu;


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
select cluster_name
from user_tables
where table_name = 'ANG_3_ALU';


--38. Elimina?i tabelul ang_3_pnu din cluster. 
drop table ang_3_alu;

--39 ok
select * from user_tables
where table_name = 'ANG_3_ALU';


--40  Sterge?i tabelul ang_2_pnu. Consulta?i vizualizarea USER_TABLES afi?a?i numele tabelelor care
--fac parte din cluster-ul definit. 
drop table ang_2_alu;

select * from user_tables
where cluster_name = 'ANGAJATI_ALU';


--41  Sterge?i cluster-ul eliminând si tabelele asociate. 
DROP CLUSTER ANGAJATI_ALU
INCLUDING TABLES
CASCADE CONSTRAINTS; 


--VI. Definirea sinonimelor 
--42. Crea?i un sinonim public EMP_PUBLIC_PNU pentru tabelul EMP_PNU. 
create public synonym emp_public_alu for emp_alu; -- nu a mers


--43. Crea?i un sinonim V30_PNU pentru vizualizarea VIZ_EMP30_PNU. 
create synonym v30_alu for viz_emp30_alu;


--44. Crea?i un sinonim pentru DEPT_PNU. Utiliza?i sinonimul pentru accesarea datelor din tabel.
--Redenumi?i tabelul (RENAME …TO ..). Încerca?i din nou s? utiliza?i sinonimul pentru a accesa
--datele din tabel. Ce se ob?ine? 
create synonym d_alu for dept_alu;
select * from d_alu;
rename d_alu to sd_alu;
rename sd_alu to d_alu;

--45. Elimina?i sinonimele create anterior prin intermediul unui script care s? selecteze numele
--sinonimelor din USER_SYNONYMS care au termina?ia “pnu” ?i s? genereze un fi?ier cu comenzile
--de ?tergere corespunz?toare.
--SET FEEDBACK OFF
--SET HEADING OFF
--SET TERMOUT OFF
--SPOOL 'H:\...\delSynonym.sql'
--SELECT 'DROP SYNONYM ' || synonym_name || ';'‘
--FROM user_synonyms
--WHERE lower(synonym_name) LIKE '%alu'
--/
--SPOOL OFF
--SET FEEDBACK ON
--SET HEADING ON
--SET TERMOUT ON
select * from user_synonyms
where synonym_name like '%ALU';

drop synonym v30_alu;
drop synonym d_alu;

--VII. Definirea vizualiz?rilor materializate 
--46. S? se creeze ?i s? se completeze cu înregistr?ri o vizualizare materializat? care va con?ine numele
--joburilor, numele departamentelor ?i suma salariilor pentru un job, în cadrul unui departament.
--Reactualiz?rile ulterioare ale acestei vizualiz?ri se vor realiza prin reexecutarea cererii din defini?ie.
--Vizualizarea creat? va putea fi aleas? pentru rescrierea cererilor.
CREATE MATERIALIZED VIEW job_dep_sal_alu
 BUILD IMMEDIATE
 REFRESH COMPLETE
 ENABLE QUERY REWRITE
 AS SELECT d.department_name, j.job_title, SUM(salary) suma_salarii
 FROM employees e, departments d, jobs j
 WHERE e.department_id = d. department_id
 AND e.job_id = j.job_id
 GROUP BY d.department_name, j.job_title;
 
 
 --47.S? se creeze tabelul job_dep_pnu. Acesta va fi utilizat ca tabel sumar preexistent în crearea unei
--vizualiz?ri materializate ce va permite diferen?e de precizie ?i rescrierea cererilor.
CREATE TABLE job_dep_alu (
 job VARCHAR2(10),
 dep NUMBER(4),
 suma_salarii NUMBER(9,2));
 
CREATE MATERIALIZED VIEW vm_job_dep_alu
 ON PREBUILT TABLE WITH REDUCED PRECISION
 ENABLE QUERY REWRITE
 AS SELECT d.department_name, j.job_title, SUM(salary) suma_salarii
 FROM employees e, departments d, jobs j
 WHERE e.department_id = d. department_id
 AND e.job_id = j.job_id
 GROUP BY d.department_name, j.job_title;
 
 
--48. S? se creeze o vizualizare materializat? care con?ine informa?iile din tabelul dep_pnu, permite
--reorganizarea acestuia ?i este reactualizat? la momentul cre?rii, iar apoi la fiecare 5 minute.
CREATE MATERIALIZED VIEW LOG ON dept_alu;

CREATE MATERIALIZED VIEW dep_vm_alu
 REFRESH FAST START WITH SYSDATE NEXT SYSDATE + 1/288
 WITH PRIMARY KEY
 AS SELECT * FROM dept_alu;
 
 
 --49.  S? se modifice vizualizarea materializat? job_dep_sal_pnu creat? anterior, astfel încât metoda de
--reactualizare implicit? s? fie de tip FAST, iar intervalul de timp la care se realizeaz? reactualizarea
--s? fie de 7 zile. Nu va fi permis? utilizarea acestei vizualiz?ri pentru rescrierea cererilor.
ALTER MATERIALIZED VIEW job_dep_sal_alu
 REFRESH FAST NEXT SYSDATE + 7 DISABLE QUERY REWRITE;
 
 
-- 50.S? se ?tearg? vizualiz?rile materializate create anterior. 
DROP MATERIALIZED VIEW dep_vm_alu;
DROP MATERIALIZED VIEW job_dep_sal_alu;