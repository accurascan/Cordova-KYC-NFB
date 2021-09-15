Accura Cordova Plugin

cordova-kyc-nfb

# Product Installation
Note: It is assumed that the developer already has a cordova application.
## Add iOS plugin
$ `cordova plugin add <absolute-path-to-(cordova-kyc-nfb)-folder>`
### Example
`cordova plugin add /Users/apple/documents/accura-cordova/custom-plugins/cordova-kyc-nfb`

#### - Replace `AccuraKYC.framework` framework file path in plugin.xml file for change iOS library
    1. Without simulator library(only for device) size: 295Mb (Check size)
        - Open file from custom-plugins -> cordova-kyc-nfb -> plugin.xml
        - Uncomment line no 107 and comment line no 110
        

    2. With simulator support library(device + simulator both) size: 360Mb (Check size)
        - Open file from custom-plugins -> cordova-kyc-nfb -> plugin.xml
        - Uncomment line no 110 and comment line no 107
#### NOTE:- 
 - Default it has without simulator library.
 - When you change the library every time you have to first remove the plugin and then add it again.
    
<!-- How to release both support on github in one SDK.

1. Use `AccuraKYC.framework` file without simulator in project. so it'll make the Cordova sdk light in size.
2. `AccuraKYC.framework` file with simulator add in assets of github release. So other dev can use as per their requirement. 

one thing keep in mind. When we will release Cordova sdk with new update. Create release for that and attach same version of Simulator support framework file in release assets. -->
<!-- ### Options for iOS Library
Here you have two options for iOS that which library you want to use for this plugin.
- Library with  -->
## Add dependencies
`$ cordova plugin add cordova-plugin-file`
## Permissions
- Camera Access Permission in iOS (this plugin will require it and take care of permission in the plist file of the project)
# Cordova Configurations
### AccuraConfigrations:  JSON Object

|Option|Type|Default|Description|
| :- | :- | :- | :- |
|enableLogs|boolean|false|<p>if true logs will be enabled for the app.</p><p><br>make sure to disable logs in release mode</p>|
|with_face|boolean|false|need when using liveness or face match after ocr|
|face_uri|URI Sting|undefined|Required when with_face = true|
|face1|boolean|false|need when using facematch with “with_face = false”<br><br>For Face1 set it to TRUE|
|face2|boolean|false|<p>need when using facematch with “with_face = false”</p><p>For Face2 set it to TRUE</p>|
|rg_setBlurPercentage|integer|62|0 for clean document and 100 for Blurry document|
|rg_setFaceBlurPercentage|integer|70|0 for clean face and 100 for Blurry face|
|rg_setGlarePercentage_0|integer|6|Set min percentage for glare|
|rg_setGlarePercentage_1|integer|98|Set max percentage for glare|
|rg_isCheckPhotoCopy|boolean|false|Set Photo Copy to allow photocopy document or not|
|rg_SetHologramDetection|boolean|true|<p>Set Hologram detection to verify the hologram on the face</p><p></p><p>true to check hologram on face</p><p></p><p></p>|
|rg_setLowLightTolerance|integer|39|Set light tolerance to detect light on document|
|rg_setMotionThreshold|integer|18|<p>Set motion threshold to detect motion on camera document</p><p></p><p>1 - allows 1% motion on document and</p><p></p><p>100 - it can not detect motion and allow documents to scan.</p><p></p><p></p>|
|rg_setMinFrameForValidate|integer|3|<p>Set min frame for qatar ID card for Most validated data. minFrame supports only odd numbers like 3,5...</p><p></p><p></p>|
|rg_setCameraFacing|integer|0|To set the front or back camera. allows 0,1|
|rg_setBackSide|boolean|false|set true to use backside|
|rg_setEnableMediaPlayer|boolean|true|false to disable default sound and default it is true|
|rg_customMediaURL|string|null|if given a valid URL it will download the file and use it as an alert sound.|
|SCAN_TITLE_OCR_FRONT|string|Scan Front Side of %s||
|SCAN_TITLE_OCR_BACK|string|Scan Back Side of %s||
|SCAN_TITLE_OCR|string|Scan %s||
|SCAN_TITLE_BANKCARD|string|Scan Bank Card||
|SCAN_TITLE_BARCODE|string|Scan Barcode||
|SCAN_TITLE_MRZ_PDF417_FRONT|string|Scan Front Side of Document||
|SCAN_TITLE_MRZ_PDF417_BACK|string|Now Scan Back Side of Document||
|SCAN_TITLE_DLPLATE|string|Scan Number Plate||
|ACCURA_ERROR_CODE_MOTION|string|Keep Document Steady||
|ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME|string|Keep document in frame||
|ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME|string|Bring card near to frame.||
|ACCURA_ERROR_CODE_PROCESSING|string|Processing…||
|ACCURA_ERROR_CODE_BLUR_DOCUMENT|string|Blur detect in document||
|ACCURA_ERROR_CODE_FACE_BLUR|string|Blur detected over face||
|ACCURA_ERROR_CODE_GLARE_DOCUMENT|string|Glare detect in document||
|ACCURA_ERROR_CODE_HOLOGRAM|string|Hologram Detected||
|ACCURA_ERROR_CODE_DARK_DOCUMENT|string|Low lighting detected||
|ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT|string|Can not accept Photo Copy Document||
|ACCURA_ERROR_CODE_FACE|string|Face not detected||
|ACCURA_ERROR_CODE_MRZ|string|MRZ not detected||
|ACCURA_ERROR_CODE_PASSPORT_MRZ|string|Passport MRZ not detected||
|ACCURA_ERROR_CODE_ID_MRZ|string|ID card MRZ not detected||
|ACCURA_ERROR_CODE_VISA_MRZ|string|Visa MRZ not detected||
|ACCURA_ERROR_CODE_WRONG_SIDE|string|Scanning wrong side of document||
|ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE|string|Document is upside down. Place it properly||
###
### Liveness Configurations:  JSON Object

