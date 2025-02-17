-- Name: Sanad Masannat
-- Student ID: 24217734



-- Q1
select distinct features.title , features.year,franchises.name
From franchises join franchise_features
on franchises.franchise_id = franchise_features.franchise_id
join features
on features.feature_id=franchise_features.feature_id
join feature_role
on feature_role.feature_id=features.feature_id
where  feature_role.person="Robert Downey Jr."; 

-- Q2
select distinct features.title , features.year,franchises.name, budget.amount, domestic_gross.amount, international_gross.amount
From franchises join franchise_features
on franchises.franchise_id = franchise_features.franchise_id
join features
on features.feature_id=franchise_features.feature_id
join feature_role
on feature_role.feature_id=features.feature_id
join budget
on budget.feature_id=features.feature_id
join domestic_gross
on domestic_gross.feature_id=features.feature_id
join international_gross
on international_gross.feature_id=features.feature_id
where budget.amount<domestic_gross.amount
and budget.amount*3<international_gross.amount;

-- Q3
select distinct features.title , features.year,franchises.name
From franchises join franchise_features
on franchises.franchise_id = franchise_features.franchise_id
join features
on features.feature_id=franchise_features.feature_id
join feature_role
on feature_role.feature_id=features.feature_id
where  feature_role.person="Robert Downey Jr."
and franchises.name!="Marvel Cinematic Universe"; 

-- Q4
select distinct features.title , features.year,franchises.name, budget.amount, domestic_gross.amount, international_gross.amount
From franchises join franchise_features
on franchises.franchise_id = franchise_features.franchise_id
join features
on features.feature_id=franchise_features.feature_id
join feature_role
on feature_role.feature_id=features.feature_id
join budget
on budget.feature_id=features.feature_id
join domestic_gross
on domestic_gross.feature_id=features.feature_id
join international_gross
on international_gross.feature_id=features.feature_id
where budget.amount*2.5>domestic_gross.amount + international_gross.amount
and franchises.name="Marvel Cinematic Universe";

-- Q5
select features.title, features.year
From features 
join feature_role 
on feature_role.feature_id=features.feature_id
left join franchise_features
on franchise_features.feature_id =features.feature_id
left join franchises 
on franchises.franchise_id = franchise_features.franchise_id
where  feature_role.person="Benedict Cumberbatch"
and  (franchises.name!="Marvel Cinematic Universe"
or franchises.name is null);

;


 