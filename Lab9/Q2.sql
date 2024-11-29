-- Q2.1
CREATE VIEW deptSummary AS
SELECT dept.dno, dept.dname, COUNT(*) as totalEmp, SUM(salary) as totalSalary
FROM dept JOIN emp ON dept.dno = emp.dno
GROUP BY dept.dno

-- Q2.2 (todo)
-- Write a CREATE VIEW statement for workson database called empSummary
--  that has the employee number, name, salary, birthdate, department, count of 
--  projects worked on for the employee and the total hours worked. 
--  Only show employees in 'D1', 'D2', or 'D3' and with birthdate after '1966-06-08'.
--  View contents:
CREATE VIEW empSummary AS 
SELECT e.eno, e.ename, e.salary, e.bdate, e.dno 
FROM emp as e
JOIN workson ON 