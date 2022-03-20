document.addEventListener('deviceready', onDeviceReady, false);
//This method will call automatically when device is ready.
document.addEventListener("backbutton", function () {
    if ($('#lv-modal').hasClass('show')) {
        $('#lv-modal').modal('hide');
        return;
    }
    if ($('#fm-modal').hasClass('show')) {
        $('#fm-modal').modal('hide');
        return;
    }
    if ($('#result-modal').hasClass('show')) {
        $('#result-modal').modal('hide');
        return;
    }
    Swal.fire({
        title: 'Do you want to Exit?',
        showCancelButton: true,
        confirmButtonText: `Exit`,
        confirmButtonColor: 'red'
    }).then((result) => {
        if (result.isConfirmed) {
            navigator.app.exitApp();
        }
    });
}, false);
//Create object of accura.
var accura;
var loadingImg = 'data:image/jpeg;base64,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';
var errorImg = 'data:image/jpeg;base64,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';

function onDeviceReady() {

    screen.orientation.lock('portrait');
    $('#orientation-btn').on('click', function () {
        var txt = $('#orientation-btn').text().trim().toLowerCase();
        if (txt.indexOf('landscape') !== -1) {
            screen.orientation.lock('landscape-primary');
            $('#orientation-btn').text("Portrait");
        } else {
            screen.orientation.lock('portrait');
            $('#orientation-btn').text("Landscape");
        }
    });
    window.alert = function (m) {
        Swal.fire({
            title: 'Accura',
            text: m,
            confirmButtonColor: 'red'
        });
    };
    //Init object of Accura services
    accura = cordova.plugins.ACCURAService;
    console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);
    getMetadata();
    $('#fm-modal').on('hide.bs.modal', function () {
        $('#fm-1,#fm-2').attr("src", "img/fm.png");
        $('#fm-standalone-score').text("");
        $('.face-btn').fadeIn();

        accura.cleanFaceMatch(function () {

        }, function () {

        });
    });
    $('#result-modal').on('hide.bs.modal', function () {
        accura.cleanFaceMatch(function () {

        }, function () {

        });
    });
}

var countries = [];
var cards;
var countrySelected = '';
var countrySelectedForCard = '';
var cardSelected = '';
var mrzSelected = 'other_mrz';
var mrzCountryList = 'all';
var barcodeSelected = '';
var language = 'ar';

var countrySelectedId;
var countryCard;
//Code of get license info from SDK
function getMetadata() {
    accura.getMetadata(function (results) {
        console.log(results);
        $('#countries-1, #countries-2, #country-modal .modal-body').empty();
        if (results.isValid) {
            alert('Licence Loaded\n' + results.sdk_version);
            $('#main-div').fadeIn();
            if (results.isMRZ) {
                $('#mrz-div').fadeIn();
            }
        } else {
            alert('Licence is not Loaded');
        }

    }, function (error) {
        alert(error);
    })
}

