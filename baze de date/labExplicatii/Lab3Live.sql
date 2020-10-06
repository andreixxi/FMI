--inner
select d.department_id, e.employee_id 
from employees e
join departments d on (d.department_id = e.department_id);

--
select d.department_id, e.employee_id 
from employees e
join departments d on (d.department_id <> e.department_id);

--cross join 106 * 27
select * from employees, departments;

select d.department_id, e.employee_id from employees e 
cross join departments d;

select * from employees e, departments d
where e.department_id = d.department_id;

--pt primul table din from iau toate datele, si unde nu gaseste in celalalt tabel afiseaza null
select department_id, e.employee_id from employees e 
left join departments d using(department_id);

--department_id fara employee o sa aiba null
select department_id, e.employee_id from employees e 
right join departments d using(department_id);

select department_id, e.employee_id from employees e 
full join departments d using(department_id);


select * from employees e, departments d
where e.department_id = d.department_id(+); --left join

select * from employees e, departments d
where e.department_id(+) = d.department_id; --right join

--inner join, sunt luati doar angajatii cu un manager si managerii cu macar un angajat
select * from employees e1
join employees e2 on  (e1.manager_id = e2.employee_id);

--si angjat fata manager
select * from employees e1
left join employees e2 on  (e1.manager_id = e2.employee_id);


--angajatul 101 din deparment 90 cu managaer 100
select e1.employee_id, e1.manager_id, d.department_id from employees e1
join employees e2 on (e1.manager_id = e2.employee_id)
join departments d on (e1.department_id = d.department_id);


select e1.employee_id, e1.manager_id, e1.department_id, d2.department_id from employees e1
join employees e2 on (e1.manager_id = e2.employee_id)
join departments d on (e1.department_id = d.department_id)
join departments d2 on (d2.department_id = e2.department_id);


select * from employees 
natural join departments 
natural join locations;



select employee_id from employees
where department_id = 90
UNION --OR
select employee_id from employees
where salary > 1000
order by 1;

--un fel de reuniune, dar vor fi duplciate
select employee_id from employees
where department_id = 90
UNION ALL
select employee_id from employees
where salary > 1000
order by 1;

select employee_id from employees
where department_id = 90
INTERSECT --AND
select employee_id from employees
where salary > 1000
order by 1;


select employee_id from employees
where salary > 1000
MINUS --diferenta
select employee_id from employees
where department_id = 90
order by 1;


--ex10
select department_id from departments where department_name like '%re%'
union
select  department_id from employees where job_id = 'SA_REP';

--subquery //subcerere
select * from employees 
where employee_id in (select department_id from departments
                  where department_name like '%re%');
                  
--ex 15
select * from employees
where hire_date > (select hire_date from employees where lower(last_name) = 'gates');