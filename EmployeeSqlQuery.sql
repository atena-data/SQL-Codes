-- Selecting the database--
USE EmployeeInformation;

--ETL on master table--

ALTER TABLE EmployeeDataPractice 
ADD CitizenshipID AS (CASE
							WHEN CitizenDesc = 'Eligible NonCitizen' THEN 1
							WHEN CitizenDesc = 'Non-Citizen' THEN 2
							ELSE 3
						END);


ALTER TABLE EmployeeDataPractice 
ADD RaceID AS (CASE
						WHEN RaceDesc = 'American Indian or Alaska Native' THEN 1
						WHEN RaceDesc = 'Asian' THEN 2
						WHEN RaceDesc = 'Black or African American' THEN 3
						WHEN RaceDesc = 'Hispanic' THEN 4
						WHEN RaceDesc = 'White' THEN 5
						ELSE 6
					END);

ALTER TABLE EmployeeDataPractice 
ADD RecruitSourceID AS (CASE
						WHEN RecruitmentSource = 'CareerBuilder' THEN 1
						WHEN RecruitmentSource = 'Diversity Job Fair' THEN 2
						WHEN RecruitmentSource = 'Employee Referral' THEN 3
						WHEN RecruitmentSource = 'Google Search' THEN 4
						WHEN RecruitmentSource = 'Indeed' THEN 5
						WHEN RecruitmentSource = 'LinkedIn' THEN 6
						WHEN RecruitmentSource = 'On-line Web application' THEN 7
						WHEN RecruitmentSource = 'Website' THEN 8
						ELSE 9
					END);

UPDATE EmployeeDataPractice
SET Position = 'IT Manager'
WHERE PositionID=13;

--Create tables from master table--

SELECT DISTINCT MaritalStatusID, MaritalDesc 
INTO EmployeeMarital
FROM EmployeeDataPractice;

SELECT DISTINCT EmpStatusID, EmploymentStatus 
INTO EmploymentStatus
FROM EmployeeDataPractice;

SELECT DISTINCT DeptID, Department 
INTO Departments
FROM EmployeeDataPractice;

SELECT DISTINCT PerfScoreID, PerformanceScore 
INTO EmployeePerformance
FROM EmployeeDataPractice;

SELECT DISTINCT PositionID, Position 
INTO EmployeePosition
FROM EmployeeDataPractice;

SELECT DISTINCT ManagerID, ManagerName 
INTO Managers
FROM EmployeeDataPractice;

SELECT DISTINCT GenderID, Sex AS Gender 
INTO EmployeeGender
FROM EmployeeDataPractice;

SELECT Zip, State, EmpID 
INTO EmployeeAddress
FROM EmployeeDataPractice;

SELECT EmpID, Employee_Name 
INTO EmployeeName
FROM EmployeeDataPractice;

SELECT DISTINCT CitizenshipID, CitizenDesc 
INTO EmployeeCitizenship
FROM EmployeeDataPractice;

SELECT DISTINCT RaceID, RaceDesc 
INTO EmployeeRace
FROM EmployeeDataPractice;

SELECT DISTINCT RecruitSourceID, RecruitmentSource 
INTO EmployeeRecSource
FROM EmployeeDataPractice;

SELECT Salary, DOB, DateofHire, DateofTermination, TermReason, 
EmpSatisfaction, SpecialProjectsCount, LastPerformanceReview_Date, 
DaysLateLast30, Absences,EmpID, MaritalStatusID, GenderID, 
PositionID, ManagerID, EmpStatusID, DeptID, PerfScoreID, 
CitizenshipID, RaceID, RecruitSourceID 
INTO Employees
FROM EmployeeDataPractice;

--Assign Primary Key to the tables--

ALTER TABLE Employees
ADD CONSTRAINT PK_EmpID PRIMARY KEY(EmpID);

ALTER TABLE Departments
ADD CONSTRAINT PK_DeptID PRIMARY KEY(DeptID);

ALTER TABLE EmployeeMarital
ADD CONSTRAINT PK_MariID PRIMARY KEY(MaritalStatusID);

ALTER TABLE EmployeePerformance
ADD CONSTRAINT PK_PerfScoreID PRIMARY KEY(PerfScoreID);

