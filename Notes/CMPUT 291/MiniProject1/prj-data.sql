-- Data prepapred by Davood Rafiei, drafiei@ualberta.ca
---Vincent Wainman
---Abeer Waheed
---Giancarlo Pernudi Segura
---HongZu Li

-- Data Edited by Tyler Bach, tpbach@ualberta.ca

PRAGMA foreign_keys = ON;

-- TEST USE OF NUMBERS
insert into users values ('u100','Davood Rafiei','Edmonton',        'cmput291', '2020-01-10');

--TEST CASE SENSITIVITY
insert into users values ('u200','Joe Smith','Vancouver',           'Apple', '2020-08-15');

--TEST USE OF SYMBOLS
insert into users values ('u300','Mary Brown','Edmonton',           '6q=sx[](),".\--', '2020-06-04');

-- TEST USE OF SPACE
insert into users values ('u001','Aled Hastings','Edmonton',        'spa ce', '2020-01-10');

-- TEST NULL
insert into users values ('u002','Joe Smith','Vancouver',           'IS NULL', '2020-08-15');

-- RANDOM PWDS
insert into users values ('u003','Mary Brown','Ottawa',             'NULL', '2020-06-04');
insert into users values ('u004','Precious Friedman','Halifax',     'zoom123', '2019-01-10');
insert into users values ('u005','Edie Barlow','Quebec City',       'spa ce', '2019-08-15');
insert into users values ('u006','Kristy Simpson','Edmonton',       'IS NULL', '2019-06-04');
insert into users values ('u007','Lilli Kane','Ottawa',             'edmonton2020', '2018-01-10');
insert into users values ('u008','Kody Hill','Halifax',             'edmonton2020', '2018-08-15');
insert into users values ('u009','Zavier Gilmore','Winnipeg',       'canada', '2018-06-04');
insert into users values ('u010','Diana Pratt','Calgary',           'math', '2020-04-10');
insert into users values ('u011','Ace Harper','Whitehouse',         'qwerty', '2020-07-10');
insert into users values ('u012','Tymon Valazquez','Regina',        '12345', '2020-08-14');
insert into users values ('u013','Casper Grant','Edmonton',         'akm2-1', '2017-01-04');
insert into users values ('u014','Laurence Sutton','Ottawa',        'mango', '2020-06-10');
insert into users values ('u015','Clarke Chan','Vancouver',         'holiday', '2020-09-15');
insert into users values ('u016','Nancy King','Quebec City',        'poodle', '2020-06-05');
insert into users values ('u017','Rocco Benton','Halifax',          'milkshake2', '2020-01-14');
insert into users values ('u018','Colby Hartman','Winnipeg',        'tabletop', '2020-08-01');
insert into users values ('u019','Finnlay Regan','Calgary',         'cornamze2020', '2020-05-04');
insert into users values ('u020','Bob Mcintyre','Victoria',         'winter\20', '2020-01-10');
insert into users values ('u021','Nieve Richard','Toronto',         'pwd', '2020-12-20');
insert into users values ('u022','Mischa Yates','Vancouver',        'x86_64', '2020-08-24');
insert into users values ('u023','Gwion Goulding','Edmonton',       '01p12', '2020-06-25');
insert into users values ('u024','Kean Barclay','Toronto',          'nanorobotics', '2020-06-21');
insert into users values ('u025','Evernett Rodrique','Toronto',	    'ability', '2020-08-25');
insert into users values ('u026','Nicolas Akhtar','Halifax',        'calendar', '2016-03-24');
insert into users values ('u027','Wilson Greer','Winnipeg',         'knowledge10', '2016-06-10');
insert into users values ('u028','Jace Whyte','Regina',             'boiled', '2016-08-30');
insert into users values ('u029','Giuseppe David','Victoria',       'machine', '2016-06-30');
insert into users values ('u030','Samera Ahmad','Quebec City',      'popular', '2020-12-30');
insert into users values ('u031','Vihaan Meza','Toronto',           'just-in-time', '2020-12-20');
insert into users values ('u032','Finnian Dillon','Vancouver',      'vim', '2020-08-24');
insert into users values ('u033','Kerion Sawyer','Edmonton',        'minimal', '2020-06-25');
insert into users values ('u034','Layla-Mee Howells','Toronto',     'helloworld', '2020-06-21');
insert into users values ('u035','Taybah Penn','Toronto',           'hidden', '2020-08-25');
insert into users values ('u036','Jimmie Colley','Halifax',         'oilers', '2016-03-24');
insert into users values ('u037','Kanye Kendall','Winnipeg',        'queries', '2016-06-10');
insert into users values ('u038','Huma Denton','Regina',            'breakdown', '2016-08-30');
insert into users values ('u039','Kierran Blankenship','Victoria',  'technology', '2016-06-30');
insert into users values ('u040','Ruari Wagstaff','Quebec City',    'incredible', '2020-12-30');
insert into users values ('u041','Dillon Galindo','Toronto',        '/badges', '2020-12-20');
insert into users values ('u042','Lillian Donovan','Vancouver',     'york', '2020-08-24');
insert into users values ('u043','Luella Huffman','Edmonton',       'zer0', '2020-06-25');
insert into users values ('u044','Tymon Fritz','Toronto',           'sandbox', '2020-06-21');
insert into users values ('u045','Yazmin Wolfe','Toronto',          'files', '2020-08-25');
insert into users values ('u046','Cherie Marquez','Halifax',        'unknown', '2016-03-24');
insert into users values ('u047','Nabilah Butler','Winnipeg',       'november', '2016-06-10');
insert into users values ('u048','Moshe Metcalfe','Regina',         'language', '2016-08-30');
insert into users values ('u049','Terrence Henderson','Victoria',   'banana', '2016-06-30');
insert into users values ('u050','Samera Ahmad','Halifax',          'party', '2019-12-30');