//Code for liveness check with messages
function startLiveness() {
    // var accuraConfs = { enableLogs: false, with_face: true, face_uri: facematchURI }; or
    var accuraConfs = { enableLogs: false, with_face: true, face_base64: faceMatchBase64 };
    var config = {
        feedbackTextSize: 18,
        feedBackframeMessage: language == 'en' ? 'Frame Your Face' : 'ضع إطارًا لوجهك',
        feedBackAwayMessage: language == 'en' ? 'Move Phone Away' : 'انقل الهاتف بعيدًا',
        feedBackOpenEyesMessage: language == 'en' ? 'Keep Your Eyes Open' : 'أبق أعينك مفتوحة',
        feedBackCloserMessage: language == 'en' ? 'Move Phone Closer' : 'نقل الهاتف أقرب',
        feedBackCenterMessage: language == 'en' ? 'Move Phone Center' : 'نقل مركز الهاتف',
        feedBackMultipleFaceMessage: language == 'en' ? 'Multiple Face Detected' : 'تم اكتشاف وجوه متعددة',
        feedBackHeadStraightMessage: language == 'en' ? 'Keep Your Head Straight' : 'حافظ على استقامة رأسك',
        feedBackBlurFaceMessage: language == 'en' ? 'Blur Detected Over Face' : 'تم اكتشاف ضبابية على الوجه',
        feedBackGlareFaceMessage: language == 'en' ? 'Glare Detected' : 'تم الكشف عن الوهج',
        // <!--// 0 for clean face and 100 for Blurry face or set it -1 to remove blur filter-->
        setBlurPercentage: 80,
        // <!--// Set min percentage for glare or set it -1 to remove glare filter-->
        setGlarePercentage_0: -1,
        // <!--// Set max percentage for glare or set it -1 to remove glare filter-->
        setGlarePercentage_1: -1,
        isSaveImage: true,
        liveness_url: 'Your liveness url',

        //        New SDK changes in configs
        feedBackLowLightMessage: language == 'en' ? 'Low light detected' : 'تم الكشف عن إضاءة منخفضة',
        feedbackLowLightTolerence: 39,
        feedBackStartMessage: language == 'en' ? 'Put your face inside the oval' : 'ضع وجهك داخل الشكل البيضاوي',
        feedBackLookLeftMessage: language == 'en' ? 'Look over your left shoulder' : 'انظر فوق كتفك الأيسر',
        feedBackLookRightMessage: language == 'en' ? 'Look over your right shoulder' : 'انظر فوق كتفك الأيمن',
        feedBackOralInfoMessage: language == 'en' ? 'Say each digits out loud' : 'قل كل رقم بصوت عالٍ',
        feedBackProcessingMessage: language == 'en' ? 'Processing...' : 'يعالج...',
        enableOralVerification: false,
        codeTextColor: 'white',
        isShowLogo: false
    };
    $('#ls-score,#fm-score').text("0.00 %");
    accura.startLiveness(accuraConfs, config, function (result) {
        console.log(result);
        if (result.hasOwnProperty('status')) {
            if (result.status) {
                if (result.with_face) {
                    $('#score-div').fadeIn('fast', function () {
                        $('#score-div').css('display', 'flex');
                    });
                    $('#ls-score').text(Number(result.score).toFixed(2) + ' %');
                    if (result.hasOwnProperty('detect')) {
                        $('#detect-face').fadeIn();
                        getImage('detect-face', result.detect);
                        $('#face-div').addClass('justify-content-between');
                    }
                    if (result.hasOwnProperty('fm_score')) {
                        $('#fm-score').text(Number(result.fm_score).toFixed(2) + ' %');
                    }
                    return;
                }
                var html = '<h4>Liveness Results</h4>';
                if (result.hasOwnProperty('image_uri')) {
                    window.resolveLocalFileSystemURL(result.image_uri, function (fileEntry) {
                        fileEntry.file(function (file) {
                            var reader = new FileReader();
                            reader.onloadend = function () {
                                $('#live_img_div').empty().append(
                                    '<h3>Liveness Image: </h3><img src="' + this.result + '" class="img-fluid">'
                                )
                                $('#live_image').attr("src", this.result);
                            };

                            reader.onerror = function () {
                                $('#live_img_div').remove();
                            }

                            reader.readAsDataURL(file);

                        }, function () {
                            $('#live_img_div').remove();
                        });
                    }, function () {
                        $('#live_img_div').remove();
                    });
                    html += '<div id="live_img_div"><h3>Liveness Image: </h3><img id="live_image" src="' + loadingImg + '"></div>'
                }
                if (result.hasOwnProperty('video_uri')) {
                    video_uri = result.video_uri;
                    html += '<div id="live_video" class="w-100">' + '<h3>Live Video: </h3>' +
                        '<button onclick="openVideoForPlay()" class="btn btn-rose">Play Live Video</button>' + '</div>'
                } else {
                    video_uri = undefined;
                }
                html += '<h5>Liveness Score: ' + Number(result.score).toFixed(2) + ' %</h5>';
                $('#lv-modal .modal-body').empty().append(
                    html
                );
                $('#lv-modal').modal();
            }
        }
        console.log(result);
    }, function (error) {
        alert(error);
    });
}

