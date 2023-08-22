.print Question 3 - Sanad

select questions.pid, posts.title
from posts,
questions left join answers on questions.pid=answers.qid
where answers.pid IS NULL
and questions.pid=posts.pid
union
select m1.pid, m1.title
from (posts as p1 left join questions on questions.pid) as m1,(posts as p2 left join answers on answers.pid=p2.pid) as m2
where  (m2.qid=m1.pid  and julianday(m2.pdate) - julianday(m1.pdate)>3);