-- PRIVALEGED USERS
insert into privileged values ('u001');
insert into privileged values ('u005');
insert into privileged values ('u006');
insert into privileged values ('u011');
insert into privileged values ('u014');
insert into privileged values ('u015');
insert into privileged values ('u018');
insert into privileged values ('u035');
insert into privileged values ('u042');
insert into privileged values ('u049');

insert into badges values ('socratic question','gold');
insert into badges values ('stellar question', 'gold');
insert into badges values ('great answer','gold');
insert into badges values ('popular answer','gold');
insert into badges values ('fanatic user','gold');
insert into badges values ('legendary user','gold');
insert into badges values ('good question','silver');
insert into badges values ('good answer','silver');
insert into badges values ('enthusiast user','silver');
insert into badges values ('nice question','bronze');
insert into badges values ('nice answer','bronze');
insert into badges values ('commentator user','bronze');


insert into ubadges values ('u200','2020-09-06','stellar question');
insert into ubadges values ('u002','2020-09-06','stellar question');
insert into ubadges values ('u005','2020-04-12','socratic question');
insert into ubadges values ('u012','2019-03-30','nice answer');
insert into ubadges values ('u012','2019-05-23','good answer');
insert into ubadges values ('u043','2020-03-04','legendary user');
insert into ubadges values ('u043','2020-02-28','socratic question');
insert into ubadges values ('u043','2020-01-05','stellar question');
insert into ubadges values ('u028','2019-08-27','good question');
insert into ubadges values ('u028','2019-08-15','nice question');
insert into ubadges values ('u028','2020-01-11','legendary user');
insert into ubadges values ('u028','2020-03-12','great answer');
insert into ubadges values ('u030','2020-09-08','enthusiast user');
insert into ubadges values ('u030','2020-06-21','nice question');
insert into ubadges values ('u014','2019-12-14','popular answer');


insert into posts values ('p100',date('now','-30 days'),'What is a relational database?','What is the term referred to and what are the benefits?','u200');
insert into posts values ('p200',date('now','-29 days'),'introduction to relational databases','This is a post that introduce the relational databases including SQL','u100');
insert into posts values ('p300',date('now','-25 days'),'test answer tp p100','this is an answer to p100','u300');
insert into posts values ('p400',date('now','-10 days'),'test question 1','this is a test question 1','u100');
insert into posts values ('p500',date('now','-15 days'),'test question 2','this is a test question 2','u100');
insert into posts values ('p600',date('now','-10 days'),'test answer tp p500','this is a answer to p500','u100');
insert into posts values ('p700',date('now','-25 days'),'test answer tp p100','this is relational database test','u100');

