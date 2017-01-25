
DROP TABLE Contracts CASCADE CONSTRAINTS;
DROP TABLE Routes CASCADE CONSTRAINTS;

CREATE TABLE Contracts(
   Ref VARCHAR(10) PRIMARY KEY,
   Organization VARCHAR(100),
   ContDate DATE,
   NumRoutes NUMBER(2,0)
);

CREATE TABLE Routes(
   Ref VARCHAR(10) REFERENCES Contracts ON DELETE CASCADE,
   Origin VARCHAR(50),
   Destination VARCHAR(50),
   Vehicle VARCHAR(20),
   PRIMARY KEY (Ref, Origin, Destination)
);

INSERT INTO CONTRACTS VALUES('1', 'UCM', '1/1/2017', 0);
INSERT INTO CONTRACTS VALUES('2', 'UPM', '2/1/2017', 0);
INSERT INTO CONTRACTS VALUES('3', 'UC3M', '3/1/2017', 0);



-- A) Write a stored procedure with a reference contract as input parameter. The procedure must update the information in NumRoutes, according to the number of routes associated with the contract. The procedure also must print the name of the organization and the total number of associated routes. You must declare an exception that is thrown to show a message if the reference does not have associated any route.

CREATE OR REPLACE PROCEDURE updateNumRoutes(contractReference IN VARCHAR)
IS
  totalNumRoutes Contracts.NumRoutes%TYPE:= 0;
  orgName Contracts.Organization%TYPE;
  noAssociateRoute exception;
BEGIN
   SELECT count(Ref) INTO totalNumRoutes
   FROM Routes
   WHERE Ref=contractReference;
    
   if (totalNumRoutes> 0) then
      UPDATE Contracts
      SET NumRoutes=totalNumRoutes
      WHERE Ref=contractReference;
   else
      raise noAssociateRoute;
   end if;
   
   SELECT DISTINCT Organization INTO orgName
   FROM Contracts
   WHERE Ref=contractReference;

   DBMS_OUTPUT.PUT_LINE('Organization name ' || orgName);
   DBMS_OUTPUT.PUT_LINE('Total Routes is ' || totalNumRoutes); 
    
EXCEPTION WHEN noAssociateRoute THEN
   DBMS_OUTPUT.PUT_LINE('No routes for this reference');
END;

-----------------------------------

EXEC updateNumRoutes('1');
INSERT INTO Routes VALUES('1', 'MADRID', 'CANTABRIA', 'CAR');
EXEC updateNumRoutes('1');

-----------------------------------

-- B) Create a trigger to keep updated the value of NumRoutes whenever a row is inserted or deleted.
CREATE OR REPLACE TRIGGER keepNumRoutesUpdated
AFTER INSERT OR DELETE
ON Routes
FOR EACH ROW
BEGIN
   IF DELETING THEN
      UPDATE Contracts
      SET NumRoutes = NumRoutes-1
      WHERE Contracts.Ref = :OLD.Ref;
   ELSIF INSERTING THEN
      UPDATE Contracts
      SET NumRoutes = NumRoutes+1
      WHERE Contracts.Ref = :NEW.Ref;
   END IF;  
END;  

-----------------------------------

INSERT INTO Routes VALUES('1', 'MADRID', 'LEON', 'CAR');
INSERT INTO Routes VALUES('1', 'MADRID', 'MADRID', 'BOAT');
INSERT INTO Routes VALUES('2', 'MADRID', 'MORDOR', 'PLANE');


SELECT Organization, NumRoutes FROM Contracts;