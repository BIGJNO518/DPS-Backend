DROP DATABASE DPSbackend;
CREATE DATABASE DPSbackend;
USE DPSbackend;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    ID INT NOT NULL AUTO_INCREMENT,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(12) NOT NULL,
    userEmail VARCHAR(255) NOT NULL,
    password BLOB NOT NULL, 
    last_login TIMESTAMP,
    PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS Sessions;
CREATE TABLE Sessions (
	ID INT NOT NULL AUTO_INCREMENT,
	token VARCHAR(32) NOT NULL UNIQUE, 
	expires DATETIME NOT NULL, 
	PRIMARY KEY (ID)
	);

DROP TABLE IF EXISTS Roles;
CREATE TABLE Roles (
	RID INT PRIMARY KEY,
	roleslist VARCHAR(255)
);

DROP TABLE IF EXISTS Permissions;
CREATE TABLE Permissions(
    ID INT,
    view CHAR,
    edit CHAR,
    addUser CHAR,
    updateDB CHAR,
    viewAllUserInfo CHAR,
    PRIMARY KEY (RID)
);

DROP TABLE IF EXISTS Events;
CREATE TABLE Events (
	ID INT NOT NULL AUTO_INCREMENT, 
	eventName VARCHAR(50) NOT NULL, 
	description VARCHAR(255) NOT NULL,
	isDeleted BOOLEAN NOT NULL,
	startTime DATETIME NOT NULL, 
	endTime DATETIME NOT NULL,
	Address VARCHAR(30) NOT NULL,
	City VARCHAR(20) NOT NULL,
	State VARCHAR(20) NOT NULL,
	PRIMARY KEY(ID)
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
	ID INT NOT NULL AUTO_INCREMENT,
	EID INT NOT NULL, 
	name VARCHAR(255) NOT NULL,
	startTime DATETIME NOT NULL,
	endTime DATETIME NOT NULL,
	PRIMARY KEY (ID)
);
	
ALTER TABLE `sessions` ADD CONSTRAINT `sessions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `permissions` ADD CONSTRAINT `permissions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `jobs` ADD CONSTRAINT `jobs_fk0` FOREIGN KEY (`eid`) REFERENCES `events`(`ID`);

ALTER TABLE `jobs` ADD CONSTRAINT `jobs_fk1` FOREIGN KEY (`uid`) REFERENCES `users`(`ID`);


INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (001,'Ganoush', 'Baba', '34 Awesome Ave.', '518-775-7775', 'Yummy@food.com', 1, AES_ENCRYPT(MD5('yummy'),UNHEX(SHA2('Timmy', 512)))); 
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (002,'Lovelace', 'Betty','37 Best Ave.', '518-665-8899', 'beez@email.com', 1,AES_ENCRYPT(MD5('worst'),UNHEX(SHA2('Spiders', 512)))); 
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (003,'Jordan', 'Hal', '43 Lantern St.', '518-889-0099', 'GreenBaby@DC_Uni.com', 2, AES_ENCRYPT(MD5('Green'),UNHEX(SHA2('Goblin', 512))));
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (004,'Wiggen', 'Ender','BattleSchool, Lusitania', '518-009-8877', 'xenocide@email.com', 3,AES_ENCRYPT(MD5('peace'),UNHEX(SHA2('LandWorld', 512)))); 
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (005,'Athens, Greece', '765-957-9009', 'beannme@email.com', 2,AES_ENCRYPT(MD5('utopia'),UNHEX(SHA2('NewYorkcity', 512)))); );
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (006,'Wiggin', 'Peter','Greensboro, NC', '800-HEGEMON', 'Hegemon@offices.earthgov', 3,AES_ENCRYPT(MD5('Yellow'),UNHEX(SHA2('Townsville', 512)))); );
INSERT INTO Users(ID, LastName, FirstName, address, phoneNumber, userEmail, password, last_login) VALUES (999, 'User', 'General', 'NULL', 'NULL', 'NULL', 4,AES_ENCRYPT(MD5('NULL'),UNHEX(SHA2('NULL1', 512)))); );


INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(001, 'Save the Planet', 'plant more trees', 'true', '1899-01-01', '2014-04-01', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(002, 'Save the Animals', 'Stop PETA', 'false', '1899-01-01', '2012-02-05', 'Single st', 'Once', 'Ohio');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(003, 'Save the Food', 'Help people eat more greens', 'true', '1899-01-01', '1997-08-02', 'Mono', 'Harlem', 'New York');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(004, 'Save the People', 'More hospitals and medical treatment', 'false', '1899-01-01', '0001-01-01', 'Jerus av', 'Truths', 'News');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(005, 'Science for the future', 'Funds for the science field', 'true', '1899-01-01', '1980-09-12', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(006, 'Think about the Children', 'More school books and funds', 'true', '1899-01-01', '2010-06-05', '3 That ave', 'Here', 'NoAlter');
INSERT INTO Events(ID, eventName, description, isDeleted, startTime, endTime, Address, City, State) VALUES(999, 'NULL', 'NULL', 'true', '1899-01-01', '1899-02-02', 'NULL', 'NULL', 'NULL');


INSERT INTO Contributions(EID, PID, Amount) VALUES(001, 001, 1000.00);
INSERT INTO Contributions(EID, PID, Amount) VALUES(002, 002, 421.20);
INSERT INTO Contributions(EID, PID, Amount) VALUES(003, 003, 2222.22);
INSERT INTO Contributions(EID, PID, Amount) VALUES(004, 004, 1.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(005, 005, 0.01);
INSERT INTO Contributions(EID, PID, Amount) VALUES(006, 006, 100000.10);
INSERT INTO Contributions(EID, PID, Amount) VALUES(999, 999, NULL);

INSERT INTO Roles(ID, roleslist) VALUES (1, 'Employee');
INSERT INTO Roles(ID, roleslist) VALUES (2, 'Volunteer');
INSERT INTO Roles(ID, roleslist) VALUES (3, 'Adminstrator');
INSERT INTO Roles(ID, roleslist) VALUES (4, 'General User');

INSERT INTO Permissions(ID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (1, 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO Permissions(ID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (2, 'Y', 'N', 'Y', 'N', 'N');
INSERT INTO Permissions(ID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (3, 'Y', 'Y', 'Y', 'Y', 'Y');
INSERT INTO Permissions(ID, view, edit, addUser, updateDB, viewAllUserInfo) VALUES (4, 'Y', 'N', 'Y', 'N', 'N');
