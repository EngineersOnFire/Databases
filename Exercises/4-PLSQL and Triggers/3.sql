
DROP TABLE Author CASCADE CONSTRAINTS;
DROP TABLE Journal CASCADE CONSTRAINTS;
DROP TABLE Article CASCADE CONSTRAINTS;
DROP TABLE Sign CASCADE CONSTRAINTS;

CREATE TABLE Author (
   SSN CHAR(9) PRIMARY KEY,
   Name VARCHAR(50) NOT NULL,
   LastName VARCHAR(50) NOT NULL,
   Country VARCHAR(30) NOT NULL,
   NumArticles CHAR(3) NOT NULL
);

CREATE TABLE Journal (
   ISSN VARCHAR(9) PRIMARY KEY,
   Name VARCHAR(100) NOT NULL
);

CREATE TABLE Article (
   DOI CHAR(30) PRIMARY KEY,
   Title VARCHAR(100) NOT NULL,
   ISSNJournal VARCHAR(9) NOT NULL REFERENCES Journal(ISSN) ON DELETE CASCADE,
   NumAuthors NUMBER(1,0) NOT NULL,
   CHECK (NumAuthors BETWEEN 1 AND 4)
);

CREATE TABLE Sign (
   SSN CHAR(9) NOT NULL REFERENCES Author,
   DOI CHAR(30) NOT NULL REFERENCES Article ON DELETE CASCADE,
   PRIMARY KEY(SSN, DOI)
);

-- A) Write a stored procedure with a journal as input parameter. The procedure must show the data associated to the journal (ISSN and Name) and the names and surnames of the authors that have signed at least one article published in the journal. In the case that the journal has not associated any article, the procedure will show the message. “No Authors”.

CREATE OR REPLACE PROCEDURE
journalInfo(journalissn IN VARCHAR)
IS
   currentJournal Journal%ROWTYPE;
   
   CURSOR authorsInJournalCursor IS
      SELECT DISTINCT Author.Name, Author.LastName
      FROM Article
      JOIN Sign ON Article.DOI = Sign.DOI
      JOIN Author ON Sign.SSN = Author.SSN
      WHERE Article.ISSNJournal = journalissn
   ;
   
   tmpAuthor authorsInJournalCursor%ROWTYPE;
   noAuthorsInJournalException exception;
BEGIN
   SELECT ISSN, Name INTO currentJournal
   FROM Journal
   WHERE ISSN = journalissn;
   dbms_output.put_line('->' || currentJournal.ISSN || ', ' || currentJournal.Name);
   
   OPEN authorsInJournalCursor;
   FETCH authorsInJournalCursor INTO tmpAuthor;
   IF authorsInJournalCursor%NOTFOUND THEN
      CLOSE authorsInJournalCursor;
      raise noAuthorsInJournalException;
   END IF;
   LOOP
      EXIT WHEN authorsInJournalCursor%NOTFOUND;
      dbms_output.put_line('  >> ' || tmpAuthor.Name || ', ' || tmpAuthor.LastName);
      FETCH authorsInJournalCursor INTO tmpAuthor;
   END LOOP;
   CLOSE authorsInJournalCursor;
   
EXCEPTION
   WHEN noAuthorsInJournalException THEN
      dbms_output.put_line('  >> NO AUTHORS IN JOURNAL!');
   WHEN no_data_found then
      dbms_output.put_line('No journal identified by ' || journalissn || ' !');
END;

-- B) Write a trigger that updates the column NumArticles in the table Author when a new article is inserted or deleted.

CREATE OR REPLACE TRIGGER keepNumArticlesUpdated
AFTER INSERT OR DELETE
ON Sign
FOR EACH ROW
BEGIN
   IF INSERTING THEN
      UPDATE Author
      SET NumArticles = NumArticles+1
      WHERE SSN = :NEW.SSN;
   ELSIF DELETING THEN
      UPDATE Author
      SET NumArticles = NumArticles-1
      WHERE SSN = :OLD.SSN;
   END IF;
END;



INSERT INTO Author VALUES('785412589', 'Pepe', 'Perez', 'Pepelandia', 0);
INSERT INTO Author VALUES('753159753', 'Eustaquia', 'Bendita', 'España', 0);
INSERT INTO Author VALUES('951478965', 'Parloteador', 'Supremo', 'Francia', 0);

INSERT INTO Journal VALUES('000000001', 'Journal1');
INSERT INTO Journal VALUES('000000002', 'Journal2');
INSERT INTO Journal VALUES('000000003', 'Journal3');

INSERT INTO Article VALUES('AAA001', 'Article on Dolphins, Whales, and other big swimmer annimals', '000000001', '1');
INSERT INTO Article VALUES('AAA002', 'The reproduction of the Polar Bear on shortage of females', '000000001', '2');
INSERT INTO Article VALUES('AAA003', 'A narcissist article about myself', '000000002', '1');


INSERT INTO Sign VALUES ('785412589', 'AAA001');
INSERT INTO Sign VALUES ('785412589', 'AAA002');
INSERT INTO Sign VALUES ('753159753', 'AAA002');
INSERT INTO Sign VALUES ('951478965', 'AAA003');



EXEC journalInfo('000000001');
EXEC journalInfo('000000003');
EXEC journalInfo('000000004');


