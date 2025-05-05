DROP DATABASE IF EXISTS movies;

CREATE DATABASE IF NOT EXISTS movies;

USE movies;

-- source /Users/tonyveale/Dropbox/SQL Lectures/Movie database/movies data.sql
-- Edited by: Sanad Masannat 24217734

CREATE TABLE  features (
    feature_id int NOT NULL AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    year int NOT NULL,
    type varchar(255) NOT NULL,
    PRIMARY KEY (feature_id)
);

CREATE TABLE  feature_work (
   job_id int NOT NULL AUTO_INCREMENT,
   feature_id int NOT NULL,
   person varchar(255) NOT NULL,
   job varchar(255) NOT NULL,
   gender varchar(12) NOT NULL,
   ethnicity varchar(24) NOT NULL,
   PRIMARY KEY (job_id),
   FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
);

CREATE TABLE feature_role (
   role_id int NOT NULL AUTO_INCREMENT,
   feature_id int NOT NULL,
   person varchar(255) NOT NULL,
   role varchar(255) NOT NULL,
   gender varchar(12) NOT NULL,
   ethnicity varchar(24) NOT NULL,
   PRIMARY KEY (role_id),
   FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
);


CREATE TABLE role_type (
   role_id int NOT NULL,
   role_type varchar(255) NOT NULL,
   PRIMARY KEY (role_id, role_type),
   FOREIGN KEY (role_id) REFERENCES feature_role(role_id) ON DELETE CASCADE
);


CREATE TABLE franchises (
   franchise_id int NOT NULL AUTO_INCREMENT,
   name varchar(255) NOT NULL,
   studio varchar(255) NOT NULL,
   PRIMARY KEY (franchise_id)
);


# Associate a feature with a franchise, indicating its order within the franchise (1st, 2nd, 3rd, etc.)
# The joint primary key means a feature can be in multiple franchises (e.g., Iron Man 2 is in the MCU and in the Iron Man franchise)

CREATE TABLE  franchise_features (
   feature_id int NOT NULL,
   franchise_id int NOT NULL,
   franchise_number int NOT NULL,
   PRIMARY KEY (feature_id, franchise_id),
   FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE,
   FOREIGN KEY (franchise_id) REFERENCES franchises(franchise_id) ON DELETE CASCADE
);




CREATE TABLE currencies (
  currency_id int NOT NULL AUTO_INCREMENT,
  currency_name varchar(255) NOT NULL,
  currency_symbol varchar(255) NOT NULL,
  PRIMARY KEY (currency_id)
);


CREATE TABLE budget (
  feature_id int NOT NULL,
  currency_id int NOT NULL,
  amount int NOT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE,
  FOREIGN KEY (currency_id) REFERENCES currencies(currency_id) ON DELETE CASCADE
);


CREATE TABLE domestic_gross (
  feature_id int NOT NULL,
  currency_id int NOT NULL,
  amount int NOT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE,
  FOREIGN KEY (currency_id) REFERENCES currencies(currency_id) ON DELETE CASCADE
);


CREATE TABLE international_gross (
  feature_id int NOT NULL,
  currency_id int NOT NULL,
  amount int NOT NULL,
  PRIMARY KEY (feature_id),
  FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE,
  FOREIGN KEY (currency_id) REFERENCES currencies(currency_id) ON DELETE CASCADE
);
 

 CREATE TABLE genres (
  feature_id int NOT NULL,
  comedy int default 0,
  romance int default 0,
  action int default 0,
  fantasy int default 0,
  horror int default 0,
  mystery int default 0,
  science_fiction int default 0,
  historical int default 0,
  espionage int default 0,
  crime int default 0,
  drama int default 0,
  youth int default 0,
  biography int default 0,
  political int default 0,
  PRIMARY KEY(feature_id),
  FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
 );
 
 -- New tables are created here
CREATE TABLE feature_synopsis (
    feature_id INT,
    synopsis TEXT NOT NULL,
    PRIMARY KEY(feature_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
);


CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
	account_creation_date date,
    PRIMARY KEY (user_id)
);

