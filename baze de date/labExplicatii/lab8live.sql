-- LAB 8
-- 1. S? se creeze tabelul ANGAJATI_pnu (pnu se alcatuie?te din prima liter? din prenume ?i primele
--dou? din numele studentului) corespunz?tor schemei rela?ionale:
--ANGAJATI_pnu(cod_ang number(4), nume varchar2(20), prenume varchar2(20), email char(15),
--data_ang date, job varchar2(10), cod_sef number(4), salariu number(8, 2), cod_dep number(2))
--în urm?toarele moduri: 
--a) f?r? precizarea vreunei chei sau constrângeri; 
create table angajati_alu (
   cod_ang number(4), 
   nume varchar2(20), 
   prenume varchar2(20), 
   email char(15),
   data_ang date default sysdate, 
   job varchar2(10), 
   cod_sef number(4), 
   salariu number(8, 2), 
   cod_dep number(2)
   );
drop table angajati_alu;


--b)
create table angajati_alu (
   cod_ang number(4) primary key, 
   nume varchar2(20) not null, 
   prenume varchar2(20), 
   email char(15),
   data_ang date default sysdate, 
   job varchar2(10), 
   cod_sef number(4), 
   salariu number(8, 2) not null, 
   cod_dep number(2)
   );
drop table angajati_alu;


--c)
create table angajati_alu (
   cod_ang number(4), 
   nume varchar2(20) not null, 
   prenume varchar2(20), 
   email char(15),
   data_ang date default sysdate, 
   job varchar2(10), 
   cod_sef number(4), 
   salariu number(8, 2) not null, 
   cod_dep number(2),
   constraint pk_nagajati_alu primary key (cod_ang)
   --sau primary key (cod_ang)
   );
drop table angajati_alu;


--2
insert into angajati_alu (Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5' ,' Nume5', 'Analist', 101, 3000, 30);

--problema la 101 si 102
insert into angajati_alu 
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-02-2004', 'Inginer', 100, 10000, 10); 

insert into angajati_alu
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-06-2000', 'Analist', 101, 5000, 20);

insert into angajati_alu 
values (103, 'Nume4', 'Prenume4', Null, Null, 'Inginer', 100, 9000, 20);


--3
create table angajati10_alu as select * from angajati_alu where cod_dep = 10;
drop table angajati10_alu;

select * from angajati10_alu;
desc angajati10_alu;


--4
alter table angajati_alu
add(comision number (4, 2));

select * from angajati_alu;


--5
-- nu merge pt ca scadem dimensiunea coloanei 
alter table angajati_alu
modify (salariu number (6, 2)); 


--6
alter table angajati_alu
modify (salariu default 10000);


--7
--merge, creste dimenisunea la salariu, iar la comision era null inainte 
alter table angajati_alu
modify (salariu number(10, 2), comision number(2, 2));


--8
update angajati_alu 
set comision = 0.1 where job like 'A%';
commit;


--9
alter table angajati_alu 
modify (email varchar2(15));


--10
alter table angajati_alu
add (nr_telefon char(10) default '0000000000');

select * from angajati_alu;


--11
alter table angajati_alu
drop column nr_telefon;
rollback; -- nu functioneaza pt ldd (drop column)


--12
rename angajati_alu to angajati3_alu;


--13
select * from tab;
rename angajati3_alu to angajati_alu;


--14
truncate table angajati10_alu;
select * from angajati10_alu;
rollback; -- nu functioneaza pt LDD (trtuncate e LDD ,   delete e LMD)


--15
create table departament_alu (
   cod_dep number(2), 
   nume varchar2(15) not null,
   cod_director number(4)
   ); 
desc departament_alu;


--16
insert into departament_alu 
values (10, 'Administrativ', 10);

insert into departament_alu 
values (20, 'Proiectare', 101);

insert into departament_alu 
values (30, 'Programare', Null);


--17
alter table departament_alu
add constraint pk_departament_alu primary key (cod_dep);
desc departament_alu;


--18
--a)
alter table angajati_alu
add constraint fk_angajati_alu_dep_alu foreign key (cod_dep) references departament_alu (cod_dep);


--b)
drop table angajati_alu;

create table angajati_alu (
   cod_ang number(4) primary key, 
   nume varchar2(20) not null, -- nivel de coloana  
   prenume varchar2(20),  
   email char(15) unique,
   data_ang date default sysdate, 
   comision number (2, 2), 
   job varchar2(10), 
   cod_sef number(4) key references angajati_alu(cod_ang), 
   salariu number(8, 2) not null, 
   cod_dep number(2) check (cod_dep > 0),
   unique (nume, prenume), --nivel de tabel
   check (salariu > nvl(comision, 0) * 100),
   foreign key (cod_dep) references departament_alu (cod_dep)
   --constraint uq_nume_pren unique (nume, prenume)
   );


-- 19
--  de pus ce e la nivel de coloana la nivel de table, nu not null


--20
desc angajati_alu;
insert into angajati_alu (Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5' ,' Nume5', 'Analist', 101, 3000, 30);

--problema la 101 si 102
insert into angajati_alu 
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-02-2004', 0.1, 'Inginer', 100, 10000, 10); 

insert into angajati_alu
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-06-2000', null, 'Analist', 101, 5000, 20);

insert into angajati_alu 
values (103, 'Nume4', 'Prenume4', Null, Null, null, 'Inginer', 100, 9000, 20);

commit;


--21
-- cica nu functioneaza
drop table departament_alu;


--22, 23 noi


--24
-- nu merge pt ca sunt linii care au email null (trb ca toate sa respecte constrangerea data)
alter table angajati_alu 
modify (email not null);


--25
-- nu functioneaza pt ca dep 50 nu exista in tabelul referntiat (departament_alu)


--26
insert into departament_alu
values (60, 'Analiza', null);
commit;


--27
-- incearca sa stearga o valoare parinte care are copii ofofofof (mai intai trb stersi copiii/ disable la contraint)
-- fara a specifica clauza on cascade la nivel de foreign key constraint nu se poate realiza deltete pe un row parinte care e referentiat de randuri din tabelul copil
delete from deprtament_alu where cod_dep = 20;


--28
-- nu e niciun angajat in dep 60 deci functioneaza 
delete from departament_alu where cod_dep = 60;
rollback;


--29
-- nu exista 114 in tabel deci nu face insert 


--30



--31

SELECT constraint_name, constraint_type, table_name
FROM user_cons_columns
WHERE lower(table_name) IN ('angajati_alu'); 


alter table angajati_alu 
drop constraint SYS_0515650 ;--ceva de la comanda de mai sus de la cod_dep

alter table angajati_alu
add constraint fk_angajati_dep_alu foreign key (cod_dep) references departament_alu(cod_dep) on delete cascade;


--32
delete from departament_alu where cod_dep = 20;

select * from departament_alu;
select * from angajati_alu;
rollback;


--33
--tema


--34 --similar cu 33 restul tema HORROOOOOOOOOOOOOORRRRRRRRRRRRRRRRRRRRRRRRRRRRRR 
