-- Name: Sanad Masannat
-- Student ID: 24217734
-- q1
select feature_role.person, feature_role.role, COUNT(*) as num_features
from feature_role
join features on feature_role.feature_id = features.feature_id
join budget on features.feature_id = budget.feature_id
join domestic_gross on features.feature_id = domestic_gross.feature_id
join international_gross on features.feature_id = international_gross.feature_id
where (domestic_gross.amount + international_gross.amount) > 2.5 * budget.amount
group by feature_role.person, feature_role.role
and COUNT(*) > 1;

-- q2
select table1.name, table1.average_amount 
from
(select franchises.name , avg(domestic_gross.amount + international_gross.amount) as average_amount
from franchises
join franchise_features on franchise_features.franchise_id = franchises.franchise_id
join features on features.feature_id = franchise_features.feature_id
join domestic_gross on features.feature_id = domestic_gross.feature_id
join international_gross on features.feature_id = international_gross.feature_id
where franchises.franchise_id not in
 (select distinct franchises.franchise_id
from features
join feature_role on features.feature_id = feature_role.feature_id
join franchise_features on franchise_features.feature_id = features.feature_id
join franchises on franchise_features.franchise_id = franchises.franchise_id
where feature_role.person = 'Robert Downey Jr.')
group by franchises.name 
) as table1
order by table1.average_amount desc
limit 1;

-- q3
select distinct features.title, features.year , domestic_gross.amount + international_gross.amount as gross
from features
join domestic_gross on features.feature_id = domestic_gross.feature_id
join international_gross on features.feature_id = international_gross.feature_id
join feature_role on features.feature_id = feature_role.feature_id
join role_type on role_type.role_id = feature_role.role_id
where role_type.role_type = 'superhero'
order by gross asc
limit 1;


-- q4
select feature_role.person, role_type.role_type, COUNT(*) AS affinity
from feature_role
join role_type on feature_role.role_id = role_type.role_id
group by feature_role.person, role_type.role_type
having COUNT(*) = (
select MAX(role_count) 
from (
select feature_role.person, role_type.role_type, COUNT(*) as role_count
from feature_role 
join role_type on feature_role.role_id = role_type.role_id
group by feature_role.person, role_type.role_type) as t1
where t1.person = feature_role.person)
order by affinity desc;








 