SELECT employee_id, last_name,salary * 12 "ANNUAL SALARY"
FROM employees;

SELECT employee_id, last_name,salary * 12 as sal
FROM employees
where sal>7000; --nu


SELECT employee_id, last_name,salary * 12 as sal
FROM employees
where salary * 12>70000
order by 3 desc; 


SELECT employee_id, last_name,salary * 12 as sal
FROM employees
where salary * 12>70000
order by sal desc; 

desc employees;

--3. S? se afi?eze numele salaria?ilor ?i codul 
--departamentelor pentru toti angaja?ii din departamentele 10 ?i 30 în ordine alfabetic? a numelor.
SELECT first_name, department_id
FROM employees 
where department_id IN (10, 30)
order by 1;

select sysdate 
from dual;

select 1+2
from dual;


select sysdate
from jobs;

select sysdate 
from dual;


select to_char(sysdate, 'DD')
from dual;

select to_char(sysdate, 'Day')
from dual;

select to_char(sysdate, 'DD-MM-YYYY')
from dual;

select  Year(sysdate)
from dual;--nu

select first_name
from employees
where lower(first_name) like 'd%';

select first_name
from employees
where lower(first_name) like '%d%';


select first_name
from employees
where lower(first_name) like '_d%';


select first_name
from employees
where lower(first_name) like '%d';

--6. S? se afi?eze numele ?i job-ul pentru to?i angaja?ii care nu au manager.

Select first_name, manager_id
from employees
where manager_id is null;

--11. S? se afiseze numele, job-ul si salariul pentru toti salariatii al
--caror job con?ine ?irul “CLERK” sau “REP” ?i salariul nu este egal 
--cu 1000, 2000 sau 3000. (operatorul NOT IN)


select first_name,job_id,salary
FROM EMPLOYEES
WHERE (lower(job_id) like lower('%cLERK%')  or lower(job_id) like lower('%REP%')) and salary not in (1000,2000,3000);

select first_name,job_id,salary
FROM EMPLOYEES
WHERE (upper(job_id) like '%CLERK%'  or upper(job_id) like ('%REP%')) and salary not in (1000,2000,3000);

--12. S? se afi?eze numele salaria?ilor ?i numele departamentelor
--în care lucreaz?. Se vor afi?a ?i salaria?ii care nu au asociat un departament.

select first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID; --106

select count(employee_id)
from employees;

select first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID(+); --107

--13. S? se afi?eze numele departamentelor ?i numele salaria?ilor care
--lucreaz? în ele. Se vor afi?a ?i departamentele care nu au salaria?i.

select first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID; --122


select first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID(+);--nu

select employee_id,first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID = d.DEPARTMENT_ID(+)
union 
select employee_id, first_name, d.*
from employees e, departments d
where e.DEPARTMENT_ID(+) = d.DEPARTMENT_ID; --123

--14. S? se afi?eze codul angajatului ?i numele acestuia, împreun? cu numele ?i codul ?efului s?u direct.

select e.employee_id, e.last_name, e.manager_id, m.employee_id, m.last_name
from employees e, employees m
where e.manager_id= m.employee_id;

--15. S? se modifice cererea anterioar? pentru a afi?a to?i salaria?ii, inclusiv cei care nu au ?ef.

select e.employee_id, e.last_name, e.manager_id, m.employee_id, m.last_name
from employees e, employees m
where e.manager_id= m.employee_id or e.manager_id is null; --nu

select e.employee_id, e.last_name, e.manager_id, m.employee_id, m.last_name
from employees e, employees m
where e.manager_id= m.employee_id(+);

select e.employee_id, e.last_name, e.manager_id,
        ( select m.last_name
        from employees m
        where e.manager_id= m.employee_id)
from employees e;

--select * from employees;
--e.employee_id =102
--e.manager_id = 100
-- select m.last_name
--        from employees m
--        where 100= m.employee_id

--16. S? se ob?in? codurile departamentelor în care nu lucreaza
--nimeni (nu este introdus nici un salariat în tabelul employees).

