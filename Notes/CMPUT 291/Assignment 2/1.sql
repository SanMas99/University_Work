.print Question 1-Sanad

select distinct users.uid

FROM badges, ubadges, users, posts, questions

where badges.type='gold' and users.uid=ubadges.uid and posts.pid=questions.pid and poster=ubadges.uid;

.print ----------------- Given Solution

select distinct ub.uid
from ubadges ub, badges b, posts p, questions q
where ub.bname=b.bname and ub.uid = p.poster and p.pid=q.pid and
  b.type='gold';