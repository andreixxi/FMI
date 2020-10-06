--Exercitii (DIVISION + alte cereri): 
--1.S? se listeze informa?ii despre angaja?ii care au lucrat în toate proiectele demarate în primele 6 luni
--ale anului 2006. Implementa?i toate variantele.   (facut de prof la lab)
-- ex 1 varianta 1
select * from employees e
where not exists (
  select 1 from projects p
  where extract (month from start_date) <= 6 and extract (year from start_date) = 2006
  and not exists (
    select 1 from works_on w
    where w.employee_id = e. employee_id and
    p.project_id = w.project_id
  )
);

-- ex 1 varianta 2
select employee_id, count(*) from works_on 
where project_id in (
  select project_id from projects
  where extract (month from start_date) <= 6 and extract (year from start_date) = 2006
)
group by employee_id
having count(employee_id) = (
  select count(*) from projects
  where extract (month from start_date) <= 6 and  extract (year from start_date) = 2006
);

-- ex 1 varianta 3
select employee_id from works_on
minus
select employee_id from (
  select employee_id, project_id from (
    select distinct employee_id from works_on
  ) t1, (
    select project_id from projects
    where extract (month from start_date) <= 6
  ) t2
  minus
  select employee_id, project_id from works_on
);

-- ex 1 varianta 4
select distinct employee_id
from works_on a
where not exists (
  (
    select project_id
    from projects p
    where extract (month from start_date) <= 6
  )
  minus
  (
    select p.project_id
    from projects p, works_on b
    where p.project_id=b.project_id
    and b.employee_id=a.employee_id
  )
);

--2.S? se listeze informantii despre proiectele la care au participat toti angajatii care au detinut alte 2
--posturi în firm?. 

select * from works_on
where employee_id in (select employee_id 
                      from job_history 
                      group by employee_id
                      having count(*) = 2)
order by employee_id;


select employee_id, count(*)
from job_history
group by employee_id;

select * from job_history order by employee_id;


--3.S? se ob?in? num?rul de angaja?i care au avut cel pu?in trei job-uri, luându-se în considerare ?i job-ul
--curent. 
with tabel as (select employee_id, count(1) as numar
              from job_history
              group by employee_id
              )
select employee_id from employees
join tabel using (employee_id)
where numar >= 2;


--4. Pentru fiecare tar?, s? se afi?eze num?rul de angaja?i din cadrul acesteia. 
select country_id, count(1) as numar
from employees
join departments using (department_id)
join locations using (location_id)
group by country_id;


--5.S? se listeze angaja?ii (codul ?i numele acestora) care au lucrat pe cel pu?in dou? proiecte nelivrate
--la termen. 
with tabel as ( -- proiectele cu deadline depasit
              select project_id
              from projects
              where delivery_date > deadline
              )
select employee_id, last_name
from employees e
where 2 <= (
            select count(project_id)
            from works_on
            join tabel using (project_id)
            where employee_id = e.employee_id
            );
--select * from projects;


--6.
--S? se listeze codurile angaja?ilor ?i codurile proiectelor pe care au lucrat. Listarea va cuprinde ?i
--angaja?ii care nu au lucrat pe nici un proiect. 

--fara left join nu ia in calcul valorile null
select employee_id, project_id 
from employees
left join works_on using(employee_id)
left join projects using (project_id);


-- 7. S? se afi?eze angaja?ii care lucreaz? în acela?i departament cu cel pu?in un manager de proiect. 
select * from employees
where department_id in (select department_id
                        from employees
                        where employee_id in (
                              select project_manager from projects
                                             ) 
                          );
                          
                          
--8. S? se afi?eze angaja?ii care nu lucreaz? în acela?i departament cu nici un manager de proiect. 
select * from employees
where department_id not in (select department_id
                        from employees
                        where employee_id in (
                              select project_manager from projects
                                             ) 
                          );


--9. S? se determine departamentele având media salariilor mai mare decît un num?r dat.
select department_id, department_name 
from departments 
join employees using (department_id)
group by department_id, department_name
having avg(salary) > &p;


