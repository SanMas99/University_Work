
select posts.pid, ifNull(count(votes.pid),0)
from posts,votes
where posts.pid=votes.pid
group by posts.pid
order by posts.pid asc;
.print ---------------

select questions.pid, ifNull(count(answers.pid),0) as ansFreq
from questions, answers
where questions.pid=answers.qid
group by questions.pid;
.print ---------------

select posts.pid, tags.tag
from posts left join tags on posts.pid=tags.pid
group by posts.pid, tags.tag