Contact AccuraScan at contact@accurascan.com for Liveness SDK or API

|Option|Type|Default|Description|
| :- | :- | :- | :- |
|feedbackTextSize|integer|18||
|feedBackframeMessage|string|Frame Your Face||
|feedBackAwayMessage|string|Move Phone Away||
|feedBackOpenEyesMessage|string|Keep Your Eyes Open||
|feedBackCloserMessage|string|Move Phone Closer||
|feedBackCenterMessage|string|Move Phone Center||
|feedBackMultipleFaceMessage|string|Multiple Face Detected||
|feedBackHeadStraightMessage|string|Keep Your Head Straight||
|feedBackBlurFaceMessage|string|Blur Detected Over Face||
|feedBackGlareFaceMessage|string|Glare Detected||
|feedBackVideoRecordingMessage|string|Processing…||
|setBlurPercentage|integer|80|0 for clean face and 100 for Blurry face or set it -1 to remove blur filter|
|setGlarePercentage_0|integer|-1|Set min percentage for glare or set it -1 to remove glare filter|
|setGlarePercentage_1|integer|-1|Set max percentage for glare or set it -1 to remove glare filter|
|isSaveImage|boolean|true||
|isRecordVideo|boolean|true||
|videoLengthInSecond|integer|5||
|recordingTimerTextSize|integer|45||
|recordingMessage|string|Scanning your face be steady||
|recordingMessageTextSize|integer|18||
|enableFaceDetect|boolean|true||
|enableFaceMatch|boolean|true||
|fmScoreThreshold|integer|50||
|feedbackFMFailed|string|Face not matched||
|liveness_url|URL string|Your liveness url||
|livenessBackground|color string|#FFC4C4C5||
|livenessCloseIcon|color string|#FF000000||
|livenessfeedbackBg|color string|#00000000||
|livenessfeedbackText|color string|#FF000000||
|livenessRecordingTextColor|color string|#555555||
|livenessRecordingTimerTextColor|color string|#555555||
###
### Face Match Configurations:  JSON Object

|Option|Type|Default|Description|
| :- | :- | :- | :- |
|fm_feedbackTextSize|integer|18||
|fm_feedBackframeMessage|string|Frame Your Face||
|fm_feedBackAwayMessage|string|Move Phone Away||
|fm_feedBackOpenEyesMessage|string|Keep Your Eyes Open||
|fm_feedBackCloserMessage|string|Move Phone Closer||
|fm_feedBackCenterMessage|string|Move Phone Center||
|fm_feedBackMultipleFaceMessage|string|Multiple Face Detected||
|fm_feedBackHeadStraightMessage|string|Keep Your Head Straight||
|fm_feedBackBlurFaceMessage|string|Blur Detected Over Face||
|fm_feedBackGlareFaceMessage|string|Glare Detected||
|fm_setBlurPercentage|integer|80|0 for clean face and 100 for Blurry face or set it -1 to remove blur filter|
|fm_setGlarePercentage_0|integer|-1|Set min percentage for glare or set it -1 to remove glare filter|
|fm_setGlarePercentage_1|integer|-1|Set max percentage for glare or set it -1 to remove glare filter|
|backGroundColor|color string|#FFC4C4C5||
|closeIconColor|color string|#FF000000||
|feedbackBackGroundColor|color string|#00000000||
|feedbackTextColor|color string|#FF000000||





### CountryModels: 
- type: JSON Array
- contents: CardItems
- properties: 
  - id: integer
  - name: string
  - Cards: JSON Array<Card Items>
