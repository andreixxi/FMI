-- Lab6. 
-- Exercitii DIVISION 
-- Ex 1 (facut la lab)
--S? se listeze informa?ii despre angaja?ii care au lucrat în toate proiectele demarate în primele 6 luni
--ale anului 2006. Implementa?i toate variantele. 


-- Ex 15
-- Sa se afiseze codul, numele, salariul si codul departamentului din care face parte pentru un angajat
-- al carui cod este introdus de utilizator de la tastatura. Analizati diferentele dintre cele 4 posibilitati:
--I
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod; 
--II
DEFINE p_cod; 
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod;
UNDEFINE p_cod;
--III
DEFINE p_cod = 100;
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &&p_cod;
UNDEFINE p_cod;
--IV
ACCEPT p_cod PROMPT 'cod= ';
SELECT employee_id, last_name, salary, department_id
FROM employees WHERE employee_id = &p_cod; 

select * from employees where lower(last_name) like '%&p_nume%'; 

select * from departments where department_id = &p_dept_id;


-- Ex 16
-- Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au un anumit
-- job.
ACCEPT p_jobId PROMPT 'p_jobId= '; -- de ex it_prog
SELECT last_name, department_id, salary 
FROM employees 
WHERE lower(job_id) = '&p_jobId'; 

select * from employees;
select * from employees where lower(job_id) = '%&p_nume%';

--Ex 17
--Sa se afiseze numele, codul departamentului si salariul anual pentru toti angajatii care au fost
--angajati dupa o anumita data calendaristica. 
SELECT first_name, department_id, salary
FROM employees
WHERE hire_date > '&p_date'; -- de forma 10-SEP-90

-- Ex 18
-- Sa se afiseze o coloana aleasa de utilizator, dintr-un tabel ales de utilizator, ordonand dupa aceeasi
--coloana care se afiseaza. De asemenea, este obligatorie precizarea unei conditii WHERE. 
accept data1 prompt "coloana=";
accept data2 prompt "tabel=";
select &data1 from &data2
order by 1;

--Ex 19
-- S? se realizeze un script prin care s? se afi?eze numele, job-ul ?i data angaj?rii salariatilor care
--au început lucrul între 2 date calendaristice introduse de utilizator. S? se concateneze numele
-- si job-ul, separate prin spatiu si virgul?, si s? se eticheteze coloana "Angajati".
-- Se vor folosi comanda ACCEPT si formatul pentru data calendaristica MM/DD/YY.
accept data1 prompt 'data inceput = ';
accept data2 prompt 'data final = ';
select last_name || ', ' || job_id Angajati, to_char(hire_date, 'MM/DD/YY')
from employees
where to_date('&data1', 'MM/DD/YY') < hire_date and hire_date < to_date('&data2', 'MM/DD/YY');

--Ex 20
-- Sa se realizeze un script pentru a afisa numele angajatului, codul job-ului, salariul si numele
-- departamentului pentru salariatii care lucreaza intr-o locatie data de utilizator. Va fi permisa cautarea
-- case-insensitive.
accept locatie prompt 'locatie= ';
select e.last_name, e.job_id, e.salary, d.department_name
from employees e
join departments d using(department_id)
join locations l using(location_id)
where lower('&locatie') = lower(l.city);