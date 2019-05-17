use SEDCHome
go

--Find all Students with FirstName = Antonio
select * from Student
where FirstName='Antonio'

--Find all Students with DateOfBirth greater than ‘01.01.1999’
select * from Student
where DateOfBirth > '01.01.1999'

--Find all Male students
select * from Student
where Gender='M'

--Find all Students with LastName starting With ‘T’
select * from Student
where LastName like 'T%'

--Find all Students Enrolled in January/1998
select * from Student
where EnrolledDate >= '01.01.1998' and EnrolledDate < '02.01.1998'

--Find all Students with LastName starting With ‘J’ enrolled in January/1998
select * from Student
where LastName like 'J%' and EnrolledDate >= '01.01.1998' and EnrolledDate < '02.01.1998'

--Find all Students with FirstName = Antonio ordered by Last Name
select * from Student
where FirstName='Antonio'
order by LastName

--List all Students ordered by FirstName
select * from Student
order by FirstName

--Find all Male students ordered by EnrolledDate, starting from the last enrolled
select * from Student
where Gender='M'
order by EnrolledDate desc

--List all Teacher First Names and Student First Names in single result set with duplicates
select FirstName from Teacher
union all 
select FirstName from Student

--List all Teacher Last Names and Student Last Names in single result set. Remove duplicates
select FirstName from Teacher
union
select FirstName from Student

--List all common First Names for Teachers and Students
select FirstName from Teacher
intersect
select FirstName from Student

--Change GradeDetails table always to insert value 100 in AchievementMaxPoints column if no value is provided on insert
alter table GradeDetails
add constraint DF_GradeDetails_AchievementMaxPoints
default 100 for AchievementMaxPoints

--Change GradeDetails table to prevent inserting AchievementPoints that will more than AchievementMaxPoints
alter table GradeDetails with check
add constraint CHK_GradeDetails_AchievementPoints
check (AchievementPoints <= AchievementMaxPoints)

--Change AchievementType table to guarantee unique names across the Achievement types
alter table AchievementType with check
add constraint UN_AchievementType_Name unique (Name)

--Create Foreign key constraints from diagram or with script
alter table GradeDetails with check
add constraint FK_GradeDetails_Grade
foreign key (GradeId)
references Grade(Id)

alter table GradeDetails with check
add constraint FK_GradeDetails_AchievementType
foreign key (AchievementTypeID)
references AchievementType(ID)

alter table Grade with check
add constraint FK_Grade_Student
foreign key (StudentID)
references Student(ID)

alter table Grade with check
add constraint FK_Grade_Course
foreign key (CourseID)
references Course(ID)

alter table Grade with check
add constraint FK_Grade_Teacher
foreign key (TeacherID)
references Teacher(ID)

alter table Grade with check
add constraint FK_Grade_Student
foreign key (StudentID)
references Student(ID)

--List all possible combinations of Courses names and AchievementType names that can be passed by student
select c.Name as CourseName, a.Name as AchievementTypeName
from Course c
cross join AchievementType a

--List all Teachers that has any exam Grade
select distinct t.FirstName
from Grade g
inner join Teacher t on t.ID=g.TeacherID

--List all Teachers without exam Grade
select distinct t.FirstName
from Teacher t
left join Grade g on t.ID=g.TeacherID
where g.TeacherID is null

--List all Students without exam Grade (using Right Join)
select distinct s.FirstName
from Grade g
right join Student s on s.ID=g.StudentID
where g.StudentID is null