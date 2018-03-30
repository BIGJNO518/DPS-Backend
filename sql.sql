CREATE TABLE `users` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`phoneNumber` VARCHAR(255) NOT NULL,
	`password` blob NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE `sessions` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`token` varchar(32) NOT NULL UNIQUE,
	`expires` DATETIME NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE `permissions` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`admin` BOOLEAN NOT NULL,
	`employee` BOOLEAN NOT NULL,
	`volunteer` BOOLEAN NOT NULL DEFAULT True,
	`developer` BOOLEAN NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE `events` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`startTime` DATETIME NOT NULL,
	`endTime` DATETIME NOT NULL,
	`description` VARCHAR(255) NOT NULL,
	`isDeleted` BOOLEAN NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE `jobs` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`eid` INT NOT NULL,
	`name` VARCHAR(255) NOT NULL,
	`startTime` DATETIME NOT NULL,
	`endTime` DATETIME NOT NULL,
	PRIMARY KEY (`ID`)
);

CREATE TABLE `volunteers` (
	`ID` INT NOT NULL AUTO_INCREMENT,
	`jid` INT NOT NULL,
	`uid` INT NOT NULL,
	PRIMARY KEY (`ID`)
);

ALTER TABLE `sessions` ADD CONSTRAINT `sessions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `permissions` ADD CONSTRAINT `permissions_fk0` FOREIGN KEY (`ID`) REFERENCES `users`(`ID`);

ALTER TABLE `jobs` ADD CONSTRAINT `jobs_fk0` FOREIGN KEY (`eid`) REFERENCES `events`(`ID`);

ALTER TABLE `volunteers` ADD CONSTRAINT `volunteers_fk0` FOREIGN KEY (`jid`) REFERENCES `jobs`(`ID`);

ALTER TABLE `volunteers` ADD CONSTRAINT `volunteers_fk1` FOREIGN KEY (`uid`) REFERENCES `users`(`ID`);
