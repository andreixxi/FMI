--lab 5 (2, 4, 5 - 13)
-- Lab 5
-- Ex 1 (facut la lab)
--a)
select department_name, job_title, round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id)
group by rollup (department_name, job_title);

--b)
select department_name, job_title, round(avg(salary), 2) avg_salary, grouping(department_name), grouping(job_title)
from employees
join departments using(department_id)
join jobs using(job_id)
group by rollup (department_name, job_title);

--Ex 2
--a)
select department_name, job_title, round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id)
group by cube(department_name, job_title);

--b)
select department_name, job_title, round(avg(salary), 2) avg_salary,
case
    when grouping(department_name) = 0 then 'dep'
    when grouping(job_title) = 0 then 'job'
end "interventie coloane"
from employees
join departments using(department_id)
join jobs using(job_id)
group by cube(department_name, job_title);


-- Ex 3 
select department_name, job_title, e.manager_id, round(avg(salary), 2) avg_salary
from employees e
join departments using(department_id)
join jobs using(job_id)
group by grouping sets (
                      (department_name, job_title), 
                      (job_title, e.manager_id), 
                      ()
                      );
                      
                      
-- Ex 4
select max_salary
from jobs
where max_salary > 15000;

select max(salary)
from employees
having max(salary) > 15000;


-- [Subcereri corelate (sincronizate)
-- Ex 5
--a) S? se afi?eze informa?ii despre angaja?ii al c?ror salariu dep??e?te valoarea medie a
--salariilor colegilor s?i de departament
select employee_id, last_name, first_name, department_id, salary
from employees e1
where salary > (
                select avg(salary)
                from employees e2
                where e2.department_id = e1.department_id
                );

--b)  Analog cu cererea precedent?, afi?ându-se ?i numele departamentului ?i media salariilor
-- acestuia ?i num?rul de angaja?i (2 solutii: subcerere necorelat? în clauza FROM, subcerere
-- corelat? în clauza SELECT).

SELECT last_name, salary, e.department_id, department_name, sal_med, nr_sal
FROM employees e, departments d, (
                                  SELECT department_id, AVG(salary) sal_med,
                                  COUNT(*) nr_sal
                                  FROM employees
                                  GROUP BY department_id
                                  ) sm
                                  WHERE e.department_id = d.department_id
                                  AND d.department_id = sm.department_id
                                  AND salary > (
                                                SELECT AVG(salary)
                                                FROM employees
                                                WHERE department_id = e.department_id
                                  );


-- Ex6
--S? se afi?eze numele ?i salariul angaja?ilor al c?ror salariu este mai mare decât salariile medii
-- din toate departamentele. Se cer 2 variante de rezolvare: cu operatorul ALL sau cu func?ia MAX.
select last_name, salary
from employees
where salary > all ( select avg(salary)
                     from employees
                     group by department_id
                     );
                     
select last_name, salary
from employees
where salary > (    select max(avg(salary))
                    from employees
                    group by department_id
                    );
                    
                    
-- Ex 7
--Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament (se cer 3
-- solutii: subcerere sincronizata, subcerere nesincronizata si subcerere în clauza FROM).
-- var 1 subcerere sincronizata
select last_name, salary
from employees e1
where salary = (select min(salary)
                from employees e2
                where e1.department_id = e2.department_id
                );
--var 2 subcerere nesincronizata
select last_name, salary
from employees
where (department_id, salary ) in ( select department_id, min(salary)
                                     from employees
                                     group by department_id
                                     );
                                     
--var 3 subcerere in clauza from ??????????????????????/
select e.last_name, a.min_sal
from  ( select min(salary) as min_sal, department_id
       from employees
       group by department_id
       ) a
join employees e on (e.department_id = a.department_id);
       


--Ex 8
-- Pentru fiecare departament, s? se obtina numele salariatului avand cea mai mare vechime din
-- departament. S? se ordoneze rezultatul dup? numele departamentului.
select last_name, department_name
from employees e
join departments d on (e.department_id = d.department_id) 
where hire_date = (select min(hire_date) 
                   from employees
                   where department_id = e.department_id)
order by department_name;


