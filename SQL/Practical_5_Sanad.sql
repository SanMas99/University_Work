-- Name: Sanad Masannat
-- ID: 24217734


-- q1

drop view if exists character_type_counts;
create view character_type_counts as 
select 
	sum(case when role_type.role_type = 'hero' then 1 else 0 end) as hero,
	sum(case when role_type.role_type = 'playboy' then 1 else 0 end) as playboy,
	sum(case when role_type.role_type = 'spy' then 1 else 0 end) as spy,
	sum(case when role_type.role_type = 'detective' then 1 else 0 end) as detective,
	sum(case when role_type.role_type = 'alien' then 1 else 0 end) as alien,
	sum(case when role_type.role_type = 'superhero' then 1 else 0 end) as superhero,
	sum(case when role_type.role_type = 'reporter' then 1 else 0 end) as reporter,
	sum(case when role_type.role_type = 'billionaire' then 1 else 0 end) as billionaire,
	sum(case when role_type.role_type = 'CEO' then 1 else 0 end) as CEO,
	sum(case when role_type.role_type = 'philanthropist' then 1 else 0 end) as philanthropist,
	sum(case when role_type.role_type = 'archer' then 1 else 0 end) as archer,
	sum(case when role_type.role_type = 'thief' then 1 else 0 end) as thief,
	sum(case when role_type.role_type = 'magician' then 1 else 0 end) as magician,
	sum(case when role_type.role_type = 'doctor' then 1 else 0 end) as doctor,
	sum(case when role_type.role_type = 'villain' then 1 else 0 end) as villain,
	sum(case when role_type.role_type = 'politician' then 1 else 0 end) as politician,
	sum(case when role_type.role_type = 'president' then 1 else 0 end) as president,
	sum(case when role_type.role_type = 'mathematician' then 1 else 0 end) as mathematician,
	sum(case when role_type.role_type = 'assassin' then 1 else 0 end) as assassin,
	sum(case when role_type.role_type = 'butler' then 1 else 0 end) as butler,
	sum(case when role_type.role_type = 'amnesiac' then 1 else 0 end) as amnesiac,
	sum(case when role_type.role_type = 'hacker' then 1 else 0 end) as hacker,
	sum(case when role_type.role_type = 'inventor' then 1 else 0 end) as inventor,
	sum(case when role_type.role_type = 'mutant' then 1 else 0 end) as mutant,
	sum(case when role_type.role_type = 'astronaut' then 1 else 0 end) as astronaut,
	sum(case when role_type.role_type = 'professor' then 1 else 0 end) as professor,
	sum(case when role_type.role_type = 'scientist' then 1 else 0 end) as scientist,
	sum(case when role_type.role_type = 'god' then 1 else 0 end) as god,
	sum(case when role_type.role_type = 'soldier' then 1 else 0 end) as soldier,
	sum(case when role_type.role_type = 'raccoon' then 1 else 0 end) as raccoon,
	sum(case when role_type.role_type = 'tree' then 1 else 0 end) as tree,
	sum(case when role_type.role_type = 'student' then 1 else 0 end) as student,
	sum(case when role_type.role_type = 'pilot' then 1 else 0 end) as pilot,
	sum(case when role_type.role_type = 'king' then 1 else 0 end) as king,
	sum(case when role_type.role_type = 'bodyguard' then 1 else 0 end) as bodyguard,
	sum(case when role_type.role_type = 'butcher' then 1 else 0 end) as butcher
from feature_role feature_role
join role_type role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


-- q2

drop view if exists actor_type;

