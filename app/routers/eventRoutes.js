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
            async.apply(getUserFromToken, req.headers.authentication),
            async.apply(getEvent, req.param('eventId')),
            async.apply(getJobs, req.param('eventId'))
        ], function (err, results) {
            if (err) {
                res.status(err.status).send(err.message);
                return;
            }
            // filter results if not authorized.
            if (!results.permissions.admin) {
                for (var i = 0; i < results.Event.jobs.length; i++) {
                    if (results.Event.jobs[i].volunteer && results.Event.jobs[i].volunteer.ID != results.user.ID) {
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

    //removing jobs
    eventRouter.put('/unregister/:eventId/:jobId', function (req, res) {
        var token = req.headers.authentication;
        if (!token) {
            res.status(401).send("Unauthorized");
            return;
        }
        
        async.waterfall([
            async.apply(getUserFromToken, token),
            function (user, callback) {
                // Check if this person is authorized to make this change
                if (user.permissions.volunteer) {
                    con.query("UPDATE jobs SET uid=" + null + " WHERE eid=" + 
                    req.param('eventId')+ " AND ID=" + req.param('jobId') + ";", function (err, result, fields) {
                        callback(null, user);
                        return;
                    });
                } else {
                    res.status(401).send("Unauthorized");
                }
            }
        ], function (err, results) {
            if (err) {
                res.status(err.status).send(err.message);
            } else {
                res.status(200).send();
            }
        });

    });

    //adding jobs
    eventRouter.put('/job/:eventId', function (req, res) {
        var token = req.headers.authentication;
        if (!token) {
            res.status(401).send("Unauthorized");
            return;
        }

        var job = {
            ID: req.body.ID,
            eid: req.params.eventId,
            name: req.body.name,
            startTime: req.body.startTime,
            endTime: req.body.endTime
        };

        async.waterfall([
            async.apply(getUserFromToken, token),
            async.apply(function (job, obj, callback) {
                // User isn't admin, can't make change
                if (!obj.permissions.admin) {
                    callback({status: 201, message: "Unauthorized"}, null);
                }

                // ID will be -1 for new job, ID will be set for update
                if (job.ID >= 0) {
                    con.query("UPDATE jobs SET name='" + job.name 
                    + "', startTime=from_unixtime(FLOOR(" + job.startTime + "/1000)), endTime=from_unixtime(FLOOR(" + job.endTime + "/1000)) WHERE ID=" + job.ID + ";"
                    , function (err, result, fields) {
                        callback(err, result);
                    });
                } else {
                    con.query("INSERT INTO jobs (eid, name, startTime, endTime) VALUE (" + job.eid + ", '" + job.name 
                    + "', from_unixtime(FLOOR(" + job.startTime + "/1000)), from_unixtime(FLOOR(" + job.endTime + "/1000)));", function (err, result, fields) {
                        callback(err, result);
                    });
                }
            }, job)

        ],
        function (err, result) {
            if (err) {
                res.status(err.status).send(err.message)
            } else {
                res.status(200).send();
            }
            console.log(result);
        })

        //deleting an event
        eventRouter.delete('/:eventId', function (req, res) {
                    async.waterfall([
                    async.apply(getUserFromToken, req.headers.authentication),
                    async.apply(deleteEvent, req.param('eventId'))
                     ] ,function (err, results) {

                            res.status(err.status).send(err.message);
                            return;


                        res.json(null);
                    });
                });
        
        // async.waterfall([
        //     async.apply(getUserFromToken, token),
        //     function (user, callback) {
        //         // Check if this person is authorized to make this change
        //         if (user.permissions.volunteer) {
        //             con.query("UPDATE jobs SET uid=" + user.user.ID + " WHERE eid=" + 
        //             req.param('eventId')+ " AND ID=" + req.param('jobId') + ";", function (err, result, fields) {
        //                 callback(null, user);
        //                 return;
        //         });
        //         }
        //         res.status(401).send("Unauthorized");
        //         return;
        //     }
        // ], function (err, results) {
        //     if (err) {
        //         res.status(500).send();
        //     } else {
        //         res.status(200).send();
        //     }
        // });
    });
    

    // Update/Add Event
    eventRouter.put('/', function (req, res) {
        if (!req.headers.authentication) {
            res.status(401).send('Unauthorized');
            return;
        }
        var event = {
            ID: req.body.ID,
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
                con.query("INSERT INTO events (name, startTime, endTime, description) VALUE ('" + event.name + "', from_unixtime(FLOOR(" + 
                  event.startTime + "/1000)), from_unixtime(FLOOR(" + event.endTime + "/1000)), '" + event.description + "');", function (err, result, fields) {
                    event.ID = result.insertId;
                    res.json(event);
                });
            } else {
                con.query("UPDATE events SET name='" + event.name + "', startTime=from_unixtime(FLOOR(" + 
                  event.startTime + "/1000)), endTime=from_unixtime(FLOOR(" + event.endTime + "/1000)), description='" + 
                  event.description + "' WHERE id=" + event.ID + ";", function (err, result, fields) {
                    if (err) {
                        res.status(400).send('Error updating Event');
                        return;
                    }
                    res.json(event)
                  });
            }
        });
    });

    // Volunteer for a job
    eventRouter.put('/:eventId/:jobId', function (req, res) {
        if (!req.headers.authentication) {
            res.status(401).send('Unauthorized');
            return;
        }

        async.waterfall([
            async.apply(getPermissionFromToken, req.headers.authentication)
            ], function (err, results) {
            // Check if permitted to make change
            if(err){
                res.status(err.status).send(err.message)
                return;
            }

            if (results.permissions.volunteer != 1) {
                res.status(401).send('Unauthorized');
                return;
            }
            con.query("UPDATE jobs SET uid=" + req.body.userId + " WHERE ID=" + req.params.jobId, function (err, result, fields) {
                if (err) {
                    res.status(400).send('Error Updating Job');
                } else {
                    res.status(200).send();
                }
            });
        });
    });

    function getPermissionFromToken (token, callback) {
        if (!token) {
            callback(null, {permissions: {admin: false, employee: false, volunteer: false, developer: false}});
            return;
        }
        con.query("SELECT * FROM users WHERE token='" + token + "';", function (err, result, fields) {
            if(err){
                callback({status: 400, message: 'Error Getting Token'}, null);
                return;
            }
            callback(null, {permissions: {admin: result[0].admin, employee: result[0].employee, volunteer: result[0].volunteer, developer: result[0].developer}});
            return;
        });
    };

    function getEvent(eventId, obj, callback) {
        con.query("SELECT * FROM events WHERE ID=" + eventId + ';', function (err, result, fields) {
<<<<<<< HEAD
        if (err){
            //This is not final error message.
            return callback(err);
        }
         
            obj.Event = result;
=======

            if(err){
                callback({status: 400, message: 'Error Getting Event'}, null);
                return;
            }
            if(result.length == 0){
                callback({status: 404, message: "Does not exist"}, null);
                return;
            }

            obj.Event = result[0];
>>>>>>> 803ca6ca5de3cd9069993860978852e84e7aee5d
            callback(null, obj);
            return;
         } );
    };

    function deleteEvent(eventId, obj, callback) {
        if (!obj.permissions.admin || !obj.permissions.employee) {
            callback({status: 401, message: "Unauthorized"}, null);
            return;
        }

        con.query("UPDATE Events SET isDeleted = TRUE WHERE Events.ID=" + eventId + ';', function (err, result, fields) {
            callback({status: 200, message: "Succesfully Deleted"}, null);
            return;
        });
    };

    //gets the job from the particular event
    function getJobs(eventId, obj, callback) {
        con.query("SELECT jobs.ID, jobs.name, jobs.startTime, jobs.endTime, jobs.uid, users.name AS username, users.email " + 
            "FROM jobs LEFT OUTER JOIN users ON jobs.uid=users.ID " + "WHERE eid=" + eventId + ";", function (err, result, fields) {
                // if(result.length == 0){
                //     callback({status: 400, message: 'Error Getting Job'}, null);
                //     return;
                // }
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

    function getUserFromToken(token, callback) {
        con.query("SELECT * FROM users WHERE token='" + token + "';", function (err, result, fields) {
            // If there was an error.
            if (err) {
                callback({status: 400, message: 'Error Getting Token'});
            }

            // If there was no user found send anonymous permissions
            if (result.length === 0) {
                var user = {
                    user: {
                        ID: -1,
                        name: "",
                        email: "",
                        phoneNumber: ""
                    },
                    permissions: {
                        admin: false,
                        employee: false,
                        volunteer: false,
                        developer: false
                    }
                };
            } else {
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
            }
            callback(null, user);
        });
    }

    return eventRouter;

}

module.exports = routes;