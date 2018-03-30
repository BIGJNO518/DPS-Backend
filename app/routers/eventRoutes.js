var express = require('express');
var async = require('async');

var routes = function (con) {
    var eventRouter = express.Router();

    eventRouter.get('/', function (req, res) {
        con.query("SELECT * FROM events WHERE startTime > NOW()", function (err, result, fields) {
            res.send(JSON.stringify(result));
        });
    })

    return eventRouter;

}

module.exports = routes;