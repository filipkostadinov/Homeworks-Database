--Create new procedure called CreateGrade
CREATE PROCEDURE CreateGrade (@StudentId int,@CourseId int,@TeacherId int,@Grade int,
@Comment nvarchar(100),@CreatedDate datetime)
AS
BEGIN

IF @CreatedDate is null
BEGIN
SET @CreatedDate = GETDATE()
END
--Procedure should create only Grade header info (not Grade Details) 
INSERT INTO Grade (StudentID,CourseID,TeacherID,Grade,Comment,CreatedDate)
VALUES(@StudentId,@CourseId,@TeacherId,@Grade,@Comment,@CreatedDate)

--Procedure should return the total number of grades in the system for the Student on input (from the CreateGrade)
SELECT COUNT(Grade) FROM Grade
WHERE StudentID = @StudentId

--Procedure should return second resultset with the MAX Grade of all grades for the Student and Teacher on input (regardless the Course)
SELECT MAX(Grade) FROM Grade
WHERE StudentID = @StudentId and TeacherID = @TeacherId

END
GO

EXEC CreateGrade 
@StudentId = 115,
@CourseId = 10,
@TeacherId = 10,
@Grade = 8,
@Comment = 'Dobar',
@CreatedDate = null

EXEC CreateGrade
@StudentId = 115,
@CourseId = 6,
@TeacherId = 6,
@Grade = 8,
@Comment = 'Dobar',
@CreatedDate = null

GO

--Create new procedure called CreateGradeDetail
CREATE PROCEDURE CreateGradeDetail (@GradeId int,@AchievementTypeId tinyint,@AchievementPoints tinyint,
@AchievementMaxPoints tinyint,@AchievementDate datetime)
AS
BEGIN

IF @AchievementDate IS NULL
BEGIN
SET @AchievementDate = GETDATE()
END

--Add error handling on CreateGradeDetail procedure
BEGIN TRY

--Procedure should add details for specific Grade (new record for new AchievementTypeID, Points, MaxPoints, Date for specific Grade)
INSERT INTO GradeDetails (GradeID,AchievementTypeID,AchievementPoints,AchievementMaxPoints,AchievementDate)
VALUES (@GradeId,@AchievementTypeId,@AchievementPoints,@AchievementMaxPoints,@AchievementDate)

--Output from this procedure should be resultset with SUM of GradePoints calculated with formula AchievementPoints/AchievementMaxPoints*ParticipationRate for specific Grade
SELECT SUM(CAST(gd.AchievementPoints as decimal(18,2))/gd.AchievementMaxPoints*a.ParticipationRate)
FROM GradeDetails gd
INNER JOIN AchievementType a ON a.ID = gd.AchievementTypeID
WHERE gd.GradeID = @GradeId

END TRY
BEGIN CATCH
SELECT 
	ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH

END
GO

--GradeId 20062 is new created grade in previous task
EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 0,
@AchievementPoints = 90,
@AchievementMaxPoints = 100,
@AchievementDate = null

EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 1,
@AchievementPoints = 50,
@AchievementMaxPoints = 100,
@AchievementDate = null

EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 2,
@AchievementPoints = 70,
@AchievementMaxPoints = 100,
@AchievementDate = null

EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 3,
@AchievementPoints = 75,
@AchievementMaxPoints = 100,
@AchievementDate = null

EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 4,
@AchievementPoints = 70,
@AchievementMaxPoints = 100,
@AchievementDate = null

GO

--Test the error handling by inserting not-existing values for AchievementTypeID
EXEC CreateGradeDetail 
@GradeId = 20062,
@AchievementTypeId = 12,
@AchievementPoints = 70,
@AchievementMaxPoints = 100,
@AchievementDate = null