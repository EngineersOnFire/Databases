

-- A)

DROP TABLE Jugador CASCADE CONSTRAINTS;
DROP TABLE Partida CASCADE CONSTRAINTS;
DROP TABLE Maestro CASCADE CONSTRAINTS;

CREATE TABLE Jugador (
   nick VARCHAR(32) PRIMARY KEY,
   sexo CHAR(1) NOT NULL,
   edad INTEGER NOT NULL,
   CHECK (sexo='H' OR sexo='M')
);

CREATE TABLE Partida (
   nickRetador VARCHAR(32) NOT NULL,
   nickRetado VARCHAR(32) NOT NULL,
   juego VARCHAR(32) NOT NULL,
   fecha DATE NOT NULL,
   resultado INTEGER,
   PRIMARY KEY(nickRetador,nickRetado, juego, fecha),
   FOREIGN KEY(nickRetador) REFERENCES Jugador,
   FOREIGN KEY(nickRetado) REFERENCES Jugador,
   CHECK (nickRetador<>nickRetado),
   CHECK (resultado BETWEEN 0 AND 2)
);

CREATE TABLE Maestro (
   nick VARCHAR(32) NOT NULL,
   juego VARCHAR(32) NOT NULL,
   PRIMARY KEY (nick, juego),
   FOREIGN KEY (nick) REFERENCES Jugador
);



INSERT INTO Jugador VALUES ('DevPGSV', 'H', 21);
INSERT INTO Jugador VALUES ('Loser', 'H', 50);
INSERT INTO Jugador VALUES ('Eustaquia', 'M', 20);


INSERT INTO Partida VALUES ('DevPGSV', 'Loser', '4inRow', '20/01/2017', 1);
INSERT INTO Partida VALUES ('DevPGSV', 'Eustaquia', 'Chess', '26/01/2017', NULL);
INSERT INTO Partida VALUES ('DevPGSV', 'Eustaquia', '4inRow', '26/01/2017', NULL);
INSERT INTO Partida VALUES ('Eustaquia', 'DevPGSV', 'chess', '10/01/2017', 2);

INSERT INTO Maestro VALUES ('DevPGSV', 'chess');
INSERT INTO Maestro VALUES ('Loser', '4inRow');

INSERT INTO Jugador VALUES ('Alien', 'A', 21); -- Error!
INSERT INTO Partida VALUES ('DevPGSV', 'DevPGSV', 'Chess', '20/01/2017', 0); -- Error!
INSERT INTO Partida VALUES ('Eustaquia', 'DevPGSV', 'Chess', '20/01/2017', 3); -- Error!

-- B)

/*
The table Maestro has Players from table Jugador when they win at least 20 games.
This restriction can not be imposed by SQL.
This could be implemented in PL/SQL, by creating a trigger that is triggered when there are insertions on Partida, and then updates the Maestro table accordingly.
*/

-- C)

SELECT juego
   FROM Partida
   WHERE resultado = 0
   GROUP BY juego
   ORDER BY count(resultado) DESC
;

-- D)

SELECT Partida.nickRetador, count(adversary.nick)
   FROM Partida
   JOIN Jugador ON Partida.nickRetador = Jugador.nick
   JOIN Jugador adversary ON Partida.nickRetado = adversary.nick AND Jugador.edad > adversary.edad
   GROUP BY Partida.nickRetador
;

-- E)

SELECT nick
   FROM Maestro
   WHERE
      nick IN (
         SELECT nickRetador
         FROM Partida
         WHERE NOT Partida.juego = Maestro.juego
      )
;


-- F)

SELECT Maestro.nick, Jugador.edad, count(Partida.nickRetador)
   FROM Maestro
   JOIN Jugador ON Maestro.nick = Jugador.nick
   JOIN Partida ON Jugador.nick = Partida.nickRetador OR Jugador.nick = Partida.nickRetado
   GROUP BY Maestro.nick, Jugador.edad
   HAVING count(Partida.nickRetador) > 100
;

-- G)

SELECT DISTINCT nickRetador
   FROM Partida
   WHERE nickRetador NOT IN (
      SELECT DISTINCT nickRetador
         FROM Partida
         WHERE NOT juego = 'chess'
   )
;

-- H)

SELECT Juego, COUNT(CASE resultado WHEN 1 THEN 1 ELSE NULL END) "Ganado por retador", COUNT(CASE resultado WHEN 2 THEN 1 ELSE NULL END) "Ganado por retado", COUNT(CASE resultado WHEN 0 THEN 1 ELSE NULL END) "Empate"
   FROM Partida
   GROUP BY juego
;


-- I) (This doesnt work!)

CREATE OR REPLACE TRIGGER setMaestro
AFTER UPDATE
OF resultado ON Partida
FOR EACH ROW
DECLARE
   maestroRowCount NUMBER;
   alreadyMaestro NUMBER;
   ganador Jugador.nick%TYPE;
   noWinnerException exception;
BEGIN
   IF :NEW.resultado = 1 THEN
      ganador := :NEW.nickRetador;
   ELSIF :NEW.resultado = 2 THEN
      ganador := :NEW.nickRetado;
   END IF;
   IF (:NEW.resultado = 1 OR :NEW.resultado = 2) THEN
      SELECT count(*) INTO alreadyMaestro
         FROM Maestro
         WHERE nick = ganador;
      
      IF alreadyMaestro = 0 THEN
         SELECT count(*) INTO maestroRowCount
            FROM Partida
            WHERE juego = :NEW.juego AND (
               (nickRetador = ganador AND resultado = 1) OR
               (nickRetado = ganador AND resultado = 2)
            )
         ;
         dbms_output.put_line(maestroRowCount);
         IF maestroRowCount > 1 THEN
            INSERT INTO Maestro VALUES (ganador, :NEW.juego);
         END IF;
      END IF;
   END IF;
EXCEPTION
  WHEN noWinnerException THEN
    dbms_output.put_line('No winner');
END;



