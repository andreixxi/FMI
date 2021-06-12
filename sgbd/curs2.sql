select count(null) 
from dual;
/

set serveroutput on
declare
    v_last_name varchar2(30);
    v_nume2 v_last_name%type; --acelasi tip cu v_last_name
    nr number := 0;
    cod number := &cod;
begin
select count(employee_id) into nr --verific daca exista angajatul, nr va fi 0 sau 1
from employees
where employee_id = cod; 
case
    when nr = 1 
            then 
                select last_name into v_last_name
                from employees
                where employee_id = cod;
                DBMS_OUTPUT.PUT_LINE('angajatul cu codul introdus este ' || v_last_name);
            else
                DBMS_OUTPUT.PUT_LINE('angajatul nu exista ');
end case;
end;
/


--sau 
declare
    v_last_name varchar2(30);
begin
    select  last_name into v_last_name
    from employees
    where employee_id = &cod;
    DBMS_OUTPUT.PUT_LINE('angajatul cu codul introdus este ' || v_last_name);
exception
    when no_data_found then 
    DBMS_OUTPUT.PUT_LINE('angajatul nu exista ');
end;
/

variable n number
/
print n 
/
begin
select count(employee_id) into : n
from employees;
end;
/
print n; 


set serveroutput on
<<extern>>
declare
    n number := 3;
begin 
    dbms_output.put_line(:n|| ' dar n este ' || n);
    :n := n + 1;
    dbms_output.put_line(:n|| ' pentru ca n este ' || n);
        declare
            n number := 5;
            begin
                   dbms_output.put_line('in sub ' || :n|| ' dar n este ' || n);
                   :n  := extern.n + 2;
                   dbms_output.put_line('in sub ' || :n || ' pt ca n este ' || extern.n);
            end;
end;



BEGIN
    << outer >> DECLARE
        v_sal       NUMBER(7, 2) := 60000;
        v_comm      NUMBER(7, 2) := v_sal * 0.2;
        v_message   VARCHAR2(255) := ' eligible for commission';
    BEGIN
        DECLARE
            v_sal          NUMBER(7, 2) := 50000;
            v_comm         NUMBER(7, 2) := 0;
            v_total_comp   NUMBER(7, 2) := v_sal + v_comm;
        BEGIN
            dbms_output.put_line('v_total_comp ' || v_total_comp); --50000
            dbms_output.put_line('v_comm ' || v_comm); -- 0
            v_message := 'clerk not ' || v_message;
            dbms_output.put_line('v_message ' || v_message); --clerk not  eligible for commission
            outer.v_comm := v_sal * 0.3;
            dbms_output.put_line('outer.v_comm ' || outer.v_comm); --15000
        END;

        v_message := 'salesman' || v_message;
    END;
END outer;
/












