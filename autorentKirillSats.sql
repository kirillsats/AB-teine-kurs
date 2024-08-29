CREATE DATABASE autorentSats;
USE autorentSats;

CREATE TABLE auto (
    autoID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    regNumber CHAR(6) UNIQUE,
    markID INT,
    varv VARCHAR(20),
    v_aasta INT,
    kaigukastID INT,
    km DECIMAL(10, 2)
);

INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km)
VALUES ('372BCB', 2, 'punane', 2007, 2, 2000.00);

INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km)
VALUES ('007KIR', 3, 'must', 2007, 1, 178.00);

INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km)
VALUES ('314DOR', 1, 'valge', 1978, 2, 897.00);

CREATE TABLE mark (
    markID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    autoMark VARCHAR(30) UNIQUE
);

INSERT INTO mark (autoMark)
VALUES ('Ziguli'), ('Lambordzini'), ('BMW');

CREATE TABLE kaigukast (
    kaigukastID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    kaigukast VARCHAR(30) UNIQUE
);

INSERT INTO kaigukast (kaigukast)
VALUES ('Automaat'), ('Manual');

ALTER TABLE auto
ADD FOREIGN KEY (markID) REFERENCES mark(markID);

ALTER TABLE auto
ADD FOREIGN KEY (kaigukastID) REFERENCES kaigukast(kaigukastID);

--Loo tabel "tootaja"
CREATE TABLE tootaja (
    tootajaID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    tootajaNimi VARCHAR(50),
    ametID INT,
    FOREIGN KEY (ametID) REFERENCES mark(markID)
);
--Loo tabel "klient"
CREATE TABLE klient (
    klientID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    kliendiNimi VARCHAR(50),
    telefon VARCHAR(20),
    aadress VARCHAR(50),
    soiduKogemus VARCHAR(30)
);
--Loo tabel "rendileping"
CREATE TABLE rendileping (
    lepingID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    rendiAlgus DATE,
    rendiLopp DATE,
    klientID INT,
    autoID INT,
    rendiKestvus INT,
    hindKokku DECIMAL(10, 2),
    tootajaID INT,
    FOREIGN KEY (klientID) REFERENCES klient(klientID),
    FOREIGN KEY (autoID) REFERENCES auto(autoID),
    FOREIGN KEY (tootajaID) REFERENCES tootaja(tootajaID)
);
--Loo tabel "lisavarustus"
CREATE TABLE lisavarustus (
    lisavarustusID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nimi VARCHAR(100) NOT NULL,
    hind DECIMAL(10, 2) NOT NULL
);

SELECT * FROM auto
INNER JOIN mark ON mark.markID = auto.markID
INNER JOIN kaigukast ON kaigukast.kaigukastID = auto.kaigukastID;
--Loo protseduur "InsertRendileping"
CREATE PROCEDURE InsertRendileping
    @rendiAlgus DATE,
    @rendiLopp DATE,
    @klientID INT,
    @autoID INT,
    @rendiKestvus INT,
    @hindKokku DECIMAL(10, 2),
    @tootajaID INT
AS
BEGIN
    INSERT INTO rendileping (rendiAlgus, rendiLopp, klientID, autoID, rendiKestvus, hindKokku, tootajaID)
    VALUES (@rendiAlgus, @rendiLopp, @klientID, @autoID, @rendiKestvus, @hindKokku, @tootajaID);

    PRINT 'Rendileping added successfully';
END;
--Loo protseduur "DeleteRendileping"
CREATE PROCEDURE DeleteRendileping
    @lepingID INT
AS
BEGIN
    DELETE FROM rendileping WHERE lepingID = @lepingID;
END;
--Loo protseduur "UpdateRendileping"
CREATE PROCEDURE UpdateRendileping
    @lepingID INT,
    @newRendiKestvus INT,
    @newHindKokku DECIMAL(10, 2)
AS
BEGIN
    UPDATE rendileping
    SET rendiKestvus = @newRendiKestvus, 
        hindKokku = @newHindKokku
    WHERE lepingID = @lepingID;
END;


--ıiguste m‰‰ramine
GRANT SELECT ON Rendileping TO tootaja;
GRANT INSERT ON Rendileping TO tootaja;