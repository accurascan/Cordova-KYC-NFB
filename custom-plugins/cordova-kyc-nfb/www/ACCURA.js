var exec = require('cordova/exec');

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

exports.getMetadata = function (success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'getMetadata', []);
};

exports.startMRZ = function (accuraConfigs = {}, type = 'other_mrz', countryList = 'all', success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startMRZ', [accuraConfigs, type, countryList, screen.orientation.type]);
};

exports.startLiveness = function (accuraConfigs = {}, livenessConfigs = {}, success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startLiveness', [accuraConfigs, livenessConfigs, screen.orientation.type]);
};

exports.startFaceMatch = function (accuraConfigs = {}, faceMatchConfigs = {}, success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'startFaceMatch', [accuraConfigs, faceMatchConfigs, screen.orientation.type]);
};

exports.cleanFaceMatch = function (success, error) {
    return execAsPromise(success, error, 'ACCURAService', 'cleanFaceMatch', []);
};

