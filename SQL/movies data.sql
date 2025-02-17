DROP DATABASE IF EXISTS movies;

CREATE DATABASE IF NOT EXISTS movies;

USE movies;

-- source /Users/tonyveale/Dropbox/SQL Lectures/Movie database/movies data.sql


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
   PRIMARY KEY (job_id),
   FOREIGN KEY (feature_id) REFERENCES features(feature_id) ON DELETE CASCADE
);

CREATE TABLE feature_role (
   role_id int NOT NULL AUTO_INCREMENT,
   feature_id int NOT NULL,
   person varchar(255) NOT NULL,
   role varchar(255) NOT NULL,
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


INSERT INTO feature_work(feature_id, person, job) VALUES (1, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (2, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (3, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (4, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (5, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (6, "George Lazenby", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (7, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (8, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (9, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (10, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (11, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (12, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (13, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (14, "Roger Moore", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (15, "Timothy Dalton", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (16, "Timothy Dalton", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (17, "Pierce Brosnan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (18, "Pierce Brosnan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (19, "Pierce Brosnan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (20, "Pierce Brosnan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (21, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (22, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (23, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (24, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (25, "Daniel Craig", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (26, "Benedict Cumberbatch", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (27, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (28, "Henry Cavill", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (29, "Johnny Depp", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (30, "Ian McKellen", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (31, "Henry Cavill", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (32, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (33, "Errol Flynn", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (34, "Russell Crowe", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (35, "Kevin Costner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (36, "Sean Connery", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (37, "Benedict Cumberbatch", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (38, "Kevin Spacey", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (39, "Jesse Eisenberg", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (39, "Henry Cavill", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (40, "Jesse Eisenberg", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (41, "Kevin Spacey", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (42, "Benedict Cumberbatch", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (43, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (44, "Daniel Craig", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "David Niven", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Peter Sellers", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Woody Allen", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (1, "Terence Young", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (2, "Terence Young", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (3, "Guy Hamilton", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (4, "Terence Young", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (5, "Lewis Gilbert", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (6, "Peter R. Hunt", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (7, "Guy Hamilton", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (8, "Guy Hamilton", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (9, "Guy Hamilton", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (10, "Lewis Gilbert", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (11, "Lewis Gilbert", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (12, "John Glen", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (13, "John Glen", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (14, "John Glen", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (15, "John Glen", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (16, "John Glen", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (17, "Martin Campbell", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (18, "Roger Spottiswoode", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (19, "Michael Apted", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (20, "Lee Tamahori", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (21, "Martin Campbell", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (22, "Marc Forster", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (23, "Sam Mendes", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (24, "Sam Mendes", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (25, "Cary Joji Fukunaga", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (32, "Jon Favreau", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (37, "Scott Derrickson", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (43, "Rian Johnson", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (44, "Rian Johnson", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "John Huston", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Val Guest", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Ken Hughes", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Joseph McGrath", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (45, "Robert Parrish", "director");

INSERT INTO feature_work(feature_id, person, job) VALUES (46, "Chad Stahelski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (46, "David Lietch", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (47, "Chad Stahelski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (48, "Chad Stahelski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (49, "Chad Stahelski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (50, "Doug Liman", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (51, "Paul Greengrass", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (52, "Paul Greengrass", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (53, "Tony Gilroy", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (54, "Paul Greengrass", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Lilly Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Lana Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Lilly Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Lana Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Lilly Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Lana Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (58, "Lana Wachowski", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (59, "Michael Sloan", "creator");
INSERT INTO feature_work(feature_id, person, job) VALUES (59, "Richard Lindheim", "creator");
INSERT INTO feature_work(feature_id, person, job) VALUES (60, "Antoine Fuqua", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (61, "Antoine Fuqua", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (62, "Antoine Fuqua", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (63, "Christopher Nolan", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Christopher Nolan", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Christopher Nolan", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (66, "Tim Miller", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (67, "David Leitch", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (68, "Shawn Levy", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (69, "Christopher Nolan", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (70, "Louis Leterrier", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (71, "Jon Favreau", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (72, "Kenneth Branagh", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (73, "Joe Johnston[", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Joss Whedon", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (75, "Shane Black", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (76, "Alan Taylor", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (77, "Anthony Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (77, "Joe Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (78, "James Gunn", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Joss Whedon", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (80, "Peyton Reed", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Anthony Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Joe Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (82, "Christopher Nolan", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (83, "James Gunn", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (84, "Jon Watts", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (85, "Taika Waititi", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (86, "Ryan Coogler", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Anthony Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Joe Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (88, "Peyton Reed", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (89, "Anna Boden", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (89, "Ryan Fleck", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Anthony Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Joe Russo", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (91, "Jon Watts", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (92, "Cate Shortland", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (93, "Destin Daniel Cretton", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (94, "Chloé Zhao", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (95, "Jon Watts", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (96, "Sam Raimi", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (97, "Taika Waititi", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (98, "Ryan Coogler", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (99, "Peyton Reed", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (100, "James Gunn", "director");
INSERT INTO feature_work(feature_id, person, job) VALUES (101, "Nia DaCosta", "director");

INSERT INTO feature_work(feature_id, person, job) VALUES (46, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (46, "Ian McShane", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (46, "Lance Reddick", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (47, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (47, "Ian McShane", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (47, "Lance Reddick", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (48, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (48, "Ian McShane", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (48, "Lance Reddick", "actor");


INSERT INTO feature_work(feature_id, person, job) VALUES (49, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (49, "Ian McShane", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (49, "Lance Reddick", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (50, "Matt Damon", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (51, "Matt Damon", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (52, "Matt Damon", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (53, "Jeremy Renner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (54, "Matt Damon", "actor");

INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Hugo Weaving", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Laurence Fishburne", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (55, "Carrie-Anne Moss", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Hugo Weaving", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Laurence Fishburne", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (56, "Carrie-Anne Moss", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Hugo Weaving", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Laurence Fishburne", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (57, "Carrie-Anne Moss", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (58, "Keanu Reeves", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (58, "Carrie-Anne Moss", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (59, "Edward Woodward", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (60, "Denzel Washington", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (61, "Denzel Washington", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (62, "Denzel Washington", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (63, "Christian Bale", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (63, "Michael Caine", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (63, "Morgan Freeman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (63, "Gary Oldman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Christian Bale", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Michael Caine", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Morgan Freeman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Gary Oldman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (64, "Heath Ledger", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Christian Bale", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Michael Caine", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Morgan Freeman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Gary Oldman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (65, "Tom Hardy", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (66, "Ryan Reynolds", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (67, "Ryan Reynolds", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (68, "Ryan Reynolds", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (68, "Hugh Jackman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (69, "Matthew McConaughey", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (69, "Michael Caine", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (69, "Anne Hathaway", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (70, "Edward Norton", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (71, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (71, "Jeff Bridges", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (72, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (72, "Anthony Hopkins", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (73, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (73, "Hugh Weaving", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Mark Ruffalo", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Jeremy Renner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (74, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (75, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (76, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (76, "Anthony Hopkins", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (77, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (77, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (78, "Chris Pratt", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (78, "Bradley Cooper", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (78, "Vin Diesel", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Mark Ruffalo", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Jeremy Renner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (79, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (80, "Paul Rudd", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (80, "Michael Douglas", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (81, "Robert Redford", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (82, "Leonardo DiCaprio", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (82, "Michael Caine", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (82, "Tom Hardy", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (82, "Cillian Murphy", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (83, "Chris Pratt", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (83, "Bradley Cooper", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (83, "Vin Diesel", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (84, "Kurt Russell", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (84, "Tom Holland", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (84, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (84, "Michael Keaton", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (85, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (85, "Anthony Hopkins", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (85, "Cate Blanchett", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (85, "Mark Ruffalo", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (86, "Chadwick Boseman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (86, "Michael B. Jordan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Mark Ruffalo", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Jeremy Renner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (87, "Josh Brolin", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (88, "Paul Rudd", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (88, "Michael Douglas", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (89, "Brie Larson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (89, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Chris Evans", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Robert Downey Jr.", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Mark Ruffalo", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Jeremy Renner", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (90, "Josh Brolin", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (91, "Tom Holland", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (91, "Samuel L. Jackson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (91, "Jon Favreau", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (92, "Scarlet Johannson", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (92, "Florence Pugh", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (93, "Simu Liu", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (93, "Awkwafina", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (94, "Angelina Jolie", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (94, "Barry Keoghan", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (94, "Salma Hayek", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (94, "Richard Madden", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (95, "Tom Holland", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (95, "Benedict Cumberbatch", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (95, "Willem Dafoe", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (96, "Benedict Cumberbatch", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (97, "Chris Hemsworth", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (97, "Christian Bale", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (97, "Natalie Portman", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (98, "Letitia Wright", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (99, "Paul Rudd", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (99, "Michael Douglas", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (99, "Michelle Pfeiffer", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (100, "Chris Pratt", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (100, "Bradley Cooper", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (100, "Vin Diesel", "actor");
INSERT INTO feature_work(feature_id, person, job) VALUES (101, "Brie Larson", "actor");

INSERT INTO feature_role(feature_id, person, role) VALUES (1, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (2, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (3, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (4, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (5, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (6, "George Lazenby", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (7, "Sean Connery", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (8, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (9, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (10, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (11, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (12, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (13, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (14, "Roger Moore", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (15, "Timothy Dalton", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (16, "Timothy Dalton", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (17, "Pierce Brosnan", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (18, "Pierce Brosnan", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (19, "Pierce Brosnan", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (20, "Pierce Brosnan", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (21, "Daniel Craig", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (22, "Daniel Craig", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (23, "Daniel Craig", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (24, "Daniel Craig", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (25, "Daniel Craig", "James Bond");

INSERT INTO feature_role(feature_id, person, role) VALUES (26, "Benedict Cumberbatch", "Sherlock Holmes");
INSERT INTO feature_role(feature_id, person, role) VALUES (27, "Robert Downey Jr.", "Sherlock Holmes");
INSERT INTO feature_role(feature_id, person, role) VALUES (28, "Henry Cavill", "Sherlock Holmes");
INSERT INTO feature_role(feature_id, person, role) VALUES (29, "Johnny Depp", "Sherlock Holmes");
INSERT INTO feature_role(feature_id, person, role) VALUES (30, "Ian McKellen", "Sherlock Holmes");
INSERT INTO feature_role(feature_id, person, role) VALUES (31, "Henry Cavill", "Superman");
INSERT INTO feature_role(feature_id, person, role) VALUES (31, "Henry Cavill", "Clark Kent");
INSERT INTO feature_role(feature_id, person, role) VALUES (32, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (32, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (33, "Errol Flynn", "Robin Hood");
INSERT INTO feature_role(feature_id, person, role) VALUES (34, "Russell Crowe", "Robin Hood");
INSERT INTO feature_role(feature_id, person, role) VALUES (35, "Kevin Costner", "Robin Hood");
INSERT INTO feature_role(feature_id, person, role) VALUES (36, "Sean Connery", "Robin Hood");
INSERT INTO feature_role(feature_id, person, role) VALUES (37, "Benedict Cumberbatch", "Doctor Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (37, "Benedict Cumberbatch", "Stephen Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (38, "Kevin Spacey", "Lex Luthor");
INSERT INTO feature_role(feature_id, person, role) VALUES (39, "Jesse Eisenberg", "Lex Luthor");
INSERT INTO feature_role(feature_id, person, role) VALUES (39, "Henry Cavill", "Superman");
INSERT INTO feature_role(feature_id, person, role) VALUES (39, "Henry Cavill", "Clark Kent");
INSERT INTO feature_role(feature_id, person, role) VALUES (40, "Jesse Eisenberg", "Mark Zuckerberg");
INSERT INTO feature_role(feature_id, person, role) VALUES (41, "Kevin Spacey", "Frank Underwood");
INSERT INTO feature_role(feature_id, person, role) VALUES (42, "Benedict Cumberbatch", "Alan Turing");
INSERT INTO feature_role(feature_id, person, role) VALUES (43, "Daniel Craig", "Benoit Blanc");
INSERT INTO feature_role(feature_id, person, role) VALUES (44, "Daniel Craig", "Benoit Blanc");
INSERT INTO feature_role(feature_id, person, role) VALUES (45, "David Niven", "James Bond");
INSERT INTO feature_role(feature_id, person, role) VALUES (45, "Peter Sellers", "Evelyn Tremble");
INSERT INTO feature_role(feature_id, person, role) VALUES (45, "Woody Allen", "Jimmy Bond");

INSERT INTO feature_role(feature_id, person, role) VALUES (46, "Keanu Reeves", "John Wick");
INSERT INTO feature_role(feature_id, person, role) VALUES (46, "Ian McShane", "Winston Scott");
INSERT INTO feature_role(feature_id, person, role) VALUES (46, "Lance Reddick", "Charon");

INSERT INTO feature_role(feature_id, person, role) VALUES (47, "Keanu Reeves", "John Wick");
INSERT INTO feature_role(feature_id, person, role) VALUES (47, "Ian McShane", "Winston Scott");
INSERT INTO feature_role(feature_id, person, role) VALUES (47, "Lance Reddick", "Charon");

INSERT INTO feature_role(feature_id, person, role) VALUES (48, "Keanu Reeves", "John Wick");
INSERT INTO feature_role(feature_id, person, role) VALUES (48, "Ian McShane", "Winston Scott");
INSERT INTO feature_role(feature_id, person, role) VALUES (48, "Lance Reddick", "Charon");

INSERT INTO feature_role(feature_id, person, role) VALUES (49, "Keanu Reeves", "John Wick");
INSERT INTO feature_role(feature_id, person, role) VALUES (49, "Ian McShane", "Winston Scott");
INSERT INTO feature_role(feature_id, person, role) VALUES (49, "Lance Reddick", "Charon");

INSERT INTO feature_role(feature_id, person, role) VALUES (50, "Matt Damon", "Jason Bourne");
INSERT INTO feature_role(feature_id, person, role) VALUES (51, "Matt Damon", "Jason Bourne");
INSERT INTO feature_role(feature_id, person, role) VALUES (52, "Matt Damon", "Jason Bourne");
INSERT INTO feature_role(feature_id, person, role) VALUES (53, "Jeremy Renner", "Aaron Cross");
INSERT INTO feature_role(feature_id, person, role) VALUES (54, "Matt Damon", "Jason Bourne");

INSERT INTO feature_role(feature_id, person, role) VALUES (55, "Keanu Reeves", "Neo");
INSERT INTO feature_role(feature_id, person, role) VALUES (55, "Hugo Weaving", "Agent Smith");
INSERT INTO feature_role(feature_id, person, role) VALUES (55, "Laurence Fishburne", "Morpheus");
INSERT INTO feature_role(feature_id, person, role) VALUES (55, "Carrie-Anne Moss", "Trinity");
INSERT INTO feature_role(feature_id, person, role) VALUES (56, "Keanu Reeves", "Neo");
INSERT INTO feature_role(feature_id, person, role) VALUES (56, "Hugo Weaving", "Agent Smith");
INSERT INTO feature_role(feature_id, person, role) VALUES (56, "Laurence Fishburne", "Morpheus");
INSERT INTO feature_role(feature_id, person, role) VALUES (56, "Carrie-Anne Moss", "Trinity");
INSERT INTO feature_role(feature_id, person, role) VALUES (57, "Keanu Reeves", "Neo");
INSERT INTO feature_role(feature_id, person, role) VALUES (57, "Hugo Weaving", "Agent Smith");
INSERT INTO feature_role(feature_id, person, role) VALUES (57, "Laurence Fishburne", "Morpheus");
INSERT INTO feature_role(feature_id, person, role) VALUES (57, "Carrie-Anne Moss", "Trinity");
INSERT INTO feature_role(feature_id, person, role) VALUES (58, "Keanu Reeves", "Neo");
INSERT INTO feature_role(feature_id, person, role) VALUES (58, "Carrie-Anne Moss", "Trinity");
INSERT INTO feature_role(feature_id, person, role) VALUES (59, "Edward Woodward", "Robert McCall");
INSERT INTO feature_role(feature_id, person, role) VALUES (60, "Denzel Washington", "Robert McCall");
INSERT INTO feature_role(feature_id, person, role) VALUES (61, "Denzel Washington", "Robert McCall");
INSERT INTO feature_role(feature_id, person, role) VALUES (62, "Denzel Washington", "Robert McCall");
INSERT INTO feature_role(feature_id, person, role) VALUES (63, "Christian Bale", "Bruce Wayne");
INSERT INTO feature_role(feature_id, person, role) VALUES (63, "Christian Bale", "Batman");
INSERT INTO feature_role(feature_id, person, role) VALUES (63, "Michael Caine", "Alfred Pennyworth");
INSERT INTO feature_role(feature_id, person, role) VALUES (63, "Morgan Freeman", "Lucius Fox");
INSERT INTO feature_role(feature_id, person, role) VALUES (63, "Gary Oldman", "James Gordon");
INSERT INTO feature_role(feature_id, person, role) VALUES (64, "Christian Bale", "Bruce Wayne");
INSERT INTO feature_role(feature_id, person, role) VALUES (64, "Michael Caine", "Alfred Pennyworth");
INSERT INTO feature_role(feature_id, person, role) VALUES (64, "Morgan Freeman", "Lucius Fox");
INSERT INTO feature_role(feature_id, person, role) VALUES (64, "Gary Oldman", "James Gordon");
INSERT INTO feature_role(feature_id, person, role) VALUES (64, "Heath Ledger", "The Joker");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Christian Bale", "Bruce Wayne");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Christian Bale", "Batman");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Michael Caine", "Alfred Pennyworth");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Morgan Freeman", "Lucius Fox");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Gary Oldman", "James Gordon");
INSERT INTO feature_role(feature_id, person, role) VALUES (65, "Tom Hardy", "Bane");
INSERT INTO feature_role(feature_id, person, role) VALUES (66, "Ryan Reynolds", "Wade Wilson");
INSERT INTO feature_role(feature_id, person, role) VALUES (66, "Ryan Reynolds", "Deadpool");
INSERT INTO feature_role(feature_id, person, role) VALUES (67, "Ryan Reynolds", "Wade Wilson");
INSERT INTO feature_role(feature_id, person, role) VALUES (67, "Ryan Reynolds", "Deadpool");
INSERT INTO feature_role(feature_id, person, role) VALUES (68, "Ryan Reynolds", "Wade Wilson");
INSERT INTO feature_role(feature_id, person, role) VALUES (68, "Ryan Reynolds", "Deadpool");
INSERT INTO feature_role(feature_id, person, role) VALUES (68, "Hugh Jackman", "Logan");
INSERT INTO feature_role(feature_id, person, role) VALUES (68, "Hugh Jackman", "Wolverine");
INSERT INTO feature_role(feature_id, person, role) VALUES (69, "Matthew McConaughey", "Cooper");
INSERT INTO feature_role(feature_id, person, role) VALUES (69, "Michael Caine", "Professor Brand");
INSERT INTO feature_role(feature_id, person, role) VALUES (69, "Anne Hathaway", "Brand");
INSERT INTO feature_role(feature_id, person, role) VALUES (70, "Edward Norton", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (71, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (71, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (71, "Jeff Bridges", "Obidiah Stane");
INSERT INTO feature_role(feature_id, person, role) VALUES (72, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (72, "Anthony Hopkins", "Odin");
INSERT INTO feature_role(feature_id, person, role) VALUES (73, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (73, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (73, "Hugh Weaving", "Red Skull");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Mark Ruffalo", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Jeremy Renner", "Hawkeye");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Jeremy Renner", "Clint Barton");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Scarlet Johannson", "Natasha Romanova");
INSERT INTO feature_role(feature_id, person, role) VALUES (74, "Scarlet Johannson", "Black Widow");
INSERT INTO feature_role(feature_id, person, role) VALUES (75, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (75, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (76, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (76, "Anthony Hopkins", "Odin");
INSERT INTO feature_role(feature_id, person, role) VALUES (77, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (77, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (77, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (78, "Chris Pratt", "Peter Quill");
INSERT INTO feature_role(feature_id, person, role) VALUES (78, "Bradley Cooper", "Rocket Raccoon");
INSERT INTO feature_role(feature_id, person, role) VALUES (78, "Vin Diesel", "Groot");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Mark Ruffalo", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Jeremy Renner", "Hawkeye");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Jeremy Renner", "Clint Barton");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Scarlet Johannson", "Natasha Romanova");
INSERT INTO feature_role(feature_id, person, role) VALUES (79, "Scarlet Johannson", "Black Widow");
INSERT INTO feature_role(feature_id, person, role) VALUES (80, "Paul Rudd", "Scott Lang");
INSERT INTO feature_role(feature_id, person, role) VALUES (80, "Paul Rudd", "Ant-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (80, "Michael Douglas", "Henry Pym");
INSERT INTO feature_role(feature_id, person, role) VALUES (81, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (81, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (81, "Scarlet Johannson", "Natasha Romanova");
INSERT INTO feature_role(feature_id, person, role) VALUES (81, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (81, "Robert Redford", "Alexander Pierce");
INSERT INTO feature_role(feature_id, person, role) VALUES (82, "Leonardo DiCaprio", "Cobb");
INSERT INTO feature_role(feature_id, person, role) VALUES (82, "Michael Caine", "Professor Stephen Miles");
INSERT INTO feature_role(feature_id, person, role) VALUES (82, "Tom Hardy", "Eames");
INSERT INTO feature_role(feature_id, person, role) VALUES (82, "Cillian Murphy", "Fischer");
INSERT INTO feature_role(feature_id, person, role) VALUES (83, "Chris Pratt", "Peter Quill");
INSERT INTO feature_role(feature_id, person, role) VALUES (83, "Bradley Cooper", "Rocket Raccoon");
INSERT INTO feature_role(feature_id, person, role) VALUES (83, "Vin Diesel", "Groot");
INSERT INTO feature_role(feature_id, person, role) VALUES (84, "Kurt Russell", "Ego");
INSERT INTO feature_role(feature_id, person, role) VALUES (84, "Tom Holland", "Peter Parker");
INSERT INTO feature_role(feature_id, person, role) VALUES (84, "Tom Holland", "Spider-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (84, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (84, "Michael Keaton", "Adrian Toomes");
INSERT INTO feature_role(feature_id, person, role) VALUES (85, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (85, "Anthony Hopkins", "Odin");
INSERT INTO feature_role(feature_id, person, role) VALUES (85, "Cate Blanchett", "Hela");
INSERT INTO feature_role(feature_id, person, role) VALUES (85, "Mark Ruffalo", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (86, "Chadwick Boseman", "T'Challa");
INSERT INTO feature_role(feature_id, person, role) VALUES (86, "Michael B. Jordan", "Erik Killmonger");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Mark Ruffalo", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Jeremy Renner", "Clint Barton");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Jeremy Renner", "Hawkeye");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Scarlet Johannson", "Natasha Romanova");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Scarlet Johannson", "Black Widow");
INSERT INTO feature_role(feature_id, person, role) VALUES (87, "Josh Brolin", "Thanos");
INSERT INTO feature_role(feature_id, person, role) VALUES (88, "Paul Rudd", "Scott Lang");
INSERT INTO feature_role(feature_id, person, role) VALUES (88, "Paul Rudd", "Ant-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (88, "Michael Douglas", "Henry Pym");
INSERT INTO feature_role(feature_id, person, role) VALUES (89, "Brie Larson", "Carol Danvers");
INSERT INTO feature_role(feature_id, person, role) VALUES (89, "Brie Larson", "Captain Marvel");
INSERT INTO feature_role(feature_id, person, role) VALUES (89, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Chris Evans", "Captain America");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Chris Evans", "Steve Rogers");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Robert Downey Jr.", "Iron Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Robert Downey Jr.", "Tony Stark");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Mark Ruffalo", "Bruce Banner");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Jeremy Renner", "Clint Barton");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Jeremy Renner", "Hawkeye");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Brie Larson", "Carol Danvers");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Josh Brolin", "Thanos");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Paul Rudd", "Scott Lang");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Paul Rudd", "Ant-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (91, "Tom Holland", "Peter Parker");
INSERT INTO feature_role(feature_id, person, role) VALUES (91, "Tom Holland", "Spider-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (91, "Samuel L. Jackson", "Nick Fury");
INSERT INTO feature_role(feature_id, person, role) VALUES (91, "Jon Favreau", "Happy Hogan");
INSERT INTO feature_role(feature_id, person, role) VALUES (92, "Scarlet Johannson", "Black Widow");
INSERT INTO feature_role(feature_id, person, role) VALUES (92, "Scarlet Johannson", "Natasha Romanova");
INSERT INTO feature_role(feature_id, person, role) VALUES (92, "Florence Pugh", "Yelena Belova");
INSERT INTO feature_role(feature_id, person, role) VALUES (93, "Simu Liu", "Shang-Chi");
INSERT INTO feature_role(feature_id, person, role) VALUES (93, "Awkwafina", "Katy");
INSERT INTO feature_role(feature_id, person, role) VALUES (94, "Angelina Jolie", "Thena");
INSERT INTO feature_role(feature_id, person, role) VALUES (94, "Barry Keoghan", "Druig");
INSERT INTO feature_role(feature_id, person, role) VALUES (94, "Salma Hayek", "Ajak");
INSERT INTO feature_role(feature_id, person, role) VALUES (94, "Richard Madden", "Ikarus");
INSERT INTO feature_role(feature_id, person, role) VALUES (95, "Tom Holland", "Peter Parker");
INSERT INTO feature_role(feature_id, person, role) VALUES (95, "Tom Holland", "Spider-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (95, "Benedict Cumberbatch", "Doctor Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (95, "Benedict Cumberbatch", "Stephen Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (95, "Willem Dafoe", "Normon Osborne");
INSERT INTO feature_role(feature_id, person, role) VALUES (96, "Benedict Cumberbatch", "Doctor Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (96, "Benedict Cumberbatch", "Stephen Strange");
INSERT INTO feature_role(feature_id, person, role) VALUES (97, "Chris Hemsworth", "Thor");
INSERT INTO feature_role(feature_id, person, role) VALUES (97, "Christian Bale", "Gorr");
INSERT INTO feature_role(feature_id, person, role) VALUES (97, "Natalie Portman", "Jane Foster");
INSERT INTO feature_role(feature_id, person, role) VALUES (98, "Letitia Wright", "Shuri");
INSERT INTO feature_role(feature_id, person, role) VALUES (99, "Paul Rudd", "Scott Lang");
INSERT INTO feature_role(feature_id, person, role) VALUES (99, "Paul Rudd", "Ant-Man");
INSERT INTO feature_role(feature_id, person, role) VALUES (99, "Michael Douglas", "Henry Pym");
INSERT INTO feature_role(feature_id, person, role) VALUES (99, "Michelle Pfeiffer", "Janet Van Dyne");
INSERT INTO feature_role(feature_id, person, role) VALUES (100, "Chris Pratt", "Peter Quill");
INSERT INTO feature_role(feature_id, person, role) VALUES (100, "Bradley Cooper", "Rocket Raccoon");
INSERT INTO feature_role(feature_id, person, role) VALUES (100, "Vin Diesel", "Groot");
INSERT INTO feature_role(feature_id, person, role) VALUES (101, "Brie Larson", "Carol Danvers");
INSERT INTO feature_role(feature_id, person, role) VALUES (101, "Brie Larson", "Captain Marvel");
INSERT INTO feature_role(feature_id, person, role) VALUES (90, "Brie Larson", "Captain Marvel");
INSERT INTO feature_role(feature_id, person, role) VALUES (72, "Natalie Portman", "Jane Foster");
INSERT INTO feature_role(feature_id, person, role) VALUES (102, "Robert Downey Jr.", "Sherlock Holmes");

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
INSERT INTO role_type(role_id, role_type) values (34, "superhero");
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
INSERT INTO role_type(role_id, role_type) values (85, "hacker");

INSERT INTO role_type(role_id, role_type) values (86, "hero");
INSERT INTO role_type(role_id, role_type) values (86, "hacker");

INSERT INTO role_type(role_id, role_type) values (87, "hero");
INSERT INTO role_type(role_id, role_type) values (87, "hacker");


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