###  	 CardItems:
- type: JSON Array
- contents: JSON Objects
- properties: 
  - id: integer
  - name: string
  - type: integer
###  	 BarcodeItems:
- type: JSON Array
- contents: JSON Objects
- properties: 
  - name: string
  - type: integer
###  		 Recognition Types: 
- MRZ
- OCR
- PDF417
- BARCODE
- DL_PLATE


###  	 Mrz Types:
- passport_mrz
- id_mrz
- visa_mrz
- other_mrz

# Cordova Methods
- ### getMetadata(successCallback, errorCallback)
  - Success: JSON Response = {

 	 countries: Array[<CountryModels<CardItems>>],

 	 barcodes: Array[<BarcodeItems>],

 	 isValid: boolean,

 	 isOCREnable: boolean,

 	 isBarcode: boolean,

 	 isBankCard: boolean,

 	 isMRZ: boolean,

 	 sdk_version: String

}

  - Error: String<Any Error Message>
  
  
- ### startMRZ(accuraConfigrations?, MRZType, successCallback, errorCallback)
  - MRZType: String 
    - default: other_mrz
  - Success: JSON Response {

 	 front_data: JSONObjects?,

 	 back_data: JSONObjects?,

 	 type: Recognition Type,

 	 face: URI?

 	 front_img: URI?

 	 back_img: URI?

}

  - Error: String<Any Error Message>
  
  
- ### startOcrWithCard(accuraConfigrations?,countryID, cardID, cardName,successCallback, errorCallback)
  - countryID: Integer
    - allowed: CountryModel<country_id>
  - cardID: Integer
    - allowed: CardItem<card_id>
  - cardName: CardItem<card_name>
  - Success: JSON Response {

 	 front_data: JSONObjects?,

 	 back_data: JSONObjects?,

 	 mrz_data: JSONObjects?,

 	 type: Recognition Type,

 	 face: URI?

 	 front_img: URI?

 	 back_img: URI?

}

  - Error: String<Any Error Message>
  
  

- ### startBankCard(accuraConfigrations?, successCallback, errorCallback)
  - Success: JSON Response {

 	 front_data: JSONObjects?,

 	 back_data: JSONObjects?,

 	 type: Recognition Type,

 	 face: URI?

 	 front_img: URI?

 	 back_img: URI?

}

  - Error: String<Any Error Message>
  
  
- ### startBarcode(accuraConfigrations?, type, successCallback, errorCallback)
  - type: BarcodeItem<type>
  - Success: JSON Response {

 	 front_data: JSONObjects?,

 	 back_data: JSONObjects?,

 	 type: Recognition Type,

 	 face: URI?

 	 front_img: URI?

 	 back_img: URI?

}

  - Error: String<Any Error Message>



- ### startLiveness(accuraConfigrations?, livenessConfigs, successCallback, errorCallback)
  - livenessConfigs: JSONObject?
  - Success: JSON Response {

 	 with_face: Boolean,

 	 status: Boolean,

 	 detect: URI?,

 	 image_uri: URI?,

 	 video_uri: URI?,

 	 fm_score: Float? (when with_face = true),

 	 score: Float,

}

  - Error: String<Any Error Message>



- ### startFaceMatch(accuraConfigrations?, faceMatchConfigs, successCallback, errorCallback)
  - faceMatchConfigs:  JSON Object?
  - Success: JSON Response {

 	 with_face: Boolean,

 	 status: Boolean,

 	 detect: URI? (when with_face = true),

 	 img_1: URI? (when with_face = false),

 	 img_2: URI? (when with_face = false),

 	 score: Float

}

  - Error: String<Any Error Message>







# Usage
Plugin access in Javascript

`cordova.plugins.ACCURAService`

In your cordova javascript event get plugin

```js
document.addEventListener('deviceready', onDeviceReady, false);

var accura;

function onDeviceReady() {

     // Cordova is now initialized.

     accura = cordova.plugins.ACCURAService;

}
```





# Usage Example 
navigate into cordova/www directory
1. ## html(index.html)
   
 ```
 <!DOCTYPE html>

    <html>
    
    <head>
    
    <meta charset="utf-8">
    
    <meta name="format-detection" content="telephone=no">
    
    <meta name="msapplication-tap-highlight" content="no">
    
    <meta name="viewport" content="initial-scale=1, width=device-width, viewport-fit=cover">
    
    <meta name="color-scheme" content="light dark">
    
    <link rel="stylesheet" href="css/index.css">
    
    <link rel="stylesheet" href="css/material-kit.css">
    
    <title>Accura KYC</title>
    
    </head>
    
    <body style="background: white;overflow: hidden">
```



