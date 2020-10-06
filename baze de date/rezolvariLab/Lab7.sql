-- Lab 7
--INSERT
--1. Să se creeze tabelele EMP_pnu, DEPT_pnu prin copierea structurii şi conţinutului tabelelor EMPLOYEES, respectiv DEPARTMENTS. 
create table emp_alu as select * from employees;
create table dept_alu as select * from departments;


--2. Listaţi structura tabelelor sursă şi a celor create anterior. Ce se observă? 
desc emp_alu;
desc employees;


--3. Listaţi conţinutul tabelelor create anterior. 
select * from emp_alu;
select * from dept_alu;


--4. Pentru introducerea constrângerilor de integritate, executaţi instrucţiunile LDD indicate în
--continuare
ALTER TABLE emp_alu
ADD CONSTRAINT pk_emp_alu PRIMARY KEY(employee_id);
ALTER TABLE dept_alu
ADD CONSTRAINT pk_dept_alu PRIMARY KEY(department_id);
ALTER TABLE emp_alu
ADD CONSTRAINT fk_emp_dept_alu
FOREIGN KEY(department_id) REFERENCES dept_alu(department_id);


--5
--a) merge? -- nu pentru ca nu sunt toate valorile coloanelor specificate
insert into dept_alu
values(300, 'Programare');
desc dept_alu;

--b) merge dar avem valori null la coloanele nespecificate
INSERT INTO dept_alu (department_id, department_name)
VALUES (300, 'Programare');
select * from dept_alu;
rollback;

--c)  conversia nu se poate face din varchar2 la number
INSERT INTO dept_alu (department_name, department_id)
VALUES (300, 'Programare'’);

--d) merge si pune null la coloane nespcificate
INSERT INTO DEPT_alu (department_id, department_name, location_id)
VALUES (300, 'Programare', null);
rollback;
select * from dept_alu where department_id = 300;

--e) nu merge pt ca lipseste department_id care este primary key; pe versiuni mai noi exista identity insert 
-- unde cheia primara este autogenerata
INSERT INTO DEPT_alu (department_name, location_id)
VALUES ('Programare', null);


--6. Să se insereze un angajat corespunzător departamentului introdus anterior în tabelul EMP_pnu,
--precizând valoarea NULL pentru coloanele a căror valoare nu este cunoscută la inserare
--(metoda implicită de inserare). Efectele instrucţiunii să devină permanente. 
desc emp_alu;
select * from emp_alu;

insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values (207, 'Andrei', 'Lungu', 'shdas@bla.com', to_date('01-05-2020', 'DD-MM-YYYY'), 'IT_PROG', 300);

rollback;


--7. Să se mai introducă un angajat corespunzător departamentului 300, precizând după numele
-- tabelului lista coloanelor în care se introduc valori (metoda explicita de inserare). Se presupune că
-- data angajării acestuia este cea curentă (SYSDATE). Salvaţi înregistrarea.

insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values (208, 'Andrei', 'Lungu', 'shdas@bla.com', sysdate, 'IT_PROG', 300);

rollback;


--8.Este posibilă introducerea de înregistrări prin intermediul subcererilor (specificate în locul tabelului).
-- Ce reprezintă, de fapt, aceste subcereri? (view) Încercaţi dacă este posibilă introducerea unui
-- angajat, precizând pentru valoarea employee_id o subcerere care returnează (codul maxim +1). 
insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values ((select max(employee_id) + 1 from emp_alu), 'Andrei', 'Lungu', 'shdas@bla.com', sysdate, 'IT_PROG', 300);

select * from emp_alu where employee_id = 207;
rollback;

--9. Creaţi un nou tabel, numit EMP1_PNU, care va avea aceeaşi structură ca şi EMPLOYEES, dar
--nici o înregistrare. Copiaţi în tabelul EMP1_PNU salariaţii (din tabelul EMPLOYEES) al căror
--comision depăşeşte 25% din salariu.
create table emp1_alu as select * from employees;
truncate table emp1_alu; -- sterge tot
select * from emp1_alu;

insert into emp1_alu (select * from employees where commission_pct > 0.25);
rollback;


--10.Inseraţi o nouă înregistrare în tabelul EMP_PNU care să totalizeze salariile, să facă media
--comisioanelor, iar câmpurile de tip dată să conţină data curentă şi câmpurile de tip caracter să
--conţină textul 'TOTAL'. Numele şi prenumele angajatului să corespundă utilizatorului curent
--(USER). Pentru câmpul employee_id se va introduce valoarea 0, iar pentru manager_id şi
--department_id se va da valoarea null.

insert into emp_alu 
values (0, user, user, 'TOTAL', 'TOTAL', sysdate, 'IT_PROG', (select sum(salary) from employees), (select avg(commission_pct) from employees), null, null);
select * from emp_alu;
rollback;


