import sqlite3
conn = sqlite3.connect("LabQuiz2_D04_tables.db")
cur=conn.cursor()
memberID=input("Input the member ID you wish to look for ")
cur.execute("SELECT MemName, TransactionDate,TransactionType, BookTitle FROM Members ,  Books , Transactions WHERE Members.MemID=Transactions.MemID and Transactions.BookID=Books.BookID and Members.MemID=? ORDER BY TransactionDate asc;",(memberID))
print(cur.fetchall())
conn.close()
