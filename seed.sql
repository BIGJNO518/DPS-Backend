-- Turn safe updates off
SET SQL_SAFE_UPDATES = 0;

-- Insert users, update some permissions to have admins (2 lines, first put user then add token for them)
INSERT INTO users (name, phoneNumber, email, password) VALUE ('Daniel Foote', '5182224595', 'danfoote104227@gmail.com', AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))));
SET @dan_id = LAST_INSERT_ID();
UPDATE users SET token=MD5(@dan_id + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=@dan_id;

INSERT INTO users (name, phoneNumber, email, password) VALUE ('Matt Parrella', '78437892', 'parrellam617@strose.edu', AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))));
SET @matt_id = LAST_INSERT_ID();
UPDATE users SET token=MD5(@matt_id + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=@matt_id;

INSERT INTO users (name, phoneNumber, email, password) VALUE ('Jake Zembrzuski', '123', 'zembrzuski213@strose.edu', AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))));
SET @jake_id = LAST_INSERT_ID();
UPDATE users SET token=MD5(@jake_id + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=@jake_id;


-- Update some users permissions
UPDATE users SET admin = TRUE, employee = TRUE, volunteer= TRUE, developer=True WHERE email='danfoote104227@gmail.com';

-- Add some Events
INSERT INTO events (name, startTime, endTime, description) VALUE ('Pickup Main Street', concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 08:00:00'), concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 10:00:00'), 'I\'m the Trash Man! I come out, I throw trash all over the- all over the ring! And then I start eatin\' garbage! And then I pick up the trash can, and I bash the guy on the head.');
SET @main_street_eid = LAST_INSERT_ID();


-- Add some Jobs
INSERT INTO jobs (eid, name, startTime, endTime, uid, isDeleted) VALUES
(@main_street_eid, 'Bagger', concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 08:00:00'), concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 10:00:00'), @dan_id, False),
(@main_street_eid, 'Entertainment', concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 08:00:00'), concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 10:00:00'), @matt_id, False),
(@main_street_eid, 'Traffic Stopper', concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 08:00:00'), concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 10:00:00'), @jake_id, False);