--Exerci?ii – func?ii grup ?i clauzele GROUP BY, HAVING

-- ex 1
a)Toate func?iile grup, cu excep?ia lui COUNT(*), ignor? valorile null.
 COUNT(expresie) returneaz? num?rul de linii pentru care expresia dat? nu are valoarea null. 
 
 b)Op?iunea HAVING permite restric?ionarea grupurilor de linii returnate, la cele care
îndeplinesc o anumit? condi?ie.
Dac? aceast? clauz? este folosit? în absen?a unei clauze GROUP BY, aceasta
presupune c? gruparea se aplic? întregului tabel, deci este returnat? o singur? linie, care
este re?inut? în rezultat doar dac? este îndeplinit? condi?ia din clauza HAVING. 


-- ex 2
select  max(salary) Maxim, min(salary) Minim, sum(salary) Suma, round(avg(salary), 0) Media
from employees;

-- ex 3
select job_id, min(salary), max(salary), sum(salary), avg(salary)
from employees
group by job_id;

-- ex 4
select job_id, count(employee_id)
from employees
group by job_id;

-- ex 5
select count(distinct manager_id) "Nr manageri"
from employees;

-- ex 6
select max(salary), min(salary), max(salary) - min(salary) "Difernta salariu"
from employees;

-- ex 7 ???
select * from departments;
select * from locations;
select * from employees;

select d.department_name "Nume departament", l.city "Locatie departament", count(e.job_id) "Numar angajati departament", round(avg(e.salary), 3) "Salariu mediu"
from departments d
join locations l on d.location_id = l.location_id
join employees e on d.department_id = e.department_id
group by d.department_name, l.city;

-- ex 8 
select employee_id, last_name, salary
from employees
where salary > (select avg(salary) from employees)
order by salary desc;


-- ex 9
--cel mai prost platit -> min(salary)
select manager_id, min(salary), max(salary)
from employees
where manager_id is not null --exclud sefii pt care manager_id nu este cunoscut
group by manager_id
having min(salary) > 5000 --exclud pe cei peste 5000
order by min(salary) desc; --sortat desc

-- ex 10
select d.department_id, d.department_name, max(salary)
from departments d
join employees e on (d.department_id = e.department_id)
group by d.department_id, d.department_name
having max(salary) > 3000
order by max(salary);

-- ex 11
select avg(salary), job_id
from employees
group by job_id
order by 1;

select min(avg(salary))
from employees
group by job_id;

-- ex 12
select department_id, department_name, sum(salary)
from departments 
join employees using (department_id)
group by department_id, department_name;

-- ex 13
select max(avg(salary))
from employees
group by department_id;

-- ex 14
select job_id, job_title, avg(salary)
from employees
join jobs using(job_id)
having avg(salary) = (select min(avg(salary))
                      from employees
                      group by job_id)
group by job_id, job_title;

-- ex 15
select avg(salary) 
from employees
having avg(salary) > 2500;

-- ex 16
select sum(salary)
from employees
group by department_id, job_id
order by department_id;

-- ex 17
select department_name, min(salary)
from departments
join employees using(department_id)
having avg(salary) = (select max(avg(salary))
                    from employees
                    group by department_id)
group by department_name;        


--tema: lab 4 (18-25 + 29/34 bonus), lab 5 (2, 4, 5 - 13)

-- Lab 4
-- Ex 18
 -- Sa se afiseze codul, numele departamentului si numarul de angajati care lucreaza
-- in acel departament pentru:
-- a) departamentele in care lucreaza mai putin de 4 angajati;
select department_id, department_name, count(*)
from departments
join employees using (department_id)
group by department_id, department_name
having count(*) < 4;

-- b) departamentul care are numarul maxim de angajati. 
select department_id, department_name, count(*)
from departments
join employees using (department_id)
group by department_id, department_name
having count(*) = (   select max(count(*))
                      from departments
                      join employees using (department_id)
                      group by department_id
                      );
                      
