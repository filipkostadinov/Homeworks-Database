USE SEDCHome
GO

--Calculate the count of all grades in the system

SELECT count(*) AS NumberOfGrades FROM Grade

--Calculate the count of all grades per Teacher in the system

SELECT t.ID,t.FirstName,t.LastName, COUNT(*) AS NumberOfGrades
FROM Grade g
INNER JOIN Teacher t ON t.ID = g.TeacherID 
GROUP BY t.ID,t.FirstName, t.LastName

--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100)

SELECT t.ID,t.FirstName,t.LastName, COUNT(*) AS NumberOfGrades
FROM Grade g
INNER JOIN Teacher t ON t.ID = g.TeacherID 
WHERE g.StudentID < 100
GROUP BY t.ID,t.FirstName, t.LastName

--Find the Maximal Grade, and the Average Grade per Student on all grades in the system

SELECT s.ID,s.FirstName, MAX(g.Grade) AS MaxGrade, AVG(g.Grade) AS AvgGrade
FROM Grade g 
INNER JOIN Student s ON s.ID=g.StudentID
GROUP BY s.ID,s.FirstName

--Calculate the count of all grades per Teacher in the system and filter only grade count greater then 200

SELECT t.ID,t.FirstName,t.LastName, COUNT(g.Grade) AS NumberOfGrades
FROM Grade g
INNER JOIN Teacher t ON t.ID = g.TeacherID 
GROUP BY t.ID,t.FirstName, t.LastName
HAVING COUNT(g.Grade) > 200

--Calculate the count of all grades per Teacher in the system for first 100 Students (ID < 100) and filter teachers with more than 50 Grade count

SELECT t.ID,t.FirstName,t.LastName, COUNT(g.Grade) AS NumberOfGrades
FROM Grade g
INNER JOIN Teacher t ON t.ID = g.TeacherID
WHERE g.StudentID < 100
GROUP BY t.ID,t.FirstName, t.LastName
HAVING COUNT(g.Grade) > 50

--Find the Grade Count, Maximal Grade, and the Average Grade per Student on all grades in the system. Filter only records where Maximal Grade is equal to Average Grade

SELECT s.ID, s.FirstName, COUNT(g.Grade) AS NumberOfGrades, MAX(g.Grade) AS MaxGrade, AVG(g.Grade) AS AvgGrade
FROM Grade g
INNER JOIN Student s ON s.ID=g.StudentID
GROUP BY s.ID, s.FirstName
HAVING MAX(g.Grade) = AVG(g.Grade)

--List Student First Name and Last Name next to the other details from previous query

SELECT s.FirstName,s.LastName, COUNT(g.Grade) AS NumberOfGrades, MAX(g.Grade) AS MaxGrade, AVG(g.Grade) AS AvgGrade
FROM Grade g
INNER JOIN Student s ON s.ID=g.StudentID
GROUP BY s.FirstName,s.LastName
HAVING MAX(g.Grade) = AVG(g.Grade)

--Create new view (vv_StudentGrades) that will List all StudentIds and count of Grades per student

CREATE VIEW [vv_StudentGrades]
AS
SELECT StudentID, COUNT(Grade) AS NumberOfGrades
FROM Grade
GROUP BY StudentID

--Change the view to show Student First and Last Names instead of StudentID

ALTER VIEW [vv_StudentGrades]
AS
SELECT s.FirstName, s.LastName, COUNT(Grade) AS NumberOfGrades
FROM Grade g
INNER JOIN Student s ON s.ID=g.StudentID
GROUP BY s.FirstName, s.LastName

--List all rows from view ordered by biggest Grade Count

SELECT * FROM vv_StudentGrades
ORDER BY NumberOfGrades DESC

--Create new view (vv_StudentGradeDetails) that will List all Students (FirstName and LastName) and Count the courses he passed through the exam(Ispit)

CREATE VIEW [vv_StudentGradeDetails]
AS
SELECT s.FirstName, s.LastName, a.Name, COUNT(*) as PassedExam
FROM Grade g
INNER JOIN Student s ON s.ID=g.StudentID
INNER JOIN GradeDetails gd ON gd.GradeID = g.ID
INNER JOIN AchievementType a on a.ID = gd.AchievementTypeID
WHERE a.Name = 'Ispit'
GROUP BY s.FirstName, s.LastName, a.Name