.print Question-4 sanad
select users.uid
from users, questions, answers,posts
where questions.pid= answers.qid and poster=users.uid and posts.pid=answers.pid
intersect
select users.uid
from users, questions, posts
where questions.pid= posts.pid and poster=users.uid
group by users.uid,questions.pid;