--11. Să se creeze un fişier (script file) care să permită introducerea de înregistrări în tabelul EMP_PNU
-- în mod interactiv. Se vor cere utilizatorului: codul, numele, prenumele si salariul angajatului.
-- Câmpul email se va completa automat prin concatenarea primei litere din prenume şi a primelor 7
-- litere din nume. Executati script-ul pentru a introduce 2 inregistrari in tabel.
accept p_id prompt 'Id= ';
accept p_nume prompt 'Nume= ';
accept p_prenume prompt 'Prenume= ';
accept p_salariu prompt 'Salariu= ';
insert into emp_alu (employee_id, last_name, first_name, email, salary, job_id, hire_date)
values (&p_id, '&p_nume', '&p_prenume', concat(substr('&p_prenume', 0, 1), substr('&p_nume', 0, 7)), &p_salariu, 'IT_PROG', sysdate);
select * from emp_alu where employee_id = &p_id;
rollback;

--12. Creaţi 2 tabele emp2_pnu şi emp3_pnu cu aceeaşi structură ca tabelul EMPLOYEES, dar fără
-- înregistrări (acceptăm omiterea constrângerilor de integritate). Prin intermediul unei singure comenzi,
-- copiaţi din tabelul EMPLOYEES:
-- - în tabelul EMP1_PNU salariaţii care au salariul mai mic decât 5000;
-- - în tabelul EMP2_PNU salariaţii care au salariul cuprins între 5000 şi 10000;
-- - în tabelul EMP3_PNU salariaţii care au salariul mai mare decât 10000.
-- Verificaţi rezultatele, apoi ştergeţi toate înregistrările din aceste tabele
create table emp2_alu as select * from employees;
create table emp3_alu as select * from employees;
truncate table emp2_alu; -- sterge tot
truncate table emp3_alu;
select * from emp2_alu;
select * from emp3_alu;

insert into emp1_alu (select * from employees where salary < 5000);
select * from emp1_alu;
insert into emp2_alu (select * from employees where salary >= 5000 and salary <= 10000); 
select * from emp2_alu;
insert into emp3_alu (select * from employees where salary > 10000);
select * from emp3_alu;
rollback;


--13. Să se creeze tabelul EMP0_PNU cu aceeaşi structură ca tabelul EMPLOYEES (fără constrângeri),
-- dar fără nici o înregistrare. Copiaţi din tabelul EMPLOYEES:
-- - în tabelul EMP0_PNU salariaţii care lucrează în departamentul 80;
-- - în tabelul EMP1_PNU salariaţii care au salariul mai mic decât 5000;
-- - în tabelul EMP2_PNU salariaţii care au salariul cuprins între 5000 şi 10000;
-- - în tabelul EMP3_PNU salariaţii care au salariul mai mare decât 10000.
-- Dacă un salariat se încadrează în tabelul emp0_pnu atunci acesta nu va mai fi inserat şi în alt tabel
-- (tabelul corespunzător salariului său).
create table emp0_alu as select * from employees;
truncate table emp0_alu; -- sterge tot

insert into emp0_alu (select * from employees where department_id = 80);
select * from emp0_alu;
insert into emp1_alu (select * from employees where salary < 5000 and department_id != 80);
select * from emp1_alu;
insert into emp2_alu (select * from employees where salary >= 5000 and salary <= 10000 and department_id != 80);
select * from emp2_alu;
insert into emp3_alu (select * from employees where salary > 10000 and department_id != 80);
select * from emp3_alu;
rollback;

-- UPDATE
--14.Măriţi salariul tuturor angajaţilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anulaţi
--modificările. 
select * from emp_alu;
update emp_alu 
set salary = salary + salary * 0.05;
rollback;


--15. Schimbaţi jobul tuturor salariaţilor din departamentul 80 care au comision în 'SA_REP'. Anulaţi
--modificările.
update emp_alu 
set job_id = 'SA_REP'
where department_id = 80 and commission_pct is not null;
select * from emp_alu;
rollback;


--16. Să se promoveze Douglas Grant la manager în departamentul 20, având o creştere de salariu
--cu 1000$. Se poate realiza modificarea prin intermediul unei singure comenzi?
update dept_alu
set manager_id = (select employee_id from emp_alu where last_name = 'Grant' and first_name = 'Douglas')
where department_id = 20;

update emp_alu 
set salary = salary + 1000
where employee_id = (select employee_id from emp_alu where last_name = 'Grant' and first_name = 'Douglas');

rollback;

--17.Schimbaţi salariul şi comisionul celui mai prost plătit salariat din firmă, astfel încât să fie egale
--cu salariul si comisionul şefului său.
update emp_alu e1
set (salary, commission_pct) = (select salary, commission_pct from emp_alu where employee_id = e1.manager_id)
where salary = (select min(salary) from emp_alu);
rollback;


