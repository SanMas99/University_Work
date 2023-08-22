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

select * 
from QuestionInfo;