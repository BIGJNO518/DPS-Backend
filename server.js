// call the packages we need
var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');

// configure app to use bodyParser()
// this will let us get the data from a POST
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var port = process.env.PORT || 8080;        // set our port or default to 8080

var router = express.Router();              // get an instance of the express Router

// Middleware to output any debugging messages for incoming requests.
router.use(
    (req, res, next) => {
        console.log('Request Incoming: ' + req);
        next();
    }
);

// Test function for now... will delete later.
router.get('/', function(req, res) {
    res.json({ message: 'hooray! welcome to our api!' });   
});

// all of our routes will be prefixed with /api
app.use('/api', router);

// START THE SERVER
// =============================================================================
app.listen(port);
console.log('Server listening on port: ' + port);