CREATE TABLE critics (
	critic_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    working_for VARCHAR(255) NOT NULL,
    top BOOLEAN NOT NULL default FALSE,
    area_of_expertise VARCHAR(255),
    PRIMARY KEY (critic_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
    );
    
CREATE TABLE sweetness_index (
    feature_id INT,
    sweetness_percentage FLOAT,
    melon_type ENUM('HoneyDew', 'HoneyDon’t'),
    PRIMARY KEY (feature_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);


CREATE TABLE review (
    review_id INT NOT NULL AUTO_INCREMENT,
    feature_id INT NOT NULL,
    user_id INT NOT NULL,
    review_text TEXT,
    score FLOAT NOT NULL,
    created date,
    is_positive BOOLEAN NOT NULL default TRUE,
    PRIMARY KEY (review_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


CREATE TABLE user_search_history (
    search_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    search_query TEXT NOT NULL,
    search_date datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (search_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);






INSERT INTO features(title, year, type) values ("Dr. No", 1962, "movie");
INSERT INTO features(title, year, type) values ("From Russia with Love", 1963, "movie");
INSERT INTO features(title, year, type) values ("Goldfinger", 1964, "movie");
INSERT INTO features(title, year, type) values ("Thunderball", 1965, "movie");
INSERT INTO features(title, year, type) values ("You Only Live Twice", 1967, "movie");
INSERT INTO features(title, year, type) values ("On Her Majesty's Secret Service", 1969, "movie");
INSERT INTO features(title, year, type) values ("Diamonds Are Forever", 1971, "movie");
INSERT INTO features(title, year, type) values ("Live and Let Die", 1973, "movie");
INSERT INTO features(title, year, type) values ("The Man with the Golden Gun", 1974, "movie");
INSERT INTO features(title, year, type) values ("The Spy Who Loved Me", 1977, "movie");
INSERT INTO features(title, year, type) values ("Moonraker", 1979, "movie");
INSERT INTO features(title, year, type) values ("For Your Eyes Only", 1981, "movie");
INSERT INTO features(title, year, type) values ("Octopussy", 1983, "movie");
INSERT INTO features(title, year, type) values ("A View to a Kill", 1985, "movie");
INSERT INTO features(title, year, type) values ("The Living Daylights", 1987, "movie");
INSERT INTO features(title, year, type) values ("Licence to Kill", 1989, "movie");
INSERT INTO features(title, year, type) values ("GoldenEye", 1995, "movie");
INSERT INTO features(title, year, type) values ("Tomorrow Never Dies", 1997, "movie");
INSERT INTO features(title, year, type) values ("The World Is Not Enough", 1999, "movie");
INSERT INTO features(title, year, type) values ("Die Another Day", 2002, "movie");
INSERT INTO features(title, year, type) values ("Casino Royale", 2006, "movie");
INSERT INTO features(title, year, type) values ("Quantum of Solace", 2008, "movie");
INSERT INTO features(title, year, type) values ("Skyfall", 2012, "movie");
INSERT INTO features(title, year, type) values ("Spectre", 2015, "movie");
INSERT INTO features(title, year, type) values ("No Time to Die", 2021, "movie");

INSERT INTO features(title, year, type) values ("Sherlock", 2010, "TV show");
INSERT INTO features(title, year, type) values ("Sherlock Holmes", 2009, "movie");
INSERT INTO features(title, year, type) values ("Enola Holmes", 2020, "movie");
INSERT INTO features(title, year, type) values ("Sherlock Gnomes", 2018, "movie");
INSERT INTO features(title, year, type) values ("Mr. Holmes", 2018, "movie");
INSERT INTO features(title, year, type) values ("Man of Steel", 2013, "movie");
INSERT INTO features(title, year, type) values ("Iron Man", 2008, "movie");

INSERT INTO features(title, year, type) values ("The Adventures of Robin Hood", 1938, "movie");
INSERT INTO features(title, year, type) values ("Robin Hood", 2010, "movie");
INSERT INTO features(title, year, type) values ("Robin Hood: Prince of Thieves", 1991, "movie");
INSERT INTO features(title, year, type) values ("Robin and Marian", 1976, "movie");
INSERT INTO features(title, year, type) values ("Doctor Strange", 2016, "movie");
INSERT INTO features(title, year, type) values ("Superman Returns", 2006, "movie");
INSERT INTO features(title, year, type) values ("Superman Vs. Batman", 2016, "movie");
INSERT INTO features(title, year, type) values ("The Social Network", 2009, "movie");
INSERT INTO features(title, year, type) values ("House of Cards", 2013, "TV show");
INSERT INTO features(title, year, type) values ("The Imitation Game", 2014, "movie");
INSERT INTO features(title, year, type) values ("Knives Out", 2019, "movie");
INSERT INTO features(title, year, type) values ("The Glass Onion", 2022, "movie");

INSERT INTO features(title, year, type) values ("Casino Royale", 1967, "movie");

INSERT INTO features(title, year, type) values ("John Wick", 2014, "movie");
INSERT INTO features(title, year, type) values ("John Wick: Chapter 2", 2017, "movie");
INSERT INTO features(title, year, type) values ("John Wick: Chapter 3 - Parabellum", 2019, "movie");
INSERT INTO features(title, year, type) values ("John Wick: Chapter 4", 2023, "movie");

INSERT INTO features(title, year, type) values ("The Bourne Identity", 2002, "movie");
INSERT INTO features(title, year, type) values ("The Bourne Supremacy", 2004, "movie");
INSERT INTO features(title, year, type) values ("The Bourne Ultimatum", 2007, "movie");
INSERT INTO features(title, year, type) values ("The Bourne Legacy", 2012, "movie");
INSERT INTO features(title, year, type) values ("Jason Bourne", 2016, "movie");


INSERT INTO features(title, year, type) values ("The Matrix", 1999, "movie");
INSERT INTO features(title, year, type) values ("The Matrix Reloaded", 2003, "movie");
INSERT INTO features(title, year, type) values ("The Matrix Revolutions", 2003, "movie");
INSERT INTO features(title, year, type) values ("The Matrix Resurrections", 2021, "movie");


INSERT INTO features(title, year, type) values ("The Equalizer", 1985, "TV show");

INSERT INTO features(title, year, type) values ("The Equalizer", 2014, "movie");
INSERT INTO features(title, year, type) values ("The Equalizer 2", 2018, "movie");
INSERT INTO features(title, year, type) values ("The Equalizer 3", 2023, "movie");

INSERT INTO features(title, year, type) values ("Batman Begins", 2005, "movie");
INSERT INTO features(title, year, type) values ("The Dark Knight", 2008, "movie");
INSERT INTO features(title, year, type) values ("The Dark Knight Rises", 2012, "movie");

INSERT INTO features(title, year, type) values ("Deadpool", 2016, "movie");
INSERT INTO features(title, year, type) values ("Deadpool 2", 2018, "movie");
INSERT INTO features(title, year, type) values ("Deadpool & Wolverine", 2024, "movie");


INSERT INTO features(title, year, type) values ("Interstellar", 2014, "movie");
INSERT INTO features(title, year, type) values ("The Incredible Hulk", 2008, "movie");
INSERT INTO features(title, year, type) values ("Iron Man 2", 2010, "movie");
INSERT INTO features(title, year, type) values ("Thor", 2011, "movie");
INSERT INTO features(title, year, type) values ("Captain America: The First Avenger", 2008, "movie");
INSERT INTO features(title, year, type) values ("The Avengers", 2012, "movie");
INSERT INTO features(title, year, type) values ("Iron Man 3", 2013, "movie");
INSERT INTO features(title, year, type) values ("Thor: The Dark World", 2013, "movie");
INSERT INTO features(title, year, type) values ("Captain America: The Winter Soldier", 2014, "movie");
INSERT INTO features(title, year, type) values ("Guardians of the Galaxy", 2014, "movie");
INSERT INTO features(title, year, type) values ("Avengers: Age of Ultron", 2015, "movie");
INSERT INTO features(title, year, type) values ("Ant-Man", 2015, "movie");
INSERT INTO features(title, year, type) values ("Captain America: Civil War", 2016, "movie");
INSERT INTO features(title, year, type) values ("Inception", 2010, "movie");
INSERT INTO features(title, year, type) values ("Guardians of the Galaxy Vol. 2", 2017, "movie");
INSERT INTO features(title, year, type) values ("Spider-Man: Homecoming", 2017, "movie");
INSERT INTO features(title, year, type) values ("Thor: Ragnarok", 2017, "movie");
INSERT INTO features(title, year, type) values ("Black Panther", 2018, "movie");
INSERT INTO features(title, year, type) values ("Avengers: Infinity War", 2018, "movie");
INSERT INTO features(title, year, type) values ("Ant-Man and the Wasp", 2018, "movie");
INSERT INTO features(title, year, type) values ("Captain Marvel", 2019, "movie");
INSERT INTO features(title, year, type) values ("Avengers: Endgame", 2019, "movie");
INSERT INTO features(title, year, type) values ("Spider-Man: Far From Home", 2019, "movie");
INSERT INTO features(title, year, type) values ("Black Widow", 2021, "movie");
INSERT INTO features(title, year, type) values ("Shang-Chi and the Legend of the Ten Rings", 2021, "movie");
INSERT INTO features(title, year, type) values ("Eternals", 2021, "movie");
INSERT INTO features(title, year, type) values ("Spider-Man: No Way Home", 2021, "movie");
INSERT INTO features(title, year, type) values ("Doctor Strange in the Multiverse of Madness", 2022, "movie");
INSERT INTO features(title, year, type) values ("Thor: Love and Thunder", 2022, "movie");
INSERT INTO features(title, year, type) values ("Black Panther: Wakanda Forever", 2022, "movie");
INSERT INTO features(title, year, type) values ("Ant-Man and the Wasp: Quantumania", 2023, "movie");
INSERT INTO features(title, year, type) values ("Guardians of the Galaxy Vol. 3", 2023, "movie");
INSERT INTO features(title, year, type) values ("The Marvels", 2023, "movie");


INSERT INTO features(title, year, type) values ("Sherlock Holmes: A Game of Shadows", 2011, "movie");

INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (1, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (2, 100, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (3, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (4, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (5, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (6, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance, crime) values (7, 90, 90, 40, 20, 40);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (8, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (9, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (10, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance, science_fiction) values (11, 90, 90, 20, 20, 75);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (12, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (13, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (14, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (15, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (16, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (17, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (18, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (19, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (20, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (21, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (22, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (23, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (24, 90, 90, 40, 20);
INSERT INTO genres(feature_id, espionage, action, comedy, romance) values (25, 90, 90, 40, 20);
INSERT INTO genres(feature_id, crime, action, comedy, mystery) values (26, 90, 60, 40, 100);
INSERT INTO genres(feature_id, crime, action, comedy, mystery, historical) values (27, 90, 60, 40, 100, 75);
INSERT INTO genres(feature_id, crime, action, comedy, mystery, youth) values (28, 90, 60, 40, 100, 80);
INSERT INTO genres(feature_id, crime, action, comedy, mystery, youth) values (29, 80, 60, 80, 80, 75);
INSERT INTO genres(feature_id, crime, historical, mystery) values (30, 60, 80, 100);
INSERT INTO genres(feature_id, science_fiction, action, fantasy) values (31, 90, 90, 70);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy) values (32, 60, 90, 25, 30);
INSERT INTO genres(feature_id, drama, historical, action, comedy) values (33, 60, 70, 80, 40);
INSERT INTO genres(feature_id, drama, historical, action) values (34, 60, 80, 70);
INSERT INTO genres(feature_id, drama, historical, action, comedy, romance) values (35, 60, 70, 80, 40, 60);
INSERT INTO genres(feature_id, drama, historical, action, romance) values (36, 80, 80, 50, 70);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy) values (37, 20, 70, 100, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy) values (38, 90, 70, 70);
INSERT INTO genres(feature_id, science_fiction, action, fantasy) values (39, 90, 90, 80);
INSERT INTO genres(feature_id, drama, historical, biography) values (40, 80, 60, 90);
INSERT INTO genres(feature_id, drama, political) values (41, 80, 100);
INSERT INTO genres(feature_id, drama, historical, biography) values (42, 80, 60, 90);
INSERT INTO genres(feature_id, mystery, comedy, drama, crime) values (43, 80, 60, 40, 50);
INSERT INTO genres(feature_id, mystery, comedy, drama, crime) values (44, 80, 60, 40, 50);
INSERT INTO genres(feature_id, espionage, comedy, action) values (45, 80, 60, 40);
INSERT INTO genres(feature_id, action, comedy, crime) values (46, 100, 40, 60);
INSERT INTO genres(feature_id, action, comedy, crime) values (47, 100, 40, 60);
INSERT INTO genres(feature_id, action, comedy, crime) values (48, 100, 40, 60);
INSERT INTO genres(feature_id, action, comedy, crime) values (49, 100, 40, 60);
INSERT INTO genres(feature_id, espionage, drama, action, political) values (50, 80, 60, 90, 20);
INSERT INTO genres(feature_id, espionage, drama, action, political) values (51, 80, 60, 90, 20);
INSERT INTO genres(feature_id, espionage, drama, action, political) values (52, 80, 60, 90, 20);
INSERT INTO genres(feature_id, espionage, drama, action, political) values (53, 80, 60, 90, 20);
INSERT INTO genres(feature_id, espionage, drama, action, political) values (54, 80, 60, 90, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, romance) values (55, 100, 90, 80, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, romance) values (56, 100, 90, 80, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, romance) values (57, 100, 90, 40, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, romance) values (58, 100, 90, 80, 40);
INSERT INTO genres(feature_id, action, crime, drama, espionage) values (59, 40, 80, 70, 30);
INSERT INTO genres(feature_id, action, crime, drama, espionage) values (60, 90, 80, 60, 40);
INSERT INTO genres(feature_id, action, crime, drama, espionage) values (61, 90, 80, 60, 40);
INSERT INTO genres(feature_id, action, crime, drama, espionage) values (62, 90, 80, 60, 40);
INSERT INTO genres(feature_id, crime, action, drama, romance, fantasy) values (63, 90, 90, 80, 50, 40);
INSERT INTO genres(feature_id, crime, action, drama, romance, fantasy) values (64, 90, 90, 80, 50, 40);
INSERT INTO genres(feature_id, crime, action, drama, romance, fantasy) values (65, 90, 90, 80, 50, 40);
INSERT INTO genres(feature_id, action, crime, fantasy, comedy, drama) values (66, 90, 40, 70, 80, 10);
INSERT INTO genres(feature_id, action, crime, fantasy, comedy, drama) values (67, 90, 40, 70, 80, 10);
INSERT INTO genres(feature_id, action, crime, fantasy, comedy, drama) values (68, 90, 40, 70, 80, 10);
INSERT INTO genres(feature_id, science_fiction, action, drama, romance) values (69, 100, 50, 80, 50);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, romance) values (70, 70, 70, 70, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (71, 70, 70, 60, 30, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (72, 20, 70, 90, 40, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, historical, romance) values (73, 60, 70, 60, 70, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, espionage) values (74, 70, 80, 80, 30, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (75, 70, 70, 60, 30, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (76, 20, 70, 90, 40, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, espionage, political) values (77, 60, 70, 60, 60, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (78, 80, 80, 80, 70, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (79, 70, 80, 80, 30, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (80, 70, 70, 70, 50, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, political, drama) values (81, 60, 70, 60, 60, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, espionage, drama) values (82, 90, 70, 60, 60, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (83, 80, 80, 80, 70, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama, youth) values (84, 40, 80, 70, 70, 30, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (85, 30, 70, 90, 60, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, political, drama) values (86, 20, 70, 20, 60, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (87, 70, 80, 80, 30, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (88, 70, 70, 70, 50, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, espionage) values (89, 90, 70, 70, 40, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (90, 70, 80, 80, 30, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama, youth) values (91, 40, 80, 70, 70, 30, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, espionage, drama) values (92, 40, 70, 40, 70, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (93, 60, 80, 60, 30, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, drama, romance) values (94, 90, 60, 70, 40, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama, youth) values (95, 50, 80, 70, 70, 30, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy) values (96, 40, 70, 100, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (97, 50, 80, 90, 80, 20);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, political, drama) values (98, 20, 70, 20, 60, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, romance) values (99, 90, 70, 70, 60, 30);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (100, 90, 80, 80, 70, 40);
INSERT INTO genres(feature_id, science_fiction, action, fantasy, comedy, drama) values (101, 70, 70, 70, 30, 40);
INSERT INTO genres(feature_id, crime, action, comedy, mystery, historical) values (102, 90, 60, 40, 100, 75);


INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (1, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (2, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (3, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (4, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (5, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (6, "George Lazenby", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (7, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (8, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (9, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (10, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (11, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (12, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (13, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (14, "Roger Moore", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (15, "Timothy Dalton", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (16, "Timothy Dalton", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (17, "Pierce Brosnan", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (18, "Pierce Brosnan", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (19, "Pierce Brosnan", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (20, "Pierce Brosnan", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (21, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (22, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (23, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (24, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (25, "Daniel Craig", "actor", "male", "Causasian");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (26, "Benedict Cumberbatch", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (27, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (28, "Henry Cavill", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (29, "Johnny Depp", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (30, "Ian McKellen", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (31, "Henry Cavill", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (32, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (33, "Errol Flynn", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (34, "Russell Crowe", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (35, "Kevin Costner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (36, "Sean Connery", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (37, "Benedict Cumberbatch", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (38, "Kevin Spacey", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (39, "Jesse Eisenberg", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (39, "Henry Cavill", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (40, "Jesse Eisenberg", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (41, "Kevin Spacey", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (42, "Benedict Cumberbatch", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (43, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (44, "Daniel Craig", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "David Niven", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Peter Sellers", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Woody Allen", "actor", "male", "Causasian");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (1, "Terence Young", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (2, "Terence Young", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (3, "Guy Hamilton", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (4, "Terence Young", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (5, "Lewis Gilbert", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (6, "Peter R. Hunt", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (7, "Guy Hamilton", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (8, "Guy Hamilton", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (9, "Guy Hamilton", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (10, "Lewis Gilbert", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (11, "Lewis Gilbert", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (12, "John Glen", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (13, "John Glen", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (14, "John Glen", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (15, "John Glen", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (16, "John Glen", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (17, "Martin Campbell", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (18, "Roger Spottiswoode", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (19, "Michael Apted", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (20, "Lee Tamahori", "director", "male", "Asian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (21, "Martin Campbell", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (22, "Marc Forster", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (23, "Sam Mendes", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (24, "Sam Mendes", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (25, "Cary Joji Fukunaga", "director", "male", "Asian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (32, "Jon Favreau", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (37, "Scott Derrickson", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (43, "Rian Johnson", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (44, "Rian Johnson", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "John Huston", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Val Guest", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Ken Hughes", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Joseph McGrath", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (45, "Robert Parrish", "director", "male", "Causasian");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (46, "Chad Stahelski", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (46, "David Lietch", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (47, "Chad Stahelski", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (48, "Chad Stahelski", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (49, "Chad Stahelski", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (50, "Doug Liman", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (51, "Paul Greengrass", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (52, "Paul Greengrass", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (53, "Tony Gilroy", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (54, "Paul Greengrass", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Lilly Wachowski", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Lana Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Lilly Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Lana Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Lilly Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Lana Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (58, "Lana Wachowski", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (59, "Michael Sloan", "creator", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (59, "Richard Lindheim", "creator", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (60, "Antoine Fuqua", "director", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (61, "Antoine Fuqua", "director", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (62, "Antoine Fuqua", "director", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (63, "Christopher Nolan", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Christopher Nolan", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Christopher Nolan", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (66, "Tim Miller", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (67, "David Leitch", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (68, "Shawn Levy", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (69, "Christopher Nolan", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (70, "Louis Leterrier", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (71, "Jon Favreau", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (72, "Kenneth Branagh", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (73, "Joe Johnston", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Joss Whedon", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (75, "Shane Black", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (76, "Alan Taylor", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (77, "Anthony Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (77, "Joe Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (78, "James Gunn", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Joss Whedon", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (80, "Peyton Reed", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Anthony Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Joe Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (82, "Christopher Nolan", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (83, "James Gunn", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (84, "Jon Watts", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (85, "Taika Waititi", "director", "male", "Maori");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (86, "Ryan Coogler", "director", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Anthony Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Joe Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (88, "Peyton Reed", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (89, "Anna Boden", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (89, "Ryan Fleck", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Anthony Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Joe Russo", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (91, "Jon Watts", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (92, "Cate Shortland", "director", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (93, "Destin Daniel Cretton", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (94, "Chloé Zhao", "director", "female", "Asian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (95, "Jon Watts", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (96, "Sam Raimi", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (97, "Taika Waititi", "director", "male", "Maori");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (98, "Ryan Coogler", "director", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (99, "Peyton Reed", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (100, "James Gunn", "director", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (101, "Nia DaCosta", "director", "female", "Causasian");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (46, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (46, "Ian McShane", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (46, "Lance Reddick", "actor", "male", "Black");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (47, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (47, "Ian McShane", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (47, "Lance Reddick", "actor", "male", "Black");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (48, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (48, "Ian McShane", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (48, "Lance Reddick", "actor", "male", "Black");


INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (49, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (49, "Ian McShane", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (49, "Lance Reddick", "actor", "male", "Black");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (50, "Matt Damon", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (51, "Matt Damon", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (52, "Matt Damon", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (53, "Jeremy Renner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (54, "Matt Damon", "actor", "male", "Causasian");

INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Hugo Weaving", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Laurence Fishburne", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (55, "Carrie-Anne Moss", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Hugo Weaving", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Laurence Fishburne", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (56, "Carrie-Anne Moss", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Hugo Weaving", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Laurence Fishburne", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (57, "Carrie-Anne Moss", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (58, "Keanu Reeves", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (58, "Carrie-Anne Moss", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (59, "Edward Woodward", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (60, "Denzel Washington", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (61, "Denzel Washington", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (62, "Denzel Washington", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (63, "Christian Bale", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (63, "Michael Caine", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (63, "Morgan Freeman", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (63, "Gary Oldman", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Christian Bale", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Michael Caine", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Morgan Freeman", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Gary Oldman", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (64, "Heath Ledger", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Christian Bale", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Michael Caine", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Morgan Freeman", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Gary Oldman", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (65, "Tom Hardy", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (66, "Ryan Reynolds", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (67, "Ryan Reynolds", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (68, "Ryan Reynolds", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (68, "Hugh Jackman", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (69, "Matthew McConaughey", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (69, "Michael Caine", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (69, "Anne Hathaway", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (70, "Edward Norton", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (71, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (71, "Jeff Bridges", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (72, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (72, "Anthony Hopkins", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (73, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (73, "Hugh Weaving", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Mark Ruffalo", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Jeremy Renner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (74, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (75, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (76, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (76, "Anthony Hopkins", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (77, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (77, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (78, "Chris Pratt", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (78, "Bradley Cooper", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (78, "Vin Diesel", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Mark Ruffalo", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Jeremy Renner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (79, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (80, "Paul Rudd", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (80, "Michael Douglas", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (81, "Robert Redford", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (82, "Leonardo DiCaprio", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (82, "Michael Caine", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (82, "Tom Hardy", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (82, "Cillian Murphy", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (83, "Chris Pratt", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (83, "Bradley Cooper", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (83, "Vin Diesel", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (84, "Kurt Russell", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (84, "Tom Holland", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (84, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (84, "Michael Keaton", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (85, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (85, "Anthony Hopkins", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (85, "Cate Blanchett", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (85, "Mark Ruffalo", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (86, "Chadwick Boseman", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (86, "Michael B. Jordan", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Mark Ruffalo", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Jeremy Renner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (87, "Josh Brolin", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (88, "Paul Rudd", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (88, "Michael Douglas", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (89, "Brie Larson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (89, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Chris Evans", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Robert Downey Jr.", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Mark Ruffalo", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Jeremy Renner", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (90, "Josh Brolin", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (91, "Tom Holland", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (91, "Samuel L. Jackson", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (91, "Jon Favreau", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (92, "Scarlet Johannson", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (92, "Florence Pugh", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (93, "Simu Liu", "actor", "male", "Asian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (93, "Awkwafina", "actor", "female", "Asian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (94, "Angelina Jolie", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (94, "Barry Keoghan", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (94, "Salma Hayek", "actor", "female", "Hispanic");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (94, "Richard Madden", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (95, "Tom Holland", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (95, "Benedict Cumberbatch", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (95, "Willem Dafoe", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (96, "Benedict Cumberbatch", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (97, "Chris Hemsworth", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (97, "Christian Bale", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (97, "Natalie Portman", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (98, "Letitia Wright", "actor", "female", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (99, "Paul Rudd", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (99, "Michael Douglas", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (99, "Michelle Pfeiffer", "actor", "female", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (100, "Chris Pratt", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (100, "Bradley Cooper", "actor", "male", "Causasian");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (100, "Vin Diesel", "actor", "male", "Black");
INSERT INTO feature_work(feature_id, person, job, gender, ethnicity) VALUES (101, "Brie Larson", "actor", "female", "Causasian");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (1, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (2, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (3, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (4, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (5, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (6, "George Lazenby", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (7, "Sean Connery", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (8, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (9, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (10, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (11, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (12, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (13, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (14, "Roger Moore", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (15, "Timothy Dalton", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (16, "Timothy Dalton", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (17, "Pierce Brosnan", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (18, "Pierce Brosnan", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (19, "Pierce Brosnan", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (20, "Pierce Brosnan", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (21, "Daniel Craig", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (22, "Daniel Craig", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (23, "Daniel Craig", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (24, "Daniel Craig", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (25, "Daniel Craig", "James Bond", "male", "Caucasian");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (26, "Benedict Cumberbatch", "Sherlock Holmes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (27, "Robert Downey Jr.", "Sherlock Holmes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (28, "Henry Cavill", "Sherlock Holmes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (29, "Johnny Depp", "Sherlock Holmes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (30, "Ian McKellen", "Sherlock Holmes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (31, "Henry Cavill", "Superman", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (31, "Henry Cavill", "Clark Kent", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (32, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (32, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (33, "Errol Flynn", "Robin Hood", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (34, "Russell Crowe", "Robin Hood", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (35, "Kevin Costner", "Robin Hood", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (36, "Sean Connery", "Robin Hood", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (37, "Benedict Cumberbatch", "Doctor Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (37, "Benedict Cumberbatch", "Stephen Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (38, "Kevin Spacey", "Lex Luthor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (39, "Jesse Eisenberg", "Lex Luthor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (39, "Henry Cavill", "Superman", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (39, "Henry Cavill", "Clark Kent", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (40, "Jesse Eisenberg", "Mark Zuckerberg", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (41, "Kevin Spacey", "Frank Underwood", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (42, "Benedict Cumberbatch", "Alan Turing", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (43, "Daniel Craig", "Benoit Blanc", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (44, "Daniel Craig", "Benoit Blanc", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (45, "David Niven", "James Bond", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (45, "Peter Sellers", "Evelyn Tremble", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (45, "Woody Allen", "Jimmy Bond", "male", "Caucasian");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (46, "Keanu Reeves", "John Wick", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (46, "Ian McShane", "Winston Scott", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (46, "Lance Reddick", "Charon", "male", "Black");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (47, "Keanu Reeves", "John Wick", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (47, "Ian McShane", "Winston Scott", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (47, "Lance Reddick", "Charon", "male", "Black");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (48, "Keanu Reeves", "John Wick", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (48, "Ian McShane", "Winston Scott", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (48, "Lance Reddick", "Charon", "male", "Black");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (49, "Keanu Reeves", "John Wick", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (49, "Ian McShane", "Winston Scott", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (49, "Lance Reddick", "Charon", "male", "Black");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (50, "Matt Damon", "Jason Bourne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (51, "Matt Damon", "Jason Bourne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (52, "Matt Damon", "Jason Bourne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (53, "Jeremy Renner", "Aaron Cross", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (54, "Matt Damon", "Jason Bourne", "male", "Caucasian");

INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (55, "Keanu Reeves", "Neo", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (55, "Hugo Weaving", "Agent Smith", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (55, "Laurence Fishburne", "Morpheus", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (55, "Carrie-Anne Moss", "Trinity", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (56, "Keanu Reeves", "Neo", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (56, "Hugo Weaving", "Agent Smith", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (56, "Laurence Fishburne", "Morpheus", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (56, "Carrie-Anne Moss", "Trinity", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (57, "Keanu Reeves", "Neo", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (57, "Hugo Weaving", "Agent Smith", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (57, "Laurence Fishburne", "Morpheus", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (57, "Carrie-Anne Moss", "Trinity", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (58, "Keanu Reeves", "Neo", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (58, "Carrie-Anne Moss", "Trinity", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (59, "Edward Woodward", "Robert McCall", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (60, "Denzel Washington", "Robert McCall", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (61, "Denzel Washington", "Robert McCall", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (62, "Denzel Washington", "Robert McCall", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (63, "Christian Bale", "Bruce Wayne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (63, "Christian Bale", "Batman", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (63, "Michael Caine", "Alfred Pennyworth", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (63, "Morgan Freeman", "Lucius Fox", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (63, "Gary Oldman", "James Gordon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (64, "Christian Bale", "Bruce Wayne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (64, "Michael Caine", "Alfred Pennyworth", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (64, "Morgan Freeman", "Lucius Fox", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (64, "Gary Oldman", "James Gordon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (64, "Heath Ledger", "The Joker", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Christian Bale", "Bruce Wayne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Christian Bale", "Batman", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Michael Caine", "Alfred Pennyworth", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Morgan Freeman", "Lucius Fox", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Gary Oldman", "James Gordon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (65, "Tom Hardy", "Bane", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (66, "Ryan Reynolds", "Wade Wilson", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (66, "Ryan Reynolds", "Deadpool", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (67, "Ryan Reynolds", "Wade Wilson", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (67, "Ryan Reynolds", "Deadpool", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (68, "Ryan Reynolds", "Wade Wilson", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (68, "Ryan Reynolds", "Deadpool", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (68, "Hugh Jackman", "Logan", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (68, "Hugh Jackman", "Wolverine", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (69, "Matthew McConaughey", "Cooper", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (69, "Michael Caine", "Professor Brand", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (69, "Anne Hathaway", "Brand", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (70, "Edward Norton", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (71, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (71, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (71, "Jeff Bridges", "Obidiah Stane", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (72, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (72, "Anthony Hopkins", "Odin", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (73, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (73, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (73, "Hugh Weaving", "Red Skull", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Mark Ruffalo", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Jeremy Renner", "Hawkeye", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Jeremy Renner", "Clint Barton", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Scarlet Johannson", "Natasha Romanova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (74, "Scarlet Johannson", "Black Widow", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (75, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (75, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (76, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (76, "Anthony Hopkins", "Odin", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (77, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (77, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (77, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (78, "Chris Pratt", "Peter Quill", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (78, "Bradley Cooper", "Rocket Raccoon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (78, "Vin Diesel", "Groot", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Mark Ruffalo", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Jeremy Renner", "Hawkeye", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Jeremy Renner", "Clint Barton", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Scarlet Johannson", "Natasha Romanova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (79, "Scarlet Johannson", "Black Widow", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (80, "Paul Rudd", "Scott Lang", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (80, "Paul Rudd", "Ant-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (80, "Michael Douglas", "Henry Pym", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (81, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (81, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (81, "Scarlet Johannson", "Natasha Romanova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (81, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (81, "Robert Redford", "Alexander Pierce", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (82, "Leonardo DiCaprio", "Cobb", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (82, "Michael Caine", "Professor Stephen Miles", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (82, "Tom Hardy", "Eames", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (82, "Cillian Murphy", "Fischer", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (83, "Chris Pratt", "Peter Quill", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (83, "Bradley Cooper", "Rocket Raccoon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (83, "Vin Diesel", "Groot", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (84, "Kurt Russell", "Ego", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (84, "Tom Holland", "Peter Parker", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (84, "Tom Holland", "Spider-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (84, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (84, "Michael Keaton", "Adrian Toomes", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (85, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (85, "Anthony Hopkins", "Odin", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (85, "Cate Blanchett", "Hela", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (85, "Mark Ruffalo", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (86, "Chadwick Boseman", "T'Challa", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (86, "Michael B. Jordan", "Erik Killmonger", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Mark Ruffalo", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Jeremy Renner", "Clint Barton", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Jeremy Renner", "Hawkeye", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Scarlet Johannson", "Natasha Romanova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Scarlet Johannson", "Black Widow", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (87, "Josh Brolin", "Thanos", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (88, "Paul Rudd", "Scott Lang", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (88, "Paul Rudd", "Ant-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (88, "Michael Douglas", "Henry Pym", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (89, "Brie Larson", "Carol Danvers", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (89, "Brie Larson", "Captain Marvel", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (89, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Chris Evans", "Captain America", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Chris Evans", "Steve Rogers", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Robert Downey Jr.", "Iron Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Robert Downey Jr.", "Tony Stark", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Mark Ruffalo", "Bruce Banner", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Jeremy Renner", "Clint Barton", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Jeremy Renner", "Hawkeye", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Brie Larson", "Carol Danvers", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Josh Brolin", "Thanos", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Paul Rudd", "Scott Lang", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Paul Rudd", "Ant-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (91, "Tom Holland", "Peter Parker", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (91, "Tom Holland", "Spider-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (91, "Samuel L. Jackson", "Nick Fury", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (91, "Jon Favreau", "Happy Hogan", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (92, "Scarlet Johannson", "Black Widow", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (92, "Scarlet Johannson", "Natasha Romanova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (92, "Florence Pugh", "Yelena Belova", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (93, "Simu Liu", "Shang-Chi", "male", "Asian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (93, "Awkwafina", "Katy", "female", "Asian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (94, "Angelina Jolie", "Thena", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (94, "Barry Keoghan", "Druig", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (94, "Salma Hayek", "Ajak", "female", "Hispanic");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (94, "Richard Madden", "Ikarus", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (95, "Tom Holland", "Peter Parker", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (95, "Tom Holland", "Spider-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (95, "Benedict Cumberbatch", "Doctor Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (95, "Benedict Cumberbatch", "Stephen Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (95, "Willem Dafoe", "Normon Osborne", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (96, "Benedict Cumberbatch", "Doctor Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (96, "Benedict Cumberbatch", "Stephen Strange", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (97, "Chris Hemsworth", "Thor", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (97, "Christian Bale", "Gorr", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (97, "Natalie Portman", "Jane Foster", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (98, "Letitia Wright", "Shuri", "female", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (99, "Paul Rudd", "Scott Lang", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (99, "Paul Rudd", "Ant-Man", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (99, "Michael Douglas", "Henry Pym", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (99, "Michelle Pfeiffer", "Janet Van Dyne", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (100, "Chris Pratt", "Peter Quill", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (100, "Bradley Cooper", "Rocket Raccoon", "male", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (100, "Vin Diesel", "Groot", "male", "Black");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (101, "Brie Larson", "Carol Danvers", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (101, "Brie Larson", "Captain Marvel", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (90, "Brie Larson", "Captain Marvel", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (72, "Natalie Portman", "Jane Foster", "female", "Caucasian");
INSERT INTO feature_role(feature_id, person, role, gender, ethnicity) VALUES (102, "Robert Downey Jr.", "Sherlock Holmes", "male", "Caucasian");

INSERT INTO role_type(role_id, role_type) values (1, "hero");
INSERT INTO role_type(role_id, role_type) values (1, "spy");
INSERT INTO role_type(role_id, role_type) values (1, "playboy");
INSERT INTO role_type(role_id, role_type) values (2, "hero");
INSERT INTO role_type(role_id, role_type) values (2, "spy");
INSERT INTO role_type(role_id, role_type) values (2, "playboy");
INSERT INTO role_type(role_id, role_type) values (3, "hero");
INSERT INTO role_type(role_id, role_type) values (3, "spy");
INSERT INTO role_type(role_id, role_type) values (3, "playboy");
INSERT INTO role_type(role_id, role_type) values (4, "hero");
INSERT INTO role_type(role_id, role_type) values (4, "spy");
INSERT INTO role_type(role_id, role_type) values (4, "playboy");
INSERT INTO role_type(role_id, role_type) values (5, "hero");
INSERT INTO role_type(role_id, role_type) values (5, "spy");
INSERT INTO role_type(role_id, role_type) values (5, "playboy");
INSERT INTO role_type(role_id, role_type) values (6, "hero");
INSERT INTO role_type(role_id, role_type) values (6, "spy");
INSERT INTO role_type(role_id, role_type) values (6, "playboy");
INSERT INTO role_type(role_id, role_type) values (7, "hero");
INSERT INTO role_type(role_id, role_type) values (7, "spy");
INSERT INTO role_type(role_id, role_type) values (7, "playboy");
INSERT INTO role_type(role_id, role_type) values (8, "hero");
INSERT INTO role_type(role_id, role_type) values (8, "spy");
INSERT INTO role_type(role_id, role_type) values (8, "playboy");
INSERT INTO role_type(role_id, role_type) values (9, "hero");
INSERT INTO role_type(role_id, role_type) values (9, "spy");
INSERT INTO role_type(role_id, role_type) values (9, "playboy");
INSERT INTO role_type(role_id, role_type) values (10, "hero");
INSERT INTO role_type(role_id, role_type) values (10, "spy");
INSERT INTO role_type(role_id, role_type) values (10, "playboy");
INSERT INTO role_type(role_id, role_type) values (11, "hero");
INSERT INTO role_type(role_id, role_type) values (11, "spy");
INSERT INTO role_type(role_id, role_type) values (11, "playboy");
INSERT INTO role_type(role_id, role_type) values (12, "hero");
INSERT INTO role_type(role_id, role_type) values (12, "spy");
INSERT INTO role_type(role_id, role_type) values (12, "playboy");
INSERT INTO role_type(role_id, role_type) values (13, "hero");
INSERT INTO role_type(role_id, role_type) values (13, "spy");
INSERT INTO role_type(role_id, role_type) values (13, "playboy");
INSERT INTO role_type(role_id, role_type) values (14, "hero");
INSERT INTO role_type(role_id, role_type) values (14, "spy");
INSERT INTO role_type(role_id, role_type) values (14, "playboy");
INSERT INTO role_type(role_id, role_type) values (15, "hero");
INSERT INTO role_type(role_id, role_type) values (15, "spy");
INSERT INTO role_type(role_id, role_type) values (15, "playboy");
INSERT INTO role_type(role_id, role_type) values (16, "hero");
INSERT INTO role_type(role_id, role_type) values (16, "spy");
INSERT INTO role_type(role_id, role_type) values (16, "playboy");
INSERT INTO role_type(role_id, role_type) values (17, "hero");
INSERT INTO role_type(role_id, role_type) values (17, "spy");
INSERT INTO role_type(role_id, role_type) values (17, "playboy");
INSERT INTO role_type(role_id, role_type) values (18, "hero");
INSERT INTO role_type(role_id, role_type) values (18, "spy");
INSERT INTO role_type(role_id, role_type) values (18, "playboy");
INSERT INTO role_type(role_id, role_type) values (19, "hero");
INSERT INTO role_type(role_id, role_type) values (19, "spy");
INSERT INTO role_type(role_id, role_type) values (19, "playboy");
INSERT INTO role_type(role_id, role_type) values (20, "hero");
INSERT INTO role_type(role_id, role_type) values (20, "spy");
INSERT INTO role_type(role_id, role_type) values (20, "playboy");
INSERT INTO role_type(role_id, role_type) values (21, "hero");
INSERT INTO role_type(role_id, role_type) values (21, "spy");
INSERT INTO role_type(role_id, role_type) values (21, "playboy");
INSERT INTO role_type(role_id, role_type) values (22, "hero");
INSERT INTO role_type(role_id, role_type) values (22, "spy");
INSERT INTO role_type(role_id, role_type) values (22, "playboy");
INSERT INTO role_type(role_id, role_type) values (23, "hero");
INSERT INTO role_type(role_id, role_type) values (23, "spy");
INSERT INTO role_type(role_id, role_type) values (23, "playboy");
INSERT INTO role_type(role_id, role_type) values (24, "hero");
INSERT INTO role_type(role_id, role_type) values (24, "spy");
INSERT INTO role_type(role_id, role_type) values (24, "playboy");
INSERT INTO role_type(role_id, role_type) values (25, "hero");
INSERT INTO role_type(role_id, role_type) values (25, "spy");
INSERT INTO role_type(role_id, role_type) values (25, "playboy");

INSERT INTO role_type(role_id, role_type) values (26, "hero");
INSERT INTO role_type(role_id, role_type) values (26, "detective");
INSERT INTO role_type(role_id, role_type) values (27, "hero");
INSERT INTO role_type(role_id, role_type) values (27, "detective");
INSERT INTO role_type(role_id, role_type) values (28, "hero");
INSERT INTO role_type(role_id, role_type) values (28, "detective");
INSERT INTO role_type(role_id, role_type) values (29, "hero");
INSERT INTO role_type(role_id, role_type) values (29, "detective");
INSERT INTO role_type(role_id, role_type) values (30, "hero");
INSERT INTO role_type(role_id, role_type) values (30, "detective");

INSERT INTO role_type(role_id, role_type) values (31, "alien");
INSERT INTO role_type(role_id, role_type) values (31, "superhero");
INSERT INTO role_type(role_id, role_type) values (31, "hero");

INSERT INTO role_type(role_id, role_type) values (32, "hero");
INSERT INTO role_type(role_id, role_type) values (32, "reporter");

INSERT INTO role_type(role_id, role_type) values (33, "superhero");
INSERT INTO role_type(role_id, role_type) values (33, "hero");

INSERT INTO role_type(role_id, role_type) values (34, "billionaire");
INSERT INTO role_type(role_id, role_type) values (34, "playboy");
INSERT INTO role_type(role_id, role_type) values (34, "philanthropist");

INSERT INTO role_type(role_id, role_type) values (34, "hero");
INSERT INTO role_type(role_id, role_type) values (34, "CEO");

INSERT INTO role_type(role_id, role_type) values (35, "hero");
INSERT INTO role_type(role_id, role_type) values (35, "thief");
INSERT INTO role_type(role_id, role_type) values (35, "archer");

INSERT INTO role_type(role_id, role_type) values (36, "hero");
INSERT INTO role_type(role_id, role_type) values (36, "thief");
INSERT INTO role_type(role_id, role_type) values (36, "archer");

INSERT INTO role_type(role_id, role_type) values (37, "hero");
INSERT INTO role_type(role_id, role_type) values (37, "thief");
INSERT INTO role_type(role_id, role_type) values (37, "archer");

INSERT INTO role_type(role_id, role_type) values (38, "hero");
INSERT INTO role_type(role_id, role_type) values (38, "thief");
INSERT INTO role_type(role_id, role_type) values (38, "archer");

INSERT INTO role_type(role_id, role_type) values (39, "hero");
INSERT INTO role_type(role_id, role_type) values (39, "magician");
INSERT INTO role_type(role_id, role_type) values (39, "superhero");

INSERT INTO role_type(role_id, role_type) values (40, "doctor");

INSERT INTO role_type(role_id, role_type) values (41, "villain");
INSERT INTO role_type(role_id, role_type) values (41, "playboy");

INSERT INTO role_type(role_id, role_type) values (42, "villain");
INSERT INTO role_type(role_id, role_type) values (42, "CEO");
INSERT INTO role_type(role_id, role_type) values (42, "billionaire");

INSERT INTO role_type(role_id, role_type) values (43, "alien");
INSERT INTO role_type(role_id, role_type) values (43, "superhero");
INSERT INTO role_type(role_id, role_type) values (43, "hero");

INSERT INTO role_type(role_id, role_type) values (44, "hero");
INSERT INTO role_type(role_id, role_type) values (44, "reporter");

INSERT INTO role_type(role_id, role_type) values (45, "CEO");
INSERT INTO role_type(role_id, role_type) values (45, "villain");
INSERT INTO role_type(role_id, role_type) values (45, "billionaire");

INSERT INTO role_type(role_id, role_type) values (46, "politician");
INSERT INTO role_type(role_id, role_type) values (46, "villain");
INSERT INTO role_type(role_id, role_type) values (46, "president");

INSERT INTO role_type(role_id, role_type) values (47, "hero");
INSERT INTO role_type(role_id, role_type) values (47, "mathematician");

INSERT INTO role_type(role_id, role_type) values (48, "detective");
INSERT INTO role_type(role_id, role_type) values (48, "hero");

INSERT INTO role_type(role_id, role_type) values (49, "detective");
INSERT INTO role_type(role_id, role_type) values (49, "hero");

INSERT INTO role_type(role_id, role_type) values (50, "hero");
INSERT INTO role_type(role_id, role_type) values (50, "spy");

INSERT INTO role_type(role_id, role_type) values (51, "spy");

INSERT INTO role_type(role_id, role_type) values (52, "villain");

INSERT INTO role_type(role_id, role_type) values (53, "hero");
INSERT INTO role_type(role_id, role_type) values (53, "assassin");
INSERT INTO role_type(role_id, role_type) values (56, "hero");
INSERT INTO role_type(role_id, role_type) values (56, "assassin");
INSERT INTO role_type(role_id, role_type) values (59, "hero");
INSERT INTO role_type(role_id, role_type) values (59, "assassin");
INSERT INTO role_type(role_id, role_type) values (62, "hero");
INSERT INTO role_type(role_id, role_type) values (62, "assassin");

INSERT INTO role_type(role_id, role_type) values (63, "CEO");
INSERT INTO role_type(role_id, role_type) values (64, "butler");

INSERT INTO role_type(role_id, role_type) values (65, "hero");
INSERT INTO role_type(role_id, role_type) values (65, "assassin");
INSERT INTO role_type(role_id, role_type) values (65, "amnesiac");

INSERT INTO role_type(role_id, role_type) values (66, "hero");
INSERT INTO role_type(role_id, role_type) values (66, "assassin");
INSERT INTO role_type(role_id, role_type) values (66, "amnesiac");

INSERT INTO role_type(role_id, role_type) values (67, "hero");
INSERT INTO role_type(role_id, role_type) values (67, "assassin");
INSERT INTO role_type(role_id, role_type) values (67, "amnesiac");

INSERT INTO role_type(role_id, role_type) values (68, "hero");
INSERT INTO role_type(role_id, role_type) values (68, "assassin");

INSERT INTO role_type(role_id, role_type) values (69, "hero");
INSERT INTO role_type(role_id, role_type) values (69, "assassin");

INSERT INTO role_type(role_id, role_type) values (70, "hero");
INSERT INTO role_type(role_id, role_type) values (70, "hacker");

INSERT INTO role_type(role_id, role_type) values (71, "villain");

INSERT INTO role_type(role_id, role_type) values (72, "hero");
INSERT INTO role_type(role_id, role_type) values (72, "hacker");

INSERT INTO role_type(role_id, role_type) values (73, "hero");
INSERT INTO role_type(role_id, role_type) values (73, "hacker");

INSERT INTO role_type(role_id, role_type) values (74, "hero");
INSERT INTO role_type(role_id, role_type) values (74, "hacker");

INSERT INTO role_type(role_id, role_type) values (75, "villain");

INSERT INTO role_type(role_id, role_type) values (76, "hero");
INSERT INTO role_type(role_id, role_type) values (76, "hacker");

INSERT INTO role_type(role_id, role_type) values (77, "hero");
INSERT INTO role_type(role_id, role_type) values (77, "hacker");

INSERT INTO role_type(role_id, role_type) values (78, "hero");
INSERT INTO role_type(role_id, role_type) values (78, "hacker");

INSERT INTO role_type(role_id, role_type) values (79, "villain");

INSERT INTO role_type(role_id, role_type) values (80, "hero");
INSERT INTO role_type(role_id, role_type) values (80, "hacker");

INSERT INTO role_type(role_id, role_type) values (81, "hero");
INSERT INTO role_type(role_id, role_type) values (81, "hacker");

INSERT INTO role_type(role_id, role_type) values (82, "hero");
INSERT INTO role_type(role_id, role_type) values (82, "hacker");

INSERT INTO role_type(role_id, role_type) values (83, "hero");
INSERT INTO role_type(role_id, role_type) values (83, "hacker");

INSERT INTO role_type(role_id, role_type) values (84, "hero");
INSERT INTO role_type(role_id, role_type) values (84, "assassin");

INSERT INTO role_type(role_id, role_type) values (85, "hero");
INSERT INTO role_type(role_id, role_type) values (85, "assassin");

INSERT INTO role_type(role_id, role_type) values (86, "hero");
INSERT INTO role_type(role_id, role_type) values (86, "assassin");

INSERT INTO role_type(role_id, role_type) values (87, "hero");
INSERT INTO role_type(role_id, role_type) values (87, "assassin");


INSERT INTO role_type(role_id, role_type) values (88, "playboy");
INSERT INTO role_type(role_id, role_type) values (88, "billionaire");

INSERT INTO role_type(role_id, role_type) values (89, "hero");
INSERT INTO role_type(role_id, role_type) values (89, "superhero");

INSERT INTO role_type(role_id, role_type) values (90, "butler");

INSERT INTO role_type(role_id, role_type) values (91, "inventor");

INSERT INTO role_type(role_id, role_type) values (92, "detective");

INSERT INTO role_type(role_id, role_type) values (93, "playboy");
INSERT INTO role_type(role_id, role_type) values (93, "billionaire");

INSERT INTO role_type(role_id, role_type) values (94, "butler");

INSERT INTO role_type(role_id, role_type) values (95, "inventor");

INSERT INTO role_type(role_id, role_type) values (96, "detective");

INSERT INTO role_type(role_id, role_type) values (97, "villain");

INSERT INTO role_type(role_id, role_type) values (98, "playboy");
INSERT INTO role_type(role_id, role_type) values (98, "billionaire");

INSERT INTO role_type(role_id, role_type) values (99, "hero");
INSERT INTO role_type(role_id, role_type) values (99, "superhero");

INSERT INTO role_type(role_id, role_type) values (100, "butler");

INSERT INTO role_type(role_id, role_type) values (101, "inventor");

INSERT INTO role_type(role_id, role_type) values (102, "detective");

INSERT INTO role_type(role_id, role_type) values (103, "villain");


INSERT INTO role_type(role_id, role_type) values (104, "assassin");
INSERT INTO role_type(role_id, role_type) values (105, "hero");
INSERT INTO role_type(role_id, role_type) values (105, "superhero");

INSERT INTO role_type(role_id, role_type) values (106, "assassin");
INSERT INTO role_type(role_id, role_type) values (107, "hero");
INSERT INTO role_type(role_id, role_type) values (107, "superhero");

INSERT INTO role_type(role_id, role_type) values (108, "assassin");
INSERT INTO role_type(role_id, role_type) values (109, "hero");
INSERT INTO role_type(role_id, role_type) values (109, "superhero");

INSERT INTO role_type(role_id, role_type) values (110, "mutant");
INSERT INTO role_type(role_id, role_type) values (111, "hero");
INSERT INTO role_type(role_id, role_type) values (111, "superhero");

INSERT INTO role_type(role_id, role_type) values (112, "astronaut");
INSERT INTO role_type(role_id, role_type) values (112, "hero");

INSERT INTO role_type(role_id, role_type) values (113, "scientist");
INSERT INTO role_type(role_id, role_type) values (113, "professor");

INSERT INTO role_type(role_id, role_type) values (114, "astronaut");

INSERT INTO role_type(role_id, role_type) values (115, "scientist");
INSERT INTO role_type(role_id, role_type) values (115, "hero");

INSERT INTO role_type(role_id, role_type) values (116, "playboy");
INSERT INTO role_type(role_id, role_type) values (116, "billionaire");

INSERT INTO role_type(role_id, role_type) values (117, "hero");
INSERT INTO role_type(role_id, role_type) values (117, "superhero");

INSERT INTO role_type(role_id, role_type) values (118, "villain");
INSERT INTO role_type(role_id, role_type) values (118, "CEO");

INSERT INTO role_type(role_id, role_type) values (119, "god");
INSERT INTO role_type(role_id, role_type) values (119, "hero");
INSERT INTO role_type(role_id, role_type) values (119, "superhero");

INSERT INTO role_type(role_id, role_type) values (120, "god");
INSERT INTO role_type(role_id, role_type) values (138, "god");
INSERT INTO role_type(role_id, role_type) values (177, "god");

INSERT INTO role_type(role_id, role_type) values (121, "soldier");

INSERT INTO role_type(role_id, role_type) values (122, "hero");
INSERT INTO role_type(role_id, role_type) values (122, "superhero");

INSERT INTO role_type(role_id, role_type) values (123, "villain");

INSERT INTO role_type(role_id, role_type) values (124, "god");
INSERT INTO role_type(role_id, role_type) values (124, "hero");
INSERT INTO role_type(role_id, role_type) values (124, "superhero");

INSERT INTO role_type(role_id, role_type) values (125, "soldier");

INSERT INTO role_type(role_id, role_type) values (126, "hero");
INSERT INTO role_type(role_id, role_type) values (126, "superhero");

INSERT INTO role_type(role_id, role_type) values (127, "hero");
INSERT INTO role_type(role_id, role_type) values (127, "superhero");

INSERT INTO role_type(role_id, role_type) values (128, "playboy");
INSERT INTO role_type(role_id, role_type) values (128, "billionaire");

INSERT INTO role_type(role_id, role_type) values (129, "scientist");
INSERT INTO role_type(role_id, role_type) values (129, "hero");

INSERT INTO role_type(role_id, role_type) values (130, "archer");
INSERT INTO role_type(role_id, role_type) values (130, "hero");
INSERT INTO role_type(role_id, role_type) values (130, "superhero");

INSERT INTO role_type(role_id, role_type) values (131, "hero");

INSERT INTO role_type(role_id, role_type) values (132, "spy");
INSERT INTO role_type(role_id, role_type) values (132, "hero");

INSERT INTO role_type(role_id, role_type) values (133, "spy");
INSERT INTO role_type(role_id, role_type) values (134, "hero");
INSERT INTO role_type(role_id, role_type) values (134, "superhero");

INSERT INTO role_type(role_id, role_type) values (142, "thief");
INSERT INTO role_type(role_id, role_type) values (142, "hero");

INSERT INTO role_type(role_id, role_type) values (143, "raccoon");
INSERT INTO role_type(role_id, role_type) values (143, "hero");

INSERT INTO role_type(role_id, role_type) values (169, "raccoon");
INSERT INTO role_type(role_id, role_type) values (169, "hero");

INSERT INTO role_type(role_id, role_type) values (193, "villain");
INSERT INTO role_type(role_id, role_type) values (210, "villain");

INSERT INTO role_type(role_id, role_type) values (242, "raccoon");
INSERT INTO role_type(role_id, role_type) values (242, "hero");

INSERT INTO role_type(role_id, role_type) values (197, "pilot");
INSERT INTO role_type(role_id, role_type) values (209, "pilot");
INSERT INTO role_type(role_id, role_type) values (244, "pilot");

INSERT INTO role_type(role_id, role_type) values (198, "hero");
INSERT INTO role_type(role_id, role_type) values (198, "superhero");

INSERT INTO role_type(role_id, role_type) values (229, "doctor");
INSERT INTO role_type(role_id, role_type) values (232, "doctor");

INSERT INTO role_type(role_id, role_type) values (228, "hero");
INSERT INTO role_type(role_id, role_type) values (228, "magician");
INSERT INTO role_type(role_id, role_type) values (228, "superhero");

INSERT INTO role_type(role_id, role_type) values (165, "professor");
INSERT INTO role_type(role_id, role_type) values (165, "scientist");


INSERT INTO role_type(role_id, role_type) values (163, "villain");

INSERT INTO role_type(role_id, role_type) values (164, "thief");
INSERT INTO role_type(role_id, role_type) values (166, "thief");

INSERT INTO role_type(role_id, role_type) values (167, "CEO");

INSERT INTO role_type(role_id, role_type) values (171, "villain");

INSERT INTO role_type(role_id, role_type) values (178, "villain");
INSERT INTO role_type(role_id, role_type) values (178, "god");

INSERT INTO role_type(role_id, role_type) values (180, "hero");
INSERT INTO role_type(role_id, role_type) values (180, "king");
INSERT INTO role_type(role_id, role_type) values (180, "superhero");

INSERT INTO role_type(role_id, role_type) values (181, "villain");

INSERT INTO role_type(role_id, role_type) values (231, "hero");
INSERT INTO role_type(role_id, role_type) values (231, "magician");
INSERT INTO role_type(role_id, role_type) values (231, "superhero");

INSERT INTO role_type(role_id, role_type) values (235, "scientist");
INSERT INTO role_type(role_id, role_type) values (247, "scientist");

INSERT INTO role_type(role_id, role_type) values (240, "scientist");
INSERT INTO role_type(role_id, role_type) values (240, "hero");
INSERT INTO role_type(role_id, role_type) values (240, "superhero");

INSERT INTO role_type(role_id, role_type) values (245, "hero");
INSERT INTO role_type(role_id, role_type) values (245, "superhero");

INSERT INTO role_type(role_id, role_type) values (246, "hero");
INSERT INTO role_type(role_id, role_type) values (246, "superhero");


INSERT INTO role_type(role_id, role_type) values (168, "thief");
INSERT INTO role_type(role_id, role_type) values (168, "hero");

INSERT INTO role_type(role_id, role_type) values (241, "thief");
INSERT INTO role_type(role_id, role_type) values (241, "hero");

INSERT INTO role_type(role_id, role_type) values (144, "tree");
INSERT INTO role_type(role_id, role_type) values (144, "hero");

INSERT INTO role_type(role_id, role_type) values (170, "tree");
INSERT INTO role_type(role_id, role_type) values (170, "hero");

INSERT INTO role_type(role_id, role_type) values (243, "tree");
INSERT INTO role_type(role_id, role_type) values (243, "hero");

INSERT INTO role_type(role_id, role_type) values (154, "spy");
INSERT INTO role_type(role_id, role_type) values (155, "hero");
INSERT INTO role_type(role_id, role_type) values (155, "superhero");

INSERT INTO role_type(role_id, role_type) values (154, "thief");

INSERT INTO role_type(role_id, role_type) values (175, "thief");
INSERT INTO role_type(role_id, role_type) values (175, "pilot");

INSERT INTO role_type(role_id, role_type) values (194, "thief");
INSERT INTO role_type(role_id, role_type) values (211, "thief");
INSERT INTO role_type(role_id, role_type) values (237, "thief");

INSERT INTO role_type(role_id, role_type) values (216, "bodyguard");

INSERT INTO role_type(role_id, role_type) values (219, "assassin");

INSERT INTO role_type(role_id, role_type) values (157, "hero");
INSERT INTO role_type(role_id, role_type) values (157, "superhero");

INSERT INTO role_type(role_id, role_type) values (158, "scientist");
INSERT INTO role_type(role_id, role_type) values (158, "inventor");

INSERT INTO role_type(role_id, role_type) values (196, "scientist");
INSERT INTO role_type(role_id, role_type) values (196, "inventor");

INSERT INTO role_type(role_id, role_type) values (230, "villain");
INSERT INTO role_type(role_id, role_type) values (230, "CEO");

INSERT INTO role_type(role_id, role_type) values (234, "villain");
INSERT INTO role_type(role_id, role_type) values (234, "butcher");

INSERT INTO role_type(role_id, role_type) values (236, "scientist");
INSERT INTO role_type(role_id, role_type) values (236, "inventor");

INSERT INTO role_type(role_id, role_type) values (239, "scientist");
INSERT INTO role_type(role_id, role_type) values (239, "inventor");

INSERT INTO role_type(role_id, role_type) values (195, "hero");
INSERT INTO role_type(role_id, role_type) values (195, "superhero");

INSERT INTO role_type(role_id, role_type) values (212, "hero");
INSERT INTO role_type(role_id, role_type) values (212, "superhero");

INSERT INTO role_type(role_id, role_type) values (238, "hero");
INSERT INTO role_type(role_id, role_type) values (238, "superhero");

INSERT INTO role_type(role_id, role_type) values (161, "spy");

INSERT INTO role_type(role_id, role_type) values (191, "spy");
INSERT INTO role_type(role_id, role_type) values (192, "hero");
INSERT INTO role_type(role_id, role_type) values (192, "superhero");

INSERT INTO role_type(role_id, role_type) values (217, "hero");
INSERT INTO role_type(role_id, role_type) values (217, "superhero");
INSERT INTO role_type(role_id, role_type) values (218, "spy");

INSERT INTO role_type(role_id, role_type) values (141, "spy");
INSERT INTO role_type(role_id, role_type) values (141, "hero");

INSERT INTO role_type(role_id, role_type) values (153, "spy");
INSERT INTO role_type(role_id, role_type) values (153, "hero");

INSERT INTO role_type(role_id, role_type) values (162, "spy");
INSERT INTO role_type(role_id, role_type) values (162, "hero");

INSERT INTO role_type(role_id, role_type) values (190, "spy");
INSERT INTO role_type(role_id, role_type) values (190, "hero");

INSERT INTO role_type(role_id, role_type) values (199, "spy");
INSERT INTO role_type(role_id, role_type) values (199, "hero");

INSERT INTO role_type(role_id, role_type) values (208, "spy");
INSERT INTO role_type(role_id, role_type) values (208, "hero");

INSERT INTO role_type(role_id, role_type) values (215, "spy");
INSERT INTO role_type(role_id, role_type) values (215, "hero");

INSERT INTO role_type(role_id, role_type) values (135, "hero");
INSERT INTO role_type(role_id, role_type) values (135, "superhero");

INSERT INTO role_type(role_id, role_type) values (149, "hero");
INSERT INTO role_type(role_id, role_type) values (149, "superhero");

INSERT INTO role_type(role_id, role_type) values (186, "hero");
INSERT INTO role_type(role_id, role_type) values (186, "superhero");

INSERT INTO role_type(role_id, role_type) values (203, "hero");
INSERT INTO role_type(role_id, role_type) values (203, "superhero");

INSERT INTO role_type(role_id, role_type) values (136, "playboy");
INSERT INTO role_type(role_id, role_type) values (136, "billionaire");

INSERT INTO role_type(role_id, role_type) values (148, "playboy");
INSERT INTO role_type(role_id, role_type) values (148, "billionaire");

INSERT INTO role_type(role_id, role_type) values (174, "playboy");
INSERT INTO role_type(role_id, role_type) values (174, "billionaire");

INSERT INTO role_type(role_id, role_type) values (185, "playboy");
INSERT INTO role_type(role_id, role_type) values (185, "billionaire");

INSERT INTO role_type(role_id, role_type) values (204, "playboy");
INSERT INTO role_type(role_id, role_type) values (204, "billionaire");

INSERT INTO role_type(role_id, role_type) values (150, "scientist");
INSERT INTO role_type(role_id, role_type) values (150, "hero");

INSERT INTO role_type(role_id, role_type) values (179, "scientist");
INSERT INTO role_type(role_id, role_type) values (179, "hero");

INSERT INTO role_type(role_id, role_type) values (187, "scientist");
INSERT INTO role_type(role_id, role_type) values (187, "hero");

INSERT INTO role_type(role_id, role_type) values (205, "scientist");
INSERT INTO role_type(role_id, role_type) values (205, "hero");

INSERT INTO role_type(role_id, role_type) values (151, "archer");
INSERT INTO role_type(role_id, role_type) values (151, "hero");
INSERT INTO role_type(role_id, role_type) values (151, "superhero");

INSERT INTO role_type(role_id, role_type) values (189, "archer");
INSERT INTO role_type(role_id, role_type) values (189, "hero");
INSERT INTO role_type(role_id, role_type) values (189, "superhero");

INSERT INTO role_type(role_id, role_type) values (207, "archer");
INSERT INTO role_type(role_id, role_type) values (207, "hero");
INSERT INTO role_type(role_id, role_type) values (207, "superhero");

INSERT INTO role_type(role_id, role_type) values (131, "spy");

INSERT INTO role_type(role_id, role_type) values (152, "spy");

INSERT INTO role_type(role_id, role_type) values (188, "spy");

INSERT INTO role_type(role_id, role_type) values (206, "spy");

INSERT INTO role_type(role_id, role_type) values (137, "god");
INSERT INTO role_type(role_id, role_type) values (137, "hero");
INSERT INTO role_type(role_id, role_type) values (137, "superhero");

INSERT INTO role_type(role_id, role_type) values (145, "god");
INSERT INTO role_type(role_id, role_type) values (145, "hero");
INSERT INTO role_type(role_id, role_type) values (145, "superhero");

INSERT INTO role_type(role_id, role_type) values (176, "god");
INSERT INTO role_type(role_id, role_type) values (176, "hero");
INSERT INTO role_type(role_id, role_type) values (176, "superhero");

INSERT INTO role_type(role_id, role_type) values (200, "god");
INSERT INTO role_type(role_id, role_type) values (200, "hero");
INSERT INTO role_type(role_id, role_type) values (200, "superhero");

INSERT INTO role_type(role_id, role_type) values (233, "god");
INSERT INTO role_type(role_id, role_type) values (233, "hero");
INSERT INTO role_type(role_id, role_type) values (233, "superhero");

INSERT INTO role_type(role_id, role_type) values (172, "scientist");
INSERT INTO role_type(role_id, role_type) values (172, "student");

INSERT INTO role_type(role_id, role_type) values (213, "scientist");
INSERT INTO role_type(role_id, role_type) values (213, "student");

INSERT INTO role_type(role_id, role_type) values (220, "hero");
INSERT INTO role_type(role_id, role_type) values (220, "superhero");

INSERT INTO role_type(role_id, role_type) values (221, "hero");

INSERT INTO role_type(role_id, role_type) values (222, "hero");
INSERT INTO role_type(role_id, role_type) values (222, "alien");
INSERT INTO role_type(role_id, role_type) values (222, "superhero");

INSERT INTO role_type(role_id, role_type) values (223, "hero");
INSERT INTO role_type(role_id, role_type) values (223, "alien");
INSERT INTO role_type(role_id, role_type) values (223, "superhero");

INSERT INTO role_type(role_id, role_type) values (224, "hero");
INSERT INTO role_type(role_id, role_type) values (224, "alien");
INSERT INTO role_type(role_id, role_type) values (224, "superhero");

INSERT INTO role_type(role_id, role_type) values (225, "hero");
INSERT INTO role_type(role_id, role_type) values (225, "villain");
INSERT INTO role_type(role_id, role_type) values (225, "alien");
INSERT INTO role_type(role_id, role_type) values (225, "superhero");

INSERT INTO role_type(role_id, role_type) values (226, "scientist");
INSERT INTO role_type(role_id, role_type) values (226, "student");

INSERT INTO role_type(role_id, role_type) values (173, "hero");
INSERT INTO role_type(role_id, role_type) values (173, "superhero");

INSERT INTO role_type(role_id, role_type) values (214, "hero");
INSERT INTO role_type(role_id, role_type) values (214, "superhero");

INSERT INTO role_type(role_id, role_type) values (227, "hero");
INSERT INTO role_type(role_id, role_type) values (227, "superhero");

INSERT INTO role_type(role_id, role_type) values (248, "hero");
INSERT INTO role_type(role_id, role_type) values (248, "detective");

INSERT INTO franchises(name, studio) values ("Marvel Cinematic Universe", "Marvel Studios");
INSERT INTO franchises(name, studio) values ("James Bond", "United Pictures");
INSERT INTO franchises(name, studio) values ("DC Extended Universe", "Warner Bros.");
INSERT INTO franchises(name, studio) values ("Batman", "Warner Pictures");
INSERT INTO franchises(name, studio) values ("Knives Out", "Lionsgate");
INSERT INTO franchises(name, studio) values ("John Wick", "Lionsgate");
INSERT INTO franchises(name, studio) values ("Jason Bourne", "Universal Pictures");
INSERT INTO franchises(name, studio) values ("Deadpool", "Sony Pictures");
INSERT INTO franchises(name, studio) values ("The Matrix", "Warner Bros.");
INSERT INTO franchises(name, studio) values ("The Equalizer", "Sony Pictures.");
INSERT INTO franchises(name, studio) values ("Sherlock Holmes", "Warner Bros.");


INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (1, 2, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (2, 2, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (3, 2, 3);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (4, 2, 4);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (5, 2, 5);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (6, 2, 6);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (7, 2, 7);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (8, 2, 8);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (9, 2, 9);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (10, 2, 10);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (11, 2, 11);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (12, 2, 12);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (13, 2, 13);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (14, 2, 14);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (15, 2, 15);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (16, 2, 16);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (17, 2, 17);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (18, 2, 18);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (19, 2, 19);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (20, 2, 20);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (21, 2, 21);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (22, 2, 22);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (23, 2, 23);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (24, 2, 24);


INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (32, 1, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (70, 1, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (73, 1, 3);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (71, 1, 4);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (72, 1, 5);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (74, 1, 6);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (75, 1, 7);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (76, 1, 8);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (77, 1, 9);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (78, 1, 10);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (79, 1, 11);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (80, 1, 12);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (37, 1, 13);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (81, 1, 14);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (83, 1, 15);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (84, 1, 16);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (85, 1, 17);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (86, 1, 18);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (87, 1, 19);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (88, 1, 20);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (89, 1, 21);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (90, 1, 22);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (91, 1, 23);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (92, 1, 24);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (93, 1, 25);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (94, 1, 26);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (95, 1, 27);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (96, 1, 28);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (97, 1, 29);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (98, 1, 30);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (99, 1, 31);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (100, 1, 32);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (101, 1, 33);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (68, 1, 34);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (63, 4, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (64, 4, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (65, 4, 3);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (31, 3, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (39, 3, 2);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (43, 5, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (44, 5, 2);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (46, 6, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (47, 6, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (48, 6, 3);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (49, 6, 4);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (50, 7, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (51, 7, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (52, 7, 3);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (53, 7, 4);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (54, 7, 5);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (66, 8, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (67, 8, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (68, 8, 3);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (55, 9, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (56, 9, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (57, 9, 3);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (58, 9, 4);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (60, 10, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (61, 10, 2);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (62, 10, 3);

INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (27, 11, 1);
INSERT INTO franchise_features(feature_id, franchise_id, franchise_number) values (102, 11, 2);


INSERT INTO currencies(currency_name, currency_symbol) values ("US Dollar", "USD");
INSERT INTO currencies(currency_name, currency_symbol) values ("Euro", "EUR");
INSERT INTO currencies(currency_name, currency_symbol) values ("UK Pound", "UKP");
INSERT INTO currencies(currency_name, currency_symbol) values ("Canadian Dollar", "CAD");
INSERT INTO currencies(currency_name, currency_symbol) values ("Australian Dollar", "AUD");

# Bond movie budgets

INSERT INTO budget(feature_id, currency_id, amount) values (1, 1, 1000000);
INSERT INTO budget(feature_id, currency_id, amount) values (2, 1, 2000000);
INSERT INTO budget(feature_id, currency_id, amount) values (3, 1, 3000000);
INSERT INTO budget(feature_id, currency_id, amount) values (4, 1, 9000000);
INSERT INTO budget(feature_id, currency_id, amount) values (5, 1, 9500000);
INSERT INTO budget(feature_id, currency_id, amount) values (6, 1, 8000000);
INSERT INTO budget(feature_id, currency_id, amount) values (7, 1, 7200000);
INSERT INTO budget(feature_id, currency_id, amount) values (8, 1, 7000000);
INSERT INTO budget(feature_id, currency_id, amount) values (9, 1, 7000000);
INSERT INTO budget(feature_id, currency_id, amount) values (10, 1, 14000000);
INSERT INTO budget(feature_id, currency_id, amount) values (11, 1, 31000000);
INSERT INTO budget(feature_id, currency_id, amount) values (12, 1, 28000000);
INSERT INTO budget(feature_id, currency_id, amount) values (13, 1, 27500000);
INSERT INTO budget(feature_id, currency_id, amount) values (14, 1, 30000000);
INSERT INTO budget(feature_id, currency_id, amount) values (15, 1, 40000000);
INSERT INTO budget(feature_id, currency_id, amount) values (16, 1, 42000000);
INSERT INTO budget(feature_id, currency_id, amount) values (17, 1, 60000000);
INSERT INTO budget(feature_id, currency_id, amount) values (18, 1, 110000000);
INSERT INTO budget(feature_id, currency_id, amount) values (19, 1, 135000000);
INSERT INTO budget(feature_id, currency_id, amount) values (20, 1, 142000000);
INSERT INTO budget(feature_id, currency_id, amount) values (21, 1, 102000000);
INSERT INTO budget(feature_id, currency_id, amount) values (22, 1, 230000000);
INSERT INTO budget(feature_id, currency_id, amount) values (23, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (24, 1, 245000000);
INSERT INTO budget(feature_id, currency_id, amount) values (25, 1, 250000000);

# Bond movie domestic grosses

INSERT INTO domestic_gross(feature_id, currency_id, amount) values (1, 1, 16067035);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (2, 1, 24800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (3, 1, 51100000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (4, 1, 63600000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (5, 1, 43100000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (6, 1, 22800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (7, 1, 43800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (8, 1, 35400000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (9, 1, 21000000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (10, 1, 46800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (11, 1, 70300000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (12, 1, 54800000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (13, 1, 67900000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (14, 1, 50327000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (15, 1, 51185000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (16, 1, 34667015);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (17, 1, 106429941);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (18, 1, 125304276);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (19, 1, 126930660);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (20, 1, 160942139);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (21, 1, 167365000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (22, 1, 169368427);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (23, 1, 304360277);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (24, 1, 200074175);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (25, 1, 160891007);

# Bond movie international grosses

INSERT INTO international_gross(feature_id, currency_id, amount) values (1, 1, 59567035 - 16067035);
INSERT INTO international_gross(feature_id, currency_id, amount) values (2, 1, 78900000 - 24800000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (3, 1, 124900000 - 51100000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (4, 1, 141200000 - 63600000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (5, 1, 111600000 - 43100000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (6, 1, 82000000 - 22800000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (7, 1, 115999985 - 43800000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (8, 1, 161800000 - 35400000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (9, 1, 97600000 - 21000000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (10, 1, 185400000 - 46800000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (11, 1, 210300000 - 70300000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (12, 1, 195300000 - 54800000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (13, 1, 187500000 - 67900000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (14, 1, 152627960 - 50327000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (15, 1, 191199996 - 51185000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (16, 1, 156167015 - 34667015);
INSERT INTO international_gross(feature_id, currency_id, amount) values (17, 1, 356429933 - 106429941);
INSERT INTO international_gross(feature_id, currency_id, amount) values (18, 1, 339504276 - 125304276);
INSERT INTO international_gross(feature_id, currency_id, amount) values (19, 1, 361730600 - 126930660);
INSERT INTO international_gross(feature_id, currency_id, amount) values (20, 1, 431942139 - 160942139);
INSERT INTO international_gross(feature_id, currency_id, amount) values (21, 1, 594420216 - 167365000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (22, 1, 591692078 - 169368427);
INSERT INTO international_gross(feature_id, currency_id, amount) values (23, 1, 1110526981 - 304360277);
INSERT INTO international_gross(feature_id, currency_id, amount) values (24, 1, 879077344 - 200074175);
INSERT INTO international_gross(feature_id, currency_id, amount) values (25, 1, 758929771 - 160891007);


# The Matrix

INSERT INTO budget(feature_id, currency_id, amount) values (55, 1, 65000000);
INSERT INTO budget(feature_id, currency_id, amount) values (56, 1, 150000000);
INSERT INTO budget(feature_id, currency_id, amount) values (57, 1, 150000000);
INSERT INTO budget(feature_id, currency_id, amount) values (58, 1, 190000000);


INSERT INTO domestic_gross(feature_id, currency_id, amount) values (55, 1, 173993387);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (56, 1, 281553689);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (57, 1, 139270910);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (58, 1, 40463197);

INSERT INTO international_gross(feature_id, currency_id, amount) values (55, 1, 291980811);
INSERT INTO international_gross(feature_id, currency_id, amount) values (56, 1, 457023240);
INSERT INTO international_gross(feature_id, currency_id, amount) values (57, 1, 288029350);
INSERT INTO international_gross(feature_id, currency_id, amount) values (58, 1, 118734558);

# The Equalizer

INSERT INTO budget(feature_id, currency_id, amount) values (60, 1, 55000000);
INSERT INTO budget(feature_id, currency_id, amount) values (61, 1, 77000000);
INSERT INTO budget(feature_id, currency_id, amount) values (62, 1,  85000000);


INSERT INTO domestic_gross(feature_id, currency_id, amount) values (60, 1, 101530738);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (61, 1, 102084362);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (62, 1,  92373751);

INSERT INTO international_gross(feature_id, currency_id, amount) values (60, 1, 91372886);
INSERT INTO international_gross(feature_id, currency_id, amount) values (61, 1, 88291819);
INSERT INTO international_gross(feature_id, currency_id, amount) values (62, 1, 93312813);

# Jason Bourne

INSERT INTO budget(feature_id, currency_id, amount) values (50, 1, 60000000);
INSERT INTO budget(feature_id, currency_id, amount) values (51, 1, 85000000);
INSERT INTO budget(feature_id, currency_id, amount) values (52, 1, 130000000);
INSERT INTO budget(feature_id, currency_id, amount) values (53, 1, 125000000);
INSERT INTO budget(feature_id, currency_id, amount) values (54, 1, 120000000);


INSERT INTO domestic_gross(feature_id, currency_id, amount) values (50, 1, 121468960);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (51, 1, 176087450);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (52, 1, 227471070);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (53, 1, 113203870);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (54, 1, 162192920);

INSERT INTO international_gross(feature_id, currency_id, amount) values (50, 1, 92888411);
INSERT INTO international_gross(feature_id, currency_id, amount) values (51, 1, 134913674);
INSERT INTO international_gross(feature_id, currency_id, amount) values (52, 1, 216572326);
INSERT INTO international_gross(feature_id, currency_id, amount) values (53, 1, 167152050);
INSERT INTO international_gross(feature_id, currency_id, amount) values (54, 1, 253975396);

# MCU movies

INSERT INTO budget(feature_id, currency_id, amount) values (32, 1, 186000000);
INSERT INTO budget(feature_id, currency_id, amount) values (70, 1, 137500000);
INSERT INTO budget(feature_id, currency_id, amount) values (73, 1, 170000000);
INSERT INTO budget(feature_id, currency_id, amount) values (71, 1, 150000000);
INSERT INTO budget(feature_id, currency_id, amount) values (72, 1, 140000000);
INSERT INTO budget(feature_id, currency_id, amount) values (74, 1, 225000000);
INSERT INTO budget(feature_id, currency_id, amount) values (75, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (76, 1, 150000000);
INSERT INTO budget(feature_id, currency_id, amount) values (77, 1, 170000000);
INSERT INTO budget(feature_id, currency_id, amount) values (78, 1, 170000000);
INSERT INTO budget(feature_id, currency_id, amount) values (79, 1, 365000000);
INSERT INTO budget(feature_id, currency_id, amount) values (80, 1, 130000000);
INSERT INTO budget(feature_id, currency_id, amount) values (37, 1, 250000000);
INSERT INTO budget(feature_id, currency_id, amount) values (81, 1, 165000000);
INSERT INTO budget(feature_id, currency_id, amount) values (83, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (84, 1, 175000000);
INSERT INTO budget(feature_id, currency_id, amount) values (85, 1, 180000000);
INSERT INTO budget(feature_id, currency_id, amount) values (86, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (87, 1, 300000000);
INSERT INTO budget(feature_id, currency_id, amount) values (88, 1, 130000000);
INSERT INTO budget(feature_id, currency_id, amount) values (89, 1, 175000000);
INSERT INTO budget(feature_id, currency_id, amount) values (90, 1, 400000000);
INSERT INTO budget(feature_id, currency_id, amount) values (91, 1, 160000000);
INSERT INTO budget(feature_id, currency_id, amount) values (92, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (93, 1, 150000000);
INSERT INTO budget(feature_id, currency_id, amount) values (94, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (95, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (96, 1, 250000000);
INSERT INTO budget(feature_id, currency_id, amount) values (97, 1, 250000000);
INSERT INTO budget(feature_id, currency_id, amount) values (98, 1, 250000000);
INSERT INTO budget(feature_id, currency_id, amount) values (99, 1, 200000000);
INSERT INTO budget(feature_id, currency_id, amount) values (100, 1, 250000000);
INSERT INTO budget(feature_id, currency_id, amount) values (101, 1, 274800000);


INSERT INTO domestic_gross(feature_id, currency_id, amount) values (32, 1, 318604126);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (70, 1, 134806913);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (73, 1, 312433331);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (71, 1, 181030624);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (72, 1, 176654505);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (74, 1, 623357910);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (75, 1, 408992272);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (76, 1, 206362140);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (77, 1, 259746958);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (78, 1, 333714112);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (79, 1, 459005868);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (80, 1, 180202163);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (37, 1, 232641920);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (81, 1, 408084349);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (83, 1, 389613101);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (84, 1, 334201140);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (85, 1, 315058289);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (86, 1, 700059566);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (87, 1, 678815482);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (88, 1, 216648740);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (89, 1, 426829839);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (90, 1, 858373000);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (91, 1, 390535085);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (92, 1, 183651655);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (93, 1, 224543292);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (94, 1, 164870264);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (95, 1, 814115070);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (96, 1, 411331607);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (97, 1, 343256830);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (98, 1, 453829080);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (99, 1, 214506090);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (100, 1, 358995815);
INSERT INTO domestic_gross(feature_id, currency_id, amount) values (101, 1,  84500223);

INSERT INTO international_gross(feature_id, currency_id, amount) values (32, 1, 585171547 - 318604126);
INSERT INTO international_gross(feature_id, currency_id, amount) values (70, 1, 265573859 - 134806913);
INSERT INTO international_gross(feature_id, currency_id, amount) values (73, 1, 621156389 - 312433331);
INSERT INTO international_gross(feature_id, currency_id, amount) values (71, 1, 449326618 - 181030624);
INSERT INTO international_gross(feature_id, currency_id, amount) values (72, 1, 370569776 - 176654505);
INSERT INTO international_gross(feature_id, currency_id, amount) values (74, 1, 1515100211 - 623357910);
INSERT INTO international_gross(feature_id, currency_id, amount) values (75, 1, 1215392272 - 408992272);
INSERT INTO international_gross(feature_id, currency_id, amount) values (76, 1, 644602516 - 206362140);
INSERT INTO international_gross(feature_id, currency_id, amount) values (77, 1, 714401889 - 259746958);
INSERT INTO international_gross(feature_id, currency_id, amount) values (78, 1, 770882395 - 333714112);
INSERT INTO international_gross(feature_id, currency_id, amount) values (79, 1, 1395316979 - 459005868);
INSERT INTO international_gross(feature_id, currency_id, amount) values (80, 1, 518858449 - 180202163);
INSERT INTO international_gross(feature_id, currency_id, amount) values (37, 1, 676343174 - 232641920);
INSERT INTO international_gross(feature_id, currency_id, amount) values (81, 1, 1151899586 - 408084349);
INSERT INTO international_gross(feature_id, currency_id, amount) values (83, 1, 869087963 - 389613101);
INSERT INTO international_gross(feature_id, currency_id, amount) values (84, 1, 878271291 - 334201140);
INSERT INTO international_gross(feature_id, currency_id, amount) values (85, 1, 850482778 - 315058289);
INSERT INTO international_gross(feature_id, currency_id, amount) values (86, 1, 1336494320 - 700059566);
INSERT INTO international_gross(feature_id, currency_id, amount) values (87, 1, 2048359754 - 678815482);
INSERT INTO international_gross(feature_id, currency_id, amount) values (88, 1, 623144660 - 216648740);
INSERT INTO international_gross(feature_id, currency_id, amount) values (89, 1, 1129576094 - 426829839);
INSERT INTO international_gross(feature_id, currency_id, amount) values (90, 1, 2788912285 - 858373000);
INSERT INTO international_gross(feature_id, currency_id, amount) values (91, 1, 1132107522 - 390535085);
INSERT INTO international_gross(feature_id, currency_id, amount) values (92, 1, 379751131 - 183651655);
INSERT INTO international_gross(feature_id, currency_id, amount) values (93, 1, 432224634 - 224543292);
INSERT INTO international_gross(feature_id, currency_id, amount) values (94, 1, 401731759 - 164870264);
INSERT INTO international_gross(feature_id, currency_id, amount) values (95, 1, 1907836254 - 814115070);
INSERT INTO international_gross(feature_id, currency_id, amount) values (96, 1, 952224986 - 411331607);
INSERT INTO international_gross(feature_id, currency_id, amount) values (97, 1, 760928081 - 343256830);
INSERT INTO international_gross(feature_id, currency_id, amount) values (98, 1, 853985546 - 453829080);
INSERT INTO international_gross(feature_id, currency_id, amount) values (99, 1, 463635303 - 214506090);
INSERT INTO international_gross(feature_id, currency_id, amount) values (100, 1, 845468744 - 358995815);
INSERT INTO international_gross(feature_id, currency_id, amount) values (101, 1, 199706250 - 84500223);

-- Here we populate the new tables with records created from ChatGPT
INSERT INTO users (name, username, password, email, account_creation_date) VALUES
('James Holloway', 'coolfalcon', 'Z9yLq!4MvT', 'jamesh@example.com', '2021-08-14'),
('Nina Lopez', 'ninastar', 'pW1vHt3KqX', 'nina.lopez@mail.com', '2020-02-02'),
('Tom Raines', 'filmfanatic', 'mT!8uWej47', 'raines.tom@site.org', '2022-07-10'),
('Sarah Mendez', 'moviebuff92', 'Km4@xRt01q', 'sarah.m@inbox.org', '2019-12-05'),
('Leo Tang', 'leotang', 'vRtL94%xas', 'leo.tang@news.tv', '2023-01-15'),
('Sophie Yang', 'sophyy', 'HsD33&lmk', 's.yang@cinehub.io', '2022-03-09'),
('Milo Drake', 'mdrake', 'Ql9*bvsN6!', 'milo.d@gmail.com', '2021-11-24'),
('Isla Morgan', 'isla_reviews', 'Zx2!nOppl', 'morgan.isla@film.com', '2020-10-18'),
('Ayaan Patel', 'ayaaaan', 'Np3yF!6pR', 'ayaan@nyt.com', '2019-06-11'),
('Zara Bloom', 'zarabloom', 'HdR#7wp34', 'z.bloom@domain.com', '2022-12-22'),
('Caleb McCarthy', 'calebmcc', 'Gp2^!fX7zq', 'caleb@filmdaily.org', '2020-06-09'),
('Victoria Ayers', 'vicayers', 'tM9&znr5C@', 'v.ayers@moviespot.org', '2021-11-01'),
('Annette Rowe', 'arowe', '7ZuH5x&d%3', 'annette@moviewatch.net', '2023-08-26'),
('Melody Hart', 'melhart', 'MpY9a!4hLq', 'melody@collider.com', '2024-01-19'),
('Brianna Hayes', 'brih', 'N6^rbgj#Us', 'brianna@filmthreat.org', '2022-09-11'),
('Isaac Silva', 'isaacs', 'Vz1_(BR#ml', 'isaac.silva@watchflix.tv', '2022-06-04'),
('Wesley Tucker', 'westuck', '5f%2hN+E@q', 'wesley@theguardian.co.uk', '2020-02-17'),
('Tina Huff', 'tinah', 'X!pzRm08w_', 'tina@filmjunkie.org', '2021-03-23'),
('Derek Craig', 'dcraig', 'c7^MBrLu@4', 'derek@buzzfeedmedia.com', '2023-03-16'),
('Michele Benson', 'micheleb', 'p0!YW_jnR9', 'm.benson@flikzone.io', '2021-09-27'),
('Ross Flowers', 'rossf', '8Zkd9@#WT_', 'ross@watchhub.net', '2019-10-06'),
('Francis Morrison', 'franmo', 'z^J#27mVXq', 'francis@flixmail.org', '2023-11-11'),
('Carmen Oconnor', 'carmenoc', 'Tv)9!d_M83', 'carmen@streamclub.io', '2022-05-02'),
('Emily Waters', 'emilyw', 'm_Zg@0v32L', 'emily@cineplanet.tv', '2021-07-04'),
('Henry Boone', 'henryb', 'W&Zmqp9#Kb', 'henry@filmscape.net', '2020-03-30'),
('Kai Okafor', 'ko.reel', 'lMi98$nsQ1', 'kai.okafor@cinelife.io', '2021-05-30'),
('Olivia Shepard', 'oliviashep', 'gT6@pLm#94', 'oshepard@watchmail.org', '2021-10-05'),
('Jasper Vaughn', 'j_vaughn', 'L#9utYr3n!', 'jasperv@media.net', '2020-01-12'),
('Natalie Rhodes', 'nat_rhodes', 'Hdq2@#MnvX', 'nrhodes@cinezone.tv', '2022-04-28'),
('Marcus Klein', 'kleinfilms', 'Rt6!Wxz1Tq', 'm.klein@viewpoint.org', '2019-08-20'),
('Hailey Monroe', 'haileym', 'Bv7#qLpNw!', 'hmonroe@filmfeed.io', '2023-06-03'),
('Dylan Parker', 'parkerd', 'zLp3!nMv84', 'dparker@buzzstream.net', '2022-10-14'),
('Elena Griggs', 'elenag', 'Mq4$Zynp2!', 'elena.g@indieflicks.com', '2020-11-08'),
('Omar Delgado', 'odelgado22', 'Xv!19nLp#r', 'omar.d@reviewdaily.org', '2021-02-01'),
('Lily Nguyen', 'lilyreviews', 'Hs8@!LpNmv', 'lnguyen@critiquehub.io', '2019-05-17'),
('Brandon Ray', 'brayfilm', 'Np5@xR7Tq!', 'brandon.ray@flixbase.net', '2023-02-25'),
('Autumn Lee', 'autumnl', 'Wr!27qZnbv', 'autumn.lee@movieshare.org', '2021-12-19'),
('Julian Bishop', 'julianb', 'Yx3#pNvTz!', 'jbishop@silverreel.tv', '2020-06-27'),
('Naomi Finch', 'naomif', 'Kp!8zMnTq3', 'naomi.finch@cinereel.org', '2022-01-31'),
('Eli Brooks', 'elibrooks', 'Mz9^qRnXp!', 'eli.b@filmzone.io', '2023-09-08'),
('Clara Dean', 'clarad', 'Hp7@xLnwZ!', 'clara.d@filmframe.org', '2020-04-22'),
('Trevor Miles', 'tmiles', 'Fx2@LnVz!8', 'tmiles@screenpeek.com', '2021-08-02'),
('Bianca Curtis', 'biancac', 'Nq6^TzPlr!', 'bcurtis@criticscloud.org', '2019-03-11'),
('Grant Howell', 'ghowell', 'Tp9!MnLx2#', 'grant.h@watchloop.net', '2022-07-29'),
('Kayla Benson', 'kaylab', 'Zy#3nPtLx!', 'kayla.benson@streamrate.org', '2020-10-06'),
('Oscar Freeman', 'ofreeman', 'Lr!89XnvP#', 'ofreeman@filmreviewer.io', '2023-01-17'),
('Jade Ramsey', 'jade_r', 'Mq#4pXtNlz', 'jade.r@scenecritique.net', '2021-04-15'),
('Tristan Meyer', 'tmeyerfilm', 'Kx7!PnZwq#', 'tristan.m@moviespot.org', '2020-09-05'),
('Maya Shah', 'mayashah', 'Xv!93zNptL', 'maya.shah@reviewnow.io', '2022-06-11'),
('Cole Bennett', 'coleb', 'Vq9#LnWxP!', 'cole.b@cinepanel.org', '2023-10-28'),
('Vivian Blake', 'vblake', 'Tp@74nXmL#', 'vivian.blake@reelfeed.com', '2019-12-30'),
('Noah Sullivan', 'nsullivan', 'Zx2!LpTnYq', 'noah.s@movietalk.tv', '2020-07-03'),
('Anya Cross', 'anyacross', 'Lt!9wRpnXZ', 'anya.cross@screenwatcher.net', '2021-05-27'),
('Cody Barrett', 'codyb', 'M9@znLx!Tv', 'cody.barrett@filmwire.org', '2022-03-21'),
('Keira Walton', 'keiraw', 'Fp!7qZnXlw', 'keira.walton@streamcrit.org', '2023-05-12'),
('Riley Chan', 'rchan', 'Nt#3zLwXp!', 'riley.chan@cinelog.io', '2020-02-08');


INSERT INTO critics(user_id, working_for, top, area_of_expertise) VALUES 
(2, 'NY Times', TRUE, 'Drama'),
(5, 'Rolling Stone', FALSE, 'Superhero'),
(7, 'IGN', TRUE, 'Action'),
(9, 'Empire', FALSE, 'Spy Films'),
(10, 'Screen Rant', TRUE, 'Blockbusters'),
(11, 'Film Daily', FALSE, 'Science Fiction'),
(14, 'Collider', TRUE, 'Thrillers'),
(15, 'Film Threat', FALSE, 'Indies'),
(17, 'The Guardian', FALSE, 'International'),
(19, 'BuzzFeed', TRUE, 'Pop Culture'),
(22, 'AV Club', FALSE, 'Comedy'),
(24, 'IGN', TRUE, 'Animation'),
(25, 'The Ringer', FALSE, 'Crime'),
(28, 'The Verge', TRUE, 'Sci-Fi'),
(30, 'New Yorker', FALSE, 'Drama'),
(31, 'Deadline', FALSE, 'TV shows'),
(33, 'Vox', TRUE, 'Political'),
(36, 'Slate', FALSE, 'Documentaries'),
(39, 'Mashable', TRUE, 'Youth'),
(41, 'Cinema Blend', FALSE, 'Blockbusters'),
(37, 'Polygon', TRUE, 'Horror');


INSERT INTO user_search_history (user_id, search_query, search_date) VALUES
(1, 'Bond films with certified freshness', '2023-09-01 14:33:22'),
(1, 'Rank all Bond films by critic score', '2024-01-12 09:18:55'),
(2, 'Top 10 Marvel movies by score', '2024-01-05 10:12:17'),
(2, 'Best Marvel villain arcs in film', '2023-11-09 20:11:30'),
(3, 'TV shows with 70%+ sweetness', '2023-11-21 09:02:43'),
(3, 'Top 5 TV shows with critic-certified freshness', '2024-03-22 14:00:12'),
(4, 'Find movies by Ellen Page', '2024-03-04 16:25:30'),
(4, 'Movies Ellen Page rated but not top critic', '2024-02-04 11:07:45'),
(5, '2022 releases HoneyDew only', '2023-12-18 13:09:10'),
(5, 'All HoneyDew-certified thrillers since 2020', '2023-10-17 16:44:30'),
(6, 'Sci-fi above 8.0 score', '2023-07-20 08:19:02'),
(6, 'High-score sci-fi with franchise entries', '2023-12-05 13:18:29'),
(7, 'Low-rated comedies', '2023-06-12 17:58:44'),
(7, 'Comedies rated under 6.0 with 2020s release', '2023-11-25 15:33:03'),
(8, 'Compare Matrix and Bourne scores', '2024-01-22 11:41:39'),
(8, 'Bourne vs Matrix: compare average franchise score', '2023-09-13 10:12:17'),
(9, 'Sweetness by critic: Oscar Klein', '2023-10-03 18:26:13'),
(9, 'How does Oscar Klein rate Marvel vs DC?', '2024-01-06 17:15:45'),
(10, 'FilmFare reviews on Indian films', '2023-09-27 14:45:25'),
(10, 'Japanese films with 3+ critic reviews', '2023-12-31 08:27:21'),
(11, 'IGN vs Empire reviews', '2024-02-14 20:15:55'),
(11, 'Empire critic breakdown for Bond movies', '2023-10-21 19:42:00'),
(12, 'Freshness by actor: Daniel Craig', '2024-01-09 15:00:20'),
(12, 'Craig’s worst-reviewed performances', '2024-01-29 21:31:55'),
(13, 'Search Dr. No freshness', '2023-11-02 07:44:58'),
(13, 'How does sweetness correlate with review score?', '2024-02-23 07:49:10'),
(14, 'Which Bond movies are HoneyDon’t?', '2023-08-10 22:37:11'),
(14, 'Filter Bond HoneyDon’t by release decade', '2023-07-07 10:01:09'),
(15, 'What did Tasha Young rate below 6?', '2023-07-03 12:13:39'),
(15, 'Low scores for Tasha Young after 2021', '2024-01-11 13:00:00'),
(16, 'Sherlock titles with score data', '2024-04-03 18:39:46'),
(16, 'Sherlock scores across TV and Film', '2023-09-28 18:15:45'),
(17, 'Find all franchise entries with >70%', '2023-10-29 09:57:21'),
(17, 'Top-rated franchises with >3 entries', '2023-08-12 14:33:50'),
(18, 'What has Rolling Stone reviewed?', '2024-01-27 16:21:00'),
(18, 'Rolling Stone freshness average over time', '2023-11-14 12:10:10'),
(19, 'User review history: marvelwatcher', '2023-12-01 08:48:12'),
(19, 'Marvelwatcher’s lowest rated DC movie', '2023-09-20 09:00:00'),
(20, 'Compare drama vs. action sweetness', '2023-09-16 19:30:00'),
(20, 'Compare crime and superhero genres by sweetness', '2024-01-03 13:13:13'),
(21, 'Futuristic movies with high scores', '2023-12-10 15:00:00'),
(22, 'Top Netflix action originals ranked by critics', '2024-03-01 14:15:45'),
(23, 'Classic thrillers with low sweetness', '2023-10-06 11:45:22'),
(24, 'Epic battles in superhero franchises', '2024-02-18 18:09:09'),
(25, 'Biopics ranked by female critics', '2023-11-05 17:44:50'),
(26, 'Certified HoneyDew in 2022 across genres', '2024-01-08 09:30:30'),
(27, 'Compare TV and movie formats by sweetness', '2023-10-19 20:20:20'),
(1, 'Top 5 Bond films ranked by critics', '2024-01-10 12:03:45'),
(1, 'Compare Daniel Craig and Pierce Brosnan movies', '2024-03-21 09:32:17'),
(21, 'Highest grossing Marvel movies', '2024-02-04 16:23:09'),
(23, 'All MCU films with HoneyDew rating', '2023-12-15 14:44:33'),
(13, 'TV series with over 80% sweetness', '2024-01-28 10:11:58'),
(13, 'Mini-series with top critic certification', '2024-02-14 13:05:20'),
(24, 'Elliot Page films in top 10 rating', '2023-11-07 11:27:46'),
(26, 'Critics reviewing Elliot Page films', '2023-12-01 17:35:50'),
(25, '2022 Oscar-nominated thrillers', '2023-10-30 08:45:13'),
(15, 'Fresh 2022 releases with action tag', '2024-01-04 12:44:02'),
(6, 'Sci-fi from 2010–2020 with 90%+ score', '2023-09-29 19:55:55'),
(20, 'Compare sci-fi genre across critics', '2023-11-17 14:22:01'),
(19, 'Comedies with under 50% critic score', '2024-01-09 10:04:04'),
(19, 'Comedies with lowest review count', '2024-02-20 15:15:15'),
(21, 'Matrix films with highest user score', '2023-12-19 11:33:33'),
(20, 'Compare The Matrix vs Bourne critics', '2024-01-11 09:20:17'),
(2, 'Oscar Klein vs Oscar ratings', '2024-01-25 18:41:12'),
(22, 'Oscar Klein HoneyDon’t reviews', '2024-03-02 13:19:14'),
(23, 'Japanese cinema movies over 70%', '2023-10-11 20:17:22'),
(24, 'Compare FilmFare reviews across years', '2024-01-30 16:08:44'),
(25, 'IGN reviews for DC universe films', '2023-09-06 14:00:00'),
(26, 'Empire top 10 superhero movies', '2023-12-27 15:34:58'),
(27, 'All Bond movies starring Daniel Craig', '2023-11-15 13:22:22'),
(27, 'Freshness by Daniel Craig over time', '2024-02-01 19:03:19'),
(28, 'Sweetness score of Dr. No vs Goldfinger', '2024-01-20 17:30:00'),
(29, 'Bond movie freshness scores ranked', '2023-09-19 12:14:12'),
(14, 'List all HoneyDon’t Bond titles', '2024-03-09 09:29:29'),
(30, 'Compare HoneyDon’t by genre', '2023-12-13 08:11:11'),
(31, 'Tasha Young lowest scores list', '2024-02-06 13:01:50'),
(32, 'Tasha Young most positive reviews', '2024-01-19 10:16:36'),
(33, 'Top Sherlock Holmes adaptations', '2023-11-28 14:44:44'),
(33, 'TV vs Movie: Sherlock franchise analysis', '2024-01-14 16:22:22'),
(36, 'Franchise averages above 80%', '2023-12-22 15:40:00'),
(37, 'Compare franchises by entry volume', '2024-01-26 13:30:30'),
(39, 'Rolling Stone reviews for biopics', '2023-10-03 11:12:12'),
(39, 'Rolling Stone vs Empire freshness average', '2024-02-15 14:10:10'),
(39, 'Marvelwatcher most common tags', '2024-01-07 12:22:22'),
(39, 'Marvelwatcher critic overlap', '2024-03-05 10:10:10'),
(40, 'Drama vs Action freshness breakdown', '2023-09-30 14:14:14'),
(40, 'Genre comparison: crime vs comedy', '2023-10-25 17:45:45');

INSERT INTO sweetness_index (feature_id, sweetness_percentage, melon_type) VALUES
(1, 84.44, 'HoneyDew'),
(2, 75.80, 'HoneyDew'),
(3, 42.06, 'HoneyDon’t'),
(4, 25.89, 'HoneyDon’t'),
(5, 51.13, 'HoneyDon’t'),
(6, 40.49, 'HoneyDon’t'),
(7, 78.38, 'HoneyDew'),
(8, 30.33, 'HoneyDon’t'),
(9, 47.66, 'HoneyDon’t'),
(10, 58.34, 'HoneyDon’t'),
(11, 68.81, 'HoneyDew'),
(12, 87.56, 'HoneyDew'),
(13, 42.93, 'HoneyDon’t'),
(14, 55.78, 'HoneyDon’t'),
(15, 93.16, 'HoneyDew'),
(16, 69.38, 'HoneyDew'),
(17, 93.59, 'HoneyDew'),
(18, 71.53, 'HoneyDew'),
(19, 60.33, 'HoneyDon’t'),
(20, 57.46, 'HoneyDon’t'),
(21, 74.70, 'HoneyDew'),
(22, 89.79, 'HoneyDew'),
(23, 55.71, 'HoneyDon’t'),
(24, 25.55, 'HoneyDon’t'),
(25, 16.91, 'HoneyDon’t'),
(26, 40.73, 'HoneyDon’t'),
(27, 28.04, 'HoneyDon’t'),
(28, 17.15, 'HoneyDon’t'),
(29, 56.28, 'HoneyDon’t'),
(30, 77.60, 'HoneyDew'),
(31, 89.42, 'HoneyDew'),
(32, 74.85, 'HoneyDew'),
(33, 31.25, 'HoneyDon’t'),
(34, 64.72, 'HoneyDew'),
(35, 12.84, 'HoneyDon’t'),
(36, 47.19, 'HoneyDon’t'),
(37, 22.98, 'HoneyDon’t'),
(38, 63.15, 'HoneyDew'),
(39, 52.68, 'HoneyDon’t'),
(40, 59.93, 'HoneyDon’t'),
(41, 14.06, 'HoneyDon’t'),
(42, 71.44, 'HoneyDew'),
(43, 80.16, 'HoneyDew'),
(44, 67.01, 'HoneyDew'),
(45, 11.52, 'HoneyDon’t'),
(46, 23.34, 'HoneyDon’t'),
(47, 91.48, 'HoneyDew'),
(48, 44.12, 'HoneyDon’t'),
(49, 86.94, 'HoneyDew'),
(50, 49.29, 'HoneyDon’t'),
(51, 73.65, 'HoneyDew'),
(52, 70.82, 'HoneyDew'),
(53, 61.41, 'HoneyDew'),
(54, 66.32, 'HoneyDew'),
(55, 38.76, 'HoneyDon’t'),
(56, 21.57, 'HoneyDon’t'),
(57, 17.63, 'HoneyDon’t'),
(58, 59.14, 'HoneyDon’t'),
(59, 44.78, 'HoneyDon’t'),
(60, 88.36, 'HoneyDew'),
(61, 34.51, 'HoneyDon’t'),
(62, 35.73, 'HoneyDon’t'),
(63, 53.98, 'HoneyDon’t'),
(64, 98.02, 'HoneyDew'),
(65, 45.90, 'HoneyDon’t'),
(66, 79.05, 'HoneyDew'),
(67, 91.87, 'HoneyDew'),
(68, 83.74, 'HoneyDew'),
(69, 36.27, 'HoneyDon’t'),
(70, 68.52, 'HoneyDew'),
(71, 62.19, 'HoneyDew'),
(72, 41.03, 'HoneyDon’t'),
(73, 31.87, 'HoneyDon’t'),
(74, 77.29, 'HoneyDew'),
(75, 55.44, 'HoneyDon’t'),
(76, 26.91, 'HoneyDon’t'),
(77, 92.03, 'HoneyDew'),
(78, 87.20, 'HoneyDew'),
(79, 84.76, 'HoneyDew'),
(80, 97.41, 'HoneyDew'),
(81, 18.53, 'HoneyDon’t'),
(82, 69.95, 'HoneyDew'),
(83, 70.68, 'HoneyDew'),
(84, 54.36, 'HoneyDon’t'),
(85, 60.88, 'HoneyDew'),
(86, 36.94, 'HoneyDon’t'),
(87, 58.79, 'HoneyDon’t'),
(88, 66.97, 'HoneyDew'),
(89, 82.11, 'HoneyDew'),
(90, 92.90, 'HoneyDew'),
(91, 27.84, 'HoneyDon’t'),
(92, 69.28, 'HoneyDew'),
(93, 80.35, 'HoneyDew'),
(94, 31.17, 'HoneyDon’t'),
(95, 88.61, 'HoneyDew'),
(96, 90.23, 'HoneyDew'),
(97, 42.55, 'HoneyDon’t'),
(98, 39.41, 'HoneyDon’t'),
(99, 46.10, 'HoneyDon’t'),
(100, 24.87, 'HoneyDon’t'),
(101, 58.12, 'HoneyDon’t'),
(102, 73.07, 'HoneyDew');




INSERT INTO feature_synopsis (feature_id, synopsis)
VALUES
(1, "James Bond investigates the mysterious Dr. No, a villain who plans to disrupt U.S. space missions with his secret island base."),
(2, "Bond is tasked with retrieving a Soviet encryption device from a beautiful agent, but faces deadly threats from SPECTRE."),
(3, "Bond must stop the villain Auric Goldfinger, who plans to rob Fort Knox and irradiate the U.S. gold supply."),
(4, "Bond must stop a villainous organization from using stolen nuclear warheads to extort world governments."),
(5, "James Bond is sent on a mission to Japan to foil an evil plot by Blofeld, involving a stolen spacecraft and nuclear weapons."),
(6, "Bond marries Tracy Draco, but his happiness is short-lived as tragedy strikes."),
(7, "Bond investigates a diamond-smuggling ring that is linked to a deadly plot by Blofeld."),
(8, "Bond must stop Dr. Kananga, the ruler of a Caribbean island, from flooding the United States with heroin."),
(9, "Bond must face the world's most dangerous assassin, Francisco Scaramanga, in a deadly game of cat and mouse."),
(10, "Bond teams up with a Soviet agent to stop a villain's plan to destroy the world with a nuclear weapon."),
(11, "Bond investigates the hijacking of a space shuttle, leading to a plot to destroy the Earth and repopulate it with a new master race."),
(12, "Bond is tasked with retrieving a stolen missile control system and preventing global catastrophe."),
(13, "Bond investigates the murder of a fellow agent, leading him to a circus-run smuggling operation linked to nuclear threats."),
(14, "Bond uncovers a plan by the villain Zorin to flood Silicon Valley and monopolize the microchip market."),
(15, "Bond is tasked with protecting a defecting KGB agent, leading to a conspiracy involving arms dealing."),
(16, "Bond goes rogue to avenge the brutal murder of his friend by a drug kingpin."),
(17, "Bond faces a former MI6 agent, now a villain, who threatens to use a satellite weapon to destroy London."),
(18, "Bond is tasked with stopping media mogul Elliot Carver, who plans to instigate World War III to boost his global news empire."),
(19, "Bond must protect a wealthy oil heiress from a dangerous terrorist, while uncovering a deeper conspiracy."),
(20, "Bond must stop a North Korean terrorist who has a dangerous weapon and plans to dominate the world."),
(21, "Bond faces off against a terrorist financier in a high-stakes poker game."),
(22, "Bond seeks revenge after the death of his lover, uncovering a conspiracy to control global resources."),
(23, "Bond confronts his past as MI6 is attacked by a former agent, leading to a personal battle with Silva."),
(24, "Bond uncovers a secret organization known as SPECTRE and faces his greatest personal enemy, Blofeld."),
(25, "Bond comes out of retirement to confront a dangerous new foe in a quest for personal redemption."),
(26, "The modern-day adaptation of the Sherlock Holmes detective stories, starring Benedict Cumberbatch and Martin Freeman."),
(27, "Sherlock Holmes uncovers a plot to destroy Britain and must face off against his arch-nemesis Moriarty."),
(28, "Enola Holmes, Sherlock’s younger sister, embarks on a detective adventure of her own."),
(29, "Gnomeo and Juliet team up with Sherlock Gnomes to find their missing friends in a whimsical mystery."),
(30, "An aging Sherlock Holmes revisits his final case and reflects on his life."),
(31, "Clark Kent embraces his destiny as Superman while stopping General Zod from destroying Earth."),
(32, "The first movie in the Marvel Cinematic Universe, where billionaire Tony Stark becomes the armored superhero Iron Man."),
(33, "Robin Hood leads a band of outlaws in Sherwood Forest to fight against the tyranny of Prince John."),
(34, "A more lighthearted take on the Robin Hood legend, where Robin must save Nottingham from the Sheriff."),
(35, "Robin Hood returns to England to fight against Prince John's tyranny and protect the people."),
(36, "An older Robin Hood returns to England to find that his love, Marian, has moved on."),
(37, "A brilliant but arrogant surgeon becomes the Sorcerer Supreme after seeking a way to heal his hands."),
(38, "Superman returns to Earth after a long absence to stop Lex Luthor's evil plan to conquer the world."),
(39, "The ultimate showdown between Batman and Superman, as they clash over differing ideologies."),
(40, "The story of Facebook's creation, its legal battles, and Mark Zuckerberg's rise to power."),
(41, "A political drama about Frank Underwood’s ruthless rise to power as he manipulates his way to the top."),
(42, "The story of Alan Turing, the mathematician who cracked the German Enigma code during World War II."),
(43, "A modern-day whodunit where detective Benoit Blanc investigates the mysterious death of a wealthy patriarch."),
(44, "A modern-day mystery that sees a group of friends gathered for a murder mystery game, which quickly becomes real."),
(45, "Bond faces off against a terrorist financier in a high-stakes poker game."),
(46, "The first film in the franchise, where John Wick seeks vengeance against those who killed his beloved dog."),
(47, "John Wick is forced back into the assassin world to repay a blood debt, leading to violent repercussions."),
(48, "John Wick goes on the run after being declared excommunicado, facing deadly bounty hunters."),
(49, "John Wick seeks vengeance against the High Table while navigating the complex underworld."),
(50, "Jason Bourne, suffering from amnesia, uncovers a conspiracy while being pursued by hitmen."),
(51, "Jason Bourne is drawn back into the world of espionage when an operation goes wrong."),
(52, "Jason Bourne must uncover the truth behind his past while being hunted by the CIA."),
(53, "A new operative, Aaron Cross, from the same program that created Jason Bourne, tries to survive in a deadly world."),
(54, "Jason Bourne returns to the world of covert operations, seeking to uncover the truth about his past."),
(55, "Neo discovers the truth about the Matrix, a simulated reality created by machines to enslave humanity."),
(56, "Neo must make difficult choices as he continues his fight against the Matrix, uncovering secrets about the war against machines."),
(57, "Neo and his allies launch a final battle against the machines in the war for humanity's survival."),
(58, "Neo is pulled back into the Matrix once again to uncover the truth behind his reality."),
(59, "Robert McCall fights for justice and uses his skills to help the vulnerable, often using extreme methods."),
(60, "Robert McCall fights for justice and uses his skills to help the vulnerable, often using extreme methods."),
(61, "Robert McCall comes out of retirement to avenge the murder of his close friend."),
(62, "Robert McCall takes on a drug cartel and their enforcers while seeking redemption for his past actions."),
(63, "Bruce Wayne becomes Batman and confronts the crime syndicates terrorizing Gotham City."),
(64, "Batman faces the Joker, a criminal mastermind who seeks to plunge Gotham into chaos."),
(65, "Bruce Wayne comes out of retirement as Batman to face Bane, a ruthless terrorist aiming to destroy Gotham City."),
(66, "A foul-mouthed antihero, Wade Wilson becomes Deadpool after undergoing an experiment that grants him healing powers."),
(67, "Deadpool assembles a team of misfits to stop an evil time-traveling mutant from altering the future."),
(68, "A special crossover story where Deadpool and Wolverine must team up to fight a mutual enemy."),
(69, "A team of astronauts travels through a wormhole to find a new home for humanity as Earth faces extinction."),
(70, "Bruce Banner seeks a cure for his condition while being hunted by the government and a monstrous adversary."),
(71, "Tony Stark battles Ivan Vanko, who has created his own version of the Iron Man suit."),
(72, "Thor must protect Earth from the schemes of his adopted brother Loki while discovering his true power as the God of Thunder."),
(73, "Steve Rogers becomes Captain America and faces off against Hydra’s Red Skull."),
(74, "Earth’s mightiest heroes team up to stop Loki and an alien army from taking over the world."),
(75, "Tony Stark must confront the mysterious Mandarin while dealing with the aftermath of the events of The Avengers."),
(76, "Thor faces a dark elf, Malekith, who threatens to use the Aether to plunge the universe into eternal darkness."),
(77, "Captain America uncovers a conspiracy within S.H.I.E.L.D. while confronting the mysterious Winter Soldier."),
(78, "A group of misfits team up to stop a powerful villain from using an ancient artifact to destroy the universe."),
(79, "The Avengers battle Ultron, an AI gone rogue, while dealing with new team dynamics."),
(80, "Scott Lang becomes Ant-Man and must steal an advanced technology to prevent a global catastrophe."),
(81, "The Avengers are divided over a new government mandate that threatens to split them apart."),
(82, "A thief who enters the dreams of others to steal secrets is tasked with planting an idea in someone's mind."),
(83, "The Guardians continue their space adventures while facing new threats and family revelations."),
(84, "Peter Parker tries to balance his high school life with being Spider-Man, while facing the Vulture."),
(85, "Thor must escape the planet Sakaar and prevent Hela, the Goddess of Death, from destroying Asgard."),
(86, "T'Challa, the new king of Wakanda, must defend his kingdom from an enemy with ties to his past."),
(87, "The Avengers must stop Thanos from collecting all the Infinity Stones and wiping out half the universe."),
(88, "Scott Lang and Hope Van Dyne team up to rescue Janet Van Dyne from the quantum realm."),
(89, "Carol Danvers becomes Captain Marvel and faces off against an alien threat in the 1990s."),
(90, "The Avengers unite in a final battle to stop Thanos and undo the devastation caused in Infinity War."),
(91, "Peter Parker deals with the aftermath of Endgame and faces new threats while on a school trip."),
(92, "Natasha Romanoff confronts her past and faces new enemies while uncovering deep secrets."),
(93, "Shang-Chi faces his father and learns the truth about his lineage while stopping a mystical threat."),
(94, "A team of heroes must unite to stop a cosmic entity threatening the universe."),
(95, "Peter Parker teams up with Doctor Strange to undo the chaos caused by his secret identity being revealed."),
(96, "Doctor Strange faces the consequences of tampering with the multiverse."),
(97, "Thor must reunite with old allies and confront a new threat in the form of Gorr the God Butcher."),
(98, "The people of Wakanda must unite after the death of their king, T'Challa, and face a new global threat."),
(99, "Ant-Man and the Wasp face off against a new villain in the quantum realm."),
(100, "The Guardians face their biggest challenge yet while dealing with Rocket’s dark past."),
(101, "Carol Danvers, Monica Rambeau, and Kamala Khan team up to face a new threat to the universe."),
(102, "Sherlock Holmes and Dr. Watson face their greatest challenge yet as they confront the criminal mastermind, Moriarty.");


INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES
(1, 4, 'A suave debut for 007, “Dr. No” oozes Cold War charm and sets the tone for the iconic franchise. Connery’s performance is magnetic.', 81.5, '2020-05-12', TRUE),
(1, 7, 'It’s dated in some parts, but the pacing and exotic setting make “Dr. No” a stylish start to Bond.', 73.0, '2021-01-18', TRUE),
(2, 2, '“From Russia with Love” amps up the intrigue with a taut story and better-developed villains. One of the stronger early Bond films.', 85.0, '2021-06-04', TRUE),
(2, 5, 'Some parts feel slow, but the cinematography and train sequence are pure Bond brilliance.', 76.8, '2023-02-14', TRUE),
(3, 10, '“Goldfinger” is peak Bond—gadgets, girls, and a villain with a plan as ludicrous as it is fun. This is the blueprint for the rest.', 92.0, '2022-08-03', TRUE),
(3, 1, 'The pacing holds up surprisingly well, and that theme song is legendary.', 87.0, '2020-09-21', TRUE),
(4, 6,'“Thunderball” starts strong, but the underwater sequences drag. Great concept, shaky execution.', 67.5, '2022-01-30', FALSE),
(4, 3, 'Bond feels less sharp here. It’s visually impressive, but lacks the tightness of its predecessors.', 62.0, '2021-04-07', FALSE),
(5, 8, '“You Only Live Twice” leans heavily on spectacle. The volcano lair is iconic, but it borders on parody.', 71.0, '2022-05-11', TRUE),
(6, 9,  'Lazenby surprises in this emotionally resonant entry. “On Her Majesty’s Secret Service” is underrated Bond.', 79.5, '2020-10-18', TRUE),
(6, 7, 'While Lazenby lacks Connery’s gravitas, the tragic ending gives this film unexpected weight.', 72.0, '2023-06-25', TRUE),
(7, 3,  'Connery’s return feels phoned in. “Diamonds Are Forever” is campy fun, but uneven.', 60.0, '2021-11-02', FALSE),
(8, 2,  'Moore’s debut is vibrant and action-packed. “Live and Let Die” brings voodoo vibes and a killer soundtrack.', 77.2, '2022-12-19', TRUE),
(9, 1, '“The Man with the Golden Gun” has charm but suffers from tonal inconsistency. Christopher Lee is a highlight.', 68.4, '2021-07-27', FALSE),
(9, 5,  'Fun in moments, but it lacks urgency. Still, the duel scene is memorable.', 66.0, '2022-03-11', FALSE),
(10, 10,'“The Spy Who Loved Me” nails the formula—epic locations, sleek action, and the introduction of Jaws.', 84.7, '2023-01-10', TRUE),
(10, 4, 'Roger Moore is at his best here. It’s the kind of outrageous Bond that just works.', 81.0, '2020-06-22', TRUE);
INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES
(1, 5, '“Dr. No” introduced Bond with suave confidence and exotic flair. A classic that still holds intrigue decades later.', 82.5, '2021-06-12', TRUE),
(1, 3, 'Though some effects feel dated, Sean Connery’s charisma sets the stage for the entire franchise.', 78.0, '2022-04-23', TRUE),
(2, 12,  '“From Russia with Love” ups the stakes with espionage and romance. A tighter, more refined Bond.', 85.0, '2020-10-15', TRUE),
(2, 7,  'Elegant and methodical. This sequel adds tension and a fantastic train fight scene.', 80.5, '2023-03-11', TRUE),
(3, 15,  'Iconic villains and golden glamor—“Goldfinger” is peak early Bond.', 89.5, '2021-07-08', TRUE),
(3, 6,  'While some parts feel campy today, it’s undeniably influential and stylish.', 75.5, '2022-01-19', TRUE),
(3, 18,  'Oddjob and that laser scene? Unforgettable! Bond never felt more confident.', 88.0, '2023-09-03', TRUE),
(4, 2,  '“Thunderball” plays like an underwater ballet of espionage. Visually ambitious, if overlong.', 70.0, '2021-02-14', TRUE),
(4, 4, 'I respect the scale, but the pacing bogs down. Not my favorite Connery outing.', 64.5, '2022-12-04', FALSE),
(4, 10, 'The underwater scenes were impressive but slowed the momentum.', 66.0, '2020-09-27', FALSE),
(5, 14, 'Bond goes to Japan! A cultural shift that feels unique but slightly gimmicky.', 71.5, '2022-08-18', TRUE),
(5, 9,  'Some awkward representation aside, the action is sharp and memorable.', 69.0, '2023-06-12', FALSE),
(6, 8,  'Lazenby surprises with charm. “On Her Majesty’s” is more romantic and tragic than expected.', 83.0, '2021-05-03', TRUE),
(6, 13, 'A slower pace, but the emotional core stands out in the Bond saga.', 78.0, '2023-01-22', TRUE),
(6, 1, 'Underrated and sincere, with one of the best endings in the series.', 82.0, '2022-10-29', TRUE),
(7, 16,  '“Diamonds Are Forever” is flashy fun but lacks substance. Connery looks tired.', 61.0, '2020-07-04', FALSE),
(7, 17, 'The camp is entertaining, though it veers into the absurd too often.', 59.0, '2021-11-11', FALSE),
(8, 11, 'Moore debuts with confidence. The New Orleans setting and voodoo themes were a bold choice.', 76.0, '2021-08-16', TRUE),
(8, 20,  'A funky Bond outing. Fun, but the tone is all over the place.', 69.0, '2022-05-27', FALSE),
(9, 19,  '“The Man with the Golden Gun” feels like a missed opportunity. Lee is fantastic, though.', 65.5, '2023-04-30', FALSE),
(9, 6, 'Too goofy for my taste, but the duel premise was cool.', 62.0, '2020-01-18', FALSE),
(10, 3,'Slick and stylish with underwater villains. Roger Moore finds his stride here.', 80.0, '2021-03-21', TRUE),
(10, 13,  'The Lotus car! Campy, clever, and visually creative.', 78.0, '2023-02-09', TRUE),
(11, 14, '“Moonraker” in space? Ambitious but often silly. Feels like a cash-in on Star Wars.', 58.0, '2022-12-01', FALSE),
(11, 12,  'Goofy but fun. The space angle hasn’t aged well, though.', 60.0, '2023-07-25', FALSE),
(12, 15,  'More grounded Bond. Refreshing after the space antics. Moore seems more serious here.', 72.5, '2021-06-30', TRUE),
(12, 10, 'Well-paced and solid stunts. A return to espionage basics.', 74.0, '2020-09-17', TRUE),
(13, 1,  '“Octopussy” is weirdly entertaining. Camp dialed to 11 but with style.', 66.5, '2022-08-09', FALSE),
(13, 8, 'Fun, but too much slapstick. Moore deserved better material.', 63.0, '2021-02-27', FALSE),
(14, 4,  'Christopher Walken saves this film. Otherwise, pretty forgettable Bond fare.', 60.0, '2023-10-19', FALSE),
(14, 11, 'Zorin is a wild villain. The film itself feels uneven.', 58.5, '2022-11-08', FALSE),
(15, 9,  'Dalton brings grit. “The Living Daylights” has espionage tension with fewer jokes.', 75.0, '2020-06-14', TRUE),
(15, 7,  'Great pacing and seriousness. Underrated in the Bond timeline.', 77.0, '2021-12-28', TRUE),
(16, 5, 'Gritty and violent. A bold shift that makes Bond feel dangerous again.', 79.0, '2022-03-10', TRUE),
(16, 20,  'Dalton shines in this revenge-driven entry. It’s darker but satisfying.', 81.0, '2023-04-16', TRUE),
(17, 2, 'Pierce Brosnan’s debut is slick and stylish. “GoldenEye” is a great modernization.', 85.5, '2021-10-22', TRUE),
(17, 14, 'A thrilling ride from start to finish. That tank chase? Iconic.', 87.0, '2022-09-07', TRUE),
(17, 16, 'Solid action and a fantastic villain. Brosnan felt like Bond right away.', 82.0, '2023-02-14', TRUE),
(18, 18,  '“Tomorrow Never Dies” leans into action-heavy sequences, but lacks heart.', 68.0, '2020-11-23', FALSE),
(18, 6,  'Decent entertainment with a forgettable villain. The tech commentary was ahead of its time.', 70.5, '2021-04-25', TRUE),
(19, 8,  'Twists galore but pacing lags in the middle. Brosnan still owns the role.', 67.5, '2023-06-13', FALSE),
(19, 10,  'Sophie Marceau adds depth, but the oil plot isn’t that compelling.', 64.0, '2020-07-19', FALSE),
(20, 3,'Over-the-top and gadget-heavy. Halle Berry was a highlight.', 62.0, '2022-05-28', FALSE),
(20, 15,  'Invisible cars? Just no. This one pushed too far into absurdity.', 54.0, '2021-01-14', FALSE),
(21, 11,  'Craig’s Bond debut is electric. “Casino Royale” redefined the franchise.', 92.0, '2022-08-26', TRUE),
(21, 19,  'Vesper Lynd’s arc brings real emotion. Gritty, grounded, and unforgettable.', 95.0, '2023-05-12', TRUE);
INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES
(21, 1, 'The parkour chase alone is legendary. Daniel Craig’s physicality brought Bond back to life.', 91.5, '2022-10-05', TRUE),
(22, 6,  '“Quantum of Solace” feels rushed. Some solid action, but thin storytelling.', 62.5, '2021-03-12', FALSE),
(22, 20,  'Not terrible, but definitely the weakest of Craig’s films. Editing is chaotic.', 60.0, '2023-02-02', FALSE),
(23, 14,  '“Skyfall” is a visual feast. Mendes balances nostalgia and reinvention beautifully.', 93.0, '2022-09-15', TRUE),
(23, 12, 'Javier Bardem is terrifying and magnetic. Best Bond in years.', 90.0, '2021-12-03', TRUE),
(23, 4,  'Cinematography and emotional depth make this a high mark in the series.', 94.0, '2023-06-24', TRUE),
(24, 2, '“Spectre” tries to connect too many dots. Blofeld’s return underwhelms.', 66.5, '2020-05-09', FALSE),
(24, 5, 'Visually rich, but the plot meanders. Feels less fresh after “Skyfall”.', 68.0, '2021-11-21', FALSE),
(25, 3,  '“No Time to Die” is a heartfelt farewell. Craig leaves on a powerful note.', 88.0, '2022-07-06', TRUE),
(25, 17,  'Poignant and action-packed. That ending? Bold and bittersweet.', 90.5, '2023-03-18', TRUE),
(26, 7, 'Cumberbatch is mesmerizing. “Sherlock” modernizes the classic with flair.', 87.5, '2022-01-11', TRUE),
(26, 15, 'Snappy dialogue and brilliant deductions. One of the best takes on Holmes.', 90.0, '2023-08-29', TRUE),
(27, 10, 'Ritchie brings grit and swagger. Downey Jr. and Law are a dynamic duo.', 83.0, '2021-06-02', TRUE),
(27, 6, 'A fun twist on the detective genre with a kinetic pace and strong cast.', 80.5, '2020-10-16', TRUE),
(28, 13, 'Millie Bobby Brown is charming. A refreshing, youthful spin on Holmes mythology.', 78.0, '2022-09-03', TRUE),
(28, 11, 'Not groundbreaking, but energetic and well-intentioned. Enola has potential.', 74.0, '2023-05-14', TRUE),
(29, 18, 'A bizarre concept that never quite lands. Kids may enjoy it more.', 59.0, '2020-12-01', FALSE),
(29, 1,  'Even for an animated film, this felt awkward. Holmes deserved better.', 55.0, '2021-08-07', FALSE),
(30, 8,  'McKellen delivers a poignant performance in “Mr. Holmes”. A slow, thoughtful film.', 84.0, '2022-02-27', TRUE),
(30, 19, 'A quiet, reflective take on aging and memory. Beautiful in its restraint.', 86.0, '2023-07-13', TRUE),
(31, 12,  '“Man of Steel” has stunning visuals, but a joyless tone. Cavill is solid.', 68.5, '2021-04-17', FALSE),
(31, 9,  'Explosive action and gorgeous effects, though it lacks warmth.', 70.0, '2022-10-01', FALSE),
(32, 2, '“Iron Man” kickstarted the MCU with style. Downey Jr. is pitch-perfect.', 88.5, '2021-05-25', TRUE),
(32, 16,  'Fresh, funny, and clever. A strong debut for Marvel Studios.', 91.0, '2023-03-08', TRUE),
(33, 4,  'Classic swashbuckling at its best. Errol Flynn’s charisma lights up the screen.', 85.0, '2022-12-16', TRUE),
(33, 20,  'Old Hollywood magic. Vibrant and endlessly entertaining.', 82.5, '2021-09-30', TRUE),
(34, 15, 'Ridley Scott’s “Robin Hood” is gritty but a bit dull. Not enough heart.', 66.0, '2020-07-12', FALSE),
(34, 10, 'A revisionist take that forgets the fun. Solid cast, middling execution.', 63.5, '2023-06-06', FALSE),
(35, 3,  'Kevin Costner does a decent job, and Alan Rickman steals the show.', 74.0, '2021-11-27', TRUE),
(35, 18,  'A ‘90s staple with heart and humor, if a little bloated.', 72.5, '2022-03-21', TRUE);
INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES
(36, 11,  'A melancholic, romantic take on aging legends. Connery and Hepburn bring real depth.', 81.0, '2022-07-10', TRUE),
(36, 5,  'Not your typical Robin Hood movie—more introspective, with touching performances.', 78.0, '2021-09-18', TRUE),
(37, 17,  'Visually dazzling with some mind-bending sequences. Cumberbatch nails the role.', 87.5, '2023-05-14', TRUE),
(37, 1,  'Doctor Strange’s journey is compelling. The mystic visuals are a trip.', 89.0, '2022-10-19', TRUE),
(38, 2,  '“Superman Returns” plays it too safe. A respectful homage, but lacks punch.', 65.0, '2020-08-27', FALSE),
(38, 13, 'It captures some nostalgia, but doesn’t soar like it should.', 67.5, '2021-04-02', FALSE),
(39, 19,  'The movie’s tone is confused. Some epic moments, but it’s cluttered.', 61.0, '2022-12-11', FALSE),
(39, 4, 'Feels like too many movies crammed into one. Batman and Superman deserved better.', 58.5, '2023-03-04', FALSE),
(40, 6,  'Sharp, sleek, and well-written. Eisenberg’s portrayal is chilling.', 88.5, '2021-06-30', TRUE),
(40, 8, 'A fascinating character study on ambition, betrayal, and digital age fame.', 90.0, '2022-11-13', TRUE),
(41, 10, 'Spacey’s performance is haunting. The political drama is dark but gripping.', 86.0, '2020-05-16', TRUE),
(41, 14,  'Twisty and clever, but later seasons lose steam.', 79.0, '2023-01-23', TRUE),
(42, 20,  'Cumberbatch is captivating. A moving tribute to Turing’s genius.', 91.5, '2021-12-05', TRUE),
(42, 9, 'Emotional and powerful, though it plays it a bit safe historically.', 87.0, '2022-07-29', TRUE),
(43, 3, 'A delightful whodunit with flair. Craig is hilarious and sharp.', 88.0, '2020-09-14', TRUE),
(43, 18,  'Tightly scripted and unpredictable. A joy for mystery lovers.', 90.5, '2021-12-20', TRUE),
(44, 15, '“Glass Onion” goes bigger, but not always better. Still wildly entertaining.', 82.0, '2023-02-15', TRUE),
(44, 12, 'Less mysterious than the first, but still smart and fun.', 79.0, '2022-10-09', TRUE),
(45, 7,  'Different from the Craig version, but still a cool retro Bond vibe.', 72.0, '2021-11-02', TRUE),
(45, 5, 'It’s a bit dated now, but has its charm.', 70.5, '2020-06-24', TRUE),
(46, 16,  '“John Wick” is pure, brutal elegance. A surprise hit that redefined action.', 91.0, '2022-04-10', TRUE),
(46, 19,  'Clean choreography, stylish violence, and Keanu at his best.', 89.5, '2021-08-01', TRUE),
(47, 1,  'Upgraded action and deeper mythology. Chapter 2 improves on the original.', 88.0, '2023-03-19', TRUE),
(47, 11, 'More intense and sprawling. Wick’s world expands in the best way.', 87.5, '2022-05-11', TRUE),
(48, 17, 'The franchise keeps elevating itself. Stunning set-pieces and emotional stakes.', 90.0, '2022-12-08', TRUE),
(48, 6,  'Relentless and precise. Wick’s journey gets more perilous and personal.', 91.0, '2023-06-16', TRUE),
(49, 13,  'A visceral conclusion filled with heartbreak and bloodshed. A stunning finale.', 92.0, '2023-08-01', TRUE),
(49, 8,  'Chapter 4 delivers pure carnage with surprising elegance.', 94.0, '2023-08-29', TRUE),
(50, 3,  '“Bourne Identity” redefined spy thrillers. Damon is unexpectedly perfect.', 89.0, '2021-09-09', TRUE),
(50, 10,  'Raw, grounded action. The shaky cam gives it urgency.', 86.0, '2020-03-28', TRUE),
(51, 14, 'Bourne grows colder, sharper. Supremacy has high emotional stakes.', 84.0, '2022-02-12', TRUE),
(51, 2, 'A strong sequel with a darker tone. Taut and intense.', 85.5, '2021-06-07', TRUE),
(52, 4,  '“Ultimatum” is the pinnacle of the trilogy. A thrilling conclusion.', 91.0, '2023-01-26', TRUE),
(52, 12,  'From start to finish, it never lets up. Bourne at his best.', 90.5, '2022-10-21', TRUE),
(53, 9,  'Jeremy Renner tries, but this spin-off lacks the punch of Damon’s run.', 68.0, '2020-08-18', FALSE),
(53, 7, 'A decent effort, but feels like filler. Some good action though.', 66.5, '2021-12-03', FALSE),
(54, 5,  'Damon returns, but the script is lacking. Too many threads, not enough payoff.', 65.0, '2022-09-17', FALSE),
(54, 16, 'It feels like a retread. Some decent moments, but forgettable.', 64.5, '2023-04-28', FALSE),
(55, 18,  '“The Matrix” is a mind-blowing revolution in sci-fi. Still iconic.', 95.0, '2020-11-08', TRUE),
(55, 1, 'Innovative and philosophical. Neo’s journey is gripping.', 93.5, '2021-10-19', TRUE),
(56, 6, 'Bigger but not better. “Reloaded” dazzles, but confuses.', 75.0, '2022-06-23', TRUE),
(56, 19,  'Some cool sequences, but the plot spirals.', 72.5, '2023-02-14', FALSE),
(57, 8,  '“Revolutions” is visually striking but narratively unsatisfying.', 68.0, '2021-05-20', FALSE),
(57, 11,  'Too much philosophy, not enough heart. A clunky finale.', 65.5, '2022-01-11', FALSE),
(58, 20,  '“Resurrections” is a meta mess. Mixed bag with glimpses of brilliance.', 61.0, '2022-08-04', FALSE),
(58, 3, 'It tries to deconstruct itself, but loses focus.', 60.0, '2023-07-12', FALSE),
(59, 17,  'Denzel brings gravitas to a simple revenge plot. Brutal and satisfying.', 80.5, '2021-02-22', TRUE),
(59, 13, 'The slow burn makes the violence hit harder. Stylish and tense.', 82.0, '2020-09-16', TRUE),
(60, 2,  'Slightly redundant but still slick. Washington remains compelling.', 77.0, '2022-04-30', TRUE),
(60, 14,  'Not as fresh, but maintains the tone and intensity.', 75.5, '2021-11-04', TRUE),
(61, 19, 'Less impactful, but a decent continuation. More emotional stakes this time.', 73.5, '2023-01-08', TRUE),
(61, 9,  '“Equalizer 2” lacks urgency. It leans more on character than action.', 70.0, '2022-03-17', TRUE),
(62, 4,  'Brings a sense of closure, but feels a bit tired. Good performances though.', 72.0, '2023-05-29', TRUE),
(62, 12, 'Familiar formula, elevated by Denzel’s intensity.', 73.5, '2022-12-22', TRUE),
(63, 6,  '“Batman Begins” grounded the mythos with psychological realism. A strong reboot.', 89.5, '2021-09-01', TRUE),
(63, 10, 'Nolan gives Batman weight and humanity. An excellent start.', 90.0, '2020-06-25', TRUE),
(64, 1,  '“The Dark Knight” is masterful. Ledger’s Joker is unforgettable.', 96.0, '2022-03-14', TRUE),
(64, 15, 'Dark, complex, and thrilling. The gold standard of superhero films.', 94.5, '2023-06-17', TRUE),
(65, 5,  'A satisfying, operatic finale. Hardy is imposing, and the scope is epic.', 88.0, '2021-04-09', TRUE),
(65, 8,  'Though slightly bloated, it closes Nolan’s trilogy on a high note.', 87.5, '2022-07-30', TRUE);

INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES
(59, 28,  'Denzel Washington delivers a measured and intimidating performance in this slow-burn thriller. The action is precise, not excessive, making every confrontation feel earned.', 81.5, '2022-05-14', TRUE),
(59, 12,  'The Equalizer walks the line between methodical and brutal. It’s a fresh take on a vigilante story with a heart buried beneath the violence.', 78.0, '2022-05-15', TRUE),
(60, 30, 'While technically a re-release, this version emphasizes the gritty realism even more. It’s nuanced and refreshingly grounded for an action film.', 76.2, '2022-06-10', TRUE),
(61, 4, 'A solid sequel with even more tension and slick fight choreography. Denzel keeps the emotional core intact amidst the chaos.', 82.4, '2022-06-12', TRUE),
(62, 19, 'The third Equalizer tries to evolve the character’s moral complexity but leans a bit too much on repetition. Still, the action is top-notch.', 69.0, '2023-01-05', TRUE),
(63, 9, 'Batman Begins reignited a genre. Nolan’s grounded approach mixed with an origin story that has weight and consequence was a breath of fresh air.', 87.5, '2019-09-14', TRUE),
(64, 3,  'The Dark Knight is a masterpiece. Ledger’s Joker is haunting, and the film blurs lines of justice and chaos perfectly.', 95.0, '2020-07-21', TRUE),
(65, 10, 'A fitting end to a powerful trilogy. Bane is imposing, the themes are grand, and the scale is operatic.', 89.2, '2021-04-10', TRUE),
(66, 7, 'Deadpool redefines what a superhero movie can be—wild, vulgar, meta, and heartfelt all at once.', 91.0, '2021-02-16', TRUE),
(67, 20, 'Deadpool 2 doubles down on absurdity but adds more emotion and ensemble fun. It’s surprisingly touching beneath the madness.', 87.8, '2022-08-01', TRUE),
(68, 25, 'A fun addition, with Wolverine and Deadpool’s banter stealing the show. It’s less about plot, more about chemistry, and it works.', 84.5, '2024-02-19', TRUE),
(69, 2,  'Interstellar is emotionally expansive and visually stunning. The science is dense, but the humanity grounds it beautifully.', 92.4, '2020-10-03', TRUE),
(70, 18,  'This version of Hulk is more character-driven. It tries to bring depth but suffers from uneven pacing.', 60.2, '2021-05-11', FALSE),
(71, 11,  'Iron Man 2 introduces more lore but lacks the spark of the original. Still, the performances save it from mediocrity.', 68.0, '2020-03-28', FALSE),
(72, 13,  'Thor balances Asgardian grandeur with fish-out-of-water humor. Hemsworth sells both ends surprisingly well.', 74.4, '2021-07-12', TRUE),
(73, 1,  'A bold period superhero tale. It’s earnest and patriotic but lacks the punch of its successors.', 70.8, '2020-01-19', TRUE),
(74, 22, 'The Avengers is a pop culture milestone. It juggles multiple characters while keeping the fun front and center.', 91.3, '2019-05-04', TRUE),
(75, 5,  'Iron Man 3 adds Shane Black’s humor and trauma-driven story. It’s divisive, but uniquely bold.', 77.6, '2021-11-23', TRUE),
(76, 17, 'A visually dark and narratively dull sequel. Thor’s second outing struggles to find its tone.', 62.0, '2020-06-06', FALSE),
(77, 6, 'Winter Soldier is a political thriller wrapped in superhero skin. It’s sharp, stylish, and refreshingly serious.', 88.7, '2021-03-10', TRUE),
(78, 15, 'Guardians introduces oddball heroes with a killer soundtrack and surprising emotional depth. It’s space opera done right.', 90.0, '2022-07-17', TRUE),
(79, 23,  'Age of Ultron is overstuffed but entertaining. Whedon’s wit shines, though not all threads land.', 76.9, '2021-12-01', TRUE),
(80, 8,  'Ant-Man is smaller in scale but big in charm. Paul Rudd is a winning lead in this breezy heist flick.', 83.1, '2020-02-25', TRUE),
(81, 26,  'Civil War is effectively Avengers 2.5. It balances ideologies, stakes, and action brilliantly.', 89.8, '2021-06-14', TRUE),
(82, 14,  'Inception is a mind-bending journey. Every rewatch offers something new. It’s Nolan at his most ambitious.', 94.5, '2020-08-08', TRUE),
(83, 16,  'Vol. 2 pushes deeper into character drama. It’s less surprising but still emotionally satisfying.', 84.7, '2021-05-30', TRUE),
(84, 29,  'Homecoming returns Spidey to his teen roots. Holland nails the balance of nerdy and heroic.', 85.0, '2022-02-11', TRUE),
(85, 21,  'Ragnarok is a neon blast of comedy and action. Taika Waititi’s direction completely revives Thor.', 89.4, '2021-09-19', TRUE),
(86, 24,  'Black Panther is rich with culture and carried by Boseman’s quiet strength. A landmark film.', 91.1, '2019-02-18', TRUE),
(87, 27,  'Infinity War is pure spectacle with stakes that finally feel real. That ending? Chilling.', 93.0, '2018-04-28', TRUE),
(88, 31,  'Ant-Man and the Wasp is lighter fare post-Infinity War. The action is creative, but the stakes feel minimal.', 74.2, '2021-08-20', TRUE),
(89, 32,  'Captain Marvel has high ambition but stumbles in execution. Still, it’s important representation.', 70.3, '2020-03-09', TRUE),
(90, 33,  'Endgame is the emotional payoff to a decade-long saga. Epic, tearful, and totally earned.', 95.5, '2019-04-26', TRUE),
(91, 34,  'Far From Home is a great epilogue to Endgame. Mysterio is a visually inventive villain.', 84.1, '2020-07-05', TRUE),
(92, 35,  'Black Widow should’ve come earlier. Still, Johansson’s performance and family dynamics elevate it.', 75.0, '2021-09-10', TRUE),
(93, 36, 'Shang-Chi is a martial arts triumph within the MCU. Stunning fight scenes and cultural depth.', 89.0, '2022-01-15', TRUE),
(94, 37, 'Eternals is ambitious but overstuffed. Gorgeous visuals and celestial lore can’t hide pacing issues.', 68.9, '2022-03-20', FALSE),
(95, 38,  'No Way Home is pure fan service and we loved every second. The multiverse concept finally clicks.', 92.2, '2021-12-20', TRUE),
(96, 39, 'The Multiverse of Madness leans into Raimi’s horror roots. It’s uneven, but visually wild.', 78.5, '2022-05-10', TRUE),
(97, 40,  'Love and Thunder is more comedy than character. The tonal whiplash hurts, but it’s entertaining.', 66.4, '2022-08-03', FALSE),
(98, 41,  'Wakanda Forever is a heartfelt tribute to Boseman. The story is a bit scattered, but full of emotion.', 83.7, '2023-01-27', TRUE),
(99, 42, 'Quantumania struggles with tone and stakes. Majors as Kang is a highlight, though.', 62.3, '2023-03-01', FALSE),
(100, 43, 'Vol. 3 gives a bittersweet, emotional sendoff to the Guardians. Rocket’s story hits hard.', 88.8, '2023-05-05', TRUE),
(101, 44,'The Marvels is breezy fun but lacks narrative focus. The cast’s chemistry carries it.', 71.5, '2023-11-11', TRUE),
(102, 45,  'A Game of Shadows ups the stakes with Moriarty. The banter remains sharp and the visuals slick.', 80.6, '2019-01-03', TRUE);


-- Query that looks for reviews made by people who work for IGN

select users.name, review.review_text
from users
join critics on users.user_id = critics.user_id
join review on users.user_id = review.user_id
where critics.working_for='IGN';



-- Query that counts the number of searches a user has made, alongside what they searched and when thy searched it

select users.name, t1.total_searches, user_search_history.search_query, user_search_history.search_date
from users 
join user_search_history on user_search_history.user_id=users.user_id
join ( 
	select 
		users.user_id, 
		count(user_search_history.search_id) as total_searches
	from users
	join user_search_history on users.user_id = user_search_history.user_id
	group by users.user_id) as t1
    on t1.user_id=users.user_id
    where t1.total_searches>1
    order by t1.total_searches desc;

-- Query that looks for negative reviews made by a specific user
select features.title, review.score, review.review_text
from review 
join users on users.user_id = review.user_id
join features  on review.feature_id = features.feature_id
where users.username = 'filmfanatic'
and review.is_positive= False;

-- Query that averages all the scores in reviews made by users and counts the number of reviews they made as well
select t1.name, t1.review_count, avg(review.score) as avg_score
from review 
join(
	select users.name, users.user_id, count(*) as review_count
	from users
	join review on users.user_id = review.user_id
	group by users.user_id) as t1
on review.user_id=t1.user_id
group by t1.name,t1.review_count
having review_count>1
order by avg_score desc;


-- View that outputs the top 10 features currently
DROP VIEW IF EXISTS top_10;
create view top_10 as
select features.title, feature_synopsis.synopsis, sweetness_index.sweetness_percentage
from features
join sweetness_index on features.feature_id = sweetness_index.feature_id
join feature_synopsis on features.feature_id =feature_synopsis.feature_id
where sweetness_index.sweetness_percentage > 80
order by sweetness_index.sweetness_percentage desc
limit 10; 

-- View that outputs who are the top critics
DROP VIEW IF EXISTS top_critics;
create view top_critics as
select users.user_id, users.name
from users
join critics on users.user_id = critics.user_id
where critics.top = true;

-- View that outputs the average sweetness score of a franchise and the sweetness score of each feature in the franchise
drop view if exists franchise_sweetness;
create view franchise_sweetness as
select franchises.name, features.title, sweetness_index.sweetness_percentage, 
avg(sweetness_index.sweetness_percentage) over (partition by franchise_features.franchise_id) as avg_franchise, 
rank () over (partition by franchise_features.franchise_id order by sweetness_index.sweetness_percentage desc) as franchise_rank
from features 
join sweetness_index on features.feature_id = sweetness_index.feature_id
join franchise_features on features.feature_id = franchise_features.feature_id
join franchises on franchise_features.franchise_id=franchises.franchise_id;

-- View that currently outputs all favourable reviews
DROP VIEW IF EXISTS favourable_reviews;
create view favourable_reviews as
select features.title, review.score, review.review_text
from review 
join users on users.user_id = review.user_id
join features on review.feature_id = features.feature_id
and review.is_positive= True;

-- Function to log in a user
DELIMITER //
create function login(username_guess varchar(255), password_guess varchar(255))
returns varchar(255)
deterministic
begin
    declare user_exists int;
    declare return_name varchar(255);
    select count(*) into user_exists
    from users
    where username = username_guess and password = password_guess;

    if user_exists = 1 then
        select name into return_name
		from users
		where username = username_guess and password = password_guess;
        return concat('Welcome back ', return_name, " !" );
    else
        return 'Invalid username or password.';
    end if;
end //

DELIMITER ;
-- test cases
SELECT login('coolfalcon', 'Z9yLq!4MvT');
SELECT login('coolfallcon', 'Z9yLq!4MvT');
SELECT login('coolfalcon', 'Z8yLq!4MvT');


--  Trigger which would update the sweetness score table after a new review is added


DROP TRIGGER IF EXISTS update_sweetness_after_review;
DELIMITER //
create trigger update_sweetness_after_review
after insert on review
for each row 
begin
    declare new_avg_score float;
    declare review_count int;
    declare curr_score float;
    
    select count(review.feature_id) into review_count
    from review
    where review.feature_id = new.feature_id;
    
	select coalesce(sweetness_percentage,0) into curr_score
    from sweetness_index
    where feature_id = NEW.feature_id;
    
    if 
		review_count!=1 then
        set new_avg_score = (curr_score*(review_count-1) + new.score)/(review_count);
        update sweetness_index
        set sweetness_percentage = new_avg_score,
        melon_type = 
        case 
			when new_avg_score>=60 then "HoneyDew"
            else "HoneyDon't"
		end
        where sweetness_index.feature_id = new.feature_id;

	else
		set new_avg_score = new.score;
        insert into  sweetness_index (feature_id, sweetness_percentage, melon_type)
		values (new.feature_id, new_avg_score,
        case 
			when new_avg_score>=60
				then "HoneyDew"
				else "HoneyDon't"
		end
        );
	end if;

end //
DELIMITER ;


-- Testing different functionalities such as adding a new movie, adding a review to a currently existing movie
select sweetness_percentage
from sweetness_index
where feature_id=1;


select count(*)
from review
where feature_id=1;

INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive)
VALUES (1, 1, 'Good but it was missing something', 75.0, CURDATE(), TRUE);

select sweetness_percentage
from sweetness_index
where feature_id=1;

INSERT INTO features (title, year, type) VALUES ('Suzume', 2022, 'movie');
INSERT INTO review (feature_id, user_id, review_text, score, created, is_positive) VALUES (103, 3, 'Suzume is a visually stunning masterpiece. The emotional core and mythical storytelling elevate it beyond expectations.', 92.5, CURDATE(), TRUE);

select feature_id,sweetness_percentage
from sweetness_index
where feature_id=103;

-- Function to reset a users password given correct email and username


drop function if exists reset_password;

DELIMITER //
create function reset_password(acc_email varchar(255),input_username varchar(255), new_password varchar(255))
returns varchar(255)
deterministic
begin
	declare user_exists int;
    select count(*) into user_exists
    from users
    where email = acc_email
    and username=input_username;
    
	if user_exists=1 then 
		update users
		set password = new_password
		WHERE email = acc_email
		and username=input_username;
        return 'Password updated';
	else
		return 'Invalid username or email.';
	end if;
END;
//
DELIMITER ;
-- Test password reset
select reset_password('jamesh@example.com', 'Z9yLq!4MvT', '39yLq!4MvT');
select reset_password('jamesh@example.com', 'coolfalcon', '39yLq!4MvT');


-- Procedure to reset a user's seach history


drop procedure if exists reset_user_search_history;
DELIMITER //
create procedure reset_user_search_history(in userid int)
begin
  delete from user_search_history 
  where user_id = userid;
end;
// 

-- Test User Search History Reset
select user_id, search_query
from user_search_history
where user_id=7;

call reset_user_search_history(7);

select user_id, search_query
from user_search_history
where user_id=7;

-- Procedure to search for content based off a keyword or phrase


drop procedure if exists content_search;
DELIMITER //
create procedure content_search(in keyword varchar(255))
begin
  select distinct features.title, franchises.name, sweetness_index.sweetness_percentage, feature_synopsis.synopsis, review.review_text, critics.working_for
  from features
  join sweetness_index on sweetness_index.feature_id = features.feature_id
  join feature_synopsis on feature_synopsis.feature_id = features.feature_id
  join review on review.feature_id = features.feature_id
  join feature_work on feature_work.feature_id = features.feature_id
  join franchise_features on features.feature_id = franchise_features.feature_id
  join franchises on franchise_features.franchise_id=franchises.franchise_id
  join critics on review.user_id=critics.user_id
  where review.review_text like concat('%', keyword, '%') 
  or feature_synopsis.synopsis like concat('%', keyword, '%') 
  or feature_work.person like concat('%', keyword, '%')
  or critics.working_for like concat('%', keyword, '%')
  or franchises.name like concat('%', keyword, '%')
  or features.title like concat('%', keyword, '%');
end;
//
-- Test the content search functionality
CALL content_search('heart');



