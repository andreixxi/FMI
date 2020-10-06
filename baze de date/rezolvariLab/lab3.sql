--join
--1 cu sintaxa sql3 (oracle)
select e1.last_name, e1.first_name, to_char(e1.hire_date, 'MONTH YYYY')
from employees e1
join employees e2 on (e1.department_id = e2.department_id
                      and e2.last_name = 'Gates' 
                      and e1.employee_id <> e2.employee_id)
where e1.last_name like '%a%' or e1.last_name like 'A%';

--join specificat in clauza where
select e1.last_name, e1.first_name, to_char(e1.hire_date, 'MONTH YYYY')
from employees e1
where department_id = (select department_id 
                      from employees
                      where lower(last_name) = 'gates')
and (last_name like '%a%' or last_name like 'A%' or last_name like '%a')
and last_name <> 'Gates';


--2
select e.employee_id, e.last_name, e.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id
and e.department_id in (select e2.department_id 
                      from employees e2
                      where (e2.last_name like '%t%' or e2.last_name like 'T%'))
order by 2;

--varianta 2
select e.employee_id, e.last_name, d.department_id, d.department_name
from employees e
join departments d on(e.department_id = d.department_id
                      and (e.last_name like '%t%'))
order by 2;

--3; 3. Sa se afiseze numele, salariul, titlul job-ului, ora?ul ?i 
--?ara în care lucreaz? angajatii condusi direct de King.
select e.last_name, e.salary, j.job_title, l.city, co.country_name
from employees e
join jobs j on (e.job_id = j.job_id)
join departments d on (e.department_id = d.department_id)
join locations l on (l.location_id = d.location_id)
join countries co on (co.country_id = l.country_id)
where e.manager_id in (select employee_id 
                      from employees 
                      where last_name = 'King');


--4
select d.department_id, d.department_name, e.last_name, e.job_id,
        to_char(e.salary, '$99,999.00')
from departments d, employees e
where d.department_id = e.department_id
and instr(lower(d.department_name), 'ti') <> 0
order by d.department_name, e.last_name;

--cu join
select d.department_id, d.department_name, e.last_name, e.job_id,
        to_char(e.salary, '$99,999.00')
from departments d
join employees e on (e.department_id = d.department_id)
where d.department_name like '%ti%'
order by d.department_name, e.last_name;

--5
--join
select e.last_name, e.department_id, d.department_name, e.job_id, l.city
from employees e
join departments d on (e.department_id = d.department_id)
join locations l on (l.location_id = d.location_id)
where l.city = 'Oxford';


--6 
select e.job_id, e.last_name, e.salary
from employees e
join jobs j on (e.job_id = j.job_id)
            and (e.salary >= (j.min_salary + j.max_salary)/2)
join departments d on (e.department_id = d.department_id)
where d.department_id in (select department_id 
                    from employees 
                    where last_name like '%t%');

--7 (?)
select e.last_name, d.department_name
from employees e
left join departments d on (e.department_id = d.department_id)
order by d.department_name nulls first;

select e.last_name, d.department_name
from employees e, departments d
where (e.department_id = d.department_id) 
union
select last_name, null
from employees
where department_id is null;

--8 (?)
select d.department_name, e.last_name
from departments d
left join employees e using(department_id)
order by 1;

--select d.department_name, e.last_name
--from departments d, employees e
--where d.department_id = e.department_id
--union
--select department_name, null
--from departments;

--9 full join
select d.department_name, e.last_name
from departments d
full join employees e
on d.department_id = e.department_id;

select *
from employees e1
left join employees e2
using (employee_id)
union all
select *
from employees e1
right join employees e2
using (employee_id);

select *
from employees e1
full outer join employees e2
using (employee_id);

-- operatori pe mul?imi
--10
select department_id from departments where department_name like '%re%'
union --sau
select department_id from employees where job_id = 'SA_REP';


--11 apar duplicate
select department_id from departments where department_name like '%re%'
union all
select department_id from employees where job_id = 'SA_REP';


--12 
-- la al doilea query ar trebui folosit IS NOT NULL (avem in primul query toate 
--departamentele din care scoatem pe cele in care lucreaza cineva = obtinem 
--departamentele unde nu lucreaza nimeni)
select department_id from departments
minus
select department_id from employees
where department_id is not null;


--13 (?)
select department_id from departments
where department_name like '%re%'
intersect 
select department_id from employees
where job_id = 'HR_REP';


--14 
select employee_id, job_id, last_name
from employees
where salary >= 3000 
union
select e.employee_id, e.job_id, e.last_name
from employees e 
join jobs j on (j.job_id = e.job_id)
            where e.salary = (j.min_salary + j.max_salary)/2;

-- subcereri necorelate (nesincronizate)] 
--15
select last_name, hire_date 
from employees
where hire_date > (select hire_date 
                   from employees 
                   where last_name ='Gates');

--16
select last_name, salary
from employees
where department_id = (select department_id
                      from employees
                      where last_name = 'Gates');

--17
select last_name, salary
from employees
where manager_id = (select employee_id
                    from employees
                    where manager_id is null);
                    
--18 
select last_name, department_id, salary
from employees 
where department_id in (select department_id
                  from employees
                  where commission_pct is not null)
and salary in (select salary 
                  from employees
                  where commission_pct is not null);
                  
--19
select employee_id, last_name, salary
from employees e
where salary > (select (min_salary + max_salary) / 2
                from jobs j
                where e.job_id = j.job_id)
and department_id in (select department_id
                      from employees
                      where instr(lower(last_name), 't') <> 0);

--20
select * from employees
where salary > all (select salary 
                    from employees
                    where instr(upper(job_id), 'CLERK') <> 0)
order by salary desc;

    
--21
select e.last_name, d.department_name, e.salary
from employees e, departments d
where e.commission_pct is null
and e.manager_id in (select e2.manager_id 
                    from employees e2
                    where e2.commission_pct is not null);

--22 
select last_name, department_id, salary, job_id
from employees 
where (salary, commission_pct) in (
      select e.salary, e.commission_pct
      from employees e
      join departments d on e.department_id = d.department_id
      join locations l
      on l.location_id = d.location_id
      where l.city = 'Oxford');
                        
--23
select e.last_name, e.first_name, e.department_id, e.job_id, l.city
from employees e, departments d, locations l
where l.city = 'Toronto' and d.location_id = l.location_id;