var video_uri;

function openVideoForPlay() {
    if (video_uri === undefined) {
        alert("Video not found");
        return
    }
    var options = {
        errorCallback: function (errMsg) {
            alert(errMsg);
        },
        shouldAutoClose: true,  // true(default)/false
        controls: true // true(default)/false. Used to hide controls on fullscreen
    };
    window.plugins.streamingMedia.playVideo(video_uri, options);
}

var facematchURI;
var faceMatchBase64;
// Code for face match with messages.
function startFaceMatch(withFace = false, face1 = false, face2 = false) {
    // var accuraConfs = { with_face: withFace, face_uri: facematchURI, enableLogs: false };
    var accuraConfs = { with_face: withFace, face_base64: faceMatchBase64, enableLogs: false };
    if (!withFace) { delete accuraConfs.face_uri; }
    if (face1) { face2 = false; }
    if (face2) { face1 = false; }
    accuraConfs.face1 = face1;
    accuraConfs.face2 = face2;
    var config = {
        feedbackTextSize: 18,
        feedBackLowLightMessage: language == 'en' ? 'Low light detected' : 'تم الكشف عن إضاءة منخفضة',
        feedBackStartMessage: language == 'en' ? 'Put your face inside the oval' : 'ضع وجهك داخل الشكل البيضاوي',
        feedBackframeMessage: language == 'en' ?  'Frame Your Face' : 'ضع إطارًا لوجهك',
        feedBackAwayMessage: language == 'en' ?  'Move Phone Away' : 'انقل الهاتف بعيدًا',
        feedBackOpenEyesMessage: language == 'en' ?  'Keep Your Eyes Open' : 'أبق أعينك مفتوحة',
        feedBackCloserMessage: language == 'en' ?  'Move Phone Closer' : 'نقل الهاتف أقرب',
        feedBackCenterMessage: language == 'en' ?  'Move Phone Center' : 'نقل مركز الهاتف',
        feedBackMultipleFaceMessage: language == 'en' ?  'Multiple Face Detected' : 'تم اكتشاف وجوه متعددة',
        feedBackHeadStraightMessage: language == 'en' ?  'Keep Your Head Straight' : 'حافظ على استقامة رأسك',
        feedBackBlurFaceMessage: language == 'en' ?  'Blur Detected Over Face' : 'تم اكتشاف ضبابية على الوجه',
        feedBackGlareFaceMessage: language == 'en' ?  'Glare Detected' : 'تم الكشف عن الوهج',
        feedBackProcessingMessage: language == 'en' ? 'Processing...' : 'يعالج...',
        // <!--// 0 for clean face and 100 for Blurry face or set it -1 to remove blur filter-->
        setBlurPercentage: 80,
        // <!--// Set min percentage for glare or set it -1 to remove glare filter-->
        setGlarePercentage_0: -1,
        // <!--// Set max percentage for glare or set it -1 to remove glare filter-->
        setGlarePercentage_1: -1,
        isShowLogo: false,
    };
    $('#ls-score,#fm-score').text("0.00 %");
    accura.startFaceMatch(accuraConfs, config, function (result) {
        console.log(result);
        if (result.hasOwnProperty('status')) {
            if (result.status) {
                // alert("Face Match: " + result.score);
                if (result.with_face) {
                    $('#fm-score').text(Number(result.score).toFixed(2) + ' %');
                    $('#face-div').addClass('justify-content-between');
                    $('#detect-face').fadeIn();
                    getImage('detect-face', result.detect);
                    $('#score-div').fadeIn('fast', function () {
                        $('#score-div').css('display', 'flex');
                    });
                    return;
                }
                if (result.hasOwnProperty('score')) {
                    $('#fm-standalone-score').text('Face Match: ' + Number(result.score).toFixed(2) + ' %');
                } else {
                    $('#fm-standalone-score').text('0.0 %');
                }
                $('.face-btn').fadeOut();
                $('#fm-2, #fm-1').attr("src", loadingImg);
                getImage('fm-1', result.img_1);
                getImage('fm-2', result.img_2);
            } else {
                if (result.hasOwnProperty('img_1')) {
                    $('#fm-1').attr("src", loadingImg);
                    getImage('fm-1', result.img_1);
                }
            }
        }
    }, function (error) {
        $('#fm-modal').modal('hide');
        alert(error);
    });
}