ALTER TABLE EmployeePosition
ADD CONSTRAINT PK_PositionID PRIMARY KEY(PositionID);

ALTER TABLE EmploymentStatus
ADD CONSTRAINT PK_EmpStatusID PRIMARY KEY(EmpStatusID);

ALTER TABLE Managers
ADD CONSTRAINT PK_ManagerID PRIMARY KEY(ManagerID);

ALTER TABLE EmployeeGender
ADD CONSTRAINT PK_GenderID PRIMARY KEY(GenderID);

ALTER TABLE EmployeeCitizenship
ADD CONSTRAINT PK_CitizenshipID PRIMARY KEY(CitizenshipID);

ALTER TABLE EmployeeRace
ADD CONSTRAINT PK_RaceID PRIMARY KEY(RaceID);

ALTER TABLE EmployeeRecSource
ADD CONSTRAINT PK_RecruitSourceID PRIMARY KEY(RecruitSourceID);

ALTER TABLE EmployeeAddress
ADD AddressID INT IDENTITY (1,1);

ALTER TABLE EmployeeAddress
ADD CONSTRAINT PK_AddressID PRIMARY KEY(AddressID);

ALTER TABLE EmployeeName
ADD NameID INT IDENTITY (1,1);

ALTER TABLE EmployeeName
ADD CONSTRAINT PK_NameID PRIMARY KEY(NameID);

--Assign foreign key to the tables--

ALTER TABLE Employees
ADD CONSTRAINT FK_DeptID
FOREIGN KEY (DeptID) REFERENCES Departments(DeptID);

ALTER TABLE Employees
ADD CONSTRAINT FK_CitizenshipID
FOREIGN KEY (CitizenshipID) REFERENCES EmployeeCitizenship(CitizenshipID);

ALTER TABLE Employees
ADD CONSTRAINT FK_GenderID
FOREIGN KEY (GenderID) REFERENCES EmployeeGender(GenderID);

ALTER TABLE Employees
ADD CONSTRAINT FK_MaritalStatusID
FOREIGN KEY (MaritalStatusID) REFERENCES EmployeeMarital(MaritalStatusID);

ALTER TABLE Employees
ADD CONSTRAINT FK_PerfScoreID
FOREIGN KEY (PerfScoreID) REFERENCES EmployeePerformance(PerfScoreID);

ALTER TABLE Employees
ADD CONSTRAINT FK_PositionID
FOREIGN KEY (PositionID) REFERENCES EmployeePosition(PositionID);

ALTER TABLE Employees
ADD CONSTRAINT FK_ManagerID
FOREIGN KEY (ManagerID) REFERENCES Managers(ManagerID);

ALTER TABLE Employees
ADD CONSTRAINT FK_RaceID
FOREIGN KEY (RaceID) REFERENCES EmployeeRace(RaceID);

ALTER TABLE Employees
ADD CONSTRAINT FK_RecruitSourceID
FOREIGN KEY (RecruitSourceID) REFERENCES EmployeeRecSource(RecruitSourceID);

ALTER TABLE Employees
ADD CONSTRAINT FK_EmpStatusID
FOREIGN KEY (EmpStatusID) REFERENCES EmploymentStatus(EmpStatusID);

ALTER TABLE EmployeeName
ADD CONSTRAINT FK_EmpID
FOREIGN KEY (EmpID) REFERENCES Employees(EmpID);

ALTER TABLE EmployeeAddress
ADD CONSTRAINT FK1_EmpID
FOREIGN KEY (EmpID) REFERENCES Employees(EmpID);

--Employee Information as a view--

CREATE VIEW VW_EmployeeInfo
AS SELECT E.EmpID, EPO.Position, D.Department, M.ManagerName, EPE.PerformanceScore
FROM Employees AS E
FULL JOIN
EmployeePosition AS EPO
ON E.PositionID=EPO.PositionID
FULL JOIN
Departments AS D
ON E.DeptID=D.DeptID
FULL JOIN 
Managers AS M
ON E.ManagerID=M.ManagerID
FULL JOIN
EmployeePerformance AS EPE
ON E.PerfScoreID=EPE.PerfScoreID;
