# DPS-Backend
This will be the constructive repository for the Database portion of our Web-based service

### Deploying and using a SQL server
1. Install mysql on to your computer. Download/Instruction can be found here https://dev.mysql.com/downloads/installer/
2. Login using Command Terminal using this: mysql -u root -p
3. Use password that was given to you during installation phase
4. Enter the following: ALTER USER 'root'@'localhost' IDENTIFIED BY 'YourNewPassword';
5. Last step to have a fully functional databse and tables: source < sql.sql


### Development Steps
1. Install NodeJS 
2. Open terminal and navigate to project root (Contains file `package.json`)
3. Type command `npm install` to install all the dependencies for the project.
4. Do the following in the terminal: `npm install mysql`, `npm install express`, `npm install nodemailer`
5. Type command `npm start` to begin the server in watch mode. The server will restart if you change any file! So you don't need to 

### Packages
body-parser: Allows us to get content of POST requests easily.
express: Node framework that we will be using to build the API.
mysql: Database we will use to store information.
nodemon: Development package only. Watches files for changes and recompiles the server if anything
