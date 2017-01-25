
DROP TABLE Airport CASCADE CONSTRAINTS;
DROP TABLE Flight CASCADE CONSTRAINTS;
DROP TABLE Tickets CASCADE CONSTRAINTS;

Create table Airport(
   Code CHAR(6) PRIMARY KEY,
   Name VARCHAR(30) NOT NULL,
   Country VARCHAR(30)NOT NULL
);

Create table Flight(
   FNumber CHAR(6),
   FDate DATE,
   Departure CHAR(6) NOT NULL REFERENCES Airport on delete set NULL,
   Arrival CHAR(6) NOT NULL REFERENCES Airport on delete set NULL,
   Price NUMBER(6,2),
   Seats NUMBER(3) DEFAULT 100,
   primary key (FNumber,FDate),
   unique (FDate, Departure, Arrival),
   check (departure<>arrival)
);

Create table Tickets(
   eticket CHAR(6),
   fdate DATE NOT NULL,
   Passport CHAR(10) NOT NULL,
   PRIMARY KEY(eticket, fdate, passport),
   FOREIGN KEY(eticket, fdate) REFERENCES Flight
);

INSERT INTO Airport VALUES ('madrid', 'Madrid', 'Spain');
INSERT INTO Airport VALUES ('istamb', 'Istambul', 'Turkey');
INSERT INTO Airport VALUES ('pariss', 'Paris', 'France');

INSERT INTO Flight VALUES ('A01', '25/01/2017', 'madrid', 'pariss', 100.45, 2);
INSERT INTO Flight VALUES ('A02', '25/01/2017', 'madrid', 'istamb', 150.00, 2);
INSERT INTO Flight VALUES ('A01', '30/01/2017', 'madrid', 'pariss', 100.45, 2);
INSERT INTO Flight VALUES ('A01', '05/02/2017', 'madrid', 'pariss', 100.45, 2);

INSERT INTO TICKETS VALUES('A01', '30/01/2017', '7485965478');
INSERT INTO TICKETS VALUES('A01', '30/01/2017', '4785963489');

-- A) Write a stored procedure with a date, departure airport, arrival airport and a passport number as input parameters. The procedure must register a ticket for the passenger in the first flight between the provided airports in which there are available seats. In the case that we cannot find a flight that fulfils the requirements, the procedure will show a message.

CREATE OR REPLACE PROCEDURE
registerTicket(flightDate IN DATE, departureAirportCode IN CHAR, arrivalAirportCode IN CHAR, passport IN CHAR)
IS
   CURSOR foundFlightsCursor IS
      SELECT Flight.FNumber, Flight.FDate
      FROM Flight
      WHERE
         Flight.Departure = departureAirportCode AND
         Flight.Arrival = arrivalAirportCode AND
         Flight.FDate >= flightDate AND
         (Flight.FNumber, Flight.FDate) NOT IN (
            SELECT Tickets.eticket, Tickets.fdate
            FROM Tickets
            GROUP BY (Tickets.eticket, Tickets.fdate)
            HAVING count(passport) >= FlighT.Seats
         )
   ;
   
   choosenFligh foundFlightsCursor%ROWTYPE;
   flightNotFoundException exception;
BEGIN
   OPEN foundFlightsCursor;
      FETCH foundFlightsCursor INTO choosenFligh;
      IF foundFlightsCursor%NOTFOUND THEN
         CLOSE foundFlightsCursor;
         RAISE flightNotFoundException;
      END IF;
   CLOSE foundFlightsCursor;
   INSERT INTO Tickets VALUES (choosenFligh.FNumber, choosenFligh.FDate, passport);
   dbms_output.put_line('Created ticket: ' || choosenFligh.FNumber || ', ' || choosenFligh.FDate || ', ' || passport );
EXCEPTION
   WHEN flightNotFoundException THEN
      dbms_output.put_line('No flight found');
END;

EXEC registerTicket('26/01/2017', 'madrid', 'pariss', '6666666666');
EXEC registerTicket('26/01/2017', 'madrid', 'pariss', '6666666667');
EXEC registerTicket('26/01/2017', 'madrid', 'pariss', '6666666668');



-- B) Write a trigger that updates in the table Sales the total amount and the number of tickets of the flights, for each ticket that is sold or returned. In case of return, the airline only refunds 150€.


-- Incomplete question. I have no idea what it means by the Sales table.
















