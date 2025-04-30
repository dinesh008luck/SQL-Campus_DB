SELECT * FROM tbl_Camps;
SELECT * FROM tbl_Student
SELECT * FROM tbl_Campus_Visit_History;
;

with temp_camp as (
SELECT c.[Camp Title],S.[Gender], COUNT(*) AS StudentCount
FROM tbl_Campus_Visit_History AS CVH
JOIN tbl_Student AS S
ON CVH.Student_ID= S.ID
JOIN tbl_Camps AS C
ON CVH.Camp_ID= c.ID
GROUP BY 
c.[Camp Title],s.Gender
)

SELECT 
    [Camp Title],
    [Gender],
    [StudentCount],
    SUM(StudentCount) OVER (PARTITION BY [Camp Title]) AS [Total Student],
    CAST(StudentCount AS decimal(10,2)) / SUM(StudentCount) OVER (PARTITION BY [Camp Title]) AS [Percentage]
FROM 
    temp_camp;
;



SELECT 
    c.[Camp Title],
    s.Gender,
    COUNT(*) AS StudentCount
FROM 
    [dbo].[tbl_Campus_Visit_History] v
JOIN 
    [dbo].[tbl_Student] s ON v.Student_ID = s.ID
JOIN 
    [dbo].[tbl_Camps] c ON v.Camp_ID = c.ID
GROUP BY 
    c.[Camp Title], s.Gender
ORDER BY 
    c.[Camp Title], s.Gender;