insert into tags values ('p100','relational');
insert into tags values ('p100','database');
insert into tags values ('p200','relational');
insert into tags values ('p200','sql');
insert into tags values ('p300','test');
insert into tags values ('p400','question');
insert into tags values ('p500','answer');
insert into tags values ('p600','answer');
insert into tags values ('p400','test');
insert into tags values ('p500','test');
insert into tags values ('p600','test');
insert into tags values ('p700','relational');
insert into tags values ('p700','database');
insert into tags values ('p700','test');

insert into votes values ('p200',1,date('now','-20 days'),'u200');
insert into votes values ('p100',2,date('now','-19 days'),'u100');
insert into votes values ('p200',3,date('now','-18 days'),'u300');
insert into votes values ('p300',4,date('now','-17 days'),NULL);
insert into votes values ('p400',5,date('now','-16 days'),NULL);
insert into votes values ('p500',6,date('now','-15 days'),'u300');

insert into questions values ('p100',null);
insert into questions values ('p400',null);
insert into questions values ('p500',null);
insert into answers values ('p200','p100');
insert into answers values ('p300','p100');
insert into answers values ('p600','p500');


insert into posts values ('p001',date('now','-30 days'),'What is a relational database?','What is the term referred to and what are the benefits?','u002');
insert into questions values ('p001',null);
insert into votes values ('p001',1,date('now','-5 days'),'u012');
insert into votes values ('p001',2,date('now','-7 days'),'u034');
insert into votes values ('p001',3,date('now','-2 days'),'u021');
insert into votes values ('p001',4,date('now','-8 days'),'u043');
insert into votes values ('p001',5,date('now','-3 days'),'u007');
insert into tags values ('p001','relational');
insert into tags values ('p001','database');
insert into tags values ('p001','frequentTag1');
insert into posts values ('p002',date('now','-29 days'),'Introduction to relational database','This is a post that introduce the relational databases including SQL','u012');
insert into answers values ('p002','p001');
insert into votes values ('p002',1,date('now','-16 days'),'u012');
insert into tags values ('p002','relational');
insert into tags values ('p002','Database');
insert into tags values ('p002','sql');
insert into tags values ('p002','data');

insert into posts values ('p003',date('now','-30 days'),'Why use SQL?','what are the different uses for it', 'u050');
insert into questions values ('p003',null);
insert into votes values ('p003',1,date('now','-3 days'),'u050');
insert into tags values ('p003','sql');
insert into tags values ('p003','CMPUT291');
insert into tags values ('p003','relational');
insert into tags values ('p003','frequentTag1');
insert into posts values ('p004',date('now','-23 days'),'Answer to what is SQL','it is a structured query language', 'u050');
insert into answers values ('p004','p003');
insert into votes values ('p004',1,date('now','-6 days'),'u050');
insert into posts values ('p005',date('now','-24 days'),'second answer to what is SQL', 'it has lots of uses', 'u028');
insert into answers values ('p005','p003');
insert into votes values ('p005',1,date('now','-5 days'),'u028');
insert into votes values ('p005',2,date('now','-8 days'),'u028');

insert into posts values ('p006',date('now','-30 days'),'Databases question?','This is a question regarding databases','u050');
insert into questions values ('p006',null);
insert into tags values ('p006','database');
insert into tags values ('p006','computing');
insert into tags values ('p006','frequentTag2');
insert into posts values ('p007',date('now','-23 days'),'answer to databases question','test case for query two', 'u050');
insert into answers values ('p007','p006');
insert into votes values ('p007',1,date('now','-2 days'),'u050');
insert into tags values ('p007','Database');
insert into tags values ('p007','frequentTag2');
insert into posts values ('p008',date('now','-27 days'),'second answer to database question', 'just another answer', 'u028');
insert into answers values ('p008','p006');
insert into votes values ('p008',1,date('now','-6 days'),'u028');
insert into votes values ('p008',2,date('now','-9 days'),'u028');
insert into tags values ('p008','Database');
insert into tags values ('p008','access');