-- Ex 9
--Sa se obtina numele salariatilor care lucreaza intr-un departament in care exista cel putin un
-- angajat cu salariul egal cu salariul maxim din departamentul 30 (operatorul exists).
select last_name
from employees e
where exists (
              select 1 
              from employees e2
              where e.department_id = e2.department_id
              and e.salary = ( select max(salary)
                              from employees
                              where department_id = 30
                              )
              );
              
-- Ex 10
-- Sa se obtina numele primilor 3 angajati avand salariul maxim. Rezultatul se va afi?a în ordine
-- cresc?toare a salariilor. 
select last_name, salary
from (
      select last_name, salary
      from employees
      order by salary desc
      )
where rownum <= 3
order by salary;

-- Ex 11
-- S? se afi?eze codul, numele ?i prenumele angaja?ilor care au cel pu?in doi subalterni
select employee_id, last_name, first_name 
from employees sef 
where (select count(manager_id)
       from employees ang
       where sef.employee_id = ang.manager_id
       ) >= 2;


-- Ex 12
-- S? se determine loca?iile în care se afl? cel pu?in un departament
select city 
from locations 
where location_id in (
                      select location_id
                      from departments
                      );

select city 
from locations 
where exists (
              select department_id
              from departments
              );


-- Ex 13
-- S? se determine departamentele în care nu exist? nici un angajat (operatorul exists; cererea a
--mai fost rezolvata si printr-o cerere necorelata).
select d.department_name
from departments d
where not exists (select 1
                  from employees e
                  where e.department_id = d.department_id
                  );


-- tema lab 5: ex 15 - 18, 20, 22 - 26

-- SUBCERERI IERARHICE
-- Ex 14   (facut la laborator)
--S? se afi?eze codul, numele, data angaj?rii, salariul ?i managerul pentru:
--a) subalternii directi ai lui De Haan;
select employee_id, last_name, hire_date, salary, manager_id
from employees
where level <= 2
start with last_name = 'De Haan'
connect by prior employee_id = manager_id; -- angajatii lui de haan employee_id
                                           -- pentru managerii lui de haan as fi facut connect by prior manager_id = employee_id;


--b) ierarhia arborescenta de sub De Haan.
select employee_id, last_name, hire_date, salary, manager_id
from employees
start with last_name = 'De Haan'
connect by prior employee_id = manager_id; 


-- Ex 15
-- S? se ob?in? ierarhia ?ef-subaltern, considerând ca r?d?cin? angajatul având codul 114
select employee_id, last_name, hire_date, salary, manager_id
from employees
start with employee_id = 114
connect by prior employee_id = manager_id; 

-- Ex 16
--Scrieti o cerere ierarhica pentru a afisa codul salariatului, codul managerului si numele salariatului,
-- pentru angajatii care sunt cu 2 niveluri sub De Haan.
-- Afisati, de asemenea, nivelul angajatului în ierarhie.
select employee_id, last_name, manager_id, level
from employees
where level > 2
start with last_name = 'De Haan'
connect by prior employee_id = manager_id; 

-- Ex 17
--Pentru fiecare linie din tabelul EMPLOYEES, se va afisa o structura arborescenta in care va ap?rea
-- angajatul, managerul s?u, managerul managerului etc. Coloanele afi?ate vor fi: codul angajatului,
-- codul managerului, nivelul în ierarhie (LEVEL) si numele angajatului.
select employee_id, manager_id, level, last_name "nume angajat"
from employees
connect by prior employee_id = manager_id
order by employee_id;


-- Ex 18
-- S? se afi?eze ierarhia de sub angajatul având salariul maxim, re?inând numai angaja?ii al c?ror
-- salariu este mai mare de 5000. Se vor afi?a codul, numele, salariul, nivelul din ierarhie ?i codul
-- managerului.
select employee_id, last_name, salary, level, manager_id
from employees
where salary > 5000
start with salary = (select max(salary) from employees)
connect by prior employee_id = manager_id; 


-- ex 19 (facut la laborator)
--Utilizând clauza WITH, s? se scrie o cerere care afi?eaz? numele departamentelor ?i valoarea
--total? a salariilor din cadrul acestora. Se vor considera departamentele a c?ror valoare total? a
--salariilor este mai mare decât media valorilor totale ale salariilor tuturor angajatilor.
with deps as (
            select department_name, sum(salary) avg_sal
            from employees
            join departments using (department_id)
            group by department_name
             )
