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
//add
DROP TABLE IF EXISTS Sessions;
CREATE TABLE `Sessions` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`token` varchar(32) NOT NULL UNIQUE,
	`expires` DATETIME NOT NULL,
	PRIMARY KEY (`ID`)
);
//add
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


INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (001, 'Save the trees', 'plant more trees', '1899-01-01', '2014-04-01', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (002, 'Save the animals', 'Animal Shelter help', '1899-01-01', '2012-02-05', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (003, 'Save the people', 'help people eat more greens', '1899-01-01', '1997-08-02', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (004, 'Save the people 2.0', 'More hospitals and medical treatment', '1899-01-01', '0001-01-01', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (005, 'Science Funds', 'Funds for the science field', '1899-01-01', '1980-09-12', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (006, 'Think of the children', 'More school books and funds',  '1899-01-01', '2010-06-05', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (999, 'NULL', 'ue', '1899-01-01', '1899-02-02', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (007, 'Help Me', 'psychology', '2020-05-02', '2021-02-02', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (008, 'More pizza!', 'Funds for college free pizza', '2021-02-03', '2140-09-30', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (009, 'Mother Nature', 'Regrow the environment', '2140-10-01', '2240-12-25', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (010, 'Pangea 2.0', 'Building unity', '2030-11-12', '2035-07-26', false);



INSERT INTO Jobs(ID, eid, role, startTime, endTime, uid) VALUES (001, 001, 'Cook', '1899-01-01', '1899-02-02', 001);
INSERT INTO Jobs(ID, eid, role, startTime, endTime, uid) VALUES (002, 002, 'Desk', '1899-01-01', '1899-02-02', 002);

