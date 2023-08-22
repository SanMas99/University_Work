import sqlite3

conn=sqlite3.connect('./LabQuiz2_D04_tables.sql')
cur=conn.cursor()
booksID=input("Input the book ID you wish to look for ")
cur.execute("SELECT Members.MemID, MemName, BirthDate, Occupation FROM Members ,  Books , Transactions WHERE Members.MemID=Transactions.MemID and Transactions.BookID=Books.BookID and Transactions.TransactionType='borrow' and strftime('%Y',TransactionDate)='2020' and Books.BookID=?;",(booksID)).description
print(cur.fetchall())
conn.close()