//Code for scan MRZ documents with scanning messages.
function startMRZ() {
    
    var config = {
        ACCURA_ERROR_CODE_MOTION: language == 'en' ? 'Keep Document Steady' : 'حافظ على ثبات المستند',
        ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME: language == 'en' ? 'Keep document in frame' : 'احتفظ بالمستند في الإطار',
        ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME: language == 'en' ?  'Bring card near to frame' : 'إحضار البطاقة بالقرب من الإطار',
        ACCURA_ERROR_CODE_PROCESSING: language == 'en' ?  'Processing…' : 'يعالج…',
        ACCURA_ERROR_CODE_BLUR_DOCUMENT: language == 'en' ?  'Blur detect in document' : 'كشف التمويه في المستند',
        ACCURA_ERROR_CODE_FACE_BLUR: language == 'en' ?  'Blur detected over face' : 'تم الكشف عن ضبابية على الوجه',
        ACCURA_ERROR_CODE_GLARE_DOCUMENT: language == 'en' ?  'Glare detect in document' : 'كشف الوهج في المستند',
        ACCURA_ERROR_CODE_HOLOGRAM: language == 'en' ?  'Hologram Detected' : 'تم الكشف عن صورة ثلاثية الأبعاد', 
        ACCURA_ERROR_CODE_DARK_DOCUMENT: language == 'en' ?  'Low lighting detected' : 'تم الكشف عن إضاءة منخفضة',
        ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT: language == 'en' ?  'Can not accept Photo Copy Document' : 'لا يمكن قبول مستند نسخ الصور',
        ACCURA_ERROR_CODE_FACE: language == 'en' ?  'Face not detected' : 'لم يتم الكشف عن الوجه',
        ACCURA_ERROR_CODE_MRZ: language == 'en' ?  'MRZ not detected' : 'لم يتم الكشف عن MRZ',
        ACCURA_ERROR_CODE_PASSPORT_MRZ: language == 'en' ?  'Passport MRZ not detected' : 'لم يتم الكشف عن MRZ جواز سفر',
        ACCURA_ERROR_CODE_ID_MRZ: language == 'en' ?  'ID card MRZ not detected' : 'لم يتم الكشف عن بطاقة الهوية MRZ',
        ACCURA_ERROR_CODE_VISA_MRZ: language == 'en' ?  'Visa MRZ not detected' : 'لم يتم الكشف عن Visa MRZ',
        ACCURA_ERROR_CODE_WRONG_SIDE: language == 'en' ?  'Scanning wrong side of document' : 'مسح الجانب الخطأ من المستند',
        ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE: language == 'en' ?  'Document is upside down. Place it properly' : 'المستند مقلوب. ضعه بشكل صحيح',
    
        IS_SHOW_LOGO: true,
        SCAN_TITLE_MRZ_PDF417_FRONT: language == 'en' ?  'Scan Front Side of Document' : 'مسح الوجه الأمامي للمستند',
        SCAN_TITLE_MRZ_PDF417_BACK: language == 'en' ?  'Now Scan Back Side of Document' : 'الآن مسح الجانب الخلفي من المستند',
    };
    accura.startMRZ({ enableLogs: false }, config, mrzSelected, mrzCountryList, function (result) {
        generateResult(result);
    }, function (error) {
        alert(error);
    });
}
//Code for get key title
function getMRZLable(key) {

    var lableText = "";
    switch (key) {
        case "placeOfBirth":
            lableText += "Place Of Birth";
            break;
        case "retval":
            lableText += "Retval";
            break;
        case "givenNames":
            lableText += "First Name";
            break;
        case "country":
            lableText += "Country";
            break;
        case "surName":
            lableText += "Last Name";
            break;
        case "expirationDate":
            lableText += "Date of Expiry";
            break;
        case "passportType":
            lableText += "Document Type";
            break;
        case "personalNumber":
            lableText += "Other ID";
            break;
        case "correctBirthChecksum":
            lableText += "Correct Birth Check No.";
            break;
        case "correctSecondrowChecksum":
            lableText += "Correct Second Row Check No.";
            break;
        case "personalNumberChecksum":
            lableText += "Other Id Check No.";
            break;
        case "secondRowChecksum":
            lableText += "Second Row Check No.";
            break;
        case "expirationDateChecksum":
            lableText += "Expiration Check No.";
            break;
        case "correctPersonalChecksum":
            lableText += "Correct Document check No.";
            break;
        case "passportNumber":
            lableText += "Document No.";
            break;
        case "correctExpirationChecksum":
            lableText += "Correct Expiration Check No.";
            break;
        case "sex":
            lableText += "Sex";
            break;
        case "birth":
            lableText += "Date Of Birth";
            break;
        case "birthChecksum":
            lableText += "Birth Check No.";
            break;
        case "personalNumber2":
            lableText += "Other ID2";
            break;
        case "correctPassportChecksum":
            lableText += "Correct Document check No.";
            break;
        case "placeOfIssue":
            lableText += "Place Of Issue";
            break;
        case "nationality":
            lableText += "Nationality";
            break;
        case "passportNumberChecksum":
            lableText += "Document check No.";
            break;
        case "issueDate":
            lableText += "Date Of Issue";
            break;
        case "departmentNumber":
            lableText += "Department No.";
            break;
        default:
            lableText += "";
            break;
    }
    return lableText;
}

