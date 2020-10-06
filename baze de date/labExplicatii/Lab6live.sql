-- tema lab 5: ex 15 - 18, 20, 22 - 26
-- SUBCERERI IERARHICE
-- Ex 14
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


-- ex 19
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
                   
-- Ex 21 cei mai bine 10 platiti angajati
select * from (
               select * from employees
               order by salary desc
               )
where rownum <= 10;


-- DECODE NVL ETC
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
SELECT job_id,
(CASE 
when lower(job_id) LIKE 's%' then sum(salary)
when job_id= (SELECT job_id FROM employees WHERE salary =(SELECT max(salary) FROM employees)) then (SELECT AVG(salary) FROM employees)
ELSE min(salary)
END) rez 
FROM employees
GROUP BY job_id;