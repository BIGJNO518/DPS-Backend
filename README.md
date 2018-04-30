# DPS-Backend
This will be the constructive repository for the Database portion of our Web-based service

### Deploying and using a SQL server
1. Install mysql on to your computer. Download/Instruction can be found here https://dev.mysql.com/downloads/installer/
2. Go to the folder called "Backendscripts"
3. Login using the Command Terminal by using the following: mysql -u root -p
4. Use the password that was given to you during the installation phase
5. Enter the following: ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
6. CREATE USER 'custom'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON dpsbackend.* TO 'custom'@'localhost';
It is recommended if you set the custom to dps and the password to dpsbackend if you don't want to make adjustments to server.js
7. Last step to have a fully functional databse and tables: /source < sql.sql
8. If you want mock data: /source < seed.sql


### Development Steps
1. Install NodeJS 
2. Open terminal and navigate to project root (Contains file `package.json`)
3. Type command `npm install` to install all the dependencies for the project.
4. Type command `npm start` to begin the server in watch mode. The server will restart if you change any files and save it! So you don't need to manually restart it yourself.

### Packages
body-parser: Allows us to get content of POST requests easily.
express: Node framework that we will be using to build the API.
mysql: Database we will use to store information.
nodemon: Development package only. Watches files for changes and recompiles the server if anything