create view actor_type as 
select 
    feature_role.person as actor_name,
	sum(case when role_type.role_type = 'hero' then 1 else 0 end) as hero,
	sum(case when role_type.role_type = 'playboy' then 1 else 0 end) as playboy,
	sum(case when role_type.role_type = 'spy' then 1 else 0 end) as spy,
	sum(case when role_type.role_type = 'detective' then 1 else 0 end) as detective,
	sum(case when role_type.role_type = 'alien' then 1 else 0 end) as alien,
	sum(case when role_type.role_type = 'superhero' then 1 else 0 end) as superhero,
	sum(case when role_type.role_type = 'reporter' then 1 else 0 end) as reporter,
	sum(case when role_type.role_type = 'billionaire' then 1 else 0 end) as billionaire,
	sum(case when role_type.role_type = 'CEO' then 1 else 0 end) as CEO,
	sum(case when role_type.role_type = 'philanthropist' then 1 else 0 end) as philanthropist,
	sum(case when role_type.role_type = 'archer' then 1 else 0 end) as archer,
	sum(case when role_type.role_type = 'thief' then 1 else 0 end) as thief,
	sum(case when role_type.role_type = 'magician' then 1 else 0 end) as magician,
	sum(case when role_type.role_type = 'doctor' then 1 else 0 end) as doctor,
	sum(case when role_type.role_type = 'villain' then 1 else 0 end) as villain,
	sum(case when role_type.role_type = 'politician' then 1 else 0 end) as politician,
	sum(case when role_type.role_type = 'president' then 1 else 0 end) as president,
	sum(case when role_type.role_type = 'mathematician' then 1 else 0 end) as mathematician,
	sum(case when role_type.role_type = 'assassin' then 1 else 0 end) as assassin,
	sum(case when role_type.role_type = 'butler' then 1 else 0 end) as butler,
	sum(case when role_type.role_type = 'amnesiac' then 1 else 0 end) as amnesiac,
	sum(case when role_type.role_type = 'hacker' then 1 else 0 end) as hacker,
	sum(case when role_type.role_type = 'inventor' then 1 else 0 end) as inventor,
	sum(case when role_type.role_type = 'mutant' then 1 else 0 end) as mutant,
	sum(case when role_type.role_type = 'astronaut' then 1 else 0 end) as astronaut,
	sum(case when role_type.role_type = 'professor' then 1 else 0 end) as professor,
	sum(case when role_type.role_type = 'scientist' then 1 else 0 end) as scientist,
	sum(case when role_type.role_type = 'god' then 1 else 0 end) as god,
	sum(case when role_type.role_type = 'soldier' then 1 else 0 end) as soldier,
	sum(case when role_type.role_type = 'raccoon' then 1 else 0 end) as raccoon,
	sum(case when role_type.role_type = 'tree' then 1 else 0 end) as tree,
	sum(case when role_type.role_type = 'student' then 1 else 0 end) as student,
	sum(case when role_type.role_type = 'pilot' then 1 else 0 end) as pilot,
	sum(case when role_type.role_type = 'king' then 1 else 0 end) as king,
	sum(case when role_type.role_type = 'bodyguard' then 1 else 0 end) as bodyguard,
	sum(case when role_type.role_type = 'butcher' then 1 else 0 end) as butcher
from feature_role feature_role
join role_type role_type on feature_role.role_id = role_type.role_id
group by feature_role.person ;

