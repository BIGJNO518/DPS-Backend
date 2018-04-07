var express = require('express');
var async = require('async');

var routes = function (con) {
    var messageRouter = express.Router();

    var clients = [];


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
                    ws.send(JSON.stringify(results));
                })
                clients[index].ID = results[0].ID;
                clients[index].name = results[0].name;
            }
        });
        var index = clients.push(ws) - 1;

        ws.on('message', function (msg) {
            
            con.query("INSERT INTO messages (`from`, message, `time`) VALUES (" + ws.ID + ", " + con.escape(msg) +", NOW());", function (err, results, fields) {
                if (err) {
                    console.log("Error inserting message.");
                } else {
                    console.log(ws.name + " says '" + msg + "'.");
                }
                msg = {
                    from: ws.name,
                    message: msg,
                    time: new Date().getTime()
                }
                for (var i = 0; i < clients.length; i++) {
                    clients[i].send(JSON.stringify(msg));
                }
            });
        });
        ws.on('request', function (request) {
            console.log((new Date()) + ' Connection from origin ' + request.origin + '.');
        });
        ws.on('close', function () {
            clients.splice(index, 1);
        });
        console.log("Connnection request from: " + req.ip);

        function exitError() {
            ws.send('error');
            ws.close();
        }
    });

    

    return messageRouter;
}

module.exports = routes;