### Add Navbar 
```
    <div class="p-3 d-flex bg-danger justify-content-center justify-content-between">

     <h4 class="m-0 text-white font-weight-bold">Accura</h4>

     <button class="btn btn-light btn-round btn-secondary btn-sm position-absolute"

             style="

             width: 110px;

             right: 10px;

             top: 10px;"

             id="orientation-btn">Landscape

     </button>

</div>
```
###  	 Add button and contents
```
<div style="display:none;overflow: auto;height: 90%" class=" pt-2" id="main-div">

     <div class="d-flex align-items-center justify-content-center">

         <button class="btn btn-rose ocr" style="width: 220px" data-toggle="modal" data-target="#country-modal">Start

             OCR

         </button>

     </div>

     <div class="form-group p-2 border m-3 ocr">

         <h4>OCR With Country</h4>

         <div class="form-group">

             <label for="countries-1">Country</label>

             <select onchange="countrySelected=this.value" id="countries-1" class="form-control w-100">

             </select>

         </div>

         <div class="d-flex align-items-center justify-content-center">

             <button class="btn btn-rose btn-block" style="width: 220px" onclick="startOcrWithCountry()">Start OCR With

                 Country

             </button>

         </div>

     </div>

     <div class="form-group p-2 m-3 border ocr">

         <h4>OCR With Card</h4>

         <div class="form-group col-md-3">

             <label for="countries-2">Country</label>

             <select onchange="countrySelectedForCard=this.value;getCards(countrySelectedForCard);" id="countries-2"

                     class="form-control">

             </select>

         </div>

         <div class="form-group col-md-3">

             <label for="cards">Card</label>

             <select onchange="cardSelected=this.value" id="cards" class="form-control">

             </select>

         </div>

         <div class="d-flex align-items-center justify-content-center">

             <button class="btn btn-rose btn-block" style="width: 220px" onclick="startOcrWithCard()">Start OCR With Card

             </button>

         </div>

     </div>

     <div id="mrz-div" class="form-group p-2 m-3 border" style="display: none">

         <h4>MRZ</h4>

         <div class="form-group col-md-3">

             <label for="mrz-types">Type</label>

             <select id="mrz-types" onchange="mrzSelected = this.value" class="form-control">

                 <option value="passport_mrz">Passport</option>

                 <option value="id_mrz">ID Card</option>

                 <option value="visa_mrz">Visa</option>

                 <option selected value="other_mrz">All</option>

             </select>

         </div>

         <div class="d-flex align-items-center justify-content-center">

             <button class="btn btn-rose btn-block" style="width: 220px" onclick="startMRZ()">Start MRZ</button>

         </div>

     </div>

     <div id="barcode-div" class="form-group p-2 m-3 border" style="display: none">

         <h4>Barcode</h4>

         <div class="form-group col-md-3">

             <label for="barcode-types">Type</label>

             <select onchange="barcodeSelected = this.value" id="barcode-types" class="form-control">

             </select>

         </div>

         <div class="d-flex align-items-center justify-content-center">

             <button class="btn btn-rose btn-block" style="width: 220px" onclick="startBarcode()">Start Barcode</button>

         </div>

     </div>

     <div id="bank-div" style="display: flex" class="align-items-center justify-content-center">

         <button class="btn btn-rose btn-block" style="width: 220px" onclick="startBankCard()">Bank Card</button>

     </div>

     <div style="display: flex" class="align-items-center justify-content-center ocr">

         <button class="btn btn-rose btn-block" style="width: 220px" onclick="startFaceMatch()">Face Match</button>

     </div>

     <div style="display: flex" class="align-items-center justify-content-center mb-5 ocr">

         <button class="btn btn-rose btn-block" style="width: 220px" onclick="startLiveness()">Liveness</button>

     </div>

</div>
```

### Add Result Dialog
```
 	<div class="modal fade" id="result-modal" tabindex="-1" role="dialog" aria-labelledby="result-modal-title"

     aria-hidden="true">

     <div class="modal-dialog" role="document">

         <div class="modal-content">

             <div class="modal-header">

                 <h5 class="modal-title" id="result-modal-title">Accura</h5>

                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">

                     <span aria-hidden="true">&times;</span>

                 </button>

             </div>

             <div class="modal-body">

             </div>

             <div class="modal-footer">

                 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

             </div>

         </div>

     </div>

</div>
```
### Add Face Match Dialog
```
 	 <div class="modal fade" id="fm-modal" tabindex="-1" role="dialog" aria-labelledby="fm-title" aria-hidden="true">

     <div class="modal-dialog" role="document">

         <div class="modal-content">

             <div class="modal-header">

                 <h5 class="modal-title" id="fm-title">Accura Facematch</h5>

                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">

                     <span aria-hidden="true">&times;</span>

                 </button>

             </div>

             <div class="modal-body">

                 <div class="d-flex justify-content-between">

                     <div class="d-flex flex-column p-2 justify-content-between">

                         <img id="fm-1" src="img/fm.png" class="img-fluid" style="border-radius: 15px">

                         <button onclick="startFaceMatch(false, true, false)" class="mt-2 btn btn-danger btn-sm">Choose Face1</button>

                     </div>

                     <div class="d-flex flex-column p-2 justify-content-between">

                         <img id="fm-2" src="img/fm.png" class="img-fluid" style="border-radius: 15px">

                         <button onclick="startFaceMatch(false, false, true)" class="mt-2 btn btn-danger btn-sm">Choose Face2</button>

                     </div>

                 </div>

                 <h5 class="m-0" id="fm-standalone-score"></h5>

             </div>

             <div class="modal-footer">

                 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

             </div>

         </div>

     </div>

</div>
```