-- q3
drop view if exists hero_count;
create view hero_count as 
select feature_role.role as hero, coalesce (count(case when role_type.role_type = 'hero' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists playboy_count;
create view playboy_count as 
select feature_role.role as playboy, coalesce (count(case when role_type.role_type = 'playboy' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists spy_count;
create view spy_count as 
select feature_role.role as spy, coalesce (count(case when role_type.role_type = 'spy' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists detective_count;
create view detective_count as 
select feature_role.role as detective, coalesce (count(case when role_type.role_type = 'detective' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists alien_count;
create view alien_count as 
select feature_role.role as alien, coalesce (count(case when role_type.role_type = 'alien' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists superhero_count;
create view superhero_count as 
select feature_role.role as superhero, coalesce (count(case when role_type.role_type = 'superhero' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists reporter_count;
create view reporter_count as 
select feature_role.role as reporter, coalesce (count(case when role_type.role_type = 'reporter' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists billionaire_count;
create view billionaire_count as 
select feature_role.role as billionaire, coalesce (count(case when role_type.role_type = 'billionaire' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists CEO_count;
create view CEO_count as 
select feature_role.role as CEO, coalesce (count(case when role_type.role_type = 'CEO' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists philanthropist_count;
create view philanthropist_count as 
select feature_role.role as philanthropist, coalesce (count(case when role_type.role_type = 'philanthropist' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists archer_count;
create view archer_count as 
select feature_role.role as archer, coalesce (count(case when role_type.role_type = 'archer' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists thief_count;
create view thief_count as 
select feature_role.role as thief, coalesce (count(case when role_type.role_type = 'thief' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists magician_count;
create view magician_count as 
select feature_role.role as magician, coalesce (count(case when role_type.role_type = 'magician' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists doctor_count;
create view doctor_count as 
select feature_role.role as doctor, coalesce (count(case when role_type.role_type = 'doctor' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists villain_count;
create view villain_count as 
select feature_role.role as villain, coalesce (count(case when role_type.role_type = 'villain' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists politician_count;
create view politician_count as 
select feature_role.role as politician, coalesce (count(case when role_type.role_type = 'politician' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists president_count;
create view president_count as 
select feature_role.role as president, coalesce (count(case when role_type.role_type = 'president' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists mathematician_count;
create view mathematician_count as 
select feature_role.role as mathematician, coalesce (count(case when role_type.role_type = 'mathematician' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists assassin_count;
create view assassin_count as 
select feature_role.role as assassin, coalesce (count(case when role_type.role_type = 'assassin' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists butler_count;
create view butler_count as 
select feature_role.role as butler, coalesce (count(case when role_type.role_type = 'butler' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists amnesiac_count;
create view amnesiac_count as 
select feature_role.role as amnesiac, coalesce (count(case when role_type.role_type = 'amnesiac' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists hacker_count;
create view hacker_count as 
select feature_role.role as hacker, coalesce (count(case when role_type.role_type = 'hacker' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists inventor_count;
create view inventor_count as 
select feature_role.role as inventor, coalesce (count(case when role_type.role_type = 'inventor' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists mutant_count;
create view mutant_count as 
select feature_role.role as mutant, coalesce (count(case when role_type.role_type = 'mutant' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists astronaut_count;
create view astronaut_count as 
select feature_role.role as astronaut, coalesce (count(case when role_type.role_type = 'astronaut' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists professor_count;
create view professor_count as 
select feature_role.role as professor, coalesce (count(case when role_type.role_type = 'professor' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists scientist_count;
create view scientist_count as 
select feature_role.role as scientist, coalesce (count(case when role_type.role_type = 'scientist' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists god_count;
create view god_count as 
select feature_role.role as god, coalesce (count(case when role_type.role_type = 'god' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists soldier_count;
create view soldier_count as 
select feature_role.role as soldier, coalesce (count(case when role_type.role_type = 'soldier' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists raccoon_count;
create view raccoon_count as 
select feature_role.role as raccoon, coalesce (count(case when role_type.role_type = 'raccoon' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists tree_count;
create view tree_count as 
select feature_role.role as tree, coalesce (count(case when role_type.role_type = 'tree' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists student_count;
create view student_count as 
select feature_role.role as student, coalesce (count(case when role_type.role_type = 'student' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists pilot_count;
create view pilot_count as 
select feature_role.role as pilot, coalesce (count(case when role_type.role_type = 'pilot' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists king_count;
create view king_count as 
select feature_role.role as king, coalesce (count(case when role_type.role_type = 'king' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists bodyguard_count;
create view bodyguard_count as 
select feature_role.role as bodyguard, coalesce (count(case when role_type.role_type = 'bodyguard' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


drop view if exists butcher_count;
create view butcher_count as 
select feature_role.role as butcher, coalesce (count(case when role_type.role_type = 'butcher' then 1 end),0) as times
from feature_role
left join role_type on feature_role.role_id = role_type.role_id
group by feature_role.role;


-- q4
