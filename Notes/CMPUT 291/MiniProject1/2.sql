
.print -----------------------
select posts.pid, pdate, title, body, poster,  ifNull(ansFreq,0), ifNull(voteCnt,0),t3.tag
from tags,posts left join (select questions.pid,count(answers.pid) as ansFreq
from questions, answers
where questions.pid=answers.qid
group by questions.pid) as t1 on posts.pid=t1.pid left join (select posts.pid, count(votes.pid) as voteCnt
from posts,votes
where posts.pid=votes.pid
group by posts.pid
order by posts.pid asc) as t2 on posts.pid=t2.pid left join (
select posts.pid, tags.tag
from posts left join tags on posts.pid=tags.pid
group by posts.pid, tags.tag) as t3 on posts.pid=t3.pid
where t3.tag like '%relational%'or title like '%relational%' or body like '%relational%'
group by posts.pid;