### Add Liveness Dialog
```
<div class="modal fade" id="lv-modal" tabindex="-1" role="dialog" aria-labelledby="fm-title" aria-hidden="true">

     <div class="modal-dialog" role="document">

         <div class="modal-content">

             <div class="modal-header">

                 <h5 class="modal-title">Accura Liveness</h5>

                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">

                     <span aria-hidden="true">&times;</span>

                 </button>

             </div>

             <div class="modal-body">

             </div>

             <div class="modal-footer">

                 <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>

             </div>

         </div>

     </div>

</div>
```
###Add Country Selection Dialog

--------------------------------
```
<div class="modal fade" id="country-modal" tabindex="-1" role="dialog" aria-labelledby="fm-title" aria-hidden="true">

     <div class="modal-dialog" role="document">

         <div class="modal-content">

             <div class="modal-header">

                 <h5 class="modal-title">Select Country</h5>

                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">

                     <span aria-hidden="true">&times;</span>

                 </button>

             </div>

             <div class="modal-body">

             </div>

         </div>

     </div>

</div>
```



###  		 Add Card Selection Dialog
```
 		 <div class="modal fade" id="card-modal" tabindex="-1" role="dialog" aria-labelledby="fm-title" aria-hidden="true">

     <div class="modal-dialog" role="document">

         <div class="modal-content">

             <div class="modal-header">

                 <h5 class="modal-title" id="card-title"></h5>

                 <button type="button" class="close" data-dismiss="modal" aria-label="Close">

                     <span aria-hidden="true">&times;</span>

                 </button>

             </div>

             <div class="modal-body">

             </div>

         </div>

     </div>

</div>
```




### Add scripts
```
<script src="cordova.js"></script>

<script src="js/jquery.min.js"></script>

<script src="js/popper.min.js"></script>

<script src="js/material-kit.min.js"></script>

<script src="js/bootstrap-material-design.min.js"></script>

<script src="js/sweetalert2.js"></script>

<script src="js/index.js"></script>

</body>

</html>
```











1. ## CSS(index.css)
```
body {

     -webkit-touch-callout: none;                /\ prevent callout to copy image, etc when tap to hold \/

     -webkit-text-size-adjust: none;             /\ prevent webkit from resizing text to fit \/

     -webkit-user-select: none;                  /\ prevent copy paste, to allow, change 'none' to 'text' \/

     background-color:#E4E4E4;

     background-image:linear-gradient(to bottom, #A7A7A7 0%, #E4E4E4 51%);

     font-family: system-ui, -apple-system, -apple-system-font, 'Segoe UI', 'Roboto', sans-serif;

     font-size:12px;

     height:100vh;

     margin:0px;

     padding:0px;

     padding: env(safe-area-inset-top, 0px) env(safe-area-inset-right, 0px) env(safe-area-inset-bottom, 0px) env(safe-area-inset-left, 0px);

     text-transform:uppercase;

     width:100%;

}

.country-card {

     cursor: pointer;

     background: red;

     color: white;

     padding: 10px 15px;

     max-width: 320px;

     border-radius: 15px;

     margin-bottom: 10px;

}
```