select department_id
from departments d
where (select count(employee_id)
      from employees e
      where e.department_id = d.department_id) = 0; --16
      
SELECT d.department_id, COUNT(e.department_id)
 FROM employees e
 RIGHT JOIN departments d
 ON e.department_id = d.department_id
 GROUP BY d.department_id
 HAVING COUNT(e.department_id) = 0;
 
 select d.department_id
 from departments d
 where not exists (
                 select e.employee_id
                 from employees e
                 where e.department_id = d.department_id
 );
 
 select department_id
 from departments
 minus
 select  department_id
 from employees; --16

-- 17. S? se afi?eze cel mai mare salariu, cel mai mic salariu, 
-- suma ?i media salariilor tuturor angaja?ilor. Eticheta?i coloanele Maxim,
-- Minim, Suma, respectiv Media. Sa se rotunjeasca rezultatele.


select min(salary) Minim, max(salary) Maxim, sum(salary) Suma, round(avg(salary),2) Media
from employees;

--18. S? se afi?eze minimul, maximul, suma ?i media salariilor pentru fiecare job.
select job_id, min(salary) Minim, max(salary) Maxim, sum(salary) Suma, round(avg(salary),2) Media
from employees
group by job_id;


--19. S? se afi?eze num?rul de angaja?i pentru fiecare job
select job_id, count(employee_id)
from employees
group by job_id;


--chiar si pt joburile fara angajati
insert into jobs values ('TEST', 'Test', 1000, 2000);
commit;

--daca puneam count(*) numara chiar daca aveam null in employee_id
select j.job_id, j.job_title, count(employee_id)    
from jobs j, employees e 
where e.job_id(+) = j.job_id 
group by j.job_id, j.job_title;


select j.job_id, max(j.job_title), count(employee_id)    
from jobs j, employees e 
where e.job_id(+) = j.job_id 
group by j.job_id;

--20. Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, num?rul de
--angaja?i ?i salariul mediu pentru angaja?ii din acel departament. Coloanele vor fi
--etichetate corespunz?tor.
select department_name departament, 
          d.location_id locatie,
          count(employee_id) nr_angajati, 
          round(avg(salary)) salariu_mediu,
          city oras
from departments d, employees e, locations l 
where d.department_id = e.department_id
and l.location_id = d.location_id
group by d.department_id, d.department_name, d.location_id, l.city;


--21. S? se afi?eze codul ?i numele angaja?ilor care câstiga mai mult decât salariul mediu
--din firm?. Se va sorta rezultatul în ordine descresc?toare a salariilor
select employee_id, last_name, salary
from employees
where salary > (select avg(salary) --salariu mediu din firma
                        from employees)
order by salary desc;


--angajatii care au salariul mai mare decat salariile medii ale angajatilor din feicare departament
select employee_id, last_name, salary
from employees 
where salary > all (select avg(salary) --salariu mediu din firma
                        from employees e2
                       group by department_id)
order by salary desc;


--angajatii cu salariul mai mare decat media sal colegilor de dept
 select employee_id, last_name, salary from employees e1
 where salary > (select avg(salary) 
            from employees e2 
            where e1.department_id = e2.department_id)
 order by salary desc;
 
 --sau
 select e.employee_id, e.last_name, e.salary, calc
 from employees e, (select avg(salary) calc, department_id
                        from employees
                        group by department_id) t
where e.salary > t.calc
and e.department_id = t.department_id
order by e.salary desc;
 
 
-- 22. Care este salariul mediu minim al job-urilor existente? Salariul mediu al unui job va fi
--considerat drept media arirmetic? a salariilor celor care îl practic?.
select job_id, avg(salary) 
from employees
group by job_id;

select min(avg(salary))  --nu putem avea job_id in select
from employees
group by job_id;


select min(sal_mediu) "salariu mediu minim"
from (select job_id, avg(salary)  sal_mediu --alias pt coloana la care fac agregarea!!!
        from employees
        group by job_id);


