-- Name: Sanad Masannat
-- Student ID: 24217734

INSERT INTO features(title, year, type) values ("The Chronicles of Narnia: The Lion, the Witch and the Wardrobe", 2005, "movie");
INSERT INTO features(title, year, type) values ("The Chronicles of Narnia: Prince Caspian", 2008, "movie");
INSERT INTO features(title, year, type) values ("The Chronicles of Narnia: The Voyage of the Dawn Treader", 2010, "movie");
INSERT INTO features(title, year, type) values ("Barbie", 2023, "movie");
INSERT INTO features(title, year, type) values ("Wicked", 2024, "movie");

INSERT INTO franchises(name, studio) values ("Narnia", "Walden Media");

INSERT INTO feature_work(feature_id, person, job) VALUES (103, "Georgie Henly", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (103, "Skandar Keynes", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (103, "William Mosely", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (103, "Anna Popplewell", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (103, "Liam Neeson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (103, "Andrew Adamson", "director");


INSERT INTO feature_role(feature_id, person, role) VALUES (103, "Georgie Henly", "Lucy Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (103, "Skandar Keynes", "Edmund Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (103, "William Mosely", "Peter Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (103, "Anna Popplewell", "Susan Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (103, "Liam Neeson", "Aslan");

INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Georgie Henly", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Skandar Keynes", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "William Mosely", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Anna Popplewell", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Liam Neeson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Andrew Adamson", "director");
INSERT INTO feature_role(feature_id, person, role) VALUES (104, "Georgie Henly", "Lucy Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (104, "Skandar Keynes", "Edmund Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (104, "William Mosely", "Peter Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (104, "Anna Popplewell", "Susan Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (104, "Liam Neeson", "Aslan");
INSERT INTO feature_work(feature_id, person, job) VALUES (104, "Andrew Adamson", "director");

INSERT INTO feature_work(feature_id, person, job) VALUES (105, "Georgie Henly", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (105, "Skandar Keynes", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (105, "William Mosely", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (105, "Anna Popplewell", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (105, "Liam Neeson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (105, "Michael Apted", "director");


INSERT INTO feature_role(feature_id, person, role) VALUES (105, "Georgie Henly", "Lucy Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (105, "Skandar Keynes", "Edmund Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (105, "William Mosely", "Peter Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (105, "Anna Popplewell", "Susan Pevensie");
INSERT INTO feature_role(feature_id, person, role) VALUES (105, "Liam Neeson", "Aslan");

INSERT INTO feature_work(feature_id, person, job) VALUES (106, "Margot Robbie", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (106, "Ryan Gosling", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (106, "Greta Gerwig", "director");

INSERT INTO feature_role(feature_id, person, role) VALUES (106, "Margot Robbie", "Barbie");
INSERT INTO feature_role(feature_id, person, role) VALUES (106, "Ryan Gosling", "Ken");


INSERT INTO feature_work(feature_id, person, job) VALUES (107, "Ariana Grande", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (107, "Cynthia Erivo", "actor");
INSERT INTO feature_role(feature_id, person, role) VALUES (107, "Ariana Grande", "Glinda");
INSERT INTO feature_role(feature_id, person, role) VALUES (107, "Cynthia Erivo", "Elphaba");
INSERT INTO feature_work(feature_id, person, job) VALUES (107, "Jon Chu", "director");



INSERT INTO role_type(role_id, role_type) values (249, "kid");
INSERT INTO role_type(role_id, role_type) values (250, "kid");
INSERT INTO role_type(role_id, role_type) values (251, "kid");
INSERT INTO role_type(role_id, role_type) values (252, "kid");
INSERT INTO role_type(role_id, role_type) values (253, "lion");

INSERT INTO role_type(role_id, role_type) values (254, "kid");
INSERT INTO role_type(role_id, role_type) values (255, "kid");
INSERT INTO role_type(role_id, role_type) values (256, "kid");
INSERT INTO role_type(role_id, role_type) values (257, "kid");
INSERT INTO role_type(role_id, role_type) values (258, "lion");

INSERT INTO role_type(role_id, role_type) values (259, "kid");
INSERT INTO role_type(role_id, role_type) values (260, "kid");
INSERT INTO role_type(role_id, role_type) values (261, "kid");
INSERT INTO role_type(role_id, role_type) values (262, "kid");
INSERT INTO role_type(role_id, role_type) values (263, "lion");

INSERT INTO role_type(role_id, role_type) values (264, "doll");
INSERT INTO role_type(role_id, role_type) values (265, "doll");

INSERT INTO role_type(role_id, role_type) values (266, "witch");
INSERT INTO role_type(role_id, role_type) values (267, "witch");

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (103, 12, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (104, 12, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (105, 12, 3);

INSERT INTO domestic_gross(feature_id, currency_id, amount) values (103, 1,  291710957);
INSERT INTO international_gross(feature_id, currency_id, amount) values (103, 1, 453302158);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (104, 1,  141621490);
INSERT INTO international_gross(feature_id, currency_id, amount) values (104, 1, 278044078);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (105, 1,  104386950);
INSERT INTO international_gross(feature_id, currency_id, amount) values (105, 1, 311299267);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (106, 1,  636238421);
INSERT INTO international_gross(feature_id, currency_id, amount) values (106, 1, 810800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (107, 1,  469513465);
INSERT INTO international_gross(feature_id, currency_id, amount) values (107, 1, 248383000);

INSERT INTO budget(feature_id, currency_id, amount) values (103, 1, 180000000);
INSERT INTO budget(feature_id, currency_id, amount) values (104, 1, 225000000);
INSERT INTO budget(feature_id, currency_id, amount) values (105, 1, 155000000);
INSERT INTO budget(feature_id, currency_id, amount) values (106, 1, 151000000);
INSERT INTO budget(feature_id, currency_id, amount) values (107, 1, 145000000);
