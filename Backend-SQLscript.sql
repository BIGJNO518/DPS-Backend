DROP DATABASE IF EXISTS dpsbackend;
CREATE DATABASE dpsbackend;

SELECT dpsbackend;

DROP TABLE IF EXISTS UserName;
CREATE TABLE UserName(
    PID INT AUTO_INCREMENT,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    PRIMARY KEY (PID) 
);


DROP TABLE IF EXISTS UserPassword;
CREATE TABLE UserPassword(
    PID INT,
    password VARCHAR(255),
    PRIMARY KEY (PID)
);

DROP TABLE IF EXISTS UserInfo;
CREATE TABLE UserInfo (
    PID INT,
    address VARCHAR(255),
    phoneNumber VARCHAR(12),
    userEmail VARCHAR(255),
    RID INT, 
    last_login TIMESTAMP,
    PRIMARY KEY (PID)
);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (001, '34 Awesome Ave.', '518-775-7775', 'Yummy@food.com', 1); 
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (002, '37 Best Ave.', '518-665-8899', 'beez@email.com', 1);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (003, '43 Lantern St.', '518-889-0099', 'GreenBaby@DC_Uni.com', 2); 
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (004, 'BattleSchool, Lusitania', '518-009-8877', 'xenocide@email.com', 3);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (005, 'Athens, Greece', '765-957-9009', 'beannme@email.com', 2);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (006, 'Greensboro, NC', '800-HEGEMON', 'Hegemon@offices.earthgov', 3);
INSERT INTO UserInfo(PID, address, phoneNumber, userEmail, RID) VALUES (999, 'NULL', 'NULL', 'NULL', 4);


DROP TABLE IF EXISTS Event;
CREATE TABLE Event 
(EID INT, 
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
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(006, 'Smort', 'Ace', '2010-06-051', '2 This ave', 'Nowear', 'Alter');
INSERT INTO Event(EID, FirstName, LastName, Date, Address, City, State) VALUES(999, 'NULL', 'NULL', '0000-00-00', 'NULL', 'NULL', 'NULL');


DROP TABLE IF EXISTS EventRoster;
CREATE TABLE EventRoster
(EID INT,
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
CREATE TABLE Contributions
(EID INT, 
PID INT, 
Amount DECIMAL,
PRIMARY KEY (PID,EID)
); 

INSERT INTO Contribution(EID, PID, Amount) VALUES(001, 001, 1000.00);
INSERT INTO Contribution(EID, PID, Amount) VALUES(002, 002, 421.20);
INSERT INTO Contribution(EID, PID, Amount) VALUES(003, 003, 2222.22);
INSERT INTO Contribution(EID, PID, Amount) VALUES(004, 004, 1.01);
INSERT INTO Contribution(EID, PID, Amount) VALUES(005, 005, 0.01);
INSERT INTO Contribution(EID, PID, Amount) VALUES(006, 006, 100000.10);
INSERT INTO Contribution(EID, PID, Amount) VALUES(999, 999, NULL);


DROP TABLE if exists Roles;
CREATE TABLE Roles (
	RID INT PRIMARY KEY,
	roleslist VARCHAR(255)
);

INSERT INTO Roles(RID, roleslist) VALUES (1, 'Employee');
INSERT INTO Roles(RID, roleslist) VALUES (2, 'Volunteer');
INSERT INTO Roles(RID, roleslist) VALUES (3, 'Adminstrator');
INSERT INTO Roles(RID, roleslist) VALUES (4, 'General User');

DROP TABLE if exists Jobs;
CREATE TABLE Jobs (
	JID INT,
	EID INT,
	PID INT, 
	title VARCHAR(255),
	intime TIME null,
	outtime TIME null,
	PRIMARY KEY (JID,EID)
);

INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (001, 001, 006, 'Teacher', '06:00:00', '14:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (002, 002, 003, 'Events Organizer', '08:00:00', '16:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (003, 004, 001, 'Tutor', '16:00:00', '00:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (004, 003, 005, 'Youth Work', '07:00:00', '15:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (005, 001, 004, 'Deliver Goods', '4:00:00', '12:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (006, 006, 002, 'Cook', '06:00:00', '14:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (007, 002, 005, 'Coaching', '07:00:00', '15:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (008, 004, 003, 'Car Pool', '10:00:00', '18:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (009, 001, 002, 'Clerk', '06:00:00', '14:00:00');
INSERT INTO Jobs(JID, EID, PID, title, intime, outtime) VALUES (010, 004, 001, 'Music Lessons', '05:00:00', '13:00:00');


DROP TABLE if exists Permissions;

CREATE TABLE Permissions (
    RID INT PRIMARY KEY,
    readPerm CHAR,
    editPerm CHAR,
    addUserPerm CHAR,
    updateDBPerm CHAR,
    viewAllUserInfoPerm CHAR
);

INSERT INTO Permissions(RID, readPerm, editPerm, addUserPerm, updateDBPerm, viewAllUserInfoPerm) VALUES (1, 'Y', 'Y', 'Y', 'Y', 'N');
INSERT INTO Permissions(RID, readPerm, editPerm, addUserPerm, updateDBPerm, viewAllUserInfoPerm) VALUES (2, 'Y', 'N', 'Y', 'N', 'N');
INSERT INTO Permissions(RID, readPerm, editPerm, addUserPerm, updateDBPerm, viewAllUserInfoPerm) VALUES (3, 'Y', 'Y', 'Y', 'Y', 'Y');
INSERT INTO Permissions(RID, readPerm, editPerm, addUserPerm, updateDBPerm, viewAllUserInfoPerm) VALUES (4, 'Y', 'N', 'Y', 'N', 'N');
