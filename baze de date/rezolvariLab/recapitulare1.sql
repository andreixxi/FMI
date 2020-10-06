--Se d? schema:
--TURIST(#id_turist, nume, prenume, data_nastere)
--ACHIZITIONEAZA(#cod_turist, #cod_excursie, #data_start, data_end, data_achizitie, discount)
--EXCURSIE(#id_excursie, denumire, pret, destinatie, durata, cod_agentie, nr_locuri)
--AGENTIE(#id_agentie, denumire, oras)

--1. S? se afi?eze denumirea primei excursii achizi?ionate. 
select * from (
      select e.denumire
      from excursie e
      join achizitioneaza a on (a.cod_excursie = e.id_excursie)
      order by a.data_achizitie
      )
 where rownum = 1;


--2. Afi?a?i de câte ori a fost achizi?ionat? fiecare excursie. 
select cod_excursie, count(*)
from achizitioneaza
group by cod_excursie;


--3.S? se afi?eze pentru fiecare agen?ie, denumirea, ora?ul, num?rul de excursii oferite, media pre?urilor excursiilor oferite
select a.denumire, a.oras, count(1) as numar_excursii, avg(e.pret)
from agentie a
join excursie e on (a.id_agentie = e.cod_agentie)
group by a.denumire, a.oras;


--4. a. S? se ob?in? numele ?i prenumele turi?tilor care au achizi?ionat cel pu?in 2 excursii. 
select t.nume, t.prenume, count(1) numar_excursii
from turist t
join achizitioneaza a on (t.id_turist = a.cod_turist)
group by t.nume, t.prenume
having count(1) >= 2;


--b. S? se ob?in? num?rul turi?tilor care au achizi?ionat cel putin 2 excursii. 
select count(count(1)) as "turisti 2 excursii"
from achizitioneaza
group by cod_turist 
having count(cod_turist) >= 2;


--5.Afi?a?i informa?ii despre turi?tii care nu au achizi?ionat excursii cu destina?ia Paris. 
select distinct t.id_turist, t.nume, t.prenume, t.data_nastere
from turist t
join achizitioneaza a on (a.cod_turist = t.id_turist)
join excursie e on (e.id_excursie = a.cod_excursie)
where e.id_excursie in ( --id ul excursiei nu este cu dest paris
             select id_excursie 
             from excursie 
             where destinatie != 'Paris')
and (t.id_turist not in (
             select cod_turist  --turistii care au cumparat pentru paris
             from achizitioneaza 
             where cod_excursie in (
                         select id_excursie 
                         from excursie 
                         where destinatie = 'Paris'
                                   )
                       )
      or t.id_turist not in (select distinct cod_turist from achizitioneaza))
order by t.id_turist;

        
          
select distinct t.id_turist, t.nume, t.prenume, t.data_nastere
from turist t
join achizitioneaza a on (a.cod_turist = t.id_turist)
join excursie e on (e.id_excursie = a.cod_excursie)
where e.id_excursie in ( --id ul excursiei nu este cu dest paris
             select id_excursie 
             from excursie 
             where destinatie != 'Paris')
or (t.id_turist not in (select distinct cod_turist from achizitioneaza))
order by t.id_turist;


select t.id_turist, t.nume, t.prenume, t.data_nastere
from turist t
left join achizitioneaza ac
on ac.cod_turist = t.id_turist
left join excursie ex
on ex.id_excursie = ac.cod_excursie
where ex.destinatie != 'Paris' or ex.destinatie is null;

      
select t.id_turist 
from turist t
where t.id_turist not in ( select distinct cod_turist from achizitioneaza);


-- corect
with dest_paris as (
    select * from turist t
    join achizitioneaza a on (a.cod_turist = t.id_turist)
    join excursie e on (e.id_excursie = a.cod_excursie)
    where e.destinatie = 'Paris')
select * from turist
where id_turist not in (select id_turist from dest_paris);


--6. Afi?a?i codul ?i numele turi?tilor care au achizi?ionat excursii spre cel pu?in dou?
--destina?ii diferite. 
select id_turist, nume, prenume
from turist t
where (select count(distinct destinatie)
     from turist t2
     join achizitioneaza a on (a.cod_turist = t2.id_turist)
     join excursie e on (e.id_excursie = a.cod_excursie)
     where t2.id_turist = t.id_turist
      ) >= 2;
  

--7. S? se afi?eze pentru fiecare agen?ie, denumirea ?i profitul ob?inut. (Profitul ob?inut din
--vânzarea unei excursii este pret – pret * discount Dac? discountul este necunoscut
--profitul este pre?ul excursiei). 
select denumire, 
            nvl (
              (select sum(pret - pret * nvl (discount, 0)) profit
              from achizitioneaza 
              join excursie on (cod_excursie = id_excursie)
              where cod_agentie = id_agentie), 
            0) profit
from agentie;

select * from agentie;
select * from excursie;
select * from achizitioneaza;

--8.S? se afi?eze denumirea ?i ora?ul pentru agen?iile care au cel pu?in 3 excusii oferite la
--un pre? mai mic dec?t 2000 euro.
select denumire, oras
from agentie 
where (select count(1) 
      from excursie
      where cod_agentie = id_agentie
      and pret < 2000) >= 3;


--9.S? se afi?eze excursiile care nu au fost achizi?ionate de c?tre nici un turist
select * 
from excursie
where id_excursie not in (select cod_excursie from achizitioneaza);


--10.Afi?a?i informa?ii despre excursii, inclusiv denumirea agen?iei. Pentru excursiile
--pentru care nu este cunoscut? agen?ia se va afi?a textul “agentie necunoscuta”. 
select e.id_excursie, e.denumire "denumire excursie", 
       nvl(a.denumire, 'agentie necunoscuta') "denumire agentie"
from excursie e
left join agentie a on (a.id_agentie = e.cod_agentie);


--11. S? se afi?eze informa?ii despre excursiile care au pre?ul mai mare dec?t excursia cu
--denumirea “Orasul luminilor” existent? în oferta agen?iei cu codul 10. 
select id_excursie, denumire, pret
from excursie
where pret > (select pret
            from excursie 
            where denumire = 'Orasul luminilor' and cod_agentie = 10);
            
            
--12. S? se ob?in? lista turi?tilor care au achizi?ionat excursii cu o durata mai mare de 10
--zile. (se va lua în considerare data_start ?i data_end) 
select id_turist, nume, prenume, data_end - data_start durata
from turist
join achizitioneaza on (cod_turist = id_turist)
where (data_end - data_start) >= 10;


--13. S? se ob?in? excusiile achizi?ionate de cel pu?in un turist vârsta mai mic? de 30 de ani. 
select cod_excursie
from achizitioneaza 
join turist on (cod_turist = id_turist)
where (sysdate - data_nastere)/365 <= 30;

select (sysdate - data_nastere)/365 from turist;


--14.S? se ob?in? turi?tii care nu au achizi?ionat nicio excursie oferit? de agen?ii din
--Bucuresti. 
select t.id_turist, t.nume, t.prenume
from turist t
where t.id_turist not in (select id_turist from turist t2
                          join achizitioneaza a on (t2.id_turist = a.cod_turist)
                          join excursie e on (e.id_excursie = a.cod_excursie)
                          join agentie ag on (ag.id_agentie = e.cod_agentie)
                          where ag.oras = 'Bucuresti');
                          
                          
--15. S? se ob?in? numele turi?tilor care au achizi?ionat excursii care con?in în denumire “1
--mai” de la o agen?ie din Bucure?ti. 
 select t.id_turist, t.nume, t.prenume
from turist t
where t.id_turist  in (select id_turist from turist t2
                          join achizitioneaza a on (t2.id_turist = a.cod_turist)
                          join excursie e on (e.id_excursie = a.cod_excursie)
                          join agentie ag on (ag.id_agentie = e.cod_agentie)
                          where ag.oras = 'Bucuresti'
                          and lower(e.denumire) like '%1 mai%'); 
                          select * from excursie;
                          

--16. S? se ob?ina numele, prenume turi?tilor ?i excursiile oferite de agen?ia “Smart Tour”
--achizi?ionate de c?tre ace?tia. 
select nume, prenume, e.denumire 
from turist
join achizitioneaza on (cod_turist = id_turist)
join excursie e on (e.id_excursie = cod_excursie)
join agentie ag on (ag.id_agentie = cod_agentie)
where ag.denumire = 'Smart Tour';


--17. S? se afi?eze excursiile pentru care nu mai exist? locuri pentru data de plecare 14 -
--aug-2011. 
select * from (select id_excursie, nr_locuri, count(1) ocupate
              from excursie
              join achizitioneaza on cod_excursie = id_excursie
              where data_start = '14-AUG-11'
              group by id_excursie, nr_locuri) 
              where nr_locuri = ocupate;
              
              
--18. S? se ob?in? codurile turi?tilor ?i codul ultimei excursii achizi?ionate de c?tre ace?tia.               
with data_achiz as (select id_turist, id_excursie, data_achizitie
                    from excursie
                    join achizitioneaza on (id_excursie = cod_excursie)
                    join turist on (id_turist = cod_turist)
                    order by data_achizitie desc
                    )
select id_turist, max(data_achizitie)
from data_achiz
group by id_turist;


--19.Afi?a?i topul celor mai scumpe excursii (primele 5). 
select * from (select * from excursie order by pret desc)
where rownum <= 5;


--20. Afi?a?i numele turi?tilor care au achizi?ionat excursii cu data de plecare în aceea?i
--luna cu luna în care î?i serbeaz? ziua de na?tere. 
select nume, prenume, data_nastere, data_start 
from turist
join achizitioneaza on cod_turist = id_turist
where to_char(data_start, 'MM') = to_char(data_nastere, 'MM');


--21. S? se afi?eze informa?ii despre turi?tii care au achizi?ionat excusii de 2 persoane de la
--agen?ii din Constan?a. 
select nume, prenume
from turist 
join achizitioneaza on id_turist = cod_turist
join excursie on id_excursie = cod_excursie
join agentie on id_agentie = cod_agentie
where agentie.oras = 'Constanta';

select nume, prenume, count(*)
from turist 
join achizitioneaza on id_turist = cod_turist
join excursie on id_excursie = cod_excursie
join agentie on id_agentie = cod_agentie
where agentie.oras = 'Constanta' 
group by nume, prenume
having count(*) = 2;

with total as (select cod_excursie, count(*) numar
              from achizitioneaza
              group by cod_excursie),
pers2 as (select *
              from total
              where numar = 2)
select nume, prenume
from turist
join achizitioneaza on id_turist = cod_turist
join excursie on id_excursie = cod_excursie
join agentie on id_agentie = cod_agentie
join pers2 using (cod_excursie)
where agentie.oras = 'Constanta'; 



--22. În func?ie de durata excursiei afi?a?i în ordine excursiile cu durata mic? (durat? de
--maxim 5 zile), medie (durata între 6 ?i 19 de zile), lunga (durata peste 20 de zile). 
with durata as (
    select id_excursie, 
    case
      when durata <= 5 then 'mica'
      when durata <= 19 then 'medie'
      else 'lunga'
      end txt,
    durata
    from excursie)
select id_excursie, durata, txt
from durata
order by durata;


--23. Afi?a?i num?rul excursiilor, câte excursii sunt oferite de agen?ii din Constan?a, câte
--sunt oferite de agen?ii din Bucure?ti. 
select count(*) numar_excursii
from excursie;

select oras, count(*) agentiioras
from agentie
where oras = 'Bucuresti' or oras = 'Constanta'
group by oras;

with total as (
        select oras, count(*) excursii --numar excursii de la fiecare agentie pe oras
        from agentie
        join excursie on id_agentie = cod_agentie
        group by oras
        )
select (
        select sum(excursii)
        from total
        ) numar_excursii,
        (
        select excursii
        from total
        where oras like 'Constanta') Constanta_Excursii,
        (
        select excursii
        from total
        where oras like 'Bucuresti') Bucuresti_Excursii
        from dual;


--24. Afi?a?i excursiile care au fost achizi?ionate de to?i turi?tii în vârsta de 24 ani. 
select *
from excursie
join achizitioneaza on id_excursie = cod_excursie
join turist on id_turist = cod_turist
where round((sysdate - data_nastere) / 365) = 24;


--25. Afi?a?i valoarea total? a excursiilor:
---Pentru fiecare agen?ie ?i în cadrul agen?iei pentru fiecare destina?ie.
---Pentru fiecare agen?i (indiferent de destina?ie)
---Întreg tabelul.
--Afi?a?i o coloan? care se indice interven?ia celorlalte coloane în ob?inerea rezultatului. 

select cod_agentie, destinatie, sum(pret), grouping(cod_agentie), grouping(destinatie)
from excursie
group by rollup(cod_agentie, destinatie);


--26. S? se ob?in? pentru fiecare agen?ie media pre?urilor excursiilor oferite de agen?iile
--concurente (situate în acela?i ora?). 
with pretmediu as (
    select id_agentie, oras, avg(pret) pretm
    from agentie
    join excursie
    on id_agentie = cod_agentie
    group by id_agentie, oras)
select ag.id_agentie, 
       ag.oras, 
       pretmediu.id_agentie idconcurent, 
       pretmediu.pretm prconcurent
from agentie ag
join pretmediu
on ag.oras = pretmediu.oras
and ag.id_agentie != pretmediu.id_agentie;

