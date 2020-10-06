--Laboratorul 2
--Functii de siruri de caractere
-- 1
SELECT CONCAT(FIRST_NAME, LAST_NAME) || ' castiga '|| SALARY || ' lunar, dar doreste '|| 3 * SALARY  
FROM EMPLOYEES;

--2
--prima litera mare, restul mici
SELECT INITCAP(first_name) as "First name",  UPPER(last_name) as "Last name" , LENGTH(last_name) as "Name length"
FROM employees
WHERE (last_name LIKE ('J%') OR last_name LIKE ('M%') OR UPPER(last_name) LIKE ('__A%'))
ORDER BY LENGTH(last_name) DESC;

--cu substr
SELECT INITCAP(first_name) as "First name",  UPPER(last_name) as "Last name" , LENGTH(last_name) as "Name length"
FROM employees
--substr(str, i, n) incepe pe i si are lungime n
WHERE (SUBSTR(last_name, 1, 1) = 'J' OR SUBSTR(last_name, 1, 1) = 'M' OR SUBSTR(UPPER(last_name), 3, 1) = 'A')
ORDER BY LENGTH(last_name) DESC;

--3
SELECT employee_id, last_name, department_id
FROM employees
WHERE TRIM(LOWER(first_name)) = 'steven';
--WHERE UPPER(first_name) LIKE ('%STEVEN%');

--4
SELECT employee_id as "employee_id", last_name as "last_name", LENGTH(last_name) as "name_length", INSTR(UPPER(last_name), 'A', 1, 1) as "aparitie" --prima aparitie pt 'a'
FROM employees
WHERE substr(last_name, LENGTH(last_name), 1) = 'e';

SELECT first_name, employee_id, last_name, LENGTH(last_name) as LENGTH , INSTR (LOWER(first_name), 'a') AS INSTR
FROM employees
WHERE first_name LIKE('%e');

--Functii aritmetice
--5
--un num?r întreg de s?pt?mâni pân? la data curent?
SELECT last_name, trunc(trunc(sysdate - hire_date)/7)
FROM employees
WHERE trunc(trunc(sysdate - hire_date)/7) = trunc(sysdate - hire_date)/7;

--6
--                                                    exprimat cu 2 zecimale
SELECT employee_id, last_name, salary, TO_CHAR(salary * 1.15,'99999.99') as "Salariu nou", trunc(MOD(salary*1.15,1000)/100) as "Numar sute"
FROM employees;

--7
SELECT last_name as "Nume angajat", hire_date as "Data angajarii" 
FROM employees
WHERE commission_pct IS NOT NULL;

--Functii si operatii cu date calendaristice
--8
SELECT TO_CHAR((sysdate + 30), 'MONTH DAY YYYY HH:MI:SS')
FROM DUAL;

--9
--nr de zile pana la sf anului
SELECT TRUNC(TO_DATE('31-12-2020 23:59','dd-mm-yyyy hh24:mi') - SYSDATE)
FROM DUAL;

--10
--a data de peste 12 ore
SELECT TO_CHAR(SYSDATE + 0.5,'MONTH dd yyyy hh24:mi:ss')
FROM DUAL;
SELECT TO_CHAR(SYSDATE + 12/24,'MONTH dd yyyy hh24:mi:ss')
FROM DUAL;

--b data de peste 5 minute
SELECT TO_CHAR(SYSDATE + 1/24/60*5,'MONTH dd yyyy hh24:mi:ss')
FROM DUAL;

--11
SELECT last_name, first_name, hire_date, NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Monday') as "Negociere"
FROM employees;

--12
SELECT last_name, TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) as "Luni lucrate"
FROM employees
ORDER BY 2; --al 2lea param = TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date))

--13
SELECT last_name, hire_date, TO_CHAR(hire_date, 'day') as "Zi"
FROM employees
ORDER BY 3;

--Functii diverse
--14
SELECT last_name, NVL(TO_CHAR(commission_pct), 'Fara comision') as "Comision"
FROM employees;

--15
SELECT last_name, salary, commission_pct
FROM employees
WHERE salary > 10000;

--Instructiunea CASE, comanda DECODE
--16
SELECT last_name, job_id, salary, 
DECODE(job_id, 'IT_PROG', salary + 0.2 * salary, 
                'SA_REP', salary + 0.25 * salary, 
                'SA_MAN', salary + 0.35 * salary, 
                salary) as "Salariu negociat"
FROM employees;

--Join
--17
SELECT last_name, e.department_id, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

--18
SELECT job_id
FROM employees e, departments d
WHERE d.department_id = 30
AND e.department_id = d.department_id;

--19
SELECT last_name, d.department_name, l.location_id
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
--AND d.location_id = l.location_id
AND commission_pct is not null;

--20
SELECT last_name, department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id 
and e.last_name like '%A%';
--AND INSTR(UPPER(e.last_name), 'A') <> 0;

--21
SELECT last_name, d.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id 
AND l.location_id = d.location_id
AND l.city LIKE '%Oxford%'
ORDER BY e.last_name; 

--sau
select e.last_name, d.department_id, d.department_name
from employees e 
join departments d on (e.department_id = d.department_id)
join locations l on (l.location_id = d.location_id)
where l.city = 'Oxford'
order by e.last_name;

--22
SELECT e1.employee_id as "Ang#", 
       CONCAT(e1.last_name, e1.first_name)  as "Angajat", 
       e1.manager_id as "Mgr#", --sau e2.employee_id
       CONCAT(e2.last_name, e2.first_name) as "Manager"
FROM employees e1, employees e2
WHERE e1.manager_id = e2.employee_id;

--23
SELECT
    t1.employee_id Ang#,
    t1.first_name || ' ' || t1.last_name Angajat,
    t2.employee_id Mgr#,
    t2.first_name || ' ' || t2.last_name Manager
FROM employees t1
LEFT JOIN employees t2
ON t1.manager_id = t2.employee_id;

--24
SELECT e.last_name || ' ' || e.first_name as "Nume angajat",
       e.department_id as "Cod departament",
       e2.last_name || ' ' || e2.first_name as "Salariati"
FROM employees e, employees e2
WHERE e.department_id = e2.department_id 
AND e.employee_id <> e2.employee_id; --pentru a exclude si randurile cu acelasi angajat

--25
SELECT *
FROM jobs;

SELECT e.last_name || ' ' || e.first_name "Nume angajat",
       e.job_id, j.job_title, d.department_name, e.salary
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id;


--26
SELECT last_name || ' ' || first_name "Nume angajat",
       hire_date 
FROM employees 
WHERE hire_date > (
      SELECT hire_date
      FROM employees
      WHERE last_name = 'Gates'
      );
      
--27
SELECT e.last_name || ' ' || e.first_name "Angajat" ,
       e.hire_date  "Data_ang",
       e2.last_name || ' ' || e2.first_name "Manager",
       e2.hire_date "Data_mgr"
FROM employees e, employees e2
WHERE e.hire_date < e2.hire_date
AND e.manager_id = e2.employee_id;