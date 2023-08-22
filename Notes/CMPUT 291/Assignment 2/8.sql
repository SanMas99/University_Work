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