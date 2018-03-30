// call the packages we need
var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var mysql = require('mysql');

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
    if (err) throw err;
    console.log('Connected!');
})
var userRouter = require('./app/routers/userRoutes.js')(con);

// all of our routes will be prefixed with /api
app.use('/api/user', userRouter);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Server listening on port: ' + port);