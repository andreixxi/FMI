--sa se obtina o linie de forma <nume> are salariul anual <sal>
--pt fiecare angajat din dept 50. se cer solutii diferite (while, loop, for sepcific cursoare,
--for cu varianta de scriere a cursorului in int sau
select last_name || ' are salariul anual ' || 12 * salary
from employees
where department_id = 50;

declare
    type sal is record (nume employees.last_name%type,
                            salariu employees.salary%type);
    type tang is table of sal index by pls_integer;
    tsal tang;
begin
    select last_name, 12 * salary
    bulk collect into tsal
    from employees
    where department_id = 50;
    
    for i in 1..tsal.count loop
        dbms_output.put_line(tsal(i).nume || ' are salariul anual ' || tsal(i).salariu);
    end loop;
end;
/


--cursor (un fel de pointer)
declare
    cursor csal is  select last_name, 12 * salary salAnual
                        from employees
                        where department_id = 50;
    clinie csal%rowtype; --linie din cursor
begin
    if not csal%isopen then 
        open csal; -- executa cererea din cursor, este salvat in csal rez cererii
    end if;
    fetch csal into clinie; --incarc o linie din cursor in clinie
    while csal%found loop
        dbms_output.put_line(clinie.last_name || ' are salariul anual ' || clinie.salAnual);
        fetch csal into clinie; -- avansez la urm
    end loop;
    close csal;
end;
/


-- cursor parametrizat
declare
    cursor csal (dep employees.department_id%type) is  
                        select last_name, 12 * salary salAnual
                        from employees
                        where department_id = dep;
    clinie csal%rowtype; --linie din cursor
begin
    if not csal%isopen then 
        open csal(&dep); -- executa cererea din cursor, este salvat in csal rez cererii
    end if;
    fetch csal into clinie; --incarc o linie din cursor in clinie
    while csal%found loop
        dbms_output.put_line(clinie.last_name || ' are salariul anual ' || clinie.salAnual);
        fetch csal into clinie; -- avansez la urm
    end loop;
    close csal;
end;
/


-- cursor parametrizat frumos (dinamic)
declare
    cursor csal (dep employees.department_id%type) is  
                        select last_name, 12 * salary salAnual
                        from employees
                        where department_id = dep;
    clinie csal%rowtype; --linie din cursor
    type cdinamic is ref cursor;
    myCursor cdinamic;
    dep departments%rowtype;
begin
    open myCursor for 'select * from departments';
    fetch myCursor into dep; --incarc o linie din cursor in clinie
    while myCursor%found loop
        dbms_output.put_line(dep.department_id || ' are department name ' || dep.department_name);
        fetch myCursor into dep; -- avansez la urm
    end loop;
    close myCursor;
    
    dbms_output.put_line('---------');
    
    open myCursor for 'select * from departments where department_id>:d' using &cod_dep;
    fetch myCursor into dep; --incarc o linie din cursor in clinie
    while myCursor%found loop
        dbms_output.put_line(dep.department_id || ' are department name ' || dep.department_name);
        fetch myCursor into dep; -- avansez la urm
    end loop;
    close myCursor;
end;
/

--------test facut de mine, o eroare 
declare
    type cdinamic is ref cursor;
    myCursor cdinamic;
    emp employees%rowtype;
begin
     open myCursor for 'select last_name, 12 * salary salAnual from employees where department_id = &dep';
        fetch myCursor into emp; --incarc o linie din cursor in clinie
        while myCursor%found loop
            dbms_output.put_line(emp.last_name || ' are salariul anual ' || emp.salary * 12);
            fetch myCursor into emp; -- avansez la urm
        end loop;
        close myCursor;
end;
/



--
declare
    type cdinamic is ref cursor;
    myCursor cdinamic;
    dep departments%rowtype;
begin
open myCursor for '&cerere';
    fetch myCursor into dep; --incarc o linie din cursor in clinie
    while myCursor%found loop
        dbms_output.put_line(dep.department_id || ' are department name ' || dep.department_name);
        fetch myCursor into dep; -- avansez la urm
    end loop;
    close myCursor;
end;
/



------------------------------------
declare
    cursor csal (dep employees.department_id%type) is  
                        select last_name, 12 * salary salAnual
                        from employees
                        where department_id = dep;
begin
    for linie in csal(&dep) loop --deschide cursorul, parcurge, inchide cursorul
        dbms_output.put_line(linie.last_name||' salariu ' ||linie.salAnual);
    end loop;
end;
/

--asa nu merge cu un cursor dinamic
begin
    for linie in (select last_name, 12 * salary salAnual
                   from employees
                   where department_id = &dep) loop
        dbms_output.put_line(linie.last_name||' salariu ' ||linie.salAnual);
    end loop;
end;
/

-- update
declare 
    cursor salAng is select *
                           from employees
                           for update of salary nowait; --wait 10
begin
    for ang in salAng loop
        update employees
        set salary = salary + 4
        where employee_id = ang.employee_id;
    end loop;
end;
/
rollback

                           
                           
                           
                           