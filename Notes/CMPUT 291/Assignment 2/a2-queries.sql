.echo on

.print Question 1-sanad

select distinct users.uid
FROM badges, ubadges, users, posts, questions
where badges.type='gold' and users.uid=ubadges.uid and posts.pid=questions.pid and poster=ubadges.uid;

.print Question 2 - sanad

select distinct posts.pid, posts.title 
from posts, questions, tags
where posts.pid=questions.pid and tags.pid=questions.pid and (lower(tags.tag)='relational' or lower(posts.title) like '%relational database%')
intersect 
select distinct posts.pid, posts.title 
from posts, questions, tags
where posts.pid=questions.pid and tags.pid=questions.pid and (lower(tags.tag)='database' or lower(posts.title) like '%relational database%');

.print Question 3 - sanad

select questions.pid, posts.title
from posts,
questions left join answers on questions.pid=answers.qid
where answers.pid IS NULL
and questions.pid=posts.pid
union
select m1.pid, m1.title
from (posts as p1 left join questions on questions.pid) as m1,(posts as p2 left join answers on answers.pid=p2.pid) as m2
where  (m2.qid=m1.pid  and julianday(m2.pdate) - julianday(m1.pdate)>3);

.print Question-4 sanad
select users.uid
from users, questions, answers,posts
where questions.pid= answers.qid and poster=users.uid and posts.pid=answers.pid
intersect
select users.uid
from users, questions, posts
where questions.pid= posts.pid and poster=users.uid
group by users.uid,questions.pid;

.print Question-5 sanad
select users.uid
from votes,users,posts, questions left join answers on questions.pid=answers.qid
where answers.pid IS NOT NULL and questions.pid=posts.pid and users.uid=poster
intersect
select users.uid
from votes users,posts, questions left join answers on questions.pid=answers.qid
where answers.pid IS NOT NULL and answers.pid=posts.pid and users.uid=poster
group by poster
having count(vno)>4;

.print Question-6 sanad

select tags.tag,count(vno),freq
from votes, tags join (select tags.tag, count(tags.pid) as freq
from posts, tags
where tags.pid=posts.pid
group by tags.tag
order by count(tags.pid) desc) as t1 on tags.tag=t1.tag
where tags.pid=votes.pid and votes.pid=tags.pid
group by tags.tag
order by count(vno) desc
limit 3
;

.print Question 7 - sanad

select posts.pdate,tags.tag, count(posts.pid)
from posts, tags
where posts.pid=tags.pid
group by pdate,tag
order by posts.pdate desc,count(posts.pid) desc;

.print Question 8-sanad

select users.uid,questionnum,answernum, count(votes.uid),votesreceived
from votes,posts,users left join (select users.uid, count(posts.pid) as votesreceived
from votes,posts,users
where votes.pid=posts.pid and poster=users.uid
group by users.uid)as t1 on users.uid=t1.uid left join (select users.uid, count(posts.pid) as answernum
from answers,posts,users
where answers.pid=posts.pid and users.uid=posts.poster
group by users.uid ) as t2 on users.uid=t2.uid left join (select users.uid, count(posts.pid) as questionnum
from questions, posts,users
where questions.pid=posts.pid and users.uid=posts.poster
group by users.uid ) as t3 on users.uid=t3.uid
where votes.pid=posts.pid and votes.uid=users.uid 
group by users.uid ;


.print Question-9 sanad

create view QuestionInfo as
select  posts.pid, posts.poster, questions.theaid,votecnt, anscnt
from posts as p, questions,answers, 
posts left join (select posts.pid, count(vno) as voteCnt
from votes,users,posts
where posts.pid=votes.pid and poster=users.uid
group by posts.pid) 
as t1 on posts.pid=t1.pid left join (select posts.pid, count(answers.pid) as ansCnt
from posts,questions,answers
where posts.pid=questions.pid and answers.qid=questions.pid
group by posts.pid) as t2 on posts.pid=t2.pid
where  posts.pid=questions.pid  and (answers.pid=questions.theaid or theaid is null) and julianday('now')-julianday(posts.pdate)<=30 
group by posts.pid;

.print Question 10-sanad


select city,count(users.uid),count(badges.type),voteCnt/count(users.uid),voteCnt
from QuestionInfo,users,badges,ubadges,votes
where badges.type='gold' and badges.bname=ubadges.bname
group by city;



