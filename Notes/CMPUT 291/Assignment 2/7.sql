.print Question 7 - sanad

select posts.pdate,tags.tag, count(posts.pid)
from posts, tags
where posts.pid=tags.pid
group by pdate,tag
order by posts.pdate desc,count(posts.pid) desc;