insert into posts values ('p009',date('now','-27 days'),'what is relational query language?', 'just another question','u050');
insert into questions values ('p009',null);
insert into tags values ('p009','relational');
insert into tags values ('p009','query');
insert into tags values ('p009','frequentTag3');
insert into posts values ('p010',date('now','-27 days'),'answer to relational query question', 'just another answer','u050');
insert into answers values ('p010','p009');
insert into votes values ('p010',1,date('now','-7 days'),'u050');
insert into tags values ('p010','relational');
insert into tags values ('p010','query');
insert into tags values ('p010','frequentTag3');
insert into posts values ('p011',date('now','-27 days'),'second answer to relational query question', 'just another answer','u023');
insert into answers values ('p011','p009');
insert into tags values ('p011','relational');
insert into tags values ('p011','Sql language');

insert into posts values ('p012',date('now','-27 days'),'what is a good Relational Database Software?', 'just another question','u030');
insert into questions values ('p012',null);
insert into tags values ('p012','sql');
insert into tags values ('p012','query');
insert into posts values ('p013',date('now','-23 days'),'answer to database question question', 'just another answer','u030');
insert into answers values ('p013','p012');
insert into tags values ('p013','sql');
insert into tags values ('p013','query');

insert into posts values ('p014',date('now','-23 days'),'How do we model ER diagrams?','What are the shapes assigned for entities and relationships in an ER diagram?','u030');
insert into questions values ('p014',null);
insert into tags values ('p014','sql language');
insert into tags values ('p014', 'relational');
insert into posts values ('p028',date('now','-15 days'),'ER diagrams','The shape for entities is a rectangle while it is a rhombus for relationships','u030');
insert into answers values ('p028','p014');
insert into tags values ('p028', 'database');

insert into posts values ('p015',date('now','-20 days'),'what do we learn in cmput291?', 'just another question','u023');
insert into questions values ('p015',null);
insert into tags values ('p015','RELATIONAL');
insert into tags values ('p015','database');
insert into posts values ('p030',date('now','-5 days'),'Answer for post 15','Nothing to see here','u023');
insert into answers values ('p030','p015');
insert into posts values ('p016',date('now','-15 days'),'relational database', 'just another answer','u023');
insert into answers values ('p016','p015');
insert into tags values ('p016','sql language');
insert into posts values ('p017',date('now','-20 days'),'we learn sql', 'just another answer', 'u023');
insert into answers values ('p017','p015');
insert into tags values ('p017','query');
insert into tags values ('p017','sql language');

insert into posts values ('p018',date('now','-23 days'),'why do we learn sqlite3?', 'is it to access a relational database?', 'u028');
insert into questions values ('p018',null);
insert into votes values ('p018',1,date('now','-7 days'),'u028');
insert into votes values ('p018',2,date('now','-2 days'),'u028');

insert into posts values ('p019',date('now','-27 days'),'what is relational arithmetic?','I am an answerless question','u030');
insert into questions values ('p019',null);

insert into posts values ('p020',date('now','-30 days'),'What is the goal of this assignment?', 'I am an answerless question','u043');
insert into questions values ('p020',null);

insert into posts values ('p021',date('now','-30 days'),'how do we get better at writing queries?','just another question','u040');
insert into questions values ('p021',null);
insert into posts values ('p022',date('now','-23 days'),'just practice', 'just another answer','u040');
insert into answers values ('p022','p021');
insert into posts values ('p023',date('now','-27 days'),'more practice', 'just another answer','u013');
insert into answers values ('p023','p021');
insert into votes values ('p023',1,date('now','-17 days'),'u013');

insert into posts values ('p024',date('now','-20 days'),'how do we do well in cmput291?', 'just another question','u040');
insert into questions values ('p024',null);
insert into posts values ('p025',date('now','-15 days'),'study', 'just another answer','u040');
insert into answers values ('p025','p024');
insert into posts values ('p026',date('now','-13 days'),'more studying', 'just another answer', 'u023');
insert into answers values ('p026','p024');
insert into votes values ('p026',1,date('now','-10 days'),'u023');

