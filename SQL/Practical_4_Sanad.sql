-- Name: Sanad Masannat
-- Student ID: 24217734
-- 1a
DROP view IF EXISTS feature_diversity;

create view feature_diversity as
select features.feature_id, features.title, features.year, count(*) as diversity
from feature_work join features on features.feature_id = feature_work.feature_id
where feature_work.ethnicity <> "Causasian" or feature_work.gender <> "male"
group by features.feature_id, features.title, features.year
order by diversity desc;

select *
from feature_diversity;

-- 1b
DROP view IF EXISTS franchise_diversity;

create view franchise_diversity as
select franchises.franchise_id, franchises.name, avg(diversity) as avg_diversity
from feature_diversity join franchise_features on feature_diversity.feature_id = franchise_features.feature_id
join franchises on franchises.franchise_id = franchise_features.franchise_id
group by franchises.franchise_id, franchises.name
order by avg_diversity desc;

select *
from franchise_diversity;


-- q2
DROP view IF EXISTS franchise_grosses ;

create view franchise_grosses  as
select t1.franchise_id, t1.name, t1.year, t1.title, t1.gross , avg(t1.gross) over (partition by t1.name) as average
from (
	select franchises.franchise_id, franchises.name, features.year, features.title, domestic_gross.amount + international_gross.amount as gross
	from franchises join franchise_features on franchises.franchise_id = franchise_features.franchise_id
	join features on features.feature_id = franchise_features.feature_id
	join domestic_gross on domestic_gross.feature_id = franchise_features.feature_id
	join international_gross on international_gross.feature_id = franchise_features.feature_id) as t1
group by t1.franchise_id, t1.name, t1.year, t1.title, t1.gross
order by average desc;


-- q3
DROP view IF EXISTS type_casting;

create view type_casting as
select  t1.person, t1.role_type, t1.affinity
from(
select feature_role.person, role_type.role_type, COUNT(*) as affinity,
           rank() over (partition by feature_role.person order by COUNT(*) desc) as rank_role
    from feature_role 
    join role_type on feature_role.role_id = role_type.role_id
    group by feature_role.person, role_type.role_type) as t1
 join (select feature_role.person, count(*) as total_movies
from feature_role
group by feature_role.person) as t2 on t1.person=t2.person
where t1.rank_role=1
and t1.affinity>1
and t1.affinity=t2.total_movies
order by t1.affinity desc;

-- q4
DROP view IF EXISTS replacements;

create view replacements as
select f1.role, f1.person as first, feat1.title,feat1.year,f2.person, feat2.title as replacement ,feat2.year
from feature_role as f1 
join feature_role as f2 on f1.role = f2.role
join features as feat1 on f1.feature_id=feat1.feature_id
join features as feat2 on f2.feature_id=feat2.feature_id
where f1.person <> f2.person
and ( f2.ethnicity <> "Caucasian" or f2.gender = "Female" );







