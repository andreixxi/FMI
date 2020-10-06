--27. Afisati valoarea totala a excursiilor achizitionate:
---Pentru fiecare agentie si in cadrul agentiei pentru fiecare destinatie.
---Pentru fiecare agentie (indiferent de destinatie).
---Pentru fiecare destinatie (indiferent de agentie).
---Intreg tabelul.
select cod_agentie, destinatie, sum(pret)
from excursie
group by rollup(cod_agentie, destinatie);


--28. Afisati valoarea totala a excursiilor achizitionate
---Pentru fiecare agentie in fiecare an in care a vandut excursii.
---Pentru intreg tabelul. 
with total as (
      select cod_agentie, to_char(data_achizitie, 'YYYY') an, pret 
      from excursie
      join achizitioneaza on id_excursie = cod_excursie
      where cod_agentie is not null
      )
select cod_agentie, an, sum(pret)
from total
group by rollup (cod_agentie, an);


--29. Sa se afiseze denumirea excursiilor cu codul agentiei necunoscut care nu au fost
--achizitionate de niciun turist nascut in anul 1984.
select e.denumire
from excursie e
join achizitioneaza a on a.cod_excursie = e.id_excursie
join turist t on t.id_turist = a.cod_turist 
where e.cod_agentie is null
and to_char(t.data_nastere, 'YYYY') != '1984';



--30. Creati copii pentru toate tabelele din schema. Adaugati cheile primare si externe.
--Cheile externe vor fi create astfel incat la stergerea unei inregistrari sa se stearga si
--inregistrarile corelate. Pentru urmatoarele exercitii se vor utiliza tabelele copie. 
create table turist_alu as select * from turist;
create table achizitioneaza_alu as select * from achizitioneaza;
create table excursie_alu as select * from excursie;
create table agentie_alu as select * from agentie;

alter table turist_alu
add primary key (id_turist);
alter table excursie_alu
add primary key (id_excursie);
alter table agentie_alu
add primary key (id_agentie);

alter table achizitioneaza_alu
add foreign key (cod_turist) references turist_alu (id_turist)
on delete cascade;
alter table achizitioneaza_alu
add foreign key (cod_excursie) references excursie_alu (id_excursie)
on delete cascade;
alter table excursie_alu
add foreign key (cod_agentie) references agentie_alu (id_agentie)
on delete cascade;

commit;

--31. Modificati discount-ul obtinut la achizitioanrea excursiilor care au un pret peste
--medie astfel incat sa devina egal cu maximul discount-urilor oferite pana acum. Anulati
--modificarile. 
update achizitioneaza_alu
set discount = ( select max(discount) from achizitioneaza_alu )
where cod_excursie in ( select id_excursie
                  from excursie_alu
                  where pret > (select avg(pret) from excursie_alu)
                  );
rollback;
              
              
--32. Stergeti toate excursiile care au pretul mai mic decat media preturilor din agentie care
--le pune la dispozitie. Anulati modificarile. 
delete from excursie_alu e
where e.pret < (select avg(pret)
                from excursie_alu
                where e.cod_agentie = cod_agentie);
rollback;


--33. Stergeti constrangerea de cheie externa dintre tabelul excursie si agentie. Adaugati
--doua excursii cu coduri inexistente de agentii. Modificati codul agentie pentru excursiile
--care nu corespund unei agnetii existente astfel incat sa fie cod necunoscut (null). Anulati
--modificarile. 

alter table excursie_alu
drop constraint SYS_C00355751;
alter table excursie_alu
add foreign key (cod_agentie) references agentie_alu (id_agentie)
on delete cascade;

insert into excursie_alu 
values(1000, 'denumire', 500, 'destinatie', 8, 80, 200, null);
insert into excursie_alu 
values(1001, 'denumire2', 800, 'destinatie2', 10, 70, 150, null);

update excursie_alu
set cod_agentie = null
where cod_agentie not in (select id_agentie from agentie_alu);

select * from excursie_alu;
rollback;


