SELECT employee_id FROM employees;
DESC employees;
SELECT * FROM EMPLOYEES;

SELECT employee_id as cod, first_name "first name", last_name, job_id, hire_date 
FROM employees;

SELECT job_id 
FROM employees; 
SELECT DISTINCT job_id 
FROM employees;

SELECT last_name|| ', ' ||job_id "Angajat si titlu" 
FROM employees;

SELECT employee_id|| ', '||first_name||', '||last_name||', '||email||', '||phone_number "informatii complete" 
FROM employees;

SELECT last_name, salary
FROM employees
WHERE salary > 2850;

SELECT last_name, department_id
FROM employees
WHERE employee_id = 104;

SELECT last_name, salary
FROM employees
WHERE salary NOT BETWEEN 1500 and 2850;

SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN '20-FEB-1987' AND '1-MAY-1989'
ORDER BY hire_date;

SELECT last_name, department_id
FROM employees
WHERE department_id IN (10, 30)
ORDER BY last_name;

SELECT last_name as "Angajat", salary as "Salariu lunar"
FROM employees
WHERE salary > 3500 and department_id IN (10, 30);

SELECT sysdate 
FROM dual;

SELECT TO_CHAR(sysdate, 'YY, MONTH, DD, HH24')
FROM dual;

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE ('%87%');

SELECT first_name, last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = 1987;

SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

SELECT last_name, salary, commission_pct 
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary desc, commission_pct desc;

SELECT last_name, salary, commission_pct 
FROM employees
ORDER BY salary desc, commission_pct desc;

SELECT last_name
FROM employees
WHERE last_name LIKE ('__a%');

SELECT last_name, department_id, manager_id 
FROM employees
WHERE last_name LIKE ('%l%l%') AND (department_id = 30 OR manager_id = 101);

SELECT last_name, job_id, salary
FROM employees
WHERE (job_id LIKE ('%CLERK%') OR job_id LIKE('%REP%')) AND salary NOT IN (1000, 2000, 3000);

SELECT last_name, salary, commission_pct
FROM employees
WHERE salary > salary * commission_pct AND commission_pct IS NOT NULL;