insert into posts values ('p027',date('now','-60 days'),'is cmput291 difficult?', 'just another question','u040');
insert into questions values ('p027',null);
insert into votes values ('p027',1,date('now','-14 days'),'u040');
insert into posts values ('p029',date('now','-27 days'),'not really!','just another answer', 'u040');
insert into answers values ('p029','p027');
insert into votes values ('p029',1,date('now','-4 days'),'u040');

insert into posts values ('p031',date('now','-10 days'), 'Am I the post with famous tags? ', 'my famous tags are fun sleep and boring','u035');
insert into questions values ('p031',null);
insert into votes values ('p031',1,date('now','-5 days'),'u002');
insert into votes values ('p031',2,date('now','-6 days'),'u005');
insert into votes values ('p031',3,date('now','-7 days'),'u032');
insert into votes values ('p031',4,date('now','-8 days'),'u024');
insert into votes values ('p031',5,date('now','-9 days'),'u015');
insert into votes values ('p031',6,date('now','-2 days'),'u017');
insert into votes values ('p031',7,date('now','-5 days'),'u002');
insert into votes values ('p031',8,date('now','-6 days'),'u005');
insert into votes values ('p031',9,date('now','-7 days'),'u032');
insert into votes values ('p031',10,date('now','-8 days'),'u024');
insert into votes values ('p031',11,date('now','-9 days'),'u015');
insert into votes values ('p031',12,date('now','-2 days'),'u017');
insert into votes values ('p031',13,date('now','-5 days'),'u004');
insert into votes values ('p031',14,date('now','-6 days'),'u003');
insert into votes values ('p031',15,date('now','-7 days'),'u006');
insert into votes values ('p031',16,date('now','-8 days'),'u007');
insert into votes values ('p031',17,date('now','-9 days'),'u008');
insert into votes values ('p031',18,date('now','-2 days'),'u009');
insert into votes values ('p031',19,date('now','-5 days'),'u010');
insert into votes values ('p031',20,date('now','-6 days'),'u011');
insert into votes values ('p031',21,date('now','-7 days'),'u012');
insert into votes values ('p031',22,date('now','-8 days'),'u013');
insert into votes values ('p031',23,date('now','-9 days'),'u014');
insert into votes values ('p031',24,date('now','-2 days'),'u016');
insert into tags values ('p031','fun');
insert into tags values ('p031','sleep');
insert into tags values ('p031','boring');
insert into tags values ('p031','extra tag');
insert into tags values ('p031','just here');


insert into posts values ('p032',date('now','-10 days'), 'yes I the post with famous tags? ', 'my famous tags are fun sleep and boring','u035');
insert into answers values ('p032','p031');
insert into votes values ('p032',1,date('now','-5 days'),'u002');
insert into votes values ('p032',2,date('now','-6 days'),'u005');
insert into votes values ('p032',3,date('now','-7 days'),'u032');
insert into votes values ('p032',4,date('now','-8 days'),'u024');
insert into votes values ('p032',5,date('now','-9 days'),'u015');
insert into votes values ('p032',6,date('now','-2 days'),'u017');
insert into votes values ('p032',7,date('now','-5 days'),'u002');
insert into votes values ('p032',8,date('now','-6 days'),'u005');
insert into votes values ('p032',9,date('now','-7 days'),'u032');
insert into votes values ('p032',10,date('now','-8 days'),'u024');
insert into votes values ('p032',11,date('now','-9 days'),'u015');
insert into votes values ('p032',12,date('now','-2 days'),'u017');
insert into votes values ('p032',13,date('now','-5 days'),'u004');
insert into votes values ('p032',14,date('now','-6 days'),'u003');
insert into votes values ('p032',15,date('now','-7 days'),'u006');
insert into votes values ('p032',16,date('now','-8 days'),'u007');
insert into votes values ('p032',17,date('now','-9 days'),'u008');
insert into votes values ('p032',18,date('now','-2 days'),'u009');
insert into votes values ('p032',19,date('now','-5 days'),'u010');
insert into votes values ('p032',20,date('now','-6 days'),'u011');
insert into votes values ('p032',21,date('now','-7 days'),'u012');
insert into votes values ('p032',22,date('now','-8 days'),'u013');
insert into votes values ('p032',23,date('now','-9 days'),'u014');
insert into votes values ('p032',24,date('now','-2 days'),'u016');
insert into tags values ('p032','fun');
insert into tags values ('p032','sleep');