//Code for scan result popup.
function generateResult(result) {
    console.log("result:- ", result)
    var html = "";
    var sides = ["front_data", "back_data"];
    if (result.hasOwnProperty("face")) {
        console.log("result result.hasOwnProperty('face')")
        html +=
            "<div id='face-div' class='d-flex justify-content-center'>" +
            "   <img id='face' src='" + loadingImg + "' class='img-fluid' style='max-height: 120px'>" +
            "   <img id='detect-face' src='" + loadingImg + "' class='img-fluid' style='display: none;max-height: 120px'>" +
            "</div>" +
            "<div class='d-flex justify-content-center'>" +
            "   <button onclick='startLiveness(true)' id='check-ls' style='display: none' class='btn-rose btn btn-sm'>" +
            "       <div class='d-flex justify-content-center'>" +
            "           <img style='height: 22px' class='mr-1' src='./img/ic_liveness.png'>" +
            "           <h5 class='m-0'>LIVENESS</h5>" +
            "       </div>" +
            "   </button>" +
            "   <button onclick='startFaceMatch(true)' id='check-ls' style='display: none' class='btn-rose btn btn-sm'>" +
            "       <div class='d-flex justify-content-center'>" +
            "           <img style='margin-top:2px;height: 22px' class='mr-1' src='./img/ic_biometric.png'>" +
            "           <h5 class='m-0'>FACE MATCH</h5>" +
            "       </div>" +
            "   </button>" +
            "</div>" +
            "<div id='score-div' style='display: none' class='justify-content-center justify-content-between'>" +
            "   <h5 id='ls-score'>0.00 %</h5>" +
            "   <h5 id='fm-score'>0.00 %</h5>" +
            "</div>";
        facematchURI = result.face;
        faceMatchBase64 = result.face_base64;
        getImage('face', result.face, true);
    }
    sides.forEach(function (side, i) {
        if (result.hasOwnProperty(side)) {
            if (Object.keys(result[side]).length > 0) {
                if (i === 0) {
                    switch (result.type) {
                        case "BANKCARD":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>Bank Card Data</h4>";
                            break;
                        case "DL_PLATE":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>Vehicle Plate</h4>";
                            break;
                        case "BARCODE":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>Barcode Data</h4>";
                            break;
                        case "PDF417":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>PDF417 Barcode</h4>";
                            break;
                        case "OCR":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>OCR Front</h4>";
                            break;
                        case "MRZ":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>MRZ</h4>";
                            break;
                        case "BARCODEPDF417":
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>USA DL Result</h4>";
                            break;
                        default:
                            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>Front Side</h4>";
                            break;
                    }

                } else {
                    html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>OCR Back</h4>";
                }
                var table = '<table id="result-table" class="table table-responsive">' +
                    '                    <thead></thead><tbody>';
                var width = $(window).width();
                var tdLen1 = Math.round(0.35 * width);
                var tdLen2 = Math.round(0.55 * width);


                Object.keys(result[side]).forEach(function (key) {
                    if (key !== "PDF417") {
                        if (["signature", "front_img", "back_img"].toString().indexOf(key) === -1) {
                            if ( result[side][key] !== null && result[side][key] !== undefined && result[side][key].toString().includes("<")) {
                                table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result[side][key].toString().replace(/</g, '&lt') + "</pre></td></tr>";
                            } else {
                                if (result.type == "MRZ") {
                                    
                                    table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + getMRZLable(key) + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result[side][key] + "</td></tr>";
                                    
                                } else {
                                    
                                    table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result[side][key] + "</td></tr>";
                                }
                            }
                        } else if (key === "signature") {
                            table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;'>" + key + "</td><td><img id='signature_" + side + "' src='" + loadingImg + "' class='img-fluid'></td></tr>";
                            getImage('signature_' + side, result[side][key]);
                        }
                    }
                });
                var key = "PDF417";
                if (result[side].hasOwnProperty(key)) {

                    table += "<tr style='background: lightgrey' class='p-2 font-weight-bold'><td style='max-width: " + tdLen1 + "px;'>PDF417 Barcode</td><td></td></tr>";
                    if (result[side][key].toString().toString().indexOf("<") !== -1) {
                        table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result[side][key].toString().replace(/</g, '&lt') + "</pre></td></tr>";
                    } else {
                        table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result[side][key] + "</td></tr>";
                    }
                }
                table += '</tbody></table>';
                html += table;
            }
        }
    });
    if (result.hasOwnProperty('mrz_data')) {
        var keys = Object.keys(result.mrz_data);
        if (keys.length > 0) {
            html += "<h4 class='p-2 font-weight-bold' style='background: lightgrey'>MRZ</h4>";
            var table = '<table id="mrz-table" class="table table-responsive">' +
                '                    <thead></thead><tbody>';
            var width = $(window).width();
            var tdLen1 = Math.round(0.35 * width);
            var tdLen2 = Math.round(0.55 * width);
            if (result.mrz_data.hasOwnProperty("MRZ")) {
                if (result.mrz_data.MRZ.toString().indexOf("<") !== -1) {
                    table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>MRZ</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data.MRZ.toString().replace(/</g, '&lt') + "</pre></td></tr>";
                } else {
                    table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>MRZ</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data.MRZ + "</td></tr>";
                }
            }
            keys.forEach(function (key) {
                if (key !== "MRZ") {
                   if (result.mrz_data[key].toString().indexOf("<") !== -1) {
                       table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data[key].toString().replace(/</g, '&lt') + "</pre></td></tr>";
                   } else {
                       table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data[key] + "</td></tr>";
                   }
                }
            });
            table += '</tbody></table>';
            html += table;
        }
    }
    if (result.hasOwnProperty("front_img")) {
        html += "<div class='mt-3 d-flex align-items-center'><h4 class='p-2 font-weight-bold' style='background: lightgrey'>FRONT SIDE</h4></div><img id='front-image' src='" + loadingImg + "' class='img-fluid'>";
        getImage('front-image', result.front_img, true);
    }
    if (result.hasOwnProperty("back_img")) {
        html += "<div class='p-2 mt-3 d-flex align-items-center bg-rose'><h4 class='p-2 font-weight-bold' style='background: lightgrey'>BACK SIDE</h4></div><img id='back-image' src='" + loadingImg + "' class='img-fluid'>";
        getImage('back-image', result.back_img, true);
    }
    $('#result-modal .modal-body').empty().append(html);
    $('#result-modal').modal();
}

