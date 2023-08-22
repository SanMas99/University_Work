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
