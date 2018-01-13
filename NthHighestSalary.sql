Create table Employee
(
     ID int primary key identity,
     FirstName nvarchar(50),
     LastName nvarchar(50),
     Gender nvarchar(50),
     Salary int
)

Insert into Employee values ('Ben', 'Hoskins', 'Male', 70000)
Insert into Employee values ('Mark', 'Hastings', 'Male', 60000)
Insert into Employee values ('Steve', 'Pound', 'Male', 45000)
Insert into Employee values ('Ben', 'Hoskins', 'Male', 70000)
Insert into Employee values ('Philip', 'Hastings', 'Male', 45000)
Insert into Employee values ('Mary', 'Lambeth', 'Female', 30000)
Insert into Employee values ('Valarie', 'Vikings', 'Female', 35000)
Insert into Employee values ('John', 'Stanmore', 'Male', 80000)

SELECT TOP 1 SALARY
FROM (
      SELECT DISTINCT TOP 3 SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC
      ) RESULT
ORDER BY SALARY

--To find nth highest salary using CTE
WITH RESULT AS
(
    SELECT SALARY,
           DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DENSERANK
    FROM EMPLOYEE
)
SELECT TOP 1 SALARY
FROM RESULT
WHERE DENSERANK = 3