1. ## javascript(index.js)
### initialize Cordova
```js
document.addEventListener('deviceready', onDeviceReady, false);

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

     accura = cordova.plugins.ACCURAService;

     console.log('Running cordova-' + cordova.platformId + '@' + cordova.version);

getMetadata();

}
```
### Call Metadata to fill  forms
```js
function getMetadata() {

     accura.getMetadata(function (results) {

         console.log(results);

         $('#countries-1, #countries-2, #country-modal .modal-body').empty();

         if (results.isValid) {

             alert('Licence Loaded');

             $('#main-div').fadeIn();

             if (results.isOCR) {

                 if (results.countries.length > 0) {

                         countries = results.countries;

                     results.countries.forEach(function (country, i) {

                         var uid = i + '_' + country.id;

                         if (i === 0) {

                             countrySelected = countrySelectedForCard = uid;

                             getCards(countrySelectedForCard)

                         }

                         $('#countries-1, #countries-2').append(

                             '<option value="' + uid + '">' + country.name + '</option>'

                         )

                         $('#country-modal .modal-body').append(

                             '<h5 onclick="getCardsModal(this.id)" class="country-card" id="' + i + '">' + country.name + '</h5>'

                         )

                     });

                 }

             }

             if (results.isMRZ) {

                 $('#mrz-div').fadeIn();

             }

             if (results.isBarcode) {

                 $('#barcode-div').fadeIn();

                 results.barcodes.forEach(function (barcode, i) {

                     if (i === 0) {

                         barcodeSelected = barcode.type;

                     }

                     $('#barcode-types').append(

                         '<option value="' + barcode.type + '">' + barcode.name + '</option>'

                     )

                 })

             }

             if (results.isBankCard) {

                 $('#bank-div').fadeIn();

             }

         } else {

             alert('Licence is not Loaded');

         }

     }, function (error) {

         alert(error);

     })

}
```
### Initialize cordova back button
```js
 	document.addEventListener("backbutton", function () {

     if ($('#card-modal').hasClass('show')) {

         $('#card-modal').modal('hide');

         return;

     }

     if ($('#country-modal').hasClass('show')) {

         $('#country-modal').modal('hide');

         return;

     }

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
```
### initialize common helper variables 
```js
var accura;

var loadingImg = <image path>;

var errorImg = <image path>
```
### Initialize Country Selection
```js
var countrySelectedId;

var countryCard;

function getCardsModal(id) {

     countryCard = countries[id].cards;

     countrySelectedId = countries[id].id;

     $('#card-title').text(countries[id].name + ": ");

     $('#card-modal .modal-body').empty();

     countryCard.forEach(function (card, i) {

         $('#card-modal .modal-body').append(

             '<h5 onclick="openForCard(this.id)" class="country-card" id="' + i + '">' + card.name + '</h5>'

         )

     })

     $('#country-modal').modal('hide');

     setTimeout(function () {

         $('#card-modal').modal();

     }, 300);

}

function openForCard(id) {

     $('#country-modal').modal('hide');

     $('#card-modal').modal('hide');

     var accuraConfs = {};

     accura.startOcrWithCard(accuraConfs, countrySelectedId, countryCard[id].id, countryCard[id].name, countryCard[id].type, function (results) {

         generateResult(results);

     }, function (error) {

         alert(error);

     })

}
```

### Initialize Card Selection
```js
function startOcrWithCountry() {

     getCardsModal(countrySelected.split('_')[0]);

}
```

### Initialize Country with Card Selection
```js
var countries = [];

var cards;

var countrySelected = '';

var countrySelectedForCard = '';

var cardSelected = '';

var mrzSelected = 'other_mrz';

var barcodeSelected = '';

function getCards(id) {

     id = id.split("_");

     cards = countries[id[0]].cards;

     $('#cards').empty();

     cards.forEach(function (card, i) {

         var uid = i + '_' + card.id + '_' + card.type;

         if (i === 0) {

             cardSelected = uid;

         }

         $('#cards').append(

             '<option value="' + uid + '">' + card.name + '</option>'

         )

     })

}

function startOcrWithCard() {

     var accuraConfs = {};

     var cardSlected = cards[cardSelected.split('_')[0]];

     accura.startOcrWithCard(

         accuraConfs,

         countrySelectedForCard.split('_')[1],

         cardSlected.id,

         cardSlected.name,

         cardSlected.type,

         function (results) {

             generateResult(results);

         }, function (error) {

             alert(error);

         })

}
```
### Initialize bankcard
```js
function startBankCard() {

     var accuraConfs = {};

     accura.startBankCard(accuraConfs, function (results) {

         generateResult(results);

     }, function (error) {

         alert(error);

     });

}
```

### ` `Initialize barcode
```js
function startBarcode() {

   var accuraConfs = {};

   accura.startBarcode(accuraConfs, barcodeSelected, function (results) {

       generateResult(results);

    }, function (error) {

         alert(error);

     })

}
```