select department_name, avg_sal from deps
where avg_sal > (
                   select avg(sum(salary))
                   from employees
                   group by department_id
                   );
                   
-- Ex 20 
-- S? se afi?eze ierarhic codul, prenumele ?i numele (pe aceea?i coloan?), codul job-ului ?i data
-- angaj?rii, pornind de la subordona?ii direc?i ai lui Steven King care au cea mai mare vechime.
-- Rezultatul nu va con?ine angaja?ii în anul 1970.

--select employee_id, first_name || ' ' || last_name, job_id, hire_date, manager_id, level
--from employees
--where to_char(hire_date, 'yyyy') <> 1970 
--start with manager_id = 100
--connect by prior employee_id = manager_id
--order by level;

-- de la prof
with tabel as
 (select *
  from employees
  where manager_id = (select employee_id from employees
                      where last_name='King' and first_name='Steven') order by hire_date )
select employee_id, last_name || ' ' || first_name, job_id, hire_date, manager_id, level
from employees
where to_char(hire_date,'yyyy') != 1970                    
start with employee_id in (select employee_id from tabel)
connect by prior employee_id = manager_id
order by level;

                   
-- Ex 21 (facut la lab)
--cei mai bine 10 platiti angajati
select * from (
               select * from employees
               order by salary desc
               )
where rownum <= 10;

-- ex 22
--S? se determine cele mai prost pl?tite 3 job-uri, din punct de vedere al mediei salariilor. 
select * from (
               select job_id, avg(salary)
               from employees
               group by job_id
               order by avg(salary)
               )
where rownum <= 3;



-- DECODE NVL ETC (facut la laborator)
-- Ex 23 
--S? se afi?eze informa?ii despre departamente, în formatul urm?tor: „Departamentul
--<department_name> este condus de {<manager_id> | nimeni} ?i {are num?rul de salaria?i
--<n> | nu are salariati}“.

select 'Departamentul <' || department_name || '> este condus de {<'  ||
  nvl(to_char(d.manager_id), 'nimeni') || '>} si {' ||
case 
     when count(employee_id) = 0 then 'nu are salariati}'
     else 'are numarul de salariati <' || count(employee_id) || '>}'
end "Informatii despre departamente" --titlu query
from employees e
right join 
departments d using (department_id)
group by department_id, department_name, d.manager_id;

-- Ex 24
--S? se afi?eze numele, prenumele angaja?ilor ?i lungimea numelui pentru înregistr?rile în care
--aceasta este diferit? de lungimea prenumelui. (NULLIF)
select last_name, first_name, nullif(length(last_name), length(first_name)) "lungime nume"
from employees
order by "lungime nume";

-- Ex 25
--S? se afi?eze numele, data angaj?rii, salariul ?i o coloan? reprezentând salariul dup? ce se
--aplic? o m?rire, astfel: pentru salaria?ii angaja?i în 1989 cre?terea este de 20%, pentru cei angaja?i
--în 1990 cre?terea este de 15%, iar salariul celor angaja?i în anul 1991 cre?te cu 10%.
--Pentru salaria?ii angaja?i în al?i ani valoarea nu se modific?.
select last_name, hire_date, salary,
case to_char(hire_date, 'yyyy')
    when '1989' then salary * 1.2
    when '1990' then salary * 1.15
    when '1991' then salary * 1.1
    else salary
end "salariu dupa marire"
from employees
order by hire_date;


select last_name, hire_date, salary, 
decode(to_char(hire_date, 'yyyy'), '1989', (1 + 0.2) * salary,
                                   '1990', (1 + 0.15) * salary,
                                   '1991', (1 + 0.1) * salary,
                                    salary) "salariu_marit"
from employees;


-- Ex 26
SELECT job_id, (CASE 
                    when lower(job_id) LIKE 's%' then sum(salary)
                    when job_id = (SELECT job_id FROM employees WHERE salary = (SELECT max(salary) FROM employees)) then (SELECT round(AVG(salary), 2) FROM employees)
                    ELSE min(salary)
                END) rez 
FROM employees
GROUP BY job_id;