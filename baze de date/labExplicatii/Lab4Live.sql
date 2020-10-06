select department_id, count(employee_id)
from employees
group by department_id;

select count(employee_id) from employees;

select department_id, count(employee_id), min(salary), max(salary) 
from employees
group by department_id;

select department_id, job_id, count(employee_id), min(salary), max(salary) 
from employees
group by department_id, job_id;

select department_id, job_id, count(employee_id), min(salary), max(salary) 
from employees
group by department_id, job_id
order by 1;

select count(*) from employees;
select count(department_id) from employees; --un angajat fara departament

--having filtreaza gruparile rezultate
select job_id, sum(salary) from employees
--where manager_id is not null --ignora managerul(steve)
where lower(last_name) not like '%t%' --ignora angajatii cu t in nume
group by job_id;

select job_id, sum(salary) from employees
group by job_id
having sum(salary) > 10000;
--where sum(salary) > 10000; -- NU functioneaza, where nu suporta group func si filtreaza doar linii

select employee_id, last_name from employees
where salary > (select avg(salary) from employees);

SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY ROLLUP(department_id, TO_CHAR(hire_date, 'yyyy')); 

SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
group by department_id, TO_CHAR(hire_date, 'yyyy'); --fara null

select department_id, sum(salary) 
FROM employees
WHERE department_id < 50
group by department_id; 

select sum(salary)
from employees
where department_id < 50;

SELECT department_id, TO_CHAR(hire_date, 'yyyy'), job_id, SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY ROLLUP(department_id, TO_CHAR(hire_date, 'yyyy'), job_id); 

SELECT department_id, TO_CHAR(hire_date, 'yyyy'), SUM(salary)
FROM employees
WHERE department_id < 50
GROUP BY CUBE(department_id, TO_CHAR(hire_date, 'yyyy')); 


-- Ex 3
select job_id, min(salary), max(salary), sum(salary), avg(salary)
from employees
group by job_id;

-- Ex 9
select manager_id, min(salary), max(salary)
from employees
where manager_id is not null
group by manager_id
having min(salary) > 5000
order by min(salary) desc;

--tema de la 1 la 17