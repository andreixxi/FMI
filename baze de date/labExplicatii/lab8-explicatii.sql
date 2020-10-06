-- LDD

-- Ex1 a)
create table ANGAJATI_ari (
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

drop table angajati_ari;

-- Ex1 b)
create table ANGAJATI_ari (
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

drop table angajati_ari;

-- Ex1 c) var 1
create table ANGAJATI_ari (
  cod_ang number(4), 
  nume varchar2(20) not null, 
  prenume varchar2(20), 
  email char(15),
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2),
  primary key (cod_ang)
);

-- Ex1 c) var 2
create table ANGAJATI_ari (
  cod_ang number(4), 
  nume varchar2(20) not null, 
  prenume varchar2(20), 
  email char(15),
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2),
  constraint pk_angajati_ari primary key (cod_ang)
);

drop table angajati_ari;

-- ex2
desc angajati_ari;
insert into angajati_ari(Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

insert into angajati_ari
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-02-2004', 'Inginer', 100, 10000, 10);

insert into angajati_ari
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-06-2000', 'Analist', 101, 5000, 20);

insert into angajati_ari
values (103, 'Nume4', 'Prenume4', Null, Null, 'Inginer', 100, 9000, 20);

insert into angajati_ari(Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5', 'Nume5', 'Analist', 101, 3000, 30);

commit;

-- Ex3
create table angajati10_ari as select * from angajati_ari where cod_dep = 10;
select * from angajati10_Ari; 

desc angajati10_Ari;

-- Ex4
alter table angajati_ari
add (comision number (4,2));

select * from angajati_ari;

-- Ex5
-- nu merge pentru ca scadem dimensiunea coloanei
alter table angajati_ari
modify (salariu number(6, 2));

-- Ex6
alter table angajati_ari
modify (salariu default 1000);

-- Ex7
alter table angajati_ari
modify (salariu number(10, 2), comision number(2, 2));

-- Ex8
update angajati_ari
set comision = 0.1 where job like 'A%';

commit;

-- Ex9
alter table angajati_ari
modify (email varchar2(15));

-- Ex10
alter table angajati_ari
add (nr_telefon char(10) default '0000000000');

select * from angajati_ari;

-- Ex11
alter table angajati_ari
drop column nr_telefon;

rollback;

-- Ex12
rename angajati_ari to angajati3_ari;

-- Ex13
select * from tab;
rename angajati3_ari to angajati_ari;

-- Ex14
truncate table angajati10_ari;

select * from angajati10_ari;
-- nu functioneaza pt LDD (TRUNCATE e LDD, DELETE e LMD)
rollback;

-- Ex15
create table DEPARTAMENTE_ari (
  cod_dep number(2), 
  nume varchar2(15) not null, 
  cod_director number(4)
);

desc departamente_Ari;

-- Ex16
insert into departamente_Ari
values (10, 'Administrativ', 100);
insert into departamente_Ari
values (20, 'Proiectare', 101);
insert into departamente_Ari
values (30, 'Programare', Null);

-- Ex17
alter table departamente_ari
add constraint pk_departamente_ari primary key (cod_dep);

-- Ex18

-- a)
alter table angajati_ari
add constraint fk_angajati_ari_dep_ari foreign key (cod_dep) references departamente_ari (cod_dep);

-- b)
drop table angajati_ari;

create table ANGAJATI_ari (
  cod_ang number(4) primary key, 
  nume varchar2(20) not null, 
  prenume varchar2(20), 
  email char(15) unique,
  data_ang date default sysdate,
  comision number(2, 2),
  job varchar2(10), 
  cod_sef number(4) references angajati_ari(cod_ang), 
  salariu number(8, 2) not null, 
  cod_dep number(2) check (cod_dep > 0),
  unique (nume, prenume),
  check (salariu > nvl(comision, 0) * 100),
  foreign key (cod_dep) references departamente_ari (cod_dep)
);

-- Ex19
desc angajati_ari;
insert into angajati_ari(Cod_ang, Nume, Prenume, Job, Salariu, Cod_dep)
values (100, 'Nume1', 'Prenume1', 'Director', 20000, 10);

insert into angajati_ari
values (101, 'Nume2', 'Prenume2', 'Nume2', '02-02-2004', 0.1, 'Inginer', 100, 10000, 10);

insert into angajati_ari
values (102, 'Nume3', 'Prenume3', 'Nume3', '05-06-2000', null, 'Analist', 101, 5000, 20);

insert into angajati_ari
values (103, 'Nume4', 'Prenume4', Null, Null, null, 'Inginer', 100, 9000, 20);

insert into angajati_ari(Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (104, 'Nume5', 'Prenume5', 'Nume5', 'Analist', 101, 3000, 30);

commit;

-- Ex21
-- nu functioneaza
drop table departamente_ari;

-- Ex24
-- nu functioneaza pentru ca avem randuri care incalca constrangerile
alter table angajati_ari
modify (email not null);

-- Ex25
-- nu functioneaza pt ca dep 50 nu exista in tabelul referentiat (departamente_ari)
insert into angajati_ari(Cod_ang, Nume, Prenume, Email, Job, Cod_sef, Salariu, Cod_dep)
values (105, 'Nume6', 'Prenume6', 'Nume6', 'Analist', 101, 3000, 50);

-- Ex26
insert into departamente_ari
values (60, 'Analiza', null);
commit;

-- Ex27
-- fara a specifica clauza ON CASCADE la nivel de FK constraint nu se poate realiza delete pe un row parinte care e referentiat de randuri din tabelul copil
delete from departamente_ari where cod_dep = 20;

-- Ex28
delete from departamente_ari where cod_dep = 60;
rollback;

-- Ex31
SELECT table_name, constraint_name, column_name
FROM user_cons_columns
WHERE LOWER(table_name) IN ('angajati_ari');

alter table angajati_ari
drop constraint SYS_C00340006;

alter table angajati_ari
add constraint fk_angajati_dep_ari foreign key(cod_dep) references departamente_ari(cod_dep) on delete cascade;

-- Ex32
delete from departamente_ari
where cod_dep = 20;

select * from departamente_Ari;

select * from angajati_ari; 

rollback;