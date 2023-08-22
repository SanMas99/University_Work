select MemName
from Members
where Occupation='artist' and julianday('now')-julianday(BirthDate)>9125;

.print --------------------------

select MemID,count(BookID)
from Transactions
where TransactionType='return'
group by MemID
having count(BookID)>2
order by count(BookID) desc;

.print --------------------------

select BookTitle, strftime('%Y',TransactionDate), count(TransactionDate)
from Books, Transactions
where Books.BookID=Transactions.BookID and TransactionType='return'
group by Books.BookID,strftime('%Y',TransactionDate)
order by strftime('%Y',TransactionDate) asc;