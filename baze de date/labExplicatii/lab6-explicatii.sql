-- exemplu varianta 1
SELECT DISTINCT employee_id
FROM works_on a
WHERE NOT EXISTS
  (
    SELECT 1
    FROM projects p
    WHERE budget = 10000
    AND NOT EXISTS
    (
      SELECT 1
      FROM works_on b
      WHERE p.project_id = b.project_id
      AND b.employee_id = a.employee_id
    )
  );
  
-- exemplu varianta 2
SELECT employee_id, count(*)
FROM works_on
WHERE project_id IN
  (
    SELECT project_id
    FROM projects
    WHERE budget=10000
  )
GROUP BY employee_id
HAVING COUNT(project_id) = (
  SELECT COUNT(*)
  FROM projects
  WHERE budget=10000
);

-- exemplu varianta 3
SELECT employee_id
FROM works_on
MINUS
SELECT employee_id from ( 
  SELECT employee_id, project_id
  FROM (SELECT DISTINCT employee_id FROM works_on) t1, (
    SELECT project_id FROM projects WHERE budget=10000) t2
  MINUS
  SELECT employee_id, project_id FROM works_on
) t3;

-- exemplu varianta 4
SELECT DISTINCT employee_id
FROM works_on a
WHERE NOT EXISTS (
  (
    SELECT project_id
    FROM projects p
    WHERE budget=10000
  )
  MINUS
  (
    SELECT p.project_id
    FROM projects p, works_on b
    WHERE p.project_id=b.project_id
    AND b.employee_id=a.employee_id
  )
);

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

-- variabile de substitutie
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;

DEFINE p_cod;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;
UNDEFINE p_cod;

select * from employees
where lower(last_name) like '%&p_nume%';

DEFINE p_dept_id = 90;
select * from departments where department_id = &p_dept_id;
UNDEFINE p_dept_id;

DEFINE p_dept_id = 90;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE department_id = &&p_dept_id;
--UNDEFINE p_dept_id;

ACCEPT p_cod PROMPT 'cod= ';
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;

-- 16
ACCEPT p_jobId PROMPT 'p_jobId= ';
SELECT last_name, department_id, salary 
FROM employees 
WHERE lower(job_id) like '&p_jobId';

-- 17
SELECT first_name, department_id, salary
FROM employees
WHERE hire_date > to_date('&p_date', 'YYYY-MM-DD');

-- 18
accept data1 prompt 'coloana=';
accept data2 prompt 'tabel=';
select &data1 from &data2
order by 1;

-- 19
accept data1 prompt 'data inceput = ';
accept data2 prompt 'data final = ';
select last_name || ', ' || job_id Angajati, to_char(hire_date, 'MM/DD/YY')
from employees
where to_date('&data1', 'MM/DD/YY') < hire_date and hire_date < to_date('&data2', 'MM/DD/YY');

-- 20
accept locatie prompt 'locatie= ';
select e.last_name, e.job_id, e.salary, d.department_name
from employees e
join departments d using(department_id)
join locations l using(location_id)
where lower('&locatie') = lower(l.city);




