-- Turn safe updates off
SET SQL_SAFE_UPDATES = 0;

-- Insert users, update some permissions to have admins (2 lines, first put user then add token for them)
INSERT INTO users (name, phoneNumber, email, password) VALUE ('Daniel Foote', '5182224595', 'danfoote104227@gmail.com', AES_ENCRYPT(MD5('password'), UNHEX(SHA2('SecretDPSPassphrase', 512))));
UPDATE users SET token=MD5(LAST_INSERT_ID() + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=LAST_INSERT_ID();

-- Update some users permissions
UPDATE users SET admin=True, employee=True, volunteer=True, developer=True WHERE email='danfoote104227@gmail.com';

-- Add some Events
INSERT INTO events (name, startTime, endTime, description) VALUES 
('Pickup Main Street', concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 08:00:00'), concat(DATE_ADD(CURDATE(), INTERVAL 7 DAY), ' 10:00:00'), 'I\'m the Trash Man! I come out, I throw trash all over the- all over the ring! And then I start eatin\' garbage! And then I pick up the trash can, and I bash the guy on the head.');

-- Add some Jobs