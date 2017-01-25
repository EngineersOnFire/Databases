
DROP TABLE Departments CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;
DROP TABLE Changes CASCADE CONSTRAINTS;
DROP SEQUENCE SEQChanges;

CREATE TABLE Departments (
   CodDept CHAR(5) PRIMARY KEY,
   Name VARCHAR(100)
);
CREATE TABLE Employees (
   SSN CHAR(9) PRIMARY KEY,
   Name VARCHAR(100),
   CodDept CHAR(5) REFERENCES Departments on delete set NULL,
   Salary NUMBER(4,0)
);
CREATE TABLE Changes (
   IdChange VARCHAR(10) PRIMARY KEY,
   UserId VARCHAR(10),
   OldSalary NUMBER(4,0),
   NewSalary NUMBER(4,0)
);




INSERT INTO Departments VALUES('agric', 'Agriculture');
INSERT INTO Departments VALUES('commu', 'Comunication');
INSERT INTO Departments VALUES('defen', 'Defense');
INSERT INTO Departments VALUES('educa', 'Education');

INSERT INTO Employees VALUES('784596541', 'Pepe el Agricultor', 'agric', 600);
INSERT INTO Employees VALUES('658475896', 'Paco el Comunicator', 'commu', 1000);
INSERT INTO Employees VALUES('325698547', 'Sara la Defensora', 'defen', 1000);
INSERT INTO Employees VALUES('125478569', 'Blanca la Educatora', 'educa', 1200);
INSERT INTO Employees VALUES('785412589', 'Eustaquio el Jefe Agricultor', 'agric', 3000);
INSERT INTO Employees VALUES('985478569', 'Pepe el Jefe Comunicator', 'commu', 3000);
INSERT INTO Employees VALUES('741236985', 'Rocky el Forzudo Defensor', 'defen', 5000);




-- A) Write a trigger that records in the table Changes any update of the salary of the employees. The trigger must store the user, the date of the change, and both the salary before the change and the updated salary. The ID will be obtained from a sequence called SEQChanges.

CREATE SEQUENCE SEQChanges
   INCREMENT BY 1
   START WITH 1
   NOCYCLE
;

CREATE OR REPLACE TRIGGER logSalaryChanges
AFTER UPDATE
OF Salary ON Employees
FOR EACH ROW
BEGIN
   INSERT INTO Changes VALUES(SEQChanges.NEXTVAL, USER(), :OLD.Salary, :NEW.Salary);
END;


UPDATE Employees
SET SALARY=6000
WHERE SSN='741236985';

-- B) Write a stored procedure that lists for each department the name and salary of each employee whose salary is lower than the average of the department. For each department the procedure must show the total amount of these salaries by department.

CREATE OR REPLACE PROCEDURE lowestSalaries
IS
   CURSOR cursorDeparment IS
      SELECT Name, SALARY
      FROM EMPLOYEES E
      WHERE SALARY < (
         SELECT AVG(SALARY) 
         FROM EMPLOYEES
         WHERE CodDept=E.CodDept
         GROUP BY (CodDept)
      )
   ;
   tmpEmployee cursorDeparment%ROWTYPE;
BEGIN
   OPEN cursorDeparment;
   LOOP
      FETCH cursorDeparment into tmpEmployee;
      EXIT WHEN cursorDeparment%NOTFOUND;
      dbms_output.put_line(tmpEmployee.Name || ', ' || tmpEmployee.Salary);
   END LOOP;
   CLOSE CursorDeparment;
END;



EXEC lowestSalaries();




