.print Question 10-sanad


select city,count(users.uid),count(badges.type),voteCnt/count(users.uid)
from QuestionInfo,users,badges,ubadges,votes
where badges.type='gold' and badges.bname=ubadges.bname
group by city;