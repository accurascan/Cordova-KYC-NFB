const fs = require('fs');
const os = require('os');
const srcPath = __dirname.replace('scripts', '');
//Code for remove license files from Project root
var srcParentPath = __dirname.replace('plugins\\cordova-kyc-nfb\\scripts', 'platforms\\android');
var fcDestPath = srcParentPath + '\\app\\src\\main\\assets\\accuraface.license';
var lvDestPath = srcParentPath + '\\app\\src\\main\\assets\\accuraactiveliveness.license';
var ocrDestPath = srcParentPath + '\\app\\src\\main\\assets\\key.license';
var gridlePath = srcParentPath + "\\app\\build.gradle";
if (['linux', 'darwin'].indexOf(os.platform()) !== -1) {
    srcParentPath = __dirname.replace('plugins/cordova-kyc-nfb/scripts', 'platforms/android');
    fcDestPath = srcParentPath + '/app/src/main/assets/accuraface.license';
    lvDestPath = srcParentPath + '/app/src/main/assets/accuraactiveliveness.license';
    ocrDestPath = srcParentPath + '/app/src/main/assets/key.license';
    gridlePath = srcParentPath + "/app/build.gradle";
}
try {
    fs.unlinkSync(fcDestPath);
}catch (e) {

}
try {
    fs.unlinkSync(ocrDestPath);
}catch (e) {

}
try {
    fs.unlinkSync(lvDestPath);
}catch (e) {
}

//Code for remove aar file from Project libs directory
var gradle = fs.readFileSync(gridlePath).toString();
if (gradle.indexOf('accura_kyc.aar') !== -1) {
    const lib = 'implementation files(\'libs\\\\accura_kyc.aar\')';
    gradle = gradle.replace(lib, '');
    fs.writeFileSync(gridlePath, gradle);
}