--18.Să se modifice adresa de e-mail pentru angajaţii care câştigă cel mai mult în departamentul în
--care lucrează astfel încât acesta să devină iniţiala numelui concatenată cu prenumele. Dacă nu
--are prenume atunci în loc de acesta apare caracterul ‘.’. Anulaţi modificările. 
update emp_alu e1
set email = substr(last_name, 0, 1)||  nvl(first_name, '.')
where salary = (select max(salary) from emp_alu where department_id = e1.department_id);
rollback;


--19. Pentru fiecare departament să se mărească salariul celor care au fost angajaţi primii astfel
--încât să devină media salariilor din companie. Ţineţi cont de liniile introduse anterior. 
update emp_alu e1
set salary = (select avg(salary) from emp_alu)
where hire_date = (select min(hire_date) from emp_alu where department_id = e1.department_id);
rollback;


--20.S ă se modifice jobul şi departamentul angajatului având codul 114, astfel încât să fie la fel cu
--cele ale angajatului având codul 205. 
update emp_alu e1
set (job_id, department_id) = (select job_id, department_id from emp_alu e2 where employee_id = 205)
where e1.employee_id = 114;
select * from emp_alu where employee_id = 114 or employee_id = 205;
rollback;


--21.Creaţi un script prin intermediul caruia sa fie posibilă actualizarea în mod interactiv de înregistrări
-- ale tabelului dept_pnu. Se va cere codul departamentului care urmează a fi actualizat, se va afişa
-- linia respectivă, iar apoi se vor cere valori pentru celelalte câmpuri.
select * from dept_alu;

accept dep_id prompt 'Dep_id= ';
select * from dept_alu where department_id = &dep_id;

accept dep_nume prompt 'Dep_nume= ';
accept man_id prompt 'Manager_id= ';
accept loc_id prompt 'Location_id= ';


update dept_alu 
set department_id = &dep_id,
    department_name = '&dep_nume',
    manager_id = &man_id,
    location_id = &loc_id
where department_id = &dep_id;

rollback;


-- DELETE
--22.2. Ştergeţi toate înregistrările din tabelul DEPT_PNU. Ce înregistrări se pot şterge?
delete from dept_alu; -- eroare, nu merge pt ca avem valori in emp_alu (child values) ce referentiaza valori din dept_alu (parent values)
                      --de ex sunt anagajati in dept 10
rollback;


--23. Ştergeţi angajaţii care nu au comision. Anulaţi modificările.
delete from emp_alu
where commission_pct is null;
rollback;


--24. Suprimaţi departamentele care un au nici un angajat. Anulaţi modificările.
delete from dept_alu 
where department_id not in (select department_id from emp_alu where department_id is not null);
rollback;


--25 Să se creeze un fişier script prin care se cere utilizatorului un cod de angajat din tabelul EMP_PNU.
-- Se va lista inregistrarea corespunzatoare acestuia, iar apoi linia va fi suprimată din tabel
accept emp_id prompt 'Cod_angajat= ';
select * from emp_alu where employee_id = &emp_id; 
delete from emp_alu 
where employee_id = &emp_id;
rollback;


--26. Să se mai introducă o linie in tabel, rulând încă o dată fişierul creat la exerciţiul 11.
accept p_id prompt 'Id= ';
accept p_nume prompt 'Nume= ';
accept p_prenume prompt 'Prenume= ';
accept p_salariu prompt 'Salariu= ';
insert into emp_alu (employee_id, last_name, first_name, email, salary, job_id, hire_date)
values (&p_id, '&p_nume', '&p_prenume', concat(substr('&p_prenume', 0, 1), substr('&p_nume', 0, 7)), &p_salariu, 'IT_PROG', sysdate);


--27.  Să se marcheze un punct intermediar in procesarea tranzacţiei.
?????


--28. Să se şteargă tot conţinutul tabelului. Listaţi conţinutul tabelului.
truncate table emp_alu; 
select * from emp_alu;
rollback;


--29. Să se renunţe la cea mai recentă operaţie de ştergere, fără a renunţa la operaţia precedentă de
--introducere.
rollback; --??


--30. Listaţi conţinutul tabelului. Determinaţi ca modificările să devină permanente. 
-- ??
select * from emp_alu;



--MERGE
--31. Să se şteargă din tabelul EMP_PNU toţi angajaţii care câştigă comision.
-- Să se introducă sau să se actualizeze datele din tabelul EMP_PNU pe baza tabelului employees
delete from emp_alu 
where commission_pct is null;

merge into emp_alu e1
using (select * from employees) e2
on (e1.employee_id = e2.employee_id)
when matched then
   update set e1.salary = e2.salary, e1.last_name = e2.last_name
when not matched then 
   insert (employee_id, job_id, last_name, first_name, hire_date, email)
   values (e2.employee_id, e2.job_id, e2.last_name, e2.first_name, e2.hire_date, e2.email);
   
select * from emp_alu where commission_pct is null;
select * from emp_alu where commission_pct is not null;
rollback;
--restul tema 