--34. Creati o vizualizare v_excursie asupra tabelului excursie_*** care sa permita
--inserarea in acesta doar a excursiilor oferite de agentie 10.
--Testati inserarea unei noi inregistrari in tabelul excursie_*** prin intermediul vizualizarii
--v_excusie_***.
--Permanentizati modificarea. 
create view v_excursie_alu as 
      select * 
      from excursie_alu
      where cod_agentie = 10
      with check option;
      
select * from v_excursie_alu;

insert into v_excursie_alu 
values (105, 'denumire', 800, 'destinatie', 5, 10, 40, null);
commit;


--35. Stergeti toate inregistrarile din tabelul achizitioneaza_***.
--Creati un SAVEPOINT cu denumirea a. 
truncate table achizitioneaza_alu;
savepoint a;


--36. Populati tabelul achizitioneaza_*** astfel incat sa contina toate excursiile
--achizitionate in 2010 (din tabelul achizitioneaza) dar cu data_start si data_end decalate
--cu 1 luna. 
insert into achizitioneaza_alu
      select *
      from achizitioneaza
      where to_char(data_achizitie, 'yyyy') = '2010';
update achizitioneaza_alu
set data_start = data_start + 30,
    data_end = data_end + 30;     
    
    
    
--37. Mariti cu 10% discount-ul pentru excursiile oferite de agentia 10. 
update achizitioneaza_alu
set discount = discount + 10/100 * discount
where (select cod_agentie
      from excursie_alu
      where cod_excursie = id_excursie
        ) = 10;
select * from achizitioneaza_alu;


--38. Stergeti achizitiile turistilor pentru care data nasterii nu este cunoscuta. 
delete from achizitioneaza_alu
where (select data_nastere
      from turist_alu
      where cod_turist = id_turist) is null;


--39. Folosind comanda MERGE actualizati informatiile din tabelul achizitioneaza_***
--astfel incat sa coincida cu informatiile din tabelul achizitioneaza. Anulati modificarile
--pentru exe 36 - 39. Anulati toate midificarile. 
--select * from achizitioneaza_alu;
--merge into achizitioneaza_alu aa
--using (select * from achizitioneaza a) as a
--on(a.cod_excursie = aa.cod_excursie);
select * from achizitioneaza_alu;

insert into achizitioneaza_alu
select * from achizitioneaza;



--39. Scadeti cu 10% pretul excursiilor care au fost achizitioante de cele mai multe ori. 
select * from excursie_alu;
update excursie_alu
set pret = pret - 10/100 * pret
where id_excursie in (select cod_excursie
                      from (select cod_excursie, count(1) numar
                            from achizitioneaza_alu
                            group by cod_excursie
                      ) total
                      where numar = 2
                      );
                      
                      
--40. Adaugati tabelului turist_*** constrangerile
---Numele sa nu fie NULL
---Numele si prenumele sa fie unice. 
alter table turist_alu
modify (nume not null);
alter table turist_alu
add unique (nume, prenume);


--41. Adaugati tabelului achizitioneaza constrangerile
---data_start < data_end
---data_achizitie sa fie implicit data sistemului. 
alter table achizitioneaza_alu
add check (data_start < data_end);
alter table achizitioneaza_alu
modify (data_achizitie default sysdate);


--46. Sa se insereze un nou turist cu prenume necunoscut. Codul va fi retinut intr-o
--variabila de legatura. Sa se afiseze valoarea variabilei de legatura. Codul si numele vor fi
--citite de la tastatura. Pentru cod folositi valoarea 100. 
insert into turist_alu
values (&id_turist, '&nume', null, sysdate);


--47. Modificati prenumele turistului cu codul 100. Se va afisa numele si prenumele
--turistului pentru care s-a facut modificarea. 
update turist_alu
set prenume = 'prenume'
where id_turist = 100;

select nume, prenume 
from turist_alu 
where id_turist = 100;


--48. Stergeti turistul cu codul 100. Afisati numele si prenumele turistului sters. 
delete from turist_alu
where id_turist = 100;