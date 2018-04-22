var express = require('express');
var async = require('async');

// route '/api/user'
var routes = function (con) {
    var userRouter = express.Router();

    // Login
    userRouter.get('/authenticate', function (req, res) {
        var token = req.headers.authentication;
        if (token && !req.headers.email) {
            async.waterfall([
                async.apply(getUserFromToken, token)
            ],
            function (err, results) {
                if (err) {
                    res.status(401).send("Invalid or expired token")
                } else {
                    results.authentication = token;
                    res.status(200).send(results)
                }
            });
        } else {
            console.log(req.headers)
            async.waterfall([
                async.apply(getUser, req.headers.email, req.headers.password),
                updateToken
                ], 
                function (err, results) {
                if (err) {
                    res.status(err.status).send(err.message);
                    return;
                }
                res.json(results);
            });
        }
    });

    // Register
    userRouter.put('/register', function (req, res) {
        if (!(req.body.email && req.body.name && req.body.phoneNumber && req.body.password)) {
            res.status(406).send('Missing information');
        }
        var user = {
            user: {
                email: req.body.email,
                name: req.body.name,
                phoneNumber: req.body.phoneNumber,
                password: req.body.password
            },
            permissions: {
                admin: false,
                employee: false,
                volunteer: true,
                developer: false
            }
        }
        async.waterfall([
            async.apply(function (user, callback) {
                con.query("SELECT * FROM users WHERE email = '" + user.user.email + "'", function (err, result, fields) {
                    if (result.length > 0) {
                        res.status(406).send('Already registered!');
                        return;
                    }
                    callback(null, user)
                })
            }, user),
            function (user, callback) {
                con.query("INSERT INTO users (name, phoneNumber, email, password) VALUE ('" + 
                user.user.name + "', '" + 
                user.user.phoneNumber + "', '" + 
                user.user.email + "', AES_ENCRYPT(MD5('" + user.user.password + "'), UNHEX(SHA2('SecretDPSPassphrase', 512))));", function (err, result, fields) {
                    if(err){
                        callback({status: 400, message: 'Bad Request'}, null);
                        return;
                    }
                    delete user.user.password;
                    user.user.ID = result.insertId;
                    callback(null, user);
                })
            },
            function (user, callback) {
                con.query("UPDATE users SET token=MD5(" + user.user.ID + " + NOW()),expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=" + user.user.ID + "; SELECT token FROM users WHERE id=" + user.user.ID + ";", function (err, result, fields) {
                    if(result.length == 0){
                        callback({status: 400, message: 'Bad Request'}, null);
                        return;
                    }
                    user.authentication = result[1][0].token;
                    callback(null, user);
                })
            }
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
                if (req.body.ID == user.user.ID || user.permissions.admin) {
                    user.user.name = req.body.name;
                    user.user.email = req.body.email;
                    user.user.phoneNumber = req.body.phoneNumber;
                    callback(null, user)
                    return;
                }
                
                res.status(401).send("Unauthorized");
                return;
            },
            function (user, callback) {
                con.query("UPDATE users SET name='" + user.user.name + "', phoneNumber='" + user.user.phoneNumber + "', email='" + user.user.email + "' WHERE ID=" + 
                  user.user.ID + ";", function (err, result, fields) {
                    callback(null, user);
                });
            }
        ], function (err, results) {
            results.authentication = token;
            res.json(results);
        });
    });

    // Get list of all registered users
    userRouter.get('/', function (req, res) {
        var token = req.headers.authentication;
        console.log("log");
        if (!token) {
            
            res.status(401).send("Unauthorized");
            return;
        }
        async.waterfall([
            async.apply(getUserFromToken, token)
        ], function (err, results) {
            if (!results.permissions.admin) {
                res.status(401).send("Unauthorized");
                return;
            }
            con.query('SELECT ID, `name`, email, phoneNumber FROM users;', function (err, result, fields) {
                res.send(result);
            })

        })
    });

    function getUser(email, password, callback) {
        con.query("SELECT * FROM users WHERE email = '" + email + "' AND password = AES_ENCRYPT(MD5('" + password + "'), UNHEX(SHA2('SecretDPSPassphrase', 512)))", function (err, result, fields) {
            if (err) {
                callback(err, null);
                return;
            } else if (result.length == 0) {
                callback({status: 406, message: 'Email or password are incorrect.'}, null);
                return;
            };
            var user = {
                user: {
                    ID: result[0].ID,
                    name: result[0].name,
                    email: result[0].email,
                    phoneNumber: result[0].phoneNumber,
                },
                authentication: result[0].authentication,
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
        con.query("UPDATE users SET token=MD5(" + user.user.ID +" + NOW()), expires=DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE ID=" + user.user.ID + "; SELECT token FROM users WHERE ID=" + user.user.ID + ";", function (err, result, fields) {
            if(result.length == 0){
                callback({status: 404, message: 'User Does Not Exist'}, null);
                return;
            }
            user.authentication = result[1][0].token;
            callback(null, user);
        });
    };

    function getUserFromToken(token, callback) {
        con.query("SELECT * FROM users WHERE token='" + token + "' AND expires > NOW();", function (err, result, fields) {
            if(result.length == 0){
                callback({status: 404, message: 'User With Token Does Not Exist'}, null);
                return;
            }

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