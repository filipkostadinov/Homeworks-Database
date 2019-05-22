use SEDCHome
go

--1.1
declare @FirstName nvarchar(100)
set @FirstName = 'Antonio'

select * from Student
where FirstName = @FirstName

--1.2
declare @StudentList table
(StudentId int, StudentName nvarchar(100), DateOfBirth date)

insert into @StudentList
select ID, FirstName, DateOfBirth from Student
where Gender = 'F'

select * from @StudentList

--1.3
create table #StudentTempTable
(LastName nvarchar(100), EnrolledDate date)

insert into #StudentTempTable
select LastName, EnrolledDate
from Student
where Gender = 'M' and FirstName like 'A%'

select * from #StudentTempTable
where len(LastName) = 7

--1.4
select * from Teacher
where len(FirstName) < 5 and left(FirstName,3) = left(LastName, 3)

--2
create function dbo.fn_FormatStudentName (@StudentId int)
returns nvarchar(1000)
as 
begin
declare @Result nvarchar(100)
select @Result = substring(StudentCardNumber,4,10) + ' - ' + left(FirstName,1) + '.' + LastName
from Student
where ID = @StudentId
return @Result
end

select *, dbo.fn_FormatStudentName(id) as FunctionOutput from Student

--3

create function dbo.fn_StudentsPassedExam (@TeacherId int, @CourseId int)
returns @Output table(FirstName nvarchar(100), LastName nvarchar(100), Grade int, CreatedDate datetime)
as
begin
	insert into @Output
	select s.FirstName, s.LastName, g.Grade, g.CreatedDate
	from Grade g
	inner join Student s on s.ID = g.StudentID
	where g.TeacherID = @TeacherId and g.CourseID = @CourseId and g.Grade > 5
	group by  s.FirstName, s.LastName,g.Grade, g.CreatedDate
return
end

select * from dbo.fn_StudentsPassedExam(63,22)
