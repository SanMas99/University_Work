-- Let's drop the tables in case they exist
drop table if exists loans;
drop table if exists books;
drop table if exists users;

PRAGMA foreign_keys = ON;

create table users (
  uid 		char(4),
  name		text,
  city 		text,
  primary key (uid)
);
create table books (
  bid		char(4),
  title		text,
  author	text,
  primary key (bid)
);
create table loans (
  uid		char(4),
  bid		char(4),
  loanDate	date,
  retDate	date,
  primary key (uid,bid,loanDate),
  foreign key (uid) references users,
  foreign key (bid) references books
);

insert into users values ('u100','John','Edmonton');
insert into users values ('u200','Davood','Edmonton');
insert into users values ('u300','Mary','Calgary');
insert into users values ('u400','Joan','Edmonton');

insert into books values ('b1','Animal Farm','George Orwell');
insert into books values ('b2','1984','George Orwell');
insert into books values ('b3','To Kill a Mokingbird','Harper Lee');
insert into books values ('b4','Moby Dick','Herman Melville');
insert into books values ('b5','Les Miserables','Victor Hugo');

insert into loans values ('u100','b5','2020-09-08',null);
insert into loans values ('u200','b2','2020-10-01','2020-10-13');
insert into loans values ('u300','b4','2020-08-10','2020-08-21');
insert into loans values ('u400','b5','2020-04-12','2020-04-22');
insert into loans values ('u100','b5','2019-01-04','2019-01-12');
insert into loans values ('u200','b5','2019-04-14','2019-04-21');
