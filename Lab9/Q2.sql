-- Q2.1
CREATE VIEW deptSummary AS
SELECT dept.dno, dept.dname, COUNT(*) as totalEmp, SUM(salary) as totalSalary
FROM dept JOIN emp ON dept.dno = emp.dno
GROUP BY dept.dno

-- Q2.2 (todo)
