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


--b)cu precizarea cheilor primare la nivel de coloan? si a constrangerilor NOT NULL pentru
--coloanele nume ?i salariu;
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
desc angajati_alu;
drop table angajati_alu;


--c)cu precizarea cheii primare la nivel de tabel si a constrângerilor NOT NULL pentru coloanele
--nume ?i salariu
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


--2. Ad?uga?i urm?toarele înregistr?ri în tabelul ANGAJATI_pnu: 
insert into angajati_alu (Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

--problema la 101 si 102
insert into angajati_alu 
values (101, 'Nume2', 'Prenume2', 'Nume2', to_date('02-02-2004', 'DD-MM-YYYY'), 'Inginer', 100, 10000, 10); 

insert into angajati_alu
values (102, 'Nume3', 'Prenume3', 'Nume3', to_date('05-06-2000', 'DD-MM-YYYY'), 'Analist', 101, 5000, 20);

insert into angajati_alu 
values (103, 'Nume4', 'Prenume4', Null, Null, 'Inginer', 100, 9000, 20);

insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5' ,' Nume5', 'Analist', 101, 3000, 30);

select * from angajati_alu;


--3. Crea?i tabelul ANGAJATI10_pnu, prin copierea angaja?ilor din departamentul 10 din tabelul
--ANGAJATI_pnu. Lista?i structura noului tabel. Ce se observ?? 
create table angajati10_alu as select * from angajati_alu where cod_dep = 10;
select * from angajati10_alu;
desc angajati10_alu;
drop table angajati10_alu;


--4.  Introduceti coloana comision in tabelul ANGAJATI_pnu. Coloana va avea tipul de date
--NUMBER(4,2). 
alter table angajati_alu
add(comision number (4, 2));
desc angajati_alu;
select * from angajati_alu;


--5. Este posibil? modificarea tipului coloanei salariu în NUMBER(6,2)? 
-- nu merge pt ca scadem dimensiunea coloanei 
alter table angajati_alu
modify (salariu number (6, 2)); 


--6. Seta?i o valoare DEFAULT pentru coloana salariu. 
alter table angajati_alu
modify (salariu default 10000);


--7. Modifica?i tipul coloanei comision în NUMBER(2, 2) ?i al coloanei salariu la NUMBER(10,2), în
--cadrul aceleia?i instruc?iuni.
--merge, creste dimenisunea la salariu, iar la comision era null inainte 
alter table angajati_alu
modify (salariu number(10, 2), comision number(2, 2));


--8. Actualizati valoarea coloanei comision, setând-o la valoarea 0.1 pentru salaria?ii al c?ror job
--începe cu litera A. (UPDATE) 
update angajati_alu 
set comision = 0.1 where job like 'A%';
commit;


--9. Modifica?i tipul de date al coloanei email în VARCHAR2.
alter table angajati_alu 
modify (email varchar2(15));


--10. Ad?uga?i coloana nr_telefon în tabelul ANGAJATI_pnu, setându-i o valoare implicit?. 
alter table angajati_alu
add (nr_telefon char(10) default '0000000000');

select * from angajati_alu;


--11.  Vizualiza?i înregistr?rile existente. Suprima?i coloana nr_telefon.
--Ce efect ar avea o comand? ROLLBACK în acest moment? 
alter table angajati_alu
drop column nr_telefon;
select * from angajati_alu;
rollback; -- nu functioneaza pt ldd (drop column)
select * from angajati_alu;


--12. Redenumi?i tabelul ANGAJATI_pnu în ANGAJATI3_pnu
rename angajati_alu to angajati3_alu;


--13.  Consulta?i vizualizarea TAB din dic?ionarul datelor. Redenumi?i angajati3_pnu în angajati_pnu. 
select * from tab;
rename angajati3_alu to angajati_alu;


--14. Suprima?i con?inutul tabelului angajati10_pnu, f?r? a suprima structura acestuia. 
truncate table angajati10_alu;
select * from angajati10_alu;
rollback; -- nu functioneaza pt LDD (trtuncate e LDD ,   delete e LMD)
select * from angajati10_alu;


--15.  Crea?i ?i tabelul DEPARTAMENTE_pnu, corespunz?tor schemei rela?ionale:.... specificând doar constrângerea NOT NULL pentru nume
create table departament_alu (
   cod_dep number(2), 
   nume varchar2(15) not null,
   cod_director number(4)
   ); 
desc departament_alu;


--16. Introduce?i urm?toarele înregistr?ri în tabelul DEPARTAMENTE_pnu: 
insert into departament_alu 
values (10, 'Administrativ', 10);

insert into departament_alu 
values (20, 'Proiectare', 101);

insert into departament_alu 
values (30, 'Programare', Null);

select * from departament_alu;


--17.  Se va preciza apoi cheia primara cod_dep, f?r? suprimarea ?i recreerea tabelului (comanda ALTER). 
alter table departament_alu
add constraint pk_departament_alu primary key (cod_dep);
desc departament_alu;


--18. S? se precizeze constrângerea de cheie extern? pentru coloana cod_dep din ANGAJATI_pnu: 
--a) f?r? suprimarea tabelului (ALTER TABLE); 
alter table angajati_alu
add constraint fk_angajati_alu_dep_alu foreign key (cod_dep) references departament_alu (cod_dep);