--23. Modifica?i exerci?iul anterior pentru a afi?a ?i id-ul jobului.
select max(e.job_id), min(avg(e.salary))
 from employees e
 join jobs j on j.job_id = e.job_id
 group by e.job_id;

SELECT job_id, sal 
FROM (SELECT AVG(salary) sal, job_id
         FROM employees
         GROUP BY job_id)
 WHERE sal = (SELECT MIN(AVG(salary))
             FROM employees e
             JOIN departments d ON e.department_id = d.department_id
             JOIN jobs j ON j.job_id = e.job_id
             GROUP BY e.job_id);

--sau
select job_id, avg(salary)
 from employees
 group by job_id
 having avg(salary) = (select min(avg(salary)) 
                             from employees 
                             group by job_id);
                             
                             
--24. Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza in
--acel departament pentru:
--a) departamentele in care lucreaza mai putin de 4 angajati;
select department_id, department_name, count(1) as "numar angajati"
from departments
inner join employees
using (department_id)
group by department_id, department_name
having count(1) < 4;


--daca folosesc count(*) numara si valorile null (le considera null) si nu mai face diferenta dintre cele cu 1 ang sau niciun ang
select d.department_id, max(department_name), count(e.employee_id) as "numar angajati"
from departments d, employees e
where d.department_id = e.department_id(+) --pt departamente la care nu lucreaza nimeni
group by d.department_id
having count(employee_id) < 4
order by count(employee_id) desc;


--b) departamentul care are numarul maxim de angajati.
select d.department_id, max(d.department_name), count(e.employee_id) nr_angajati
 from departments d 
 join employees e on d.department_id = e.department_id
 group by d.department_id
 having count(e.employee_id) = (select max(count(employee_id))
                                from departments d
                                join employees e on d.department_id = e.department_id
                                group by d.department_id);
                                
                                
                                
--25. S? se ob?in? num?rul departamentelor care au cel pu?in 15 angaja?i.
select count(*) nr_departamente
from (select count(*) nr_ang
            from employees
            group by department_id
            having count(employee_id) >= 15);
            
select count(count(*))
        from employees
        group by department_id
        having count(*) >= 15;
        
select count(*) 
from (select d.department_id, count(employee_id)
         from employees e
         join departments d on d.department_id = e.department_id
         group by d.department_id
         having count(employee_id) >= 15);
         

--26. Sa se afiseze salariatii care au fost angajati în aceea?i zi a lunii în care cei mai multi
--dintre salariati au fost angajati.
select to_char(hire_date, 'dd') zi
from employees;

select (count(employee_id)), to_char(hire_date, 'dd') --nr angajari + ziua angajarii
from employees
group by to_char(hire_date, 'dd');





--27. Sa se afiseze numele si salariul celor mai prost platiti angajati din fiecare departament
select e1.first_name, e1.salary, e1.department_id
 from employees e1
 where e1.salary = (select min(salary)
                         from employees e
                         where e.department_id = e1.department_id);


--28. S? se detemine primii 10 cei mai bine pl?ti?i angaja?i.
select * 
from (select * --ordonez tabela dupa salariu desc
        from employees
        order by salary desc)
        where rownum <= 10; --iau primii 10 angajati


--29. S? se afi?eze codul, numele departamentului ?i suma salariilor pe departamente
select d.department_id, department_name, 
                            (select nvl(sum(salary), 0) as suma
                             from employees emp
                             where d.department_id = emp.department_id) as suma
from departments d;
                
select d.department_id, max(d.department_name), nvl(sum(e.salary), 0)
 from departments d
 join employees e on e.department_id(+)=d.department_id
 group by d.department_id ;


--30. S? se afi?eze informa?ii despre angaja?ii al c?ror salariu dep??e?te valoarea medie a
--salariilor colegilor s?i de departament.
select e1.last_name, e1.first_name
 from employees e1
 where e1.salary > (select avg(salary)
                         from employees e
                         where e.department_id = e1.department_id
                         and e1.employee_id <> e.employee_id);