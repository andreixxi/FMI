-- Lab 7
--INSERT
--1. S? se creeze tabelele EMP_pnu, DEPT_pnu prin copierea structurii ?i con?inutului tabelelor EMPLOYEES, respectiv DEPARTMENTS. 
create table emp_alu as select * from employees;
create table dept_alu as select * from departments;


--2. Lista?i structura tabelelor surs? ?i a celor create anterior. Ce se observ?? 
desc emp_alu;
desc employees;


--3. Lista?i con?inutul tabelelor create anterior. 
select * from emp_alu;
select * from dept_alu;


--4. Pentru introducerea constrângerilor de integritate, executa?i instruc?iunile LDD indicate în
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


--6. S? se insereze un angajat corespunz?tor departamentului introdus anterior în tabelul EMP_pnu,
--precizând valoarea NULL pentru coloanele a c?ror valoare nu este cunoscut? la inserare
--(metoda implicit? de inserare). Efectele instruc?iunii s? devin? permanente. 
desc emp_alu;
select * from emp_alu;

insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values (207, 'Andrei', 'Lungu', 'shdas@bla.com', to_date('01-05-2020', 'DD-MM-YYYY'), 'IT_PROG', 300);

rollback;


--7. S? se mai introduc? un angajat corespunz?tor departamentului 300, precizând dup? numele
-- tabelului lista coloanelor în care se introduc valori (metoda explicita de inserare). Se presupune c?
-- data angaj?rii acestuia este cea curent? (SYSDATE). Salva?i înregistrarea.

insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values (208, 'Andrei', 'Lungu', 'shdas@bla.com', sysdate, 'IT_PROG', 300);

rollback;