--10. Se cer informa?ii (nume, prenume, salariu, num?r proiecte) despre managerii de proiect care au
--condus 2 proiecte
with tabel as ( select project_manager as employee_id, count(1) as numar
                from projects
                group by project_manager
                )
select last_name, first_name, salary, numar
from employees
join tabel using (employee_id)
where numar >= 2;


--11.S? se afi?eze lista angaja?ilor care au lucrat numai pe proiecte conduse de managerul de proiect
--având codul 102. 
select * from employees
join works_on using(employee_id)
join projects using(project_id)
where project_manager = 102;


--12.???


--13????



--14
--a)
select * from job_grades;


--b) Pentru fiecare angajat, afi?a?i numele, prenumele, salariul ?i grila de salarizare corespunz?toare.
--Ce opera?ie are loc între tabelele din interogare? 
--?????



-- Ex 15
-- Sa se afiseze codul, numele, salariul si codul departamentului din care face parte pentru un angajat
-- al carui cod este introdus de utilizator de la tastatura. Analizati diferentele dintre cele 4 posibilitati:
--I
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod; 
--II
DEFINE p_cod; 
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;
UNDEFINE p_cod;
--III
DEFINE p_cod = 100;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &&p_cod;
UNDEFINE p_cod;
--IV
ACCEPT p_cod PROMPT 'cod= ';
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod; 

select * from employees where lower(last_name) like '%&p_nume%'; 

select * from departments where department_id = &p_dept_id;


-- Ex 16
-- Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au un anumit
-- job.
ACCEPT p_jobId PROMPT 'p_jobId= '; -- de ex it_prog
SELECT last_name, department_id, salary 
FROM employees 
WHERE lower(job_id) = '&p_jobId'; 

select * from employees;
select * from employees where lower(job_id) = '%&p_nume%';

--Ex 17
--Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au fost
--angajati dupa o anumita data calendaristica. 
SELECT first_name, department_id, salary
FROM employees
WHERE hire_date > '&p_date'; -- de forma 10-SEP-90

-- Ex 18
-- Sa se afiseze o coloana aleasa de utilizator, dintr-un tabel ales de utilizator, ordonand dupa aceeasi
--coloana care se afiseaza. De asemenea, este obligatorie precizarea unei conditii WHERE. 
accept data1 prompt "coloana=";
accept data2 prompt "tabel=";
select &data1 from &data2
order by 1;

--Ex 19
-- S? se realizeze un script prin care s? se afi?eze numele, job-ul ?i data angaj?rii salariatilor care
--au început lucrul între 2 date calendaristice introduse de utilizator. S? se concateneze numele
-- si job-ul, separate prin spatiu si virgul?, si s? se eticheteze coloana "Angajati".
-- Se vor folosi comanda ACCEPT si formatul pentru data calendaristica MM/DD/YY.
accept data1 prompt 'data inceput = ';
accept data2 prompt 'data final = ';
select last_name || ', ' || job_id Angajati, to_char(hire_date, 'MM/DD/YY')
from employees
where to_date('&data1', 'MM/DD/YY') < hire_date and hire_date < to_date('&data2', 'MM/DD/YY');

--Ex 20
-- Sa se realizeze un script pentru a afisa numele angajatului, codul job-ului, salariul si numele
-- departamentului pentru salariatii care lucreaza intr-o locatie data de utilizator. Va fi permisa cautarea
-- case-insensitive.
accept locatie prompt 'locatie= ';
select e.last_name, e.job_id, e.salary, d.department_name
from employees e
join departments d using(department_id)
join locations l using(location_id)
where lower('&locatie') = lower(l.city);


--21. a)S? se citeasc? dou? date calendaristice de la tastatur? si s? se afiseze zilele dintre aceste dou? date.
accept data1 prompt = 'data= ';
accept data2 prompt = 'data= ';
select (to_date(&data1) - to_date(&data2))
from dual;


-- b)Modificati cererea anterioar? astfel încât s? afiseze doar zilele lucr?toare dintre cele dou? date
-- calendaristice introduse. 
????