-- Ex 19
-- Sa se afiseze salariatii care au fost angajati în aceea?i zi a lunii în care cei mai multi
-- dintre salariati au fost angajati. 
select last_name, first_name
from employees
where to_char(hire_date, 'dd') = (
                  select to_char(hire_date, 'dd')
                  from employees
                  group by to_char(hire_date, 'dd')
                  having count(*)= (   
                                    select max(count(*))
                                    from employees
                                    group by to_char(hire_date, 'dd')
                                    )
                                  );
                                  
-- Ex 20
-- S? se ob?in? num?rul departamentelor care au cel pu?in 15 angaja?i. 
select count(department_id)
from employees
group by department_id
having count(employee_id) >= 15;


-- Ex 21
-- S? se ob?in? codul departamentelor ?i suma salariilor angaja?ilor care lucreaz? în
-- acestea, în ordine cresc?toare. Se consider? departamentele care au mai mult de 10
-- angaja?i ?i al c?ror cod este diferit de 30. 
select department_id, sum(salary)
from employees 
group by department_id
having count(employee_id) > 10 and department_id <> 30
order by 2;


-- Ex 22 ?
-- Sa se afiseze codul, numele departamentului, numarul de angajati si salariul mediu
--din departamentul respectiv. Se vor afi?a ?i departamentele f?r? angaja?i (outer join). 

select d.department_id, d.department_name,
  (select count(*) 
  from employees e 
  where e.department_id = d.department_id) "numar angajati",
  (select round(avg(salary), 2)
  from employees e 
  where e.department_id = d.department_id) "salariu mediu"
from departments d;


-- Ex 23 
-- Scrieti o cerere pentru a afisa, pentru departamentele avand codul > 80, salariul total
--pentru fiecare job din cadrul departamentului. Se vor afisa orasul, numele
--departamentului, jobul si suma salariilor. Se vor eticheta coloanele corespunzator
select sum(salary), department_id, city, job_id
from employees
join departments using (department_id)
join locations using (location_id)
group by department_id, city, job_id
having department_id > 80;

select sum(salary), department_id, city, job_id
from employees
join departments using (department_id)
join locations using (location_id)
where department_id > 80
group by department_id, city, job_id;


-- Ex 24
-- Care sunt angajatii care au mai avut cel putin doua joburi? 
select count(*), employee_id
from job_history
group by employee_id
having count(*) >= 2;


-- Ex 25
-- S? se calculeze comisionul mediu din firm?, luând în considerare toate liniile din
--tabel. 
--nvl is used to replace NULL value with another value.
select (avg(nvl(commission_pct, 0)))
from employees;


-- Ex 26 
--- am analizat la lab


-- Ex 27 facut la lab
select job_id, 
(select sum(salary) from employees where job_id = e.job_id and department_id = 30) Dept30,
(select sum(salary) from employees where job_id = e.job_id and department_id = 50) Dept50,
(select sum(salary) from employees where job_id = e.job_id and department_id = 80) Dept80,
(select sum(salary) from employees where job_id = e.job_id) total
from employees e;


-- Ex 28 facut la lab
select 
(select count(*) from employees) as total,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1997) an1997,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1998) an1998,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 1999) an1999,
(select count(*) from employees where to_char(hire_date, 'yyyy') = 2000) an2000
from dual;

-- Ex 29
select d.department_id, d.department_name,
  (select count(*) 
  from employees e 
  where e.department_id = d.department_id) "numar angajati",
  (select round(avg(salary), 2)
  from employees e 
  where e.department_id = d.department_id) "salariu mediu"
from departments d;


--facute la lab 30 - 33
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

-- 34
select department_id, department_name, nvl(nr_ang, 0), avg_salary
from departments
left join (select department_id, count(*) nr_ang 
           from employees 
           group by department_id) using (department_id)
left join (select department_id, avg(salary) avg_salary 
           from employees 
           group by department_id) 
           using (department_id);