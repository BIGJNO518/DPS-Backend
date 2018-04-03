DROP DATABASE DPSbackend;
CREATE DATABASE DPSbackend;
USE DPSbackend;

DROP TABLE IF EXISTS Users;
CREATE TABLE `Users` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`phoneNumber` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`password` blob NOT NULL,
	PRIMARY KEY (`ID`)
);

DROP TABLE IF EXISTS Sessions;
CREATE TABLE `Sessions` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`token` varchar(32) NOT NULL UNIQUE,
	`expires` DATETIME NOT NULL,
	PRIMARY KEY (`ID`)
);

DROP TABLE IF EXISTS Permissions;
CREATE TABLE `Permissions` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`admin` BOOLEAN NOT NULL,
	`employee` BOOLEAN NOT NULL,
	`volunteer` BOOLEAN NOT NULL DEFAULT True,
	`developer` BOOLEAN NOT NULL,
	PRIMARY KEY (`ID`)
);

DROP TABLE IF EXISTS Events;
CREATE TABLE `Events` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`description` VARCHAR(255) NOT NULL,
	`startTime` DATETIME NOT NULL,
	`endTime` DATETIME NOT NULL,
	`isDeleted` BOOLEAN NOT NULL,
	PRIMARY KEY (`ID`)
);

DROP TABLE IF EXISTS Jobs;
CREATE TABLE `Jobs` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`eid` INT NOT NULL,
	`role` VARCHAR(255) NOT NULL,
	`startTime` DATETIME NOT NULL,
	`endTime` DATETIME NOT NULL,
	`uid` INT NOT NULL,
	PRIMARY KEY (`ID`)
);
	
ALTER TABLE `Sessions` ADD CONSTRAINT `sessions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `Permissions` ADD CONSTRAINT `permissions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `Jobs` ADD CONSTRAINT `jobs_fk0` FOREIGN KEY (`eid`) REFERENCES `Events`(`ID`);

ALTER TABLE `Jobs` ADD CONSTRAINT `jobs_fk1` FOREIGN KEY (`uid`) REFERENCES `Users`(`ID`);


INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (001,'Ganoush Baba', '518-775-7775', 'Yummy@food.com',  AES_ENCRYPT(MD5('yummy'),UNHEX(SHA2('Timmy', 512)))); 
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (002,'Lovelace Betty', '518-665-8899', 'beez@email.com', AES_ENCRYPT(MD5('worst'),UNHEX(SHA2('Spiders', 512)))); 
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (003,'Jordan Hal', '518-889-0099', 'GreenBaby@DC_Uni.com', AES_ENCRYPT(MD5('Green'),UNHEX(SHA2('Goblin', 512))));
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (004,'Wiggen Ender', '518-009-8877', 'xenocide@email.com', AES_ENCRYPT(MD5('peace'),UNHEX(SHA2('LandWorld', 512)))); 
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (005,'Athens Greece', '765-957-9009', 'beannme@email.com', AES_ENCRYPT(MD5('utopia'),UNHEX(SHA2('NewYorkcity', 512)))); 
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (006,'Wiggin Peter', '800-HEGEMON', 'Hegemon@offices.earthgov', AES_ENCRYPT(MD5('Yellow'),UNHEX(SHA2('Townsville', 512)))); 
INSERT INTO Users(ID, name, phoneNumber, email, password) VALUES (999, 'User General',  'NULL', 'NULL', AES_ENCRYPT(MD5('NULL'),UNHEX(SHA2('NULL1', 512)))); 


INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (001, 'Save t', 'plant more trees', '1899-01-01', '2014-04-01', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (002, 'Save t', 'Stop PETA', '1899-01-01', '2012-02-05', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (003, 'Save t', 'help people eat more greens', '1899-01-01', '1997-08-02', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (004, 'Save t', 'More hospitals and medical treatment', '1899-01-01', '0001-01-01', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (005, 'Sciencture', 'Funds for the science field', '1899-01-01', '1980-09-12', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (006, 'Think ildren', 'More school books and funds',  '1899-01-01', '2010-06-05', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (999, 'NULL', 'ue', '1899-01-01', '1899-02-02', false);


INSERT INTO Permissions(ID, admin, employee, volunteer, developer) VALUES (1, True, True, True, True);
INSERT INTO Permissions(ID, admin, employee, volunteer, developer) VALUES (2, True, True, True, false);
INSERT INTO Permissions(ID, admin, employee, volunteer, developer) VALUES (3, False, True, True, false);
INSERT INTO Permissions(ID, admin, employee, volunteer, developer) VALUES (4, False, False, True, false);

INSERT INTO Jobs(ID, eid, role, startTime, endTime, uid) VALUES (001, 001, 'Cook', '1899-01-01', '1899-02-02', 001);
INSERT INTO Jobs(ID, eid, role, startTime, endTime, uid) VALUES (002, 001, 'Desk', '1899-01-01', '1899-02-02', 002);

