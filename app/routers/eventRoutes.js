var express = require('express');
var async = require('async');

var routes = function (con) {
    var eventRouter = express.Router();

    eventRouter.get('/', function (req, res) {
        con.query("SELECT * FROM events WHERE startTime > NOW()", function (err, result, fields) {
            res.send(JSON.stringify(result));
        });
    });

    eventRouter.get('/:eventId', function (req, res) {
        async.waterfall([
            async.apply(getPermissionFromToken, req.params.authentication),
            async.apply(getEvent, req.param('eventId')),
            async.apply(getJobs, req.param('eventId'))
        ], function (err, results) {
            // filter results if not authorized.
            if (!results.permissions.admin) {
                for (var i = 0; i < results.event.jobs.length; i++) {
                    if (results.event.jobs[i].volunteer) {
                        results.event.jobs[i].volunteer.id = -1;
                        results.event.jobs[i].volunteer.name = 'Volunteer';
                        results.event.jobs[i].volunteer.email = null;
                    }
                }
            }
            delete results.permissions;
            res.send(JSON.stringify(results));
        });
    });

    function getPermissionFromToken (token, callback) {
        if (!token) {
            callback(null, {permissions: {admin: false, employee: false, volunteer: false, developer: false}});
            return;
        }
        con.query("SELECT * FROM sessions INNER JOIN permissions ON sessions.ID=permissions.ID WHERE sessions.token='" + token + "';", function (err, result, fields) {
            callback(null, {permissions: {admin: result.admin, employee: result.employee, volunteer: result.volunteer, developer: result.developer}});
            return;
        });
    };

    function getEvent(eventId, obj, callback) {
        con.query("SELECT * FROM events WHERE events.ID=" + eventId + ';', function (err, result, fields) {
            obj.event = result[0];
            callback(null, obj);
            return;
        });
    };

    // BEEFY call, better way to do this?
    function getJobs(eventId, obj, callback) {
        con.query("SELECT jobs.ID, jobs.name, jobs.startTime, jobs.endTime, users.ID AS uid, users.name AS username, users.email " +
          "FROM jobs LEFT OUTER JOIN volunteers ON volunteers.jid=jobs.id LEFT OUTER JOIN users ON volunteers.uid=users.ID " +
          "WHERE jobs.eid=" + eventId + ";", function (err, result, fields) {
              obj.event.jobs = [];
              for (var i = 0; i < result.length; i++) {
                    var thisJob = {
                    id: result[i].ID,
                    name: result[i].name,
                    startTime: result[i].startTime,
                    endTime: result[i].endTime
                    };
                    if (result[i].uid) {
                        thisJob.volunteer = {
                            id: result[i].uid,
                            name: result[i].username,
                            email: result[i].email
                        }
                    } else {
                        thisJob.volunteer = null
                    };
                    obj.event.jobs.push(thisJob);
                };
                callback(null, obj);
        });
    }

    return eventRouter;

}

module.exports = routes;