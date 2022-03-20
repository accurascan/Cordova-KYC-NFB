const fs = require('fs');
const os = require('os');
const srcPath = __dirname.replace('scripts', '');
//Code for copy license files into Project root
var srcParentPath = __dirname.replace('plugins\\cordova-kyc-nfb\\scripts', 'platforms\\android');
var fcPath = srcPath + 'src\\android\\accuraface.license';
var lvPath = srcPath + 'src\\android\\accuraactiveliveness.license';
var ocrPath = srcPath + 'src\\android\\key.license';
var fcDestPath = srcParentPath + '\\app\\src\\main\\assets\\accuraface.license';
var lvDestPath = srcParentPath + '\\app\\src\\main\\assets\\accuraactiveliveness.license';
var ocrDestPath = srcParentPath + '\\app\\src\\main\\assets\\key.license';
var gridlePath = srcParentPath + "\\app\\build.gradle";
if (['linux', 'darwin'].indexOf(os.platform()) !== -1) {
    srcParentPath = __dirname.replace('plugins/cordova-kyc-nfb/scripts', 'platforms/android');
    fcPath = srcPath + 'src/android/accuraface.license';
    lvPath = srcPath + 'src/android/accuraactiveliveness.license';
    ocrPath = srcPath + 'src/android/key.license';
    fcDestPath = srcParentPath + '/app/src/main/assets/accuraface.license';
    lvDestPath = srcParentPath + '/app/src/main/assets/accuraactiveliveness.license';
    ocrDestPath = srcParentPath + '/app/src/main/assets/key.license';
    gridlePath = srcParentPath + "/app/build.gradle";
}

fs.copyFileSync(fcPath, fcDestPath);
fs.copyFileSync(lvPath, lvDestPath);
fs.copyFileSync(ocrPath, ocrDestPath);

//Code for copy aar file into Project libs directory.
var gradle = fs.readFileSync(gridlePath).toString();
if (gradle.indexOf('accura_kyc.aar') === -1) {
    const lib = 'implementation files(\'libs\\\\accura_kyc.aar\')\n';
    const indexForDep = gradle.indexOf('// SUB-PROJECT DEPENDENCIES START\n');
    const firstPart = gradle.substr(0, indexForDep);
    const lastPart = gradle.substr(indexForDep);
    fs.writeFileSync(gridlePath, firstPart + lib + lastPart)
}
