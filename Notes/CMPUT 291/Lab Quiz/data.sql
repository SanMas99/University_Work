.mode column
.headers on

DROP TABLE IF EXISTS Members ;
DROP TABLE IF EXISTS Books ;
DROP TABLE IF EXISTS Transactions ;


create table Members (MemID int PRIMARY KEY NOT NULL, MemName text, BirthDate date, occupation text);
create table Books (BookID int PRIMARY KEY NOT NULL, BookTitle text, Author text);
create table Transactions (MemID int NOT NULL, BookID int NOT NULL,TransactionType text, TransactionDate date);

insert into Books values (1, "The C Programming Language", "Brian W. Kernighan");
insert into Books values (2, "Pro Git", "Scott Chacon");
insert into Books values (3, "Planning Extreme Programming", " Kent Beck");
insert into Books values (4, "The Past Present and Future of JavaScript", "Axel Rauschmayer ");
insert into Books values (5, "Scratch 2.0 Programming", "Denis Golikov");


insert into Members values (1, "Matt Smith",'2000-02-20' , "scientist");
insert into Members values (2, "James Bruce", '1992-10-17', "scientist");
insert into Members values (3, " Roger Peng", '1991-09-04', "scientist");
insert into Members values (4, "Angela Randall", '2000-02-20', "scientist");
insert into Members values (5, "Shai Almog", '1970-05-07' , "artist");
insert into Members values (6, "Jamil Soucar", '1999-06-10', "artist");
insert into Members values (7, "Drew Neil", '1991-02-17', "artist");

insert into Transactions values ( 2, 1 , "borrow" , '2019-08-08' );
insert into Transactions values ( 2, 1 , "return" , '2019-09-09' );
insert into Transactions values ( 2, 1 , "borrow" , '2019-10-10' );
insert into Transactions values ( 2, 1 , "return" , '2019-11-11' );
insert into Transactions values ( 2, 3 , "return" , '2019-02-02' );
insert into Transactions values ( 2, 4 , "borrow" , '2019-12-12' );
insert into Transactions values ( 5, 6 , "return" , '2017-01-01' );
insert into Transactions values ( 5, 2, "return" , '2015-05-06');
insert into Transactions values ( 4, 5, "borrow" , '2016-01-01' );
insert into Transactions values ( 4, 3, "borrow" , '2016-01-01' );
insert into Transactions values ( 4, 3, "borrow" , '2016-01-01' );
insert into Transactions values ( 5, 3, "borrow" , '2017-01-01' );
insert into Transactions values ( 5, 6, "borrow" , '2017-01-01' );
insert into Transactions values ( 5, 6, "return" , '2017-01-01' );
insert into Transactions values ( 5, 5, "return" , '2019-01-01' );
insert into Transactions values ( 5, 3, "return" , '2020-01-01' );
