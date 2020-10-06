--1.
with programari as (
            select id_medic, count(1) nr_prog
            from programare p
            join medic m on(p.id_medic = m.id_medic)
            where to_char(data_prog, 'yyyy') = 2018
            group by id_medic)
select nume, prenume, nr_prog
from medic 
join programari using (id_medic);


--corina
select nume, prenume, nvl(count(1), 0)
from medic
left outer join programari using (id_medic )
where to_char(data_prog, 'yyyy') = 2018
group by id_medic, nume, prenume;

--2.
select d.denumire, m.nume, m.prenume
from departament d
join medic m on (d.id_departament = m.id_departament)
where m.salariu = (select max(salariu)
                from medic 
                where id_departament = m.id_departament);
                
--corina
select denumire, nume, prenume
from departamente d
inner join medic using (id_departament)
where salariu = (select max(salariu)
                from medic m
                where m.id_department = d.id_departement
                group by id_departament
                );
                
                
--3.
select nume, prenume 
from pacient p
join programare pr on (p.id_pacient = pr.id_pacient)
join medic using (id_medic)
join departament using (id_departament)
where to_char(pr.data_prog, 'DD') = to_char(p.data_nasterii, 'DD')
and to_char(pr.data_prog, 'MM') = to_char(p.data_nasterii, 'MM')
and (lower(denumire) = 'dermatologie' 
    or lower(denumire) = 'cardiologie');


--4. afisati pacientii care au avut programare dupa pacientul cu numele Popescu
SELECT id_pacient, nume, prenume
FROM pacient
join programare using (id_pacient)
WHERE data_prog > (SELECT data_prog
                  from programare
                  join pacient using(id_pacient)
                  where nume = 'Popescu');
                  
                  
--5.
insert into departament values(10, 'denumire', 100, 10000);
alter table departament
add primary key (id_departament);

alter table medic
add foreign key(id_departament) references departament(id_departament)
on delete cascade;



--corina
insert into departamant (id_departament, denumire, salariu_min, salariu_man)
values (300, 'Chirirgie', 10000, 1000000);

alter table departament
add primary key (id_departamant);

alter table medic
add foreign key (id_departamant) references departament (id_departamant)
on delete cascade;