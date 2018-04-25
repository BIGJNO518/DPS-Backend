var express = require('express');
var async = require('async');
var nodemailer = require('nodemailer');

var routes = function (con) {
    var messageRouter = express.Router();

    var clients = [];
    var isTyping = [];

    messageRouter.put('/mail', function (req, res) {
        const transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 465,
            auth: {
                user: 'dpsamazingsite@gmail.com',
                pass: '2L^RiH1q1ff4'
            }
        });

        let mailOptions = {
            from: '"' + req.body.name + '" <' + req.body.email + '>', // sender address
            to: 'dpsamazingsite@gmail.com', // list of receivers
            subject: req.body.subject, // Subject line
            text: req.body.body, // plain text body
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                return console.log(error);
            }
        });
    });

    messageRouter.ws('/echo', function (ws, req) {
        //Verify the token query parameter is valid and if so annotate the connection with the user information.
        var token = req.query.token;
        if (!token) {
            exitError();
            return;
        }
        con.query('SELECT * FROM users WHERE token="' + req.query.token + '";', function (err, results, fields) {
            if (results.length === 0) {
                exitError()
                return;
            } else {
                con.query('SELECT `from`, message, `time` FROM (SELECT messages.ID, users.name AS `from`, messages.message AS message, messages.time AS `time` FROM messages INNER JOIN users ON messages.from=users.ID ORDER BY messages.ID DESC LIMIT 100) AS M ORDER BY M.ID ASC;', function (err, results, fields) {
                    if (err) {
                        exitError();
                        return;
                    }
                    ws.send(JSON.stringify({messages: results}));
                })
                clients[index].ID = results[0].ID;
                clients[index].name = results[0].name;
                console.log("Connnection request from: " + ws.name);
            }
        });
        ws.typingIndex = -1;
        var index = clients.push(ws) - 1;
        

        ws.on('message', function (msg) {
            var incoming = JSON.parse(msg);
            // If they tell use they're typing
            if (incoming.typing != null) {
                if (incoming.typing) {
                    ws.isTyping = true;
                } else {
                    ws.isTyping = false;
                }
                var whosTyping = [];
                for (var i = 0; i < clients.length; i++) {
                    if (clients[i].isTyping) {
                        whosTyping.push(clients[i].name);
                    }
                }
                for (var i = 0; i < clients.length; i++) {
                    if (clients[i].isTyping) {
                        var copy = whosTyping.slice();
                        copy.splice(whosTyping.indexOf(clients[i].name), 1);
                        clients[i].send(JSON.stringify({typing: copy}));
                    } else {
                        clients[i].send(JSON.stringify({typing: whosTyping}));
                    }
                }
            }
            // If they tell use they're sending a message.
            if (incoming.message) {
                con.query("INSERT INTO messages (`from`, message, `time`) VALUES (" + ws.ID + ", " + con.escape(incoming.message) +", NOW());", function (err, results, fields) {
                    if (err) {
                        console.log("Error inserting message.");
                    } else {
                        console.log(ws.name + " says '" + incoming.message + "'.");
                    }
                    msg = {
                        from: ws.name,
                        message: incoming.message,
                        time: new Date().getTime()
                    }
                    for (var i = 0; i < clients.length; i++) {
                        clients[i].send(JSON.stringify({messages: [msg]}));
                    }
                });
            }
        });
        ws.on('request', function (request) {
            console.log((new Date()) + ' Connection from origin ' + request.origin + '.');
        });
        ws.on('close', function () {
            clients.splice(index, 1);
            console.log("Connect closed from: " + ws.name);
        });

        function exitError() {
            // ws.send('error');
            ws.close();
        }
    });

    

    return messageRouter;
}

module.exports = routes;