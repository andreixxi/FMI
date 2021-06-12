--insert into tabel 
--values var_record;
--
--update tabel
--set row = var_record;

--exemplu1 
--declare
--    type t_red is record
--        (v_sal number(8),
--        v_minsal number (8) default 1000,
--        v_hire_date employees.hire_date%type,
--        v_recl employees%rowtype);
--    v_myrec t_rec;
--begin
--    v_myrec.v_sal := 
   
   
DECLARE
    TYPE tab_index IS TABLE OF NUMBER
    INDEX BY BINARY_INTEGER;
    TYPE tab_imbri IS TABLE OF NUMBER;
    TYPE vector IS VARRAY(15) OF NUMBER;
    v_tab_index tab_index;
    v_tab_imbri tab_imbri;
    v_vector vector;
BEGIN
    v_tab_index(1) := 72;
    v_tab_index(2) := 23;
    v_tab_imbri := tab_imbri(5, 3, 2, 8, 7); --trb folosit tipul(constr) tab_imbri
    v_vector := vector(1, 2); --si aici la fel
END;
/

DECLARE
TYPE dept_table_type
IS
TABLE OF departments%ROWTYPE INDEX BY VARCHAR2(20);
dept_table dept_table_type;
-- Each element of dept_table is a record
BEGIN
SELECT * 
INTO dept_table(1) 
FROM departments
WHERE department_id = 10;
DBMS_OUTPUT.PUT_LINE(dept_table(1).department_id ||'
'||
dept_table(1).department_name ||' '||
dept_table(1).manager_id);
END;
/

--tablouri imbricate
DECLARE
    TYPE numartab IS TABLE OF NUMBER;
    -- se creeaza un tablou cu un singur element
    v_tab_1 numartab := numartab(-7);
    -- se creeaza un tablou cu 4 elemente
    v_tab_2 numartab := numartab(7,9,4,5);
    -- se creeaza un tablou fara nici un element
    v_tab_3 numartab := numartab(); -- initializarea e ft imp 
    poz number;
BEGIN
    v_tab_1(1) := 57;
    --daca ar fi fost v_tab_3(1) := 57; trb pus extend inainte
    v_tab_2.delete(2); --introduc gaura la indice 2 si explodeaza in for
    --deci folosesc while
    poz := v_tab_2.first;
    
     FOR j IN 1..v_tab_2.count LOOP
        DBMS_OUTPUT.PUT_LINE (v_tab_2(poz) || ' ');
        poz := v_tab_2.next(poz);
    END LOOP;
 /*   FOR j IN 1..v_tab_2.count LOOP
    if v_tab_2.exists(j) then
        DBMS_OUTPUT.PUT_LINE (v_tab_2(j) || ' ');
    end if;
    END LOOP;
    */
END;
/

DECLARE
    TYPE alfa IS TABLE OF VARCHAR2(50);
    tab1 alfa; -- creeaza un tablou (atomic) null
    tab2 alfa := alfa(); --tabloul nu este null, e initializat
BEGIN
    IF tab1 IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('tab1 este NULL'); --da
    ELSE
        DBMS_OUTPUT.PUT_LINE('tab1 este NOT NULL');
    END IF;
    
    IF tab2 IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('tab2 este NULL');
    ELSE
        DBMS_OUTPUT.PUT_LINE('tab2 este NOT NULL'); --da
    END IF;
END;
/

--ex 1
create or replace type tabimb is table of number;
/
declare 
--    type tab_imb is table of number;
    v_tab tabimb := tabimb();    
    poz number;
begin
    v_tab.extend(100);
    for i in 1 .. 100 loop
        v_tab(i) := i;
    end loop;
    
    for i in 1 .. v_tab.count loop
        if mod(v_tab(i), 2) = 1 then
            v_tab.delete(i);
        end if;
    end loop;
    
   DBMS_OUTPUT.PUT_LINE (v_tab.count);
   
   DBMS_OUTPUT.PUT_LINE('Direct: ');
   poz := v_tab.first; 
   FOR j IN 1..v_tab.count LOOP
        DBMS_OUTPUT.PUT(v_tab(poz) || ' ');
        poz := v_tab.next(poz);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');   
    
    DBMS_OUTPUT.PUT_LINE('Invers: ');
   poz := v_tab.last; 
   FOR j IN 1..v_tab.count LOOP
        DBMS_OUTPUT.PUT(v_tab(poz) || ' ');
        poz := v_tab.prior(poz);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');   
end;
/




