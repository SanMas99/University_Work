.print Sanad Masannat 1626221

--Q1
select u.uid, u.name
from loans l, users u
where l.uid=u.uid and retDate is null;

--Q2
select city, count(*)
from users u, loans l
where u.uid=l.uid
group by city;

--Q3
select title, author
from books b, loans l
where b.bid=l.bid
group by b.bid, title, author
having count(*) > 3;

--Q4
select distinct author
from books b1
where not exists
   (select bid
    from books b2
    where b2.author=b1.author
      except
    select bid
    from loans
   );