-- Q2.1
CREATE VIEW deptSummary AS
SELECT dept.dno, dept.dname, COUNT(*) as totalEmp, SUM(salary) as totalSalary
FROM dept JOIN emp ON dept.dno = emp.dno
GROUP BY dept.dno

-- Q2.2

CREATE VIEW empSummary AS 
SELECT 
    e.eno, 
    e.ename, 
    e.salary, 
    e.bdate, 
    e.dno, 
    COUNT(w.pno) AS totalProj,  -- Count the distinct projects worked on
    SUM(w.hours) AS totalHours -- Sum the total hours worked
FROM 
    emp AS e
LEFT JOIN 
    workson AS w 
ON 
    e.eno = w.eno
WHERE 
    (e.dno = 'D1' OR e.dno = 'D2' OR e.dno = 'D3') -- Filter departments
    AND e.bdate > '1966-06-08'                     -- Filter birthdates
GROUP BY 
    e.eno, e.ename, e.salary, e.bdate, e.dno;