--8.Este posibil? introducerea de înregistr?ri prin intermediul subcererilor (specificate în locul tabelului).
-- Ce reprezint?, de fapt, aceste subcereri? (view) Încerca?i dac? este posibil? introducerea unui
-- angajat, precizând pentru valoarea employee_id o subcerere care returneaz? (codul maxim +1). 
insert into emp_alu (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
values ((select max(employee_id) + 1 from emp_alu), 'Andrei', 'Lungu', 'shdas@bla.com', sysdate, 'IT_PROG', 300);

select * from emp_alu where employee_id = 207;
rollback;

--9. Crea?i un nou tabel, numit EMP1_PNU, care va avea aceea?i structur? ca ?i EMPLOYEES, dar
--nici o înregistrare. Copia?i în tabelul EMP1_PNU salaria?ii (din tabelul EMPLOYEES) al c?ror
--comision dep??e?te 25% din salariu.
create table emp1_alu as select * from employees;
truncate table emp1_alu; -- sterge tot
select * from emp1_alu;

insert into emp1_alu (select * from employees where commission_pct > 0.25);
rollback;


--10.Insera?i o nou? înregistrare în tabelul EMP_PNU care s? totalizeze salariile, s? fac? media
--comisioanelor, iar câmpurile de tip dat? s? con?in? data curent? ?i câmpurile de tip caracter s?
--con?in? textul 'TOTAL'. Numele ?i prenumele angajatului s? corespund? utilizatorului curent
--(USER). Pentru câmpul employee_id se va introduce valoarea 0, iar pentru manager_id ?i
--department_id se va da valoarea null.

insert into emp_alu 
values (0, user, user, 'TOTAL', 'TOTAL', sysdate, 'IT_PROG', (select sum(salary) from employees), (select avg(commission_pct) from employees), null, null);
select * from emp_alu;
rollback;


--11. S? se creeze un fi?ier (script file) care s? permit? introducerea de înregistr?ri în tabelul EMP_PNU
-- în mod interactiv. Se vor cere utilizatorului: codul, numele, prenumele si salariul angajatului.
-- Câmpul email se va completa automat prin concatenarea primei litere din prenume ?i a primelor 7
-- litere din nume. Executati script-ul pentru a introduce 2 inregistrari in tabel.
accept p_id prompt 'Id= ';
accept p_nume prompt 'Nume= ';
accept p_prenume prompt 'Prenume= ';
accept p_salariu prompt 'Salariu= ';
insert into emp_alu (employee_id, last_name, first_name, email, salary, job_id, hire_date)
values (&p_id, '&p_nume', '&p_prenume', concat(substr('&p_prenume', 0, 1), substr('&p_nume', 0, 7)), &p_salariu, 'IT_PROG', sysdate);
select * from emp_alu where employee_id = &p_id;
rollback;

--12. Crea?i 2 tabele emp2_pnu ?i emp3_pnu cu aceea?i structur? ca tabelul EMPLOYEES, dar f?r?
-- înregistr?ri (accept?m omiterea constrângerilor de integritate). Prin intermediul unei singure comenzi,
-- copia?i din tabelul EMPLOYEES:
-- - în tabelul EMP1_PNU salaria?ii care au salariul mai mic decât 5000;
-- - în tabelul EMP2_PNU salaria?ii care au salariul cuprins între 5000 ?i 10000;
-- - în tabelul EMP3_PNU salaria?ii care au salariul mai mare decât 10000.
-- Verifica?i rezultatele, apoi ?terge?i toate înregistr?rile din aceste tabele
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


--13. S? se creeze tabelul EMP0_PNU cu aceea?i structur? ca tabelul EMPLOYEES (f?r? constrângeri),
-- dar f?r? nici o înregistrare. Copia?i din tabelul EMPLOYEES:
-- - în tabelul EMP0_PNU salaria?ii care lucreaz? în departamentul 80;
-- - în tabelul EMP1_PNU salaria?ii care au salariul mai mic decât 5000;
-- - în tabelul EMP2_PNU salaria?ii care au salariul cuprins între 5000 ?i 10000;
-- - în tabelul EMP3_PNU salaria?ii care au salariul mai mare decât 10000.
-- Dac? un salariat se încadreaz? în tabelul emp0_pnu atunci acesta nu va mai fi inserat ?i în alt tabel
-- (tabelul corespunz?tor salariului s?u).
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
--14.M?ri?i salariul tuturor angaja?ilor din tabelul EMP_PNU cu 5%. Vizualizati, iar apoi anula?i
--modific?rile. 
select * from emp_alu;
update emp_alu 
set salary = salary + salary * 0.05;
rollback;


--15. Schimba?i jobul tuturor salaria?ilor din departamentul 80 care au comision în 'SA_REP'. Anula?i
--modific?rile.
update emp_alu 
set job_id = 'SA_REP'
where department_id = 80 and commission_pct is not null;
select * from emp_alu;
rollback;


--16. S? se promoveze Douglas Grant la manager în departamentul 20, având o cre?tere de salariu
--cu 1000$. Se poate realiza modificarea prin intermediul unei singure comenzi?
update dept_alu
set manager_id = (select employee_id from emp_alu where last_name = 'Grant' and first_name = 'Douglas')
where department_id = 20;

update emp_alu 
set salary = salary + 1000
where employee_id = (select employee_id from emp_alu where last_name = 'Grant' and first_name = 'Douglas');

rollback;

--17.Schimba?i salariul ?i comisionul celui mai prost pl?tit salariat din firm?, astfel încât s? fie egale
--cu salariul si comisionul ?efului s?u.
update emp_alu e1
set (salary, commission_pct) = (select salary, commission_pct from emp_alu where employee_id = e1.manager_id)
where salary = (select min(salary) from emp_alu);
rollback;


--18.S? se modifice adresa de e-mail pentru angaja?ii care câ?tig? cel mai mult în departamentul în
--care lucreaz? astfel încât acesta s? devin? ini?iala numelui concatenat? cu prenumele. Dac? nu
--are prenume atunci în loc de acesta apare caracterul ‘.’. Anula?i modific?rile. 
update emp_alu e1
set email = substr(last_name, 0, 1)||  nvl(first_name, '.')
where salary = (select max(salary) from emp_alu where department_id = e1.department_id);
rollback;


--19. Pentru fiecare departament s? se m?reasc? salariul celor care au fost angaja?i primii astfel
--încât s? devin? media salariilor din companie. ?ine?i cont de liniile introduse anterior. 
update emp_alu e1
set salary = (select avg(salary) from emp_alu)
where hire_date = (select min(hire_date) from emp_alu where department_id = e1.department_id);
rollback;


--20.S ? se modifice jobul ?i departamentul angajatului având codul 114, astfel încât s? fie la fel cu
--cele ale angajatului având codul 205. 
update emp_alu e1
set (job_id, department_id) = (select job_id, department_id from emp_alu e2 where employee_id = 205)
where e1.employee_id = 114;
select * from emp_alu where employee_id = 114 or employee_id = 205;
rollback;


--21.Crea?i un script prin intermediul caruia sa fie posibil? actualizarea în mod interactiv de înregistr?ri
-- ale tabelului dept_pnu. Se va cere codul departamentului care urmeaz? a fi actualizat, se va afi?a
-- linia respectiv?, iar apoi se vor cere valori pentru celelalte câmpuri.
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
--22. ?terge?i toate înregistr?rile din tabelul DEPT_PNU. Ce înregistr?ri se pot ?terge?
delete from dept_alu; -- eroare, nu merge pt ca avem valori in emp_alu (child values) ce referentiaza valori din dept_alu (parent values)
                      --de ex sunt anagajati in dept 10
rollback;


--23. ?terge?i angaja?ii care nu au comision. Anula?i modific?rile.
delete from emp_alu
where commission_pct is null;
rollback;


--24. Suprima?i departamentele care un au nici un angajat. Anula?i modific?rile.
delete from dept_alu 
where department_id not in (select department_id from emp_alu where department_id is not null);
rollback;


--25 S? se creeze un fi?ier script prin care se cere utilizatorului un cod de angajat din tabelul EMP_PNU.
-- Se va lista inregistrarea corespunzatoare acestuia, iar apoi linia va fi suprimat? din tabel
accept emp_id prompt 'Cod_angajat= ';
select * from emp_alu where employee_id = &emp_id; 
delete from emp_alu 
where employee_id = &emp_id;
rollback;


--26. S? se mai introduc? o linie in tabel, rulând înc? o dat? fi?ierul creat la exerci?iul 11.
accept p_id prompt 'Id= ';
accept p_nume prompt 'Nume= ';
accept p_prenume prompt 'Prenume= ';
accept p_salariu prompt 'Salariu= ';
insert into emp_alu (employee_id, last_name, first_name, email, salary, job_id, hire_date)
values (&p_id, '&p_nume', '&p_prenume', concat(substr('&p_prenume', 0, 1), substr('&p_nume', 0, 7)), &p_salariu, 'IT_PROG', sysdate);


--27.  S? se marcheze un punct intermediar in procesarea tranzac?iei.
?????


--28. S? se ?tearg? tot con?inutul tabelului. Lista?i con?inutul tabelului.
truncate table emp_alu; 
select * from emp_alu;
rollback;


--29. S? se renun?e la cea mai recent? opera?ie de ?tergere, f?r? a renun?a la opera?ia precedent? de
--introducere.
rollback; --??


--30. Lista?i con?inutul tabelului. Determina?i ca modific?rile s? devin? permanente. 
-- ??
select * from emp_alu;



--MERGE
--31. S? se ?tearg? din tabelul EMP_PNU to?i angaja?ii care câ?tig? comision.
-- S? se introduc? sau s? se actualizeze datele din tabelul EMP_PNU pe baza tabelului employees
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
