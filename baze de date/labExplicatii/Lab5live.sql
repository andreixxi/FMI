-- Ex 27
select job_id, 
(select sum(salary) from employees where job_id = e.job_id and department_id = 30) Dept30,
(select sum(salary) from employees where job_id = e.job_id and department_id = 50) Dept50,
(select sum(salary) from employees where job_id = e.job_id and department_id = 80) Dept80,
(select sum(salary) from employees where job_id = e.job_id) total
from employees e;

-- Ex 28
select 
(select count(*) from employees) as total,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1997) an1997,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1998) an1998,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1999) an1999,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 2000) an2000
from dual;

-- exemplu de subquery
select * 
from employees 
where hire_date > (select hire_date 
                  from employees
                  where employee_id = 100);


select employee_id, department_name
from employees e
join (select department_id, department_name 
      from departments) a on (a.department_id = e.department_id);


select employee_id, a.dept_id, department_name
from employees e
join (select department_id dept_id, department_name 
      from departments) a on (a.dept_id = e.department_id);
      
  
    
select * 
from  (select employee_id, salary 
        from employees
        where rownum = 1
        order by salary desc);
        

select employee_id, e.salary, a.salary 
from (
      select department_id, avg(salary) salary
      from employees
      group by department_id
      ) a
join employees e on (e.department_id = a.department_id)
where a.salary <= e.salary;


select employee_id, department_id, avg(salary) from employees e
join departments d using (department_id)
group by department_id, employee_id;



-- Ex 30
SELECT d.department_id, d.department_name, a.summ
FROM (
    SELECT department_id, SUM(salary) AS summ
    FROM employees
    GROUP BY department_id
) a
INNER JOIN departments d on (a.department_id = d.department_id);


-- Ex 31
select e.last_name, e.salary, e.department_id, a.avgs
from (
      select department_id, round(avg(salary)) as avgs
      from employees
      group by department_id
      ) a
join employees e on (e.department_id = a.department_id);


-- Ex 32
select e.last_name, e.salary, e.department_id, a.avgs, a.nr_ang
from (
      select department_id, round(avg(salary)) as avgs, count(employee_id) as nr_ang
      from employees
      group by department_id
      ) a
join employees e on (e.department_id = a.department_id);


-- Ex 33
select d.department_name, e.last_name, a.minim
from (select department_id, min(salary) as minim
      from employees
      group by department_id) a
inner join departments d on (d.department_id = a.department_id)
join employees e on (d.department_id = e.department_id and e.salary = a.minim);


--sau 

SELECT a.department_id, a.department_name, e.first_name, e.salary
FROM (
    SELECT d.department_id, d.department_name, MIN(ee.salary) AS sal
    FROM departments d
    JOIN employees ee on (ee.department_id = d.department_id)
    GROUP BY d.department_name, d.department_id
) a
JOIN employees e on ( e.department_id = a.department_id)
WHERE e.salary = a.sal;




----- LABORATORUL 5
-- Ex 1
--a)
select department_name, job_title, round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id)
group by rollup (department_name, job_title);

--echivalent (primul caz)
select department_name, job_title, round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id)
group by department_name, job_title;

--pt cazul 2
select department_name, round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id)
group by department_name;

--pt cazul 3
select round(avg(salary), 2) avg_salary
from employees
join departments using(department_id)
join jobs using(job_id);

--b)
select department_name, job_title, round(avg(salary), 2) avg_salary, grouping(department_name), grouping(job_title)
from employees
join departments using(department_id)
join jobs using(job_id)
group by rollup (department_name, job_title);

--Ex 2 cu CUBE tema + ex 4 tema


--Ex 3
select department_name, job_title, e.manager_id, round(avg(salary), 2) avg_salary
from employees e
join departments using(department_id)
join jobs using(job_id)
group by grouping sets (
                      (department_name, job_title), 
                      (job_title, e.manager_id), 
                      ()
                      );
                      
                      
                      
-- ex 5 - 13 tema + ex 2 + ex 4 

--exists example
select * from employees e
where exists (
             select 1 
             from departments d
             join locations l using (location_id)
             where d.department_id = e.department_id
             and l.city = 'Oxford'
          );
          
select * from employees 
where employee_id in (
             select employee_id 
             from employees e 
             join departments d using (department_id)
             join locations l using (location_id)
             where l.city = 'Oxford'
             );