var exec = require('cordova/exec');

//JS bridge for default JS method.
var execAsPromise = function (success, error, service, action, params) {
    return new Promise(function (resolve, reject) {
        exec(
            function (data) {
                resolve(data);
                if (typeof success === 'function') {
                    success(data);
                }
            },
            function (err) {
                reject(err);
                if (typeof error === 'function') {
                    error(err);
                }
            },
            service,
            action,
            params);
    });
};

//JS bridge for get license info
exports.getMetadata = function (success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'getMetadata', []);
};

//JS bridge for MRZ scanning method.
exports.startMRZ = function (accuraConfigs = {}, messagesConfigs = {},  type = 'other_mrz', countryList = 'all', success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startMRZ', [accuraConfigs, messagesConfigs, type, countryList, screen.orientation.type]);
};

//JS bridge for check liveness method.
exports.startLiveness = function (accuraConfigs = {}, livenessConfigs = {}, success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startLiveness', [accuraConfigs, livenessConfigs, screen.orientation.type]);
};

//JS bridge for check face match method.
exports.startFaceMatch = function (accuraConfigs = {}, faceMatchConfigs = {}, success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startFaceMatch', [accuraConfigs, faceMatchConfigs, screen.orientation.type]);
};

//JS bridge for clean face match method.
exports.cleanFaceMatch = function (success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'cleanFaceMatch', []);
};

