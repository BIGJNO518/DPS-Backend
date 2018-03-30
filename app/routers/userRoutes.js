var express = require('express');
var async = require('async');

// route '/api/user'
var routes = function (con) {
    var userRouter = express.Router();

    // Login
    userRouter.get('/authenticate', function (req, res) {
        async.waterfall([
            async.apply(getUser, req.headers.email, req.headers.password),
            updateToken,
            getToken
        ], function (err, results) {
            console.log(results); 
            res.json(results);
        });
    });

    // Register
    userRouter.put('/register', function (req, res) {
        if (!(req.headers.email && req.headers.name && req.headers.phonenumber && req.headers.password)) {
            res.status(500).send('Missing information');
        }
        var user = {
            user: {
                email: req.headers.email,
                name: req.headers.name,
                phoneNumber: req.headers.phonenumber,
                password: req.headers.password
            }
        }
        async.waterfall([
            async.apply(function (user, callback) {
                con.query("SELECT * FROM users WHERE email = '" + user.user.email + "'", function (err, result, fields) {
                    if (result.length > 0) {
                        res.status(500).send('Already registered!');
                        return;
                    }
                    callback(null, user)
                })
            }, user),
            function (user, callback) {
                con.query("INSERT INTO users (name, email, phoneNumber, password) VALUE ('" + 
                user.user.name + "', '" + 
                user.user.email + "', '" + 
                user.user.phoneNumber + "', AES_ENCRYPT(MD5('" + user.user.password + "'), UNHEX(SHA2('SecretDPSPassphrase', 512))));", function (err, result, fields) {
                    if (err) {
                        callback(err, null);
                    }
                    delete user.user.password;
                    user.user.ID = result.insertId;
                    callback(null, user);
                })
            },
            function (user, callback) {
                con.query("INSERT INTO permissions (ID, admin, employee, volunteer, developer) VALUE (" + user.user.ID + ", FALSE, FALSE, TRUE, FALSE);", function (err, result, fields) {
                    user.permissions = {
                        admin: false,
                        employee: false,
                        volunteer: true,
                        developer: false
                    };
                    callback(null, user);
                })
            },
            function (user, callback) {
                con.query("INSERT INTO sessions (ID, token, expires) VALUE (" + 
                user.user.ID +", MD5(" + 
                user.user.ID +" + NOW()), DATE_ADD(NOW(), INTERVAL 30 DAY));", function (err, result, fields) {
                    callback(null, user);
                })
            },
            getToken
        ], function (err, results) {
            if (err) {
                res.send(err);
            }
            res.json(results);
        })
    });

    // Update user information
    userRouter.put('/', function (req, res) {
        var token = req.headers.authentication;
        if (!token) {
            res.status(401).send("Unauthorized");
            return;
        }

        async.waterfall([
            async.apply(getUserFromToken, token),
            function (user, callback) {
                // Check if this person is authorized to make this change
                if (req.headers.id == user.user.ID || user.permissions.admin) {
                    user.user.name = req.headers.name;
                    user.user.email = req.headers.email;
                    user.user.phoneNumber = req.headers.phonenumber;
                    callback(null, user)
                    return;
                }
                res.status(401).send("Unauthorized");
                return;
            },
            function (user, callback) {
                con.query("UPDATE users SET name='" + user.user.name + "', email='" + user.user.email + "', phoneNumber='" + user.user.phoneNumber + "' WHERE ID=" + 
                  user.user.ID + ";", function (err, result, fields) {
                    callback(null, user);
                });
            }
        ], function (err, results) {
            res.json(results);
        });
    })

    function getUser(email, password, callback) {
        con.query("SELECT * FROM users INNER JOIN permissions ON users.ID=permissions.ID WHERE email = '" + email + "' AND password = AES_ENCRYPT(MD5('" + password + "'), UNHEX(SHA2('SecretDPSPassphrase', 512)))", function (err, result, fields) {
            if (err) {
                callback(err, null);
                return;
            };
            var user = {
                user: {
                    ID: result[0].ID,
                    name: result[0].name,
                    email: result[0].email,
                    phoneNumber: result[0].phoneNumber,
                },
                permissions: {
                    admin: result[0].admin,
                    employee: result[0].employee,
                    volunteer: result[0].volunteer,
                    developer: result[0].developer
                }
            };
            callback(null, user);
        });
    };

    function updateToken(user, callback) {
        con.query("UPDATE sessions SET token=MD5(" + user.user.ID +" + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=" + user.user.ID + ";", function (err, result, fields) {
            callback(null, user);
        });
    };

    function getToken(user, callback) {
        con.query("SELECT token FROM sessions WHERE ID=" + user.user.ID + ";", function (err, result, fields) {
            if (err) {
                callback(err, null);
            }
            user.authentication = result[0].token;
            callback(null, user);
        })
    };

    function getUserFromToken(token, callback) {
        con.query("SELECT * FROM sessions INNER JOIN users ON sessions.ID=users.ID INNER JOIN permissions ON sessions.ID=permissions.ID WHERE sessions.token='" + 
          token + "';", function (err, result, fields) {
            var user = {
                user: {
                    ID: result[0].ID,
                    name: result[0].name,
                    email: result[0].email,
                    phoneNumber: result[0].phoneNumber
                },
                permissions: {
                    admin: result[0].admin,
                    employee: result[0].employee,
                    volunteer: result[0].volunteer,
                    developer: result[0].developer
                }
            };
            callback(null, user);
        });
    }

    return userRouter;
};

module.exports = routes;