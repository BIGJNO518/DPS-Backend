DROP DATABASE DPSbackend;
CREATE DATABASE DPSbackend;
USE DPSbackend;

DROP TABLE IF EXISTS User;
CREATE TABLE `Users` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`phoneNumber` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`password` blob NOT NULL,
	`token` varchar(32),
	`expires` DATETIME,
	`admin` BOOLEAN NOT NULL DEFAULT False,
	`employee` BOOLEAN NOT NULL DEFAULT False,
	`volunteer` BOOLEAN NOT NULL DEFAULT True,
	`developer` BOOLEAN NOT NULL DEFAULT False,
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
	`name` VARCHAR(255) NOT NULL,
	`startTime` DATETIME NOT NULL,
	`endTime` DATETIME NOT NULL,
	`uid` INT NOT NULL,
	PRIMARY KEY (`ID`)
);
	

ALTER TABLE `Jobs` ADD CONSTRAINT `jobs_fk0` FOREIGN KEY (`eid`) REFERENCES `Events`(`ID`);

ALTER TABLE `Jobs` ADD CONSTRAINT `jobs_fk1` FOREIGN KEY (`uid`) REFERENCES `Users`(`ID`);


INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(001, 'Nicole' , '18001248102', 'nicoleMadison@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, True, True, False, False);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(003, 'David' ,  '12004261149', 'davidPetters@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, False, True, False, False);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(004, 'Sarah' , '184011981675', 'sarahConnor@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, False, False, True, True);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(005, 'Jackson' , '450601448100', 'jacksonMcGregor@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, True, False, False, False);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(006, 'Daniels', '96901249102', 'danielsJack@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, False, True, False, False);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(007, 'Tommy', '917666248166', 'tommyLaDuke@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, True, False, False, False);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(008, 'Karen' , '95001273202', 'karenMargret@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, False, False, False, True);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(009, 'Den' , '586015606990', 'denPatric@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, True, False, False, True);
INSERT INTO USERS(ID, name, phoneNumber, email, password, token, expires, admin, employee, volunteer, developer) 
	VALUES(010, 'Timothy' , '1918123384', 'timothyScope@test.com' ,AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))), 
	       NULL, NULL, True, True, False, False);
	

INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (001, 'Save the trees', 'plant more trees', '1899-01-01', '2014-04-01', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (002, 'Save the animals', 'Animal Shelter help', '1899-01-01', '2012-02-05', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (003, 'Save the people', 'help people eat more greens', '1899-01-01', '1997-08-02', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (004, 'Save the people 2.0', 'More hospitals and medical treatment', '1899-01-01', '0001-01-01', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (005, 'Science Funds', 'Funds for the science field', '1899-01-01', '1980-09-12', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (006, 'Think of the children', 'More school books and funds',  '1899-01-01', '2010-06-05', true);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (999, NULL, 'ue', '1899-01-01', '1899-02-02', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (007, 'Help Me', 'psychology', '2020-05-02', '2021-02-02', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (008, 'More pizza!', 'Funds for college free pizza', '2021-02-03', '2140-09-30', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (009, 'Mother Nature', 'Regrow the environment', '2140-10-01', '2240-12-25', false);
INSERT INTO Events(ID, name, description, startTime, endTime, isDeleted) VALUES (010, 'Pangea 2.0', 'Building unity', '2030-11-12', '2035-07-26', false);



INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (001, 001, 'Clean up', '2018-04-09', '2018-04-10', 001);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (002, 002, 'Get animal food', '2018-04-05', '2018-04-06', 002);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (003, 003, 'Head Cook', '2018-05-09', '2018-05-09', 003);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (004, 004, 'Get medical supplies', '2018-06-10', '2018-06-10', 004);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (005, 005, 'Keep track of all funds', '2018-04-26', '2018-04-26', 005);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (006, 006, 'Buy books', '2018-04-26', '2018-04-28', 006);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (999, 999, null, '2018-04-19', '2018-04-21', 000);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (007, 007, 'Psychologists', '2018-06-29', '2018-06-30',007);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (008, 008, 'Get pizzas', '2018-04-29', '2018-04-29', 008);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (009, 009, 'Get seeds', '2018-04-04', '2018-04-04', 009);
INSERT INTO Jobs(ID, eid, name, startTime, endTime, uid) VALUES (010, 010, 'Organize materials', '2018-05-25', '2018-05-25', 010);


