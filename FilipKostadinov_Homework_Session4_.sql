USE SEDCHome
GO

--Declare scalar variable for storing FirstName values
--Assign value ‘Antonio’ to the FirstName variable
--Find all Students having FirstName same as the variable

DECLARE @FirstName NVARCHAR(100)
SET @FirstName = 'Antonio'

SELECT * FROM Student
WHERE FirstName = @FirstName

--Declare table variable that will contain StudentId, StudentName and DateOfBirth
--Fill the table variable with all Female students

DECLARE @StudentList TABLE
(StudentId int, StudentName NVARCHAR(100), DateOfBirth date)

INSERT INTO @StudentList
SELECT ID, FirstName, DateOfBirth FROM Student
WHERE Gender = 'F'

SELECT * FROM @StudentList

--Declare temp table that will contain LastName and EnrolledDate columns
--Fill the temp table with all Male students having First Name starting with ‘A’
--Retrieve the students from the table which last name is with 7 characters

CREATE TABLE #StudentTempTable
(LastName NVARCHAR(100), EnrolledDate date)

INSERT INTO #StudentTempTable
SELECT LastName, EnrolledDate
FROM Student
WHERE Gender = 'M' and FirstName like 'A%'
GO

SELECT * FROM #StudentTempTable
WHERE LEN(LastName) = 7

--Find all teachers whose FirstName length is less than 5 and
--the first 3 characters of their FirstName and LastName are the same

SELECT * FROM Teacher
WHERE LEN(FirstName) < 5 and left(FirstName,3) = left(LastName, 3)

--Declare scalar function (fn_FormatStudentName) for retrieving the Student description for specific StudentId in the following format:
--StudentCardNumber without “sc-”
--“ – “
--First character of student FirstName
--“.”
--Student LastName

CREATE FUNCTION dbo.fn_FormatStudentName (@StudentId int)
RETURNS NVARCHAR(1000)
AS 
BEGIN
DECLARE @Result NVARCHAR(100)
SELECT @Result = SUBSTRING(StudentCardNumber,4,10) + ' - ' + left(FirstName,1) + '.' + LastName
FROM Student
WHERE ID = @StudentId
RETURN @Result
END
GO

SELECT *, dbo.fn_FormatStudentName(id) AS FunctionOutput FROM Student

--Create multi-statement table value function that for specific Teacher and Course will return list of students (FirstName, LastName) who passed the exam, together with Grade and CreatedDate

CREATE FUNCTION dbo.fn_StudentsPassedExam (@TeacherId int, @CourseId int)
RETURNS @Output TABLE(FirstName NVARCHAR(100), LastName NVARCHAR(100), Grade int, CreatedDate datetime)
AS
BEGIN
	INSERT INTO @Output
	SELECT s.FirstName, s.LastName, g.Grade, g.CreatedDate
	FROM Grade g
	INNER JOIN Student s ON s.ID = g.StudentID
	WHERE g.TeacherID = @TeacherId and g.CourseID = @CourseId and g.Grade > 5
	GROUP BY s.FirstName, s.LastName,g.Grade, g.CreatedDate
RETURN
END
GO

SELECT * FROM dbo.fn_StudentsPassedExam(63,22)