### Initialize Liveness
```js
function startLiveness(withFace = false) {

     var accuraConfs = {with_face: withFace, face_uri: facematchURI};

     if (!withFace) {delete accuraConfs.face_uri;}

     var config = {

         feedbackTextSize: 18,

         feedBackframeMessage: 'Frame Your Face',

         feedBackAwayMessage: 'Move Phone Away',

         feedBackOpenEyesMessage: 'Keep Your Eyes Open',

         feedBackCloserMessage: 'Move Phone Closer',

         feedBackCenterMessage: 'Move Phone Center',

         feedBackMultipleFaceMessage: 'Multiple Face Detected',

         feedBackHeadStraightMessage: 'Keep Your Head Straight',

         feedBackBlurFaceMessage: 'Blur Detected Over Face',

         feedBackGlareFaceMessage: 'Glare Detected',

         feedBackVideoRecordingMessage: 'Processing…',

         // <!--// 0 for clean face and 100 for Blurry face or set it -1 to remove blur filter-->

         setBlurPercentage: 80,

         // <!--// Set min percentage for glare or set it -1 to remove glare filter-->

         setGlarePercentage_0: -1,

         // <!--// Set max percentage for glare or set it -1 to remove glare filter-->

         setGlarePercentage_1: -1,

         isSaveImage: true,

         isRecordVideo: true,

         videoLengthInSecond: 2,

         recordingTimerTextSize: 45,

         recordingMessage: 'Scanning your face be steady',

         recordingMessageTextSize: 18,

         enableFaceDetect: true,

         fmScoreThreshold: 50,

         enableFaceMatch: false,

         feedbackFMFailed: "Face not matched",

         liveness_url: '<your liveness url>'

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

```





### Initialize face match 
```js 

var facematchURI;

function startFaceMatch(withFace = false, face1 = false, face2 = false) {

     var accuraConfs = {with_face: withFace, face_uri: facematchURI};

     if (!withFace) {delete accuraConfs.face_uri;}

     if (face1) {face2 = false;}

     if (face2) {face1 = false;}

     accuraConfs.face1 = face1;

     accuraConfs.face2 = face2;

     var config = {

         fm_feedbackTextSize: 18,

         fm_feedBackframeMessage: 'Frame Your Face',

         fm_feedBackAwayMessage: 'Move Phone Away',

         fm_feedBackOpenEyesMessage: 'Keep Your Eyes Open',

         fm_feedBackCloserMessage: 'Move Phone Closer',

         fm_feedBackCenterMessage: 'Move Phone Center',

         fm_feedBackMultipleFaceMessage: 'Multiple Face Detected',

         fm_feedBackHeadStraightMessage: 'Keep Your Head Straight',

         fm_feedBackBlurFaceMessage: 'Blur Detected Over Face',

         fm_feedBackGlareFaceMessage: 'Glare Detected',

         // <!--// 0 for clean face and 100 for Blurry face or set it -1 to remove blur filter-->

         fm_setBlurPercentage: 80,

         // <!--// Set min percentage for glare or set it -1 to remove glare filter-->

         fm_setGlarePercentage_0: -1,

         fm_setGlarePercentage_1: -1,

     };

     $('#ls-score,#fm-score').text("0.00 %");

     accura.startFaceMatch(accuraConfs, config, function (result) {

         console.log(result);

         if (result.hasOwnProperty('status')) {

             if (result.status) {

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

         alert(error);

     });

}
```

### Initialize MRZ
```js
function startMRZ() {

     var accuraConfigs = {};

     accura.startMRZ(accuraConfigs, mrzSelected, function (result) {

         generateResult(result)

     }, function (error) {

         alert(error)

     })

}
```
### Initialize Helper function
```js
function generateResult(result) {

     console.log(result)

     var html = '';

     var sides = ["front_data", "back_data"];

     if (result.hasOwnProperty("face")) {

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

                 var tdLen1 = Math.round(0.35 \ width);

                 var tdLen2 = Math.round(0.55 \ width);


                 Object.keys(result[side]).forEach(function (key) {

                     if (key !== "PDF417") {

                         if (["signature", "front_img", "back_img"].indexOf(key) === -1) {

                             if (result[side][key].indexOf("<") !== -1) {

                                 table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result[side][key].replace(/</g, '&lt') + "</pre></td></tr>";

                             } else {

                                 table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'>" + result[side][key] + "</td></tr>";

                             }

                         } else if (key === "signature") {

                             table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;'>" + key + "</td><td><img id='signature_" + side + "' src='" + loadingImg + "' class='img-fluid'></td></tr>";

                             getImage('signature_' + side, result[side][key]);

                         }

                     }

                 });

                 var key = "PDF417";

                 if (result[side].hasOwnProperty(key)) {

                     table += "<tr style='background: lightgrey' class='p-2 font-weight-bold'><td style='max-width: "+tdLen1+"px;'>PDF417 Barcode</td><td></td></tr>";

                     if (result[side][key].indexOf("<") !== -1) {

                         table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: "+tdLen1+"px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: "+tdLen2+"px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result[side][key].replace(/</g, '&lt') + "</pre></td></tr>";

                     } else {

                         table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: "+tdLen1+"px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: "+tdLen2+"px;white-space: pre-wrap;word-break: break-word;'>" + result[side][key] + "</td></tr>";

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

             var tdLen1 = Math.round(0.35 \ width);

             var tdLen2 = Math.round(0.55 \ width);

             if (result.mrz_data.hasOwnProperty("MRZ")) {

                 if (result.mrz_data.MRZ.indexOf("<") !== -1) {

                     table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: "+tdLen1+"px;white-space: pre-wrap;word-break: break-word;'>MRZ</td><td style='max-width: "+tdLen2+"px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data.MRZ.replace(/</g, '&lt') + "</pre></td></tr>";

                 } else {

                     table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: "+tdLen1+"px;white-space: pre-wrap;word-break: break-word;'>MRZ</td><td style='max-width: "+tdLen2+"px;white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data.MRZ + "</td></tr>";

                 }

             }

             keys.forEach(function (key) {

                 if (key !== "MRZ") {

                     if (result.mrz_data[key].indexOf("<") !== -1) {

                         table += "<tr><td class='text-danger p-2' style='vertical-align:inherit;max-width: " + tdLen1 + "px;white-space: pre-wrap;word-break: break-word;'>" + key + "</td><td style='max-width: " + tdLen2 + "px;white-space: pre-wrap;word-break: break-word;'><pre style='white-space: pre-wrap;word-break: break-word;'>" + result.mrz_data[key].replace(/</g, '&lt') + "</pre></td></tr>";

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

function getImage(id, uri, isFm = false) {

     window.resolveLocalFileSystemURL(uri, function (fileEntry) {

         fileEntry.file(function (file) {

             var reader = new FileReader();

             reader.onloadend = function () {

                 $('#' + id).attr("src", this.result);

                 if (isFm) {

                     $('#check-ls, #check-fm').fadeIn()

                 }

             };

             reader.onerror = function () {

                 $('#' + id).attr("src", errorImg);

                 if (isFm) {

                     $('#check-ls, #check-fm').fadeOut()

                 }

             }

             reader.readAsDataURL(file);

         }, function () {

             $('#' + id).attr("src", errorImg);

             if (isFm) {

                 $('#check-ls, #check-fm').fadeOut()

             }

         });

     }, function () {

         $('#' + id).attr("src", errorImg);

         if (isFm) {

             $('#check-ls, #check-fm').fadeOut()

         }

     });

}
```
## Commit Files
Run 


`$ cordova prepare ios`

#
#
#
#
#
# Details for Plugin Modifications
1. ## Structure
   1. ### Cordova Structure



1. ### Plugin Structure

Plugin path = \accura-cordova\custom-plugins\cordova-kyc-nfb





1. ## Package Name
Accura licence needs Package name for ios. To get cordova app package name open the config.xml in the root I:\accura-cordova\config.xml

id will be the package name.

TO MODIFY rename it to your desire package name and run in CMD (in the root of  cordova project i.e I:\accura-cordova\)

“cordova prepare ios”

1. ## License Paths
  
  **Generate your Accura license from [here](https://accurascan.com/developer/dashboard)**
  
These are the paths for licences:

- \accura-cordova\custom-plugins\cordova-kyc-nfb\src\ios\accuraface.license
- \accura-cordova\custom-plugins\cordova-kyc-nfb\src\ios\key.license

 	 Replace your licensees in these locations.




1. ## Configurations
Structure:

1. ### Accura Error Messages
File: /cordova-kyc-nfb/src/ios/configs/accura_error_titles_configs.swift

You can change default settings here.
1. ### Accura Scan Messages
File: /cordova-kyc-nfb/src/ios/configs/accura_scan_titles_configs.swift

You can change default settings here.
1. ### Accura Common Strings
File: /cordova-kyc-nfb/src/ios/configs/accura_strings.swift

You can change default settings here.
1. ### Face Match 
File: /cordova-kyc-nfb/src/ios/configs/face_match_config.swift

You can change default settings here.
1. ### Liveness 
File: /cordova-kyc-nfb/src/ios/liveness_config.swift

You can change default settings here.
1. ### Recog Engine Initial Settings
File: /cordova-kyc-nfb/src/ios/recog_engine_config.swift

1. ## Accura framework 
 	 Accura framework file is located at:

\accura-cordova\custom-plugins\cordova-kyc-nfb\src\ios\AccuraKYC.framework

NOTE: the filename should be the same.

For updating your new Framework file replace the above file.



# Commit Modifications
 		 After all the modifications or any modification open CMD at root(i.e \accura-cordova\) and run the following commands one by one

1. `$ cordova plugin remove cordova-kyc-nfb`
2. `$ cordova plugin add \accura-cordova\custom-plugins\cordova-kyc-nfb`




