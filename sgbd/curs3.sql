update employees
set (salary. commission_pct) = (select salary. commission_pct
                                        from employees
                                        where employee_id = 120)
where employee_id = 115;


--vizualizarea este o cerere stocata 
create or replace view remember as
select department_id, department_name
from departments
where department_id > 100
with check option; --nu pot face insert cu valori < 100 la dep_id

--insertul se face in tabelul departments (prin intermediul viewului)
insert into remember
values (77, 'test'); 

insert into remember
values (177, 'test'); 

select * from remember;
select * from departments;
rollback;


--vizualizare compusa ( cu join )
create or replace view remember as
select department_id, department_name, employee_id, last_name
from departments
join employees using (department_id)
where department_id > 100
with check option;


--printre cei din dept 10 e posibil sa fie un manager 
 --returneaza din ce am sters
set serveroutput on 
declare 
    deptno number:=120; 
    v_id employees.employee_id%type; 
begin 
    delete from employees 
    where department_id=deptno 
    returning employee_id into v_id; 
    dbms_output.put_line(v_id); 
end; 

rollback;


set serveroutput on 
declare 
    deptno number:=130; 
    v_id employees.employee_id%type; 
begin 
    delete from employees 
    where department_id=deptno 
    returning employee_id into v_id; 
    dbms_output.put_line(v_id||' au fost sterse '||sql%rowcount); 
end; 
rollback;

select * from employees;


--55 ultima valaore afisata
declare
    v_total simple_integer := 0;
begin
    for i in 1..10 loop
        v_total := v_total + i;
    dbms_output.put_line('total is '|| v_total);
    end loop;
end;