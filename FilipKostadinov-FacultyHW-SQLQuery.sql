CREATE DATABASE Faculty_Homework2
GO

USE [Faculty_Homework2]
GO

CREATE TABLE [dbo].[Teacher](
[Id] [int] IDENTITY(1,1) NOT NULL,
[FirstName] [nvarchar](50) NOT NULL,
[LastName] [nvarchar](50) NOT NULL,
[DateOfBirth] [date] NOT NULL,
[AcademicRank] [nvarchar](100) NOT NULL,
[HireDate] [date] NULL,
CONSTRAINT [PK_Teacher] PRIMARY KEY CLUSTERED
(
[Id] ASC
))

CREATE TABLE [dbo].[Student](
[Id] [int] IDENTITY(1,1) NOT NULL,
[FirstName] [nvarchar](50) NOT NULL,
[LastName] [nvarchar](50) NOT NULL,
[DateOfBirth] [date] NOT NULL,
[EnrolledDate] [date] NOT NULL,
[Gender] [nchar](10) NULL,
[NationalIdNumber] [nvarchar](20) NOT NULL,
[StudentCardNumber] [nvarchar](20) NOT NULL,
CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED
(
[Id] ASC
))

CREATE TABLE [dbo].[Course](
[Id] [int] IDENTITY(1,1) NOT NULL,
[Name] [nvarchar](100) NOT NULL,
[Credit] [nvarchar](100) NULL,
[AcademicYear] [nchar](20) NULL,
[Semester] [nvarchar](50) NULL,
CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED
(
[Id] ASC
))

CREATE TABLE [dbo].[Grade](
[Id] [int] IDENTITY(1,1) NOT NULL,
[StudentId] [int] NOT NULL,
[CourseId] [int] NOT NULL,
[TeacherId] [int] NOT NULL,
[Grade] [int] NOT NULL,
[Comment] [nvarchar](max) NULL,
[CreatedDate] [date] NULL,
CONSTRAINT [PK_Grade] PRIMARY KEY CLUSTERED
(
[Id] ASC
)
,CONSTRAINT [FK_GradeStudentId] FOREIGN KEY(StudentId)
REFERENCES Student(Id)
,CONSTRAINT [FK_GradeTeacherId] FOREIGN KEY(TeacherId)
REFERENCES Teacher(Id)
,CONSTRAINT [FK_GradeCourseId] FOREIGN KEY(CourseId)
REFERENCES Course(Id)
)

CREATE TABLE [dbo].[GradeDetails](
[Id] [int] IDENTITY(1,1) NOT NULL,
[GradeId] [int] NOT NULL,
[AchievementTypeId] [int] NOT NULL,
[AchievementPoints] [smallint] NOT NULL,
[AchievementMaxPoints] [smallint] NOT NULL,
[AchievementDate] [date] NOT NULL,
CONSTRAINT [PK_GradeDetails] PRIMARY KEY CLUSTERED
(
[Id] ASC
)
,CONSTRAINT [FK_GradeDetailsGradeId] FOREIGN KEY(GradeId)
REFERENCES Grade(Id)
)

CREATE TABLE [dbo].[AchivementType](
[Id] [int] IDENTITY(1,1) NOT NULL,
[Name] [nvarchar](100) NOT NULL,
[Description] [nvarchar](max) NULL,
[ParticipationRate] [nchar](50) NULL,
CONSTRAINT [PK_AchivementType] PRIMARY KEY CLUSTERED
(
[Id] ASC
))

INSERT INTO [dbo].[Teacher]
           ([FirstName],[LastName],[DateOfBirth],[AcademicRank],[HireDate])
     VALUES
           ('Teacher1','Teacher1','1980-04-04','Bachelor Degree','2015-03-03'),
		   ('Teacher2','Teacher2', '1985-01-01','Bachelor Degree', '2015-10-10')
GO

INSERT INTO [dbo].[Student]
           ([FirstName],[LastName],[DateOfBirth],[EnrolledDate],[Gender],[NationalIdNumber],[StudentCardNumber])
     VALUES
           ('Student1','Student1','2000-05-05','2018-04-04','male','12312312','44443333'),
		   ('Student2','Student2','2001-05-05','2019-04-04','female','12121212','22225555')
GO

INSERT INTO [dbo].[Course]
           ([Name],[Credit],[AcademicYear],[Semester])
     VALUES
           ('Database development',NULL,'2018-2019','Spring'),
		   ('C#/.NET',NULL,'2018-2019','Spring')
GO

INSERT INTO [dbo].[Grade]
           ([StudentId],[CourseId],[TeacherId],[Grade],[Comment],[CreatedDate])
     VALUES
           (1,1,1,4,NULL,'2019-04-04'),
		   (2,2,2,5,NULL,'2018-04-04')
GO

INSERT INTO [dbo].[GradeDetails]
           ([GradeId],[AchievementTypeId],[AchievementPoints],[AchievementMaxPoints],[AchievementDate])
     VALUES
           (1,1,60,100,'2019-05-05'),
		   (2,2,70,100,'2019-05-05')
GO

INSERT INTO [dbo].[AchivementType]
           ([Name],[Description],[ParticipationRate])
     VALUES
           ('Expert database developer',NULL,NULL),
		   ('Expert .NET developer',NULL,NULL)
GO