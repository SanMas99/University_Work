.print Question 2 - Sanad

select distinct posts.pid, posts.title 
from posts, questions, tags
where posts.pid=questions.pid and tags.pid=questions.pid and (lower(tags.tag)='relational' or lower(posts.title) like '%relational database%')
intersect 
select distinct posts.pid, posts.title 
from posts, questions, tags
where posts.pid=questions.pid and tags.pid=questions.pid and (lower(tags.tag)='database' or lower(posts.title) like '%relational database%');
