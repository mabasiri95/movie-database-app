/*
================================================================================
 01_schema_and_data.sql
 Description: Creates the database schema and populates it with initial data.
================================================================================
*/

-- Drop tables in reverse order of creation to avoid foreign key conflicts
DROP TABLE IF EXISTS Acted;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Director;
DROP TABLE IF EXISTS Performer;

-- Create Performer Table
CREATE TABLE Performer(
	pid INT PRIMARY KEY,
	pname VARCHAR(40),
	years_of_experience INT,
	age INT,
	CONSTRAINT CHK_age CHECK (age BETWEEN 0 AND 150),
	CONSTRAINT CHK_years_of_experience CHECK (years_of_experience BETWEEN 0 AND 100)
);

-- Create Director Table
CREATE TABLE Director(
	did INT PRIMARY KEY,
	dname VARCHAR(40),
	earnings REAL
);

-- Create Movie Table
CREATE TABLE Movie(
	mname VARCHAR(40) PRIMARY KEY,
	genre VARCHAR(40),
	mins INT,
	release_year INT,
	did INT,
	CONSTRAINT FK_did FOREIGN KEY (did) REFERENCES Director,
	CONSTRAINT CHK_release_year CHECK (release_year BETWEEN 1800 AND 2024)
);

-- Create Acted Table (Junction table for Performers and Movies)
CREATE TABLE Acted(
	pid INT,
	mname VARCHAR(40),
	CONSTRAINT PK_acted PRIMARY KEY (pid, mname),
	CONSTRAINT FK_pid FOREIGN KEY (pid) REFERENCES Performer,
	CONSTRAINT FK_mname FOREIGN KEY (mname) REFERENCES Movie
);

-------------------------------
-- INSERTING SAMPLE DATA
-------------------------------

INSERT INTO Performer (pid, pname, years_of_experience, age) VALUES
(1, 'Morgan', 48, 67),
(2, 'Cruz', 14, 28),
(3, 'Adams', 1, 16),
(4, 'Perry', 18, 32),
(5, 'Hanks', 36, 55),
(6, 'Hanks', 15, 24),
(7, 'Lewis', 13, 32);

INSERT INTO Director (did, dname, earnings) VALUES
(1, 'Parker', 580000),
(2, 'Black', 2500000),
(3, 'Black', 30000),
(4, 'Stone', 820000);

INSERT INTO Movie (mname, genre, mins, release_year, did) VALUES
('Jurassic Park', 'Action', 125, 1984, 2),
('Shawshank Redemption', 'Drama', 105, 2001, 2),
('Fight Club', 'Drama', 144, 2015, 2),
('The Departed', 'Drama', 140, 1969, 3),
('Back to the Future', 'Comedy', 89, 2008, 3),
('The Lion King', 'Animation', 97, 1990, 1),
('Alien', 'Sci-Fi', 115, 2006, 3),
('Toy Story', 'Animation', 104, 1978, 1),
('Scarface', 'Drama', 124, 2003, 1),
('Up', 'Animation', 111, 1999, 4);

INSERT INTO Acted (pid, mname) VALUES
(4, 'Fight Club'),
(5, 'Fight Club'),
(6, 'Shawshank Redemption'),
(4, 'Up'),
(5, 'Shawshank Redemption'),
(1, 'The Departed'),
(2, 'Fight Club'),
(3, 'Fight Club'),
(4, 'Alien');