--b)prin suprimarea ?i recrearea tabelului, cu precizarea noii constrângeri la nivel de coloan?
--({DROP, CREATE} TABLE).  De asemenea, se vor mai preciza constrângerile (la nivel de coloan?,
--dac? este posibil):
--- PRIMARY KEY pentru cod_ang;
--- FOREIGN KEY pentru cod_sef;
--- UNIQUE pentru combina?ia nume + prenume;
--- UNIQUE pentru email;
--- NOT NULL pentru nume;
--- verificarea cod_dep >0;
--- verificarea ca salariul sa fie mai mare decat comisionul*100

drop table angajati_alu;

create table angajati_alu (
   cod_ang number(4) primary key, 
   nume varchar2(20) not null, -- nivel de coloana  
   prenume varchar2(20),  
   email char(15) unique,
   data_ang date default sysdate, 
   comision number (2, 2), 
   job varchar2(10), 
   cod_sef number(4) references angajati_alu(cod_ang), 
   salariu number(8, 2) not null, 
   cod_dep number(2) check (cod_dep > 0),
   unique (nume, prenume), --nivel de tabel
   check (salariu > nvl(comision, 0) * 100),
   foreign key (cod_dep) references departament_alu (cod_dep)
   --constraint uq_nume_pren unique (nume, prenume)
   );


-- 19. Suprima?i ?i recrea?i tabelul, specificând toate constrângerile la nivel de tabel (în m?sura în care
--este posibil)
--  de pus ce e la nivel de coloana la nivel de table, nu not null
drop table angajati_alu;
create table angajati_alu (
   cod_ang number(4), 
   nume varchar2(20) not null, -- nivel de coloana  
   prenume varchar2(20),  
   email char(15),
   data_ang date default sysdate, 
   comision number (2, 2), 
   job varchar2(10), 
   cod_sef number(4) references angajati_alu(cod_ang), 
   salariu number(8, 2) not null, 
   cod_dep number(2) check (cod_dep > 0),
   unique (nume, prenume, email), --nivel de tabel
   check (salariu > nvl(comision, 0) * 100),
   primary key (cod_ang),
   foreign key (cod_dep) references departament_alu (cod_dep)
   --constraint uq_nume_pren unique (nume, prenume)
   );
   
   
--20.  Reintroduce?i date în tabel, utilizând (?i modificând, dac? este necesar fi?ierul l8p2.sql. 
desc angajati_alu;
insert into angajati_alu (Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

insert into angajati_alu 
values (101, 'Nume2', 'Prenume2', 'Nume2', to_date('02-02-2004', 'MM-DD-YYYY'), 0.1, 'Inginer', 100, 10000, 10); 

insert into angajati_alu
values (102, 'Nume3', 'Prenume3', 'Nume3', to_date('05-06-2000', 'MM-DD-YYYY'), null, 'Analist', 101, 5000, 20);

insert into angajati_alu 
values (103, 'Nume4', 'Prenume4', Null, Null, null, 'Inginer', 100, 9000, 20);

insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5' ,'Nume5', 'Analist', 101, 3000, 30);
commit;


--21 . Ce se întâmpl? dac? se încearc? suprimarea tabelului departamente_pnu? 
--  nu functioneaza An attempt was made to drop a table with unique or
--           primary keys referenced by foreign keys in another table.
drop table departament_alu;


--22. Analiza?i structura vizualiz?rilor USER_TABLES, TAB, USER_CONSTRAINTS. 
SELECT * FROM tab;
SELECT table_name FROM user_tables; 
select * from user_tables;
select * from user_constraints;


--23. a) Lista?i informa?iile relevante (cel pu?in nume, tip ?i tabel) despre constrângerile asupra tabelelor
--angajati_pnu ?i departamente_pnu. 
--Tipul constrângerilor este marcat prin:
--• P - pentru cheie primar?
--• R – pentru constrângerea de integritate referen?ial? (cheie extern?);
--• U – pentru constrângerea de unicitate (UNIQUE);
--• C – pentru constrângerile de tip CHECK. 
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE lower(table_name) IN ('angajati_alu', 'departament_alu'); 


--b) Afla?i care sunt coloanele la care se refer? constrângerile asupra tabelelor angajati_pnu ?i
--departamente_pnu.
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_alu', 'departament_alu');


--24. Introduce?i constrângerea NOT NULL asupra coloanei email. 
-- nu merge pt ca sunt linii care au email null (trb ca toate sa respecte constrangerea data)
alter table angajati_alu 
modify (email not null);


