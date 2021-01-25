
--Select the database

USE GradeRecorsModuleV


--Checking for duplicate records--
--1st NF--

SELECT DISTINCT * FROM GradeRecordModuleV


--Checking for grade ranges--

SELECT Grade, MAX(TotalPoints) Maximum, MIN(TotalPoints) Minimum
FROM GradeRecordModuleV
GROUP BY Grade;

--Ading GradeID to the data--

ALTER TABLE GradeRecordModuleV
ADD GradeID AS (CASE 
					WHEN TotalPoints>=370 THEN 1
					WHEN TotalPoints BETWEEN 340 AND 360 THEN 2
					WHEN TotalPoints BETWEEN 320 AND 330 THEN 3
					WHEN TotalPoints BETWEEN 300 AND 319 THEN 4
					WHEN TotalPoints BETWEEN 290 AND 299 THEN 5
					WHEN TotalPoints BETWEEN 275 AND 289 THEN 6
					WHEN TotalPoints BETWEEN 265 AND 274 THEN 7
					WHEN TotalPoints BETWEEN 252 AND 264 THEN 8
					WHEN TotalPoints BETWEEN 240 AND 251 THEN 9
					ELSE 10
				END);	

				
--Finding Duplicates in StudentID column--

SELECT StudentID, COUNT(StudentID)
FROM GradeRecordModuleV
GROUP BY StudentID
HAVING COUNT(StudentID) > 1;


SELECT DISTINCT * FROM GradeRecordModuleV
WHERE StudentID=35932 OR StudentID=47058 OR StudentID=64698;


UPDATE GradeRecordModuleV
SET StudentID=35933
WHERE FirstName='Lynde' AND LastName='Ducker';

UPDATE GradeRecordModuleV
SET StudentID=47059
WHERE FirstName='Chen' AND LastName='Dumbleton';

UPDATE GradeRecordModuleV
SET StudentID=64699
WHERE FirstName='Aurea' AND LastName='Longea';


--2nd and 3rd NF--

SELECT StudentID, FirstName, LastName
INTO Students
FROM GradeRecordModuleV;

SELECT MidTermExam, FinalExam, Assignment1, Assignment2, TotalPoints, StudentID
INTO ExamResults
FROM GradeRecordModuleV;

SELECT DISTINCT TotalPoints, StudentAverage, GradeID
INTO FinalGrades
FROM GradeRecordModuleV;

SELECT DISTINCT GradeID, Grade
INTO GradeGroups
FROM GradeRecordModuleV;


--Identify primary key--

ALTER TABLE Students
ADD CONSTRAINT PK_StudentID PRIMARY KEY(StudentID);

ALTER TABLE FinalGrades
ADD CONSTRAINT PK_TotalPoints PRIMARY KEY(TotalPoints);

ALTER TABLE ExamResults
ADD RowID INT IDENTITY (1,1);

ALTER TABLE ExamResults
ADD CONSTRAINT PK_Results PRIMARY KEY(RowID);

ALTER TABLE GradeGroups
ADD CONSTRAINT PK_GradeID PRIMARY KEY(GradeID);


--Identify foreign key--

ALTER TABLE ExamResults
ADD CONSTRAINT FK_TotalPoints
FOREIGN KEY(TotalPoints) REFERENCES FinalGrades(TotalPoints);

ALTER TABLE ExamResults
ADD CONSTRAINT FK_StudentID
FOREIGN KEY(StudentID) REFERENCES Students(StudentID);

ALTER TABLE FinalGrades
ADD CONSTRAINT FK_GradeID
FOREIGN KEY(GradeID) REFERENCES GradeGroups(GradeID);


--Resulting join table--

SELECT S.StudentID, FG.StudentAverage, G.Grade
INTO StudentsResults
FROM Students AS S
FULL JOIN 
ExamResults AS ER
ON S.StudentID=ER.StudentID
FULL JOIN
FinalGrades AS FG
ON FG.TotalPoints=ER.TotalPoints
FULL JOIN
GradeGroups AS G
ON FG.GradeID=G.GradeID;