//Code for get image from local image URL.
function getImage(id, uri, isFm = false) {

    console.log("getImage(id, uri, isFm = false):- ", id, " URI:- ", uri, "isFm:- ", isFm)
    console.log("device.platform:- ", device.platform)
    if (device.platform == 'iOS') {
        segments = uri.split("/");
        fileName = segments[segments.length - 1];
        console.log("fileName:- ", fileName)
        console.log("device.platform == 'iOS'")

        resolveLocalFileSystemURL(
            uri,
            dirEntry => {
                console.log("dirEntry:- ", dirEntry);
                //create the permanent folder
            dirEntry.file(function (file) {
                    console.log("fileEntry.file:- ", file)
                    var reader = new FileReader();
                    reader.onloadend = function () {
                        console.log("reader.onloadend")
                        $('#' + id).attr("src", this.result);
                        if (isFm) {
                            $('#check-ls, #check-fm').fadeIn();
                        }
                    };

                    reader.onerror = function () {
                        console.log("reader.onerror")
                        $('#' + id).attr("src", errorImg);
                        if (isFm) {
                            $('#check-ls, #check-fm').fadeOut();
                        }
                    }
                    console.log("reader.readAsDataURL(file)", file)
                    reader.readAsDataURL(file);

                }, function () {
                    console.log("fileEntry.file FAIL")
                    $('#' + id).attr("src", errorImg);
                    if (isFm) {
                        $('#check-ls, #check-fm').fadeOut();
                    }
                });
            },
            err => {
                console.log("window.resolveLocalFileSystemURL FAIL", error)
                $('#' + id).attr("src", errorImg);
                if (isFm) {
                    $('#check-ls, #check-fm').fadeOut();
                }
            }
        );
        
    } else {

        console.log("device.platform != 'iOS'")
        window.resolveLocalFileSystemURL(uri, function (fileEntry) {
            console.log("window.resolveLocalFileSystemURL:- ", fileEntry)
            fileEntry.file(function (file) {
                console.log("fileEntry.file:- ", file)
                var reader = new FileReader();
                reader.onloadend = function () {
                    console.log("reader.onloadend")
                    $('#' + id).attr("src", this.result);
                    if (isFm) {
                        $('#check-ls, #check-fm').fadeIn();
                    }
                };

                reader.onerror = function () {
                    console.log("reader.onerror")
                    $('#' + id).attr("src", errorImg);
                    if (isFm) {
                        $('#check-ls, #check-fm').fadeOut();
                    }
                }
                console.log("reader.readAsDataURL(file)", file)
                reader.readAsDataURL(file);

            }, function () {
                console.log("fileEntry.file FAIL")
                $('#' + id).attr("src", errorImg);
                if (isFm) {
                    $('#check-ls, #check-fm').fadeOut();
                }
            });
        }, function (error) {
            console.log("window.resolveLocalFileSystemURL FAIL", error)
            $('#' + id).attr("src", errorImg);
            if (isFm) {
                $('#check-ls, #check-fm').fadeOut();
            }
        });
    }
}


