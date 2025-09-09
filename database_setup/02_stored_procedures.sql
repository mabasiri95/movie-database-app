/*
================================================================================
 02_stored_procedures.sql
 Description: Creates the stored procedures for the application's business logic.
================================================================================
*/

--- Procedure to add a new performer, estimating experience based on age
DROP PROCEDURE IF EXISTS add_performer_by_age; 
GO
CREATE PROCEDURE add_performer_by_age 
    @pid INT,
    @pname VARCHAR(20),
    @age INT
AS
BEGIN
    DECLARE @estimated_exp INT;

    -- Estimate experience by averaging performers within +/- 10 years of age
    SET @estimated_exp = (SELECT AVG(years_of_experience) FROM Performer WHERE age BETWEEN @age - 10 AND @age + 10);

    -- If no performers are in that age range, set experience to age - 18
    IF @estimated_exp IS NULL
        SET @estimated_exp = @age - 18;

    -- Constrain the value to be between 0 and the performer's age
    IF @estimated_exp < 0
        SET @estimated_exp = 0;
    IF @estimated_exp > @age
        SET @estimated_exp = @age;

    -- Insert the new performer record
    INSERT INTO Performer (pid, pname, years_of_experience, age) VALUES (@pid, @pname, @estimated_exp, @age);
END
GO


--- Procedure to add a new performer, estimating experience based on director earnings
DROP PROCEDURE IF EXISTS add_performer_by_director_earnings; 
GO
CREATE PROCEDURE add_performer_by_director_earnings
    @pid INT,
    @pname VARCHAR(20),
    @age INT,
    @min_earnings REAL
AS
BEGIN
    DECLARE @estimated_exp INT;

    -- Find the minimum experience of performers who worked for a director with earnings > @min_earnings
    SET @estimated_exp = (
        SELECT MIN(p.years_of_experience)
        FROM Performer p
        JOIN Acted a ON p.pid = a.pid
        JOIN Movie m ON a.mname = m.mname
        JOIN Director d ON m.did = d.did
        WHERE d.earnings > @min_earnings
    );

    -- If no such performers exist, set experience to age - 18
    IF @estimated_exp IS NULL
        SET @estimated_exp = @age - 18;

    -- Constrain the value to be between 0 and the performer's age
    IF @estimated_exp < 0
        SET @estimated_exp = 0;
    IF @estimated_exp > @age
        SET @estimated_exp = @age;

    -- Insert the new performer record
    INSERT INTO Performer (pid, pname, years_of_experience, age) VALUES (@pid, @pname, @estimated_exp, @age);
END
GO


--- Procedure to display all performers
DROP PROCEDURE IF EXISTS display_all_performers; 
GO
CREATE PROCEDURE display_all_performers
AS 
BEGIN
    SELECT * FROM Performer;
END; 
GO