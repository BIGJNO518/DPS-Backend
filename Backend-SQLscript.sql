DROP DATABASE DPSbackend;
CREATE DATABASE DPSbackend;
USE DPSbackend;

DROP TABLE IF EXISTS UserName;
CREATE TABLE UserName(
    PID INT AUTO_INCREMENT,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    PRIMARY KEY (PID) 
);
INSERT INTO UserName(PID, LastName, FirstName) VALUES (001, 'Ganoush', 'Baba' ); 
INSERT INTO UserName(PID, LastName, FirstName) VALUES (002, 'Lovelace', 'Betty' ); 
INSERT INTO UserName(PID, LastName, FirstName) VALUES (003, 'Jordan', 'Hal' ); 
INSERT INTO UserName(PID, LastName, FirstName) VALUES (004, 'Wiggen', 'Ender' ); 
INSERT INTO UserName(PID, LastName, FirstName) VALUES (005, 'Arkanian', 'Petra' ); 
INSERT INTO UserName(PID, LastName, FirstName) VALUES (006, 'Wiggin', 'Peter' );
INSERT INTO UserName(PID, LastName, FirstName) VALUES (999, 'User', 'General' ); 


//DROP TABLE IF EXISTS UserPassword;
//CREATE TABLE UserPassword(
//    PID INT,
//    password VARCHAR(255),
//    PRIMARY KEY (PID)
//);

DROP TABLE IF EXISTS UserInfo;
CREATE TABLE UserInfo (
    PID INT,
    address VARCHAR(255),
    phoneNumber VARCHAR(12),
    userEmail VARCHAR(255),
    password BLOB, 
    RID INT, 
    last_login TIMESTAMP,
    PRIMARY KEY (PID)
);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (001, '34 Awesome Ave.', '518-775-7775', 'Yummy@food.com', 1, AES_ENCRYPT(MD5('yummy'),UNHEX(SHA2('Timmy', 512)))); 
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (002, '37 Best Ave.', '518-665-8899', 'beez@email.com', 1,AES_ENCRYPT(MD5('worst'),UNHEX(SHA2('Spiders', 512)))); 
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (003, '43 Lantern St.', '518-889-0099', 'GreenBaby@DC_Uni.com', 2, AES_ENCRYPT(MD5('Green'),UNHEX(SHA2('Goblin', 512))));
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (004, 'BattleSchool, Lusitania', '518-009-8877', 'xenocide@email.com', 3,AES_ENCRYPT(MD5('peace'),UNHEX(SHA2('LandWorld', 512)))); 
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (005, 'Athens, Greece', '765-957-9009', 'beannme@email.com', 2,AES_ENCRYPT(MD5('utopia'),UNHEX(SHA2('NewYorkcity', 512)))); );
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (006, 'Greensboro, NC', '800-HEGEMON', 'Hegemon@offices.earthgov', 3,AES_ENCRYPT(MD5('Yellow'),UNHEX(SHA2('Townsville', 512)))); );
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID, password) VALUES (999, 'NULL', 'NULL', 'NULL', 4,AES_ENCRYPT(MD5('NULL'),UNHEX(SHA2('NULL1', 512)))); );


DROP TABLE IF EXISTS Event;
CREATE TABLE Event (
	EID INT, 
	FirstName VARCHAR(50), 
	LastName VARCHAR(50), 
	Date DATE, 
	Address VARCHAR(30),
	City VARCHAR(20),
	State VARCHAR(20),
	PRIMARY KEY(EID,Date)
);

INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(001, 'Erick', 'Salas', '2014-04-01', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(002, 'Thinge', 'Won', '2012-02-05', 'Single st', 'Once', 'Ohio');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(003, 'Thing', 'Twou', '1997-08-02', 'Mono', 'Harlem', 'New York');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(004, 'Christ', 'Jesus', '0001-01-01', 'Jerus av', 'Truths', 'News');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(005, 'Gero', 'Cornell', '1980-09-12', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(006, 'Smort', 'Ace', '2010-06-05', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(999, 'NULL', 'NULL', '1899-01-01', 'NULL', 'NULL', 'NULL');

DROP TABLE IF EXISTS EventRoster;
CREATE TABLE EventRoster(
	EID INT,
	PID INT,
	PRIMARY KEY(PID,EID)
); 

INSERT INTO EventRoster(EID, PID) VALUES(001, 001);
INSERT INTO EventRoster(EID, PID) VALUES(002, 002);
INSERT INTO EventRoster(EID, PID) VALUES(003, 003);
INSERT INTO EventRoster(EID, PID) VALUES(004, 004);
INSERT INTO EventRoster(EID, PID) VALUES(005, 005);
INSERT INTO EventRoster(EID, PID) VALUES(006, 006);
INSERT INTO EventRoster(EID, PID) VALUES(999, 999);


DROP TABLE IF EXISTS Contributions;
CREATE TABLE Contributions(
	EID INT, 
	PID INT, 
	Amount   DECIMAL(13, 2),
	PRIMARY KEY (PID,EID)
); 

INSERT INTO Contributions(EID, PID, Amount) VALUES(001, 001, 1000.00);
INSERT INTO Contributions(EID, PID, Amount) VALUES(002, 002, 421.20);
INSERT INTO Contributions(EID, PID, Amount) VALUES(003, 003, 2222.22);
INSERT INTO Contributions(EID, PID, Amount) VALUES(004, 004, 1.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(005, 005, 0.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(006, 006, 100000.10);
INSERT INTO Contributions(EID, PID, Amount) VALUES(999, 999, NULL);



DROP TABLE IF EXISTS Roles;
CREATE TABLE Roles (
	RID INT PRIMARY KEY,
	roleslist VARCHAR(255)
);
INSERT INTO Roles(RID, roleslist) VALUES (1, 'Employee');
INSERT INTO Roles(RID, roleslist) VALUES (2, 'Volunteer');
INSERT INTO Roles(RID, roleslist) VALUES (3, 'Adminstrator');
INSERT INTO Roles(RID, roleslist) VALUES (4, 'General User');

DROP TABLE IF EXISTS Jobs;
CREATE TABLE Jobs (
	JID INT,
	EID INT,
	PID INT, 
	title VARCHAR(255),
	intime TIME,
	outtime TIME,
	PRIMARY KEY (JID,EID)
);

DROP TABLE IF EXISTS Permissions;
CREATE TABLE Permissions(
    RID INT,
    view CHAR,
    edit CHAR,
    addUser CHAR,
    updateDB CHAR,
    viewAllUserInfo CHAR,
    PRIMARY KEY (RID)
);

INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (1, 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (2, 'Y', 'N', 'Y', 'N', 'N');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (3, 'Y', 'Y', 'Y', 'Y', 'Y');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (4, 'Y', 'N', 'Y', 'N', 'N');
