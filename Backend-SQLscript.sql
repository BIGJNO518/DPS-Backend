DROP DATABASE DPSbackend;
CREATE DATABASE DPSbackend;
USE DPSbackend;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    PID INT,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    address VARCHAR(255),
    phoneNumber VARCHAR(12),
    userEmail VARCHAR(255),
    password BLOB, 
    RID INT, 
    last_login TIMESTAMP,
    PRIMARY KEY (PID)
);

DROP TABLE IF EXISTS Sessions;
CREATE TABLE Sessions (
	SID INT NOT NULL AUTO_INCREMENT,
	token VARCHAR(32) NOT NULL UNIQUE, 
	expires DATETIME NOT NULL, 
	PRIMARY KEY (SID)
	);

DROP TABLE IF EXISTS Roles;
CREATE TABLE Roles (
	RID INT PRIMARY KEY,
	roleslist VARCHAR(255)
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

DROP TABLE IF EXISTS Events;
CREATE TABLE Events (
	EID INT, 
	eventName VARCHAR(50), 
	startTime DATE, 
	endTime DATE,
	Address VARCHAR(30),
	City VARCHAR(20),
	State VARCHAR(20),
	PRIMARY KEY(EID,Date)
);


DROP TABLE IF EXISTS Contributions;
CREATE TABLE Contributions(
	EID INT, 
	PID INT, 
	Amount   DECIMAL(13, 2),
	PRIMARY KEY (PID,EID)
); 

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
	
ALTER TABLE `sessions` ADD CONSTRAINT `sessions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `permissions` ADD CONSTRAINT `permissions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `jobs` ADD CONSTRAINT `jobs_fk0` FOREIGN KEY (`eid`) REFERENCES `events`(`ID`);

ALTER TABLE `jobs` ADD CONSTRAINT `jobs_fk1` FOREIGN KEY (`uid`) REFERENCES `users`(`ID`);


INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (001,'Ganoush', 'Baba', '34 Awesome Ave.', '518-775-7775', 'Yummy@food.com', 1, AES_ENCRYPT(MD5('yummy'),UNHEX(SHA2('Timmy', 512)))); 
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (002,'Lovelace', 'Betty','37 Best Ave.', '518-665-8899', 'beez@email.com', 1,AES_ENCRYPT(MD5('worst'),UNHEX(SHA2('Spiders', 512)))); 
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (003,'Jordan', 'Hal', '43 Lantern St.', '518-889-0099', 'GreenBaby@DC_Uni.com', 2, AES_ENCRYPT(MD5('Green'),UNHEX(SHA2('Goblin', 512))));
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (004,'Wiggen', 'Ender','BattleSchool, Lusitania', '518-009-8877', 'xenocide@email.com', 3,AES_ENCRYPT(MD5('peace'),UNHEX(SHA2('LandWorld', 512)))); 
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (005,'Athens, Greece', '765-957-9009', 'beannme@email.com', 2,AES_ENCRYPT(MD5('utopia'),UNHEX(SHA2('NewYorkcity', 512)))); );
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (006,'Wiggin', 'Peter','Greensboro, NC', '800-HEGEMON', 'Hegemon@offices.earthgov', 3,AES_ENCRYPT(MD5('Yellow'),UNHEX(SHA2('Townsville', 512)))); );
INSERT INTO Users(PID, LastName, FirstName, address, phoneNumber, userEmail, RID, password) VALUES (999, 'User', 'General', 'NULL', 'NULL', 'NULL', 4,AES_ENCRYPT(MD5('NULL'),UNHEX(SHA2('NULL1', 512)))); );


INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(001, 'Save the Planet', '1899-01-01', '2014-04-01', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(002, 'Save the Animals', '1899-01-01', '2012-02-05', 'Single st', 'Once', 'Ohio');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(003, 'Save the Food', '1899-01-01', '1997-08-02', 'Mono', 'Harlem', 'New York');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(004, 'Save the People', '1899-01-01', '0001-01-01', 'Jerus av', 'Truths', 'News');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(005, 'Science for the future', '1899-01-01', '1980-09-12', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(006, 'Think about the Children', '1899-01-01', '2010-06-05', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, eventName, Date, Date, Address, City, State) VALUES(999, 'NULL', '1899-01-01', '1899-01-01', 'NULL', 'NULL', 'NULL');

INSERT INTO EventRoster(EID, PID) VALUES(001, 001);
INSERT INTO EventRoster(EID, PID) VALUES(002, 002);
INSERT INTO EventRoster(EID, PID) VALUES(003, 003);
INSERT INTO EventRoster(EID, PID) VALUES(004, 004);
INSERT INTO EventRoster(EID, PID) VALUES(005, 005);
INSERT INTO EventRoster(EID, PID) VALUES(006, 006);
INSERT INTO EventRoster(EID, PID) VALUES(999, 999);

INSERT INTO Contributions(EID, PID, Amount) VALUES(001, 001, 1000.00);
INSERT INTO Contributions(EID, PID, Amount) VALUES(002, 002, 421.20);
INSERT INTO Contributions(EID, PID, Amount) VALUES(003, 003, 2222.22);
INSERT INTO Contributions(EID, PID, Amount) VALUES(004, 004, 1.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(005, 005, 0.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(006, 006, 100000.10);
INSERT INTO Contributions(EID, PID, Amount) VALUES(999, 999, NULL);

INSERT INTO Roles(RID, roleslist) VALUES (1, 'Employee');
INSERT INTO Roles(RID, roleslist) VALUES (2, 'Volunteer');
INSERT INTO Roles(RID, roleslist) VALUES (3, 'Adminstrator');
INSERT INTO Roles(RID, roleslist) VALUES (4, 'General User');

INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (1, 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (2, 'Y', 'N', 'Y', 'N', 'N');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (3, 'Y', 'Y', 'Y', 'Y', 'Y');
INSERT INTO Permissions(RID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (4, 'Y', 'N', 'Y', 'N', 'N');
