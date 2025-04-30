## Problem Statment

You have joined a development team in an organization that organizes summer youth
camps for children & teenagers. A youth summer camp is a supervised program
designed for children and teenagers during the summer months when school is not in
session. These camps offer a variety of activities that aim to educate, entertain, and
engage young people in a safe and structured environment. The duration of these
camps can range from a few days to several weeks.

# Task 1: Your job is to create a database model for this situation. The model must
contain three tables. a) The first two tables will contain the columns that are in the
orange bubble. Each column can exist in exactly one table! b) The third table will
contain columns of your choice, but we must be able to tell how many times a
teenager Lakshmi visited the camp in last 3 years.
SUMMER CAMP TASK
First Name
Last Name
Middle Name
Date of Birth
Email
Gender
Camp Title
Start Date
Personal Phone
End Date
Price
Capacity

# Task 2: Create a script that will populate one of your tables with a random 5000
people. Out of these 5000, 65% should be girls and 35% should be boys. Out of
these 5000, 18% should be between 7 and 12 years old, 27% should be 13 to14,
20% should be 15-17 and the rest could be any age up to 19 years old.
Task 3: Write a query that can
output data in a format so that
following chart can be drawn. The
number in the chart are indicative
55%
45%
46%
54% 64%
36%
64%
36%
Gen X Millenials Gen Z Gen Alpha
█ Male █ Female

Your final solution should be submitted as one SQL script. 

# Solution



-- Create Data Base with the name of Youth_Summer_Camp
CREATE DATABASE Youth_Summer_Camp
Go
USE Youth_Summer_Camp
GO
-- Create a Tabler with name of Student where student who visit summer camp there data will store.
-- Feature:- ID is primary key with ascending order by default.
--Index Options for performance tuning.


DROP TABLE IF EXISTS dbo.tbl_Student
GO
CREATE TABLE [dbo].[tbl_Student]
(
    [ID] INT IDENTITY (1,1) NOT NULL,
    [First Name] VARCHAR(100) NOT NULL,
    [Middle Name] VARCHAR(100) NULL,
    [Last Name] VARCHAR(100)NULL,
    [Email] VARCHAR(100) NOT NULL,
    [Date Of Birth] DATE NOT NULL,
    [Gender] CHAR(6) NOT NULL,
    [Personal Phone] VARCHAR(10) NOT NULL,
CONSTRAINT [PK_tbl_Student] PRIMARY KEY CLUSTERED
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Alter table and add Create Date with Datetime as default
ALTER TABLE dbo.tbl_Student ADD [Created Date] DATETIME DEFAULT (GETDATE())


GO
-- Create Camps Table that contain Camps details like Tital/Name of Campus Start & end data etc.
--
GO


DROP TABLE IF EXISTS dbo.tbl_Camps
GO


CREATE TABLE [dbo].[tbl_Camps]
(
    ID INT IDENTITY (1,1) NOT NULL,
    [Camp Title] VARCHAR(200) NOT NULL,
    [Start Date] DATE NOT NULL,
    [End Date] DATE NOT NULL,
    [Capacity] INT NULL,
    [Price] DECIMAL(10,2) NOT NULL,
CONSTRAINT [PK_tbl_Camps] PRIMARY KEY CLUSTERED
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
-- Alter table and add Create Date with Datetime as default


ALTER TABLE dbo.tbl_Camps ADD [Created Date] DATETIME DEFAULT (GETDATE())


GO
--Craeate table of Campus Visit History where student visit to particular camp History will be recored.
--History table will be linke with Student & Camp, both table by Forigen Key.


GO


DROP TABLE IF EXISTS dbo.tbl_Campus_Visit_History
GO
CREATE TABLE [dbo].[tbl_Campus_Visit_History]
(
    [ID] INT IDENTITY (1,1) NOT NULL,
    [Student_ID] INT NOT NULL,
    [Camp_ID] INT NOT NULL,
    VisitDate DATE NOT NULL,
    FOREIGN KEY (Student_ID) REFERENCES dbo.tbl_Student(ID),
    FOREIGN KEY (Camp_ID) REFERENCES tbl_Camps(ID),
CONSTRAINT [PK_tbl_Campus_Visit_History] PRIMARY KEY CLUSTERED
(
    [ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE dbo.tbl_Campus_Visit_History ADD [Created Date] DATETIME DEFAULT (GETDATE())
GO


-------Insert data into Student Table from Excel. Data having as per Task 2


-- Insert Data into the Table
INSERT INTO [Youth_Summer_Camp].[dbo].[tbl_Student]
(
[First Name],[Middle Name],[Last Name],[Email],[Date Of Birth],[Gender],[Personal Phone]
)


SELECT
[First Name],[Middle Name],[Last Name],[Email],[Date Of Birth],[Gender],[Personal Phone]
FROM
OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;HDR=YES;Database=C:\Users\SLS0822\Desktop\Project\tbl_Student.xlsx;',
'SELECT * FROM [tbl_Student$]')


GO


-------Insert data into the Camps Table from Excel. Data having as per Task 3


-- Insert Data into the Camps Table
INSERT INTO [Youth_Summer_Camp].[dbo].[tbl_Camps]
(
[Camp Title],[Start Date],[End Date],[Capacity],[Price]
)


SELECT
[Camp Title],[Start Date],[End Date],[Capacity],[Price]
FROM
OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;HDR=YES;Database=C:\Users\SLS0822\Desktop\Project\tbl_Camps.xlsx;',
'SELECT * FROM [tbl_Camps$]')
GO


-------Insert data into Camps Visit Histry Table from Excel. Data having as per Task 3
------ Asume that [VisitDate] is [tbl_Camps].[Start Date]


-- Insert Data into the Camps Visit History Table
INSERT INTO [Youth_Summer_Camp].[dbo].[tbl_Campus_Visit_History]
(
[Student_ID],[Camp_ID],[VisitDate]
)


SELECT
[Student_ID],[Camp_ID],[VisitDate]
FROM
OPENROWSET('Microsoft.ACE.OLEDB.12.0',
'Excel 12.0;HDR=YES;Database=C:\Users\SLS0822\Desktop\Project\tbl_Campus_Visit_History.xlsx;',
'SELECT * FROM [tbl_Campus_Visit_History$]')
GO


-------- To Get Data as per chart for task 3 run below query


with temp_camp as (
SELECT c.[Camp Title],S.[Gender], COUNT(*) AS StudentCount
FROM tbl_Campus_Visit_History AS CVH
JOIN tbl_Student AS S
ON CVH.Student_ID= S.ID
JOIN tbl_Camps AS C
ON CVH.Camp_ID= c.ID
GROUP BY
c.[Camp Title],s.[Gender]
)


SELECT
    [Camp Title],
    [Gender],
    [StudentCount],
    SUM(StudentCount) OVER (PARTITION BY [Camp Title]) AS [Total Student],
    CAST(StudentCount AS decimal(10,2)) / SUM(StudentCount) OVER (PARTITION BY [Camp Title]) AS [Percentage %]
FROM
    temp_camp;
;
---------Now we are able to create the same chart in PowerBi for the same data.
-----------Thanks