insert into posts values ('p033',date('now','-10 days'), 'Am I the SECOND post with famous tags? ', 'my famous tags are fun','u049');
insert into questions values ('p033',null);
insert into votes values ('p033',1,date('now','-5 days'),'u002');
insert into votes values ('p033',2,date('now','-6 days'),'u005');
insert into votes values ('p033',3,date('now','-7 days'),'u032');
insert into votes values ('p033',4,date('now','-8 days'),'u024');
insert into votes values ('p033',5,date('now','-9 days'),'u015');
insert into votes values ('p033',6,date('now','-2 days'),'u017');
insert into votes values ('p033',7,date('now','-5 days'),'u002');
insert into votes values ('p033',8,date('now','-6 days'),'u005');
insert into votes values ('p033',9,date('now','-7 days'),'u032');
insert into votes values ('p033',10,date('now','-8 days'),'u024');
insert into votes values ('p033',11,date('now','-9 days'),'u015');
insert into votes values ('p033',12,date('now','-2 days'),'u017');
insert into votes values ('p033',13,date('now','-5 days'),'u004');
insert into votes values ('p033',14,date('now','-6 days'),'u003');
insert into votes values ('p033',15,date('now','-7 days'),'u006');
insert into votes values ('p033',16,date('now','-8 days'),'u007');
insert into votes values ('p033',17,date('now','-9 days'),'u008');
insert into votes values ('p033',18,date('now','-2 days'),'u009');
insert into votes values ('p033',19,date('now','-5 days'),'u010');
insert into votes values ('p033',20,date('now','-6 days'),'u011');
insert into votes values ('p033',21,date('now','-7 days'),'u012');
insert into votes values ('p033',22,date('now','-8 days'),'u013');
insert into tags values ('p033','fun');
insert into tags values ('p033','tag tag');
insert into tags values ('p033','more tag');

insert into posts values ('p034',date('now','-10 days'), 'yes I the SECOND post with famous tags? ', 'my famous tags are sleep and boring','u007');
insert into answers values ('p034','p031');
insert into votes values ('p034',1,date('now','-5 days'),'u002');
insert into votes values ('p034',2,date('now','-6 days'),'u005');
insert into votes values ('p034',3,date('now','-7 days'),'u032');
insert into votes values ('p034',4,date('now','-8 days'),'u024');
insert into votes values ('p034',5,date('now','-9 days'),'u015');
insert into votes values ('p034',6,date('now','-2 days'),'u017');
insert into votes values ('p034',7,date('now','-5 days'),'u002');
insert into votes values ('p034',8,date('now','-6 days'),'u005');
insert into votes values ('p034',9,date('now','-7 days'),'u032');
insert into votes values ('p034',10,date('now','-8 days'),'u024');
insert into votes values ('p034',11,date('now','-9 days'),'u015');
insert into votes values ('p034',12,date('now','-2 days'),'u017');
insert into votes values ('p034',13,date('now','-5 days'),'u004');
insert into votes values ('p034',14,date('now','-6 days'),'u003');
insert into votes values ('p034',15,date('now','-7 days'),'u006');
insert into votes values ('p034',16,date('now','-8 days'),'u007');
insert into votes values ('p034',17,date('now','-9 days'),'u008');
insert into votes values ('p034',18,date('now','-2 days'),'u009');
insert into votes values ('p034',19,date('now','-5 days'),'u010');
insert into votes values ('p034',20,date('now','-6 days'),'u011');
insert into votes values ('p034',21,date('now','-7 days'),'u012');
insert into votes values ('p034',22,date('now','-8 days'),'u013');
insert into tags values ('p034','sleep');
insert into tags values ('p034','boring');
insert into tags values ('p034','test tag');
insert into tags values ('p034','tag test');
