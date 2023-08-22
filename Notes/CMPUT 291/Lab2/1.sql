SELECT MemName, TransactionDate,TransactionType,BookTitle FROM Members , Books , Transactions WHERE Members.MemID=Transactions.MemID and Transactions.BookID=Books.BookID ORDER BY TransactionDate asc;
.print -----
SELECT distinct Members.MemID, MemName, BirthDate, Occupation 
FROM Members ,  Books , Transactions 
WHERE Members.MemID=Transactions.MemID and Transactions.BookID=Books.BookID and Transactions.TransactionType='borrow' and strftime('%Y',TransactionDate)='2020'and Books.BookID='4';