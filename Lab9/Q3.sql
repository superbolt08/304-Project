--q1
DELIMITER $$

CREATE TRIGGER increaseBudget
AFTER INSERT ON workson
FOR EACH ROW
BEGIN
    UPDATE proj -- Use the correct table name ('proj' based on earlier definitions)
    SET budget = budget + 1000
    WHERE pno = NEW.pno; -- Match the project number of the inserted workson record
END$$

DELIMITER ;

--q2
DELIMITER $$

CREATE TRIGGER updateSalary
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
    DECLARE avg_salary DECIMAL(10, 2);

    -- Calculate average salary for employees with the same title; default to 0 if no such employees exist
    SELECT COALESCE(AVG(salary), 0)
    INTO avg_salary
    FROM emp
    WHERE title = NEW.title;

    -- Update the salary if it's less than 50,000
    IF NEW.salary < 50000 THEN
        SET NEW.salary = avg_salary + 5000;
    END IF;
END$$

DELIMITER ;