--25.  (Incerca?i s?) ad?uga?i o nou? înregistrare în tabelul ANGAJATI_pnu, care s? corespund? codului
--de departament 50. Se poate? 
-- nu functioneaza pt ca dep 50 nu exista in tabelul referntiat (departament_alu)
insert into angajati_alu(Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (105, 'Nume6', 'Prenume6', 'Nume6', 'Analist', 101, 3000, 50);


--26. Ad?uga?i un nou departament, cu numele Analiza, codul 60 ?i directorul null în
--DEPARTAMENTE_pnu. COMMIT.
insert into departament_alu
values (60, 'Analiza', null);
commit;


--27.  (Incerca?i s?) ?terge?i departamentul 20 din tabelul DEPARTAMENTE_pnu. Comenta?i. 
-- incearca sa stearga o valoare parinte care are copii ofofofof (mai intai trb stersi copiii/ disable la contraint)
-- fara a specifica clauza on cascade la nivel de foreign key constraint nu se poate realiza deltete pe un row parinte care e referentiat de randuri din tabelul copil
delete from deprtament_alu where cod_dep = 20;


--28. ?terge?i departamentul 60 din DEPARTAMENTE_pnu. ROLLBACK. 
-- nu e niciun angajat in dep 60 deci functioneaza 
delete from departament_alu where cod_dep = 60;
rollback;


--29.  (Incerca?i s?) introduce?i un nou angajat, specificând valoarea 114 pentru cod_sef. Ce se ob?ine? 
-- nu exista 114 in tabel deci nu face insert ---> integrity constraint (GRUPA32.SYS_C00343840) violated - parent key not found
insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (105, 'Nume6', 'Prenume6' ,'Nume6', 'Analist', 114, 3000, 30);



--30. Ad?uga?i un nou angajat, având codul 114. Incerca?i din nou introducerea înregistr?rii de la
--exerci?iul 29. 
-- functioneaza 
insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (114, 'Nume6', 'Prenume6' ,'Nume6', 'Analist', 100, 3000, 30);

insert into angajati_alu (Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (105, 'Nume7', 'Prenume7' ,'Nume7', 'Analist', 114, 3000, 30);

select * from angajati_alu;

--31. . Se dore?te ?tergerea automat? a angaja?ilor dintr-un departament, odat? cu suprimarea
--departamentului. Pentru aceasta, este necesar? introducerea clauzei ON DELETE CASCADE în
--definirea constrângerii de cheie extern?. Suprima?i constrângerea de cheie extern? asupra
--tabelului ANGAJATI_pnu ?i reintroduce?i aceast? constrângere, specificând clauza ON DELETE
--CASCADE

SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_alu');

alter table angajati_alu 
drop constraint SYS_C00343841 ;--ceva de la comanda de mai sus de la cod_dep

alter table angajati_alu
add constraint fk_angajati_dep_alu foreign key (cod_dep) references departament_alu(cod_dep) on delete cascade;


--32.. ?terge?i departamentul 20 din DEPARTAMENTE_pnu. Ce se întâmpl?? Rollback. 
-- functioneaza, sterge si angajatii din dep 20
delete from departament_alu where cod_dep = 20;
select * from departament_alu;
select * from angajati_alu;
rollback;


--33.  Introduce?i constrângerea de cheie extern? asupra coloanei cod_director a tabelului
--DEPARTAMENTE_pnu. Se dore?te ca ?tergerea unui angajat care este director de departament
--s? atrag? dup? sine setarea automat? a valorii coloanei cod_director la null. 
--? 
alter table departament_alu 
add constraint fk_cod_director foreign key (cod_director) references angajati_alu(cod_ang) on delete set null;

select * from angajati_alu;
select * from departament_alu;



--34. Actualiza?i tabelul DEPARTAMENTE_PNU, astfel încât angajatul având codul 102 s? devin?
--directorul departamentului 30. ?terge?i angajatul având codul 102 din tabelul ANGAJATI_pnu.
--Analiza?i efectele comenzii. Rollback.
--Este posibil? suprimarea angajatului având codul 101? Comenta?i. 
update departament_alu 
set cod_director = 102
where cod_dep = 30;

select * from departament_alu;
select * from angajati_alu;
delete from angajati_alu
where cod_ang = 102; --merge 

delete from angajati_alu
where cod_ang = 101; -- nu pot sterge integrity constraint (GRUPA32.SYS_C00343943) violated - child record found (pt ca mai sunt angajati in dep unde e sef 101?)
rollback;


--35.Ad?uga?i o constrângere de tip check asupra coloanei salariu, astfel încât acesta s? nu poat?
--dep??i 30000
alter table angajati_alu 
add check (salariu <= 30000);


--36.  Incerca?i actualizarea salariului angajatului 100 la valoarea 35000. 
update angajati_alu 
set salariu = 35000
where cod_ang = 100;
--violeaza constrangerea 

--37. Dezactiva?i constrângerea creat? anterior ?i reîncerca?i actualizarea. Ce se întâmpl? dac?
--încerc?m reactivarea constrângerii? 
-- ? .. 
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_alu');

alter table angajati_alu 
drop constraint SYS_C00343938;  -- de la salariu

alter table angajati_alu 
add check (salariu <= 30000);  