.print Question-5 Sanad
select users.uid
from votes,users,posts, questions left join answers on questions.pid=answers.qid
where answers.pid IS NOT NULL and questions.pid=posts.pid and users.uid=poster
intersect
select users.uid
from votes users,posts, questions left join answers on questions.pid=answers.qid
where answers.pid IS NOT NULL and answers.pid=posts.pid and users.uid=poster
group by poster
having count(vno)>4;