CREATE TABLE `users` (
	`ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
	`name` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`phoneNumber` VARCHAR(255) NOT NULL,
	`password` varchar(32) NOT NULL,
	PRIMARY KEY (`ID`)
);