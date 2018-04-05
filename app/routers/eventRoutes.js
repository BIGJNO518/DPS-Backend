var express = require('express');
var async = require('async');

var routes = function (con) {
    var eventRouter = express.Router();

    // Get all Events
    eventRouter.get('/', function (req, res) {
        con.query("SELECT * FROM Events WHERE startTime > NOW()", function (err, result, fields) {
            res.json(result);
        });
    });

    // Get single Event
    eventRouter.get('/:eventId', function (req, res) {
        async.waterfall([
            async.apply(getPermissionFromToken, req.headers.authentication),
            async.apply(getEvent, req.param('eventId')),
            async.apply(getJobs, req.param('eventId'))
        ], function (err, results) {
            // filter results if not authorized.
            if (!results.permissions.admin) {
                for (var i = 0; i < results.Event.jobs.length; i++) {
                    if (results.Event.jobs[i].volunteer) {
                        results.Event.jobs[i].volunteer.ID = -1;
                        results.Event.jobs[i].volunteer.name = 'Volunteer';
                        results.Event.jobs[i].volunteer.email = null;
                    }
                }
            }
            delete results.permissions;
            res.json(results.Event);
        });
    });

    //place holder for removing jobs (Not Complete)
    eventRouter.get('/unregister/:eventId/:jobId', function (req, res) {

    });

    //place holder for adding jobs (Not Complete)
    eventRouter.get('/register/:eventId/:jobId', function (req, res) {
            
     });
    

    // Update/Add Event
    eventRouter.put('/', function (req, res) {
        if (!req.headers.authentication) {
            res.status(401).send('Unauthorized');
            return;
        }
        var event = {
            ID: req.body.id,
            name: req.body.name,
            startTime: +req.body.startTime,
            endTime: +req.body.endTime,
            description: req.body.description
        };
        async.waterfall([
            async.apply(getPermissionFromToken, req.headers.authentication)
        ], function (err, results) {
            // Check if permitted to make change
            if (results.permissions.admin != 1) {
                res.status(401).send('Unauthorized');
                return;
            }
            // Check Event is properly formatted
            // TODO

            // If the ID is -1, it an insert. If it's anything else it's an update.
            if (event.ID == -1) {
                con.query("INSERT INTO Events (name, startTime, endTime, description) VALUE ('" + event.name + "', from_unixtime(FLOOR(" + 
                  event.startTime + "/1000)), from_unixtime(FLOOR(" + event.endTime + "/1000)), '" + event.description + "');", function (err, result, fields) {
                    event.ID = result.insertId;
                    res.json(event);
                });
            } else {
                con.query("UPDATE Events SET name='" + event.name + "', startTime=from_unixtime(FLOOR(" + 
                  event.startTime + "/1000)), endTime=from_unixtime(FLOOR(" + event.endTime + "/1000)), description='" + 
                  event.description + "' WHERE id=" + event.ID + ";", function (err, result, fields) {
                    if (err) {
                        res.status(500).send('Error updating Event');
                    }
                    res.json(event)
                  });
            }
        });
    });

    function getPermissionFromToken (token, callback) {
        if (!token) {
            callback(null, {permissions: {admin: false, employee: false, volunteer: false, developer: false}});
            return;
        }
        con.query("SELECT * FROM users WHERE token='" + token + "';", function (err, result, fields) {
            callback(null, {permissions: {admin: result[0].admin, employee: result[0].employee, volunteer: result[0].volunteer, developer: result[0].developer}});
            return;
        });
    };

    function getEvent(eventId, obj, callback) {
        con.query("SELECT * FROM events WHERE ID=" + eventId + ';', function (err, result, fields) {
            obj.Event = result[0];
            callback(null, obj);
            return;
        });
    };

    function deleteEvent(eventId, obj, callback) {
        con.query("UPDATE Events SET isDeleted = TRUE WHERE Events.ID=" + eventId + ';', function (err, result, fields) {
            obj.Event = result[0];
            callback(null, obj);
            return;
        });
    };

    //gets the job from the particular event
    function getJobs(eventId, obj, callback) {
        con.query("SELECT jobs.ID, jobs.name, jobs.startTime, jobs.endTime, jobs.uid, users.name AS username, users.email " + 
            "FROM jobs LEFT OUTER JOIN users ON jobs.uid=users.ID " + "WHERE eid=" + eventId + ";", function (err, result, fields) {
              obj.Event.jobs = [];
              for (var i = 0; i < result.length; i++) {
                    var thisJob = {
                    ID: result[i].ID,
                    name: result[i].name,
                    startTime: result[i].startTime,
                    endTime: result[i].endTime
                    };
                    if (result[i].uid) {
                        thisJob.volunteer = {
                            ID: result[i].uid,
                            name: result[i].username,
                            email: result[i].email
                        }
                    } else {
                        thisJob.volunteer = null
                    };
                    obj.Event.jobs.push(thisJob);
                };
                callback(null, obj);
                return;
        });
    }

    return eventRouter;

}

module.exports = routes;