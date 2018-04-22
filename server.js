// call the packages we need
var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');
var expressWs = require('express-ws')(app);

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;        // set our port or default to 8080
var con = mysql.createConnection({
    host: 'localhost',
    user: 'dps',
    password: 'backend',
    database: 'dpsbackend',
    multipleStatements: true
});
con.connect(function (err) {
    if(err){
        callback({status: 502, message: 'Invalid Server'}, null);
        return;
    }
    console.log('Connected!');
})
var userRouter = require('./app/routers/userRoutes.js')(con);
var eventRouter = require('./app/routers/eventRoutes.js')(con);
var messageRouter = require('./app/routers/messageRoutes.js')(con);

// Check if authentication token has expired, if it has strip it off.
app.use(function (req, res, next) {
    var token = req.headers.authentication;
    if (!token) {
        next();
        return;
    }
    con.query("SELECT expires FROM users WHERE token='" + token + "'", function (err, result, fields) {
        if (result[0].expires < new Date()) {
            delete req.headers.authentication;
        };
        next();
        return;
    })
});

// all of our routes will be prefixed with /api
app.use('/api/user', userRouter);
app.use('/api/events', eventRouter);
app.use('/api/messages', messageRouter);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Server listening on port: ' + port);