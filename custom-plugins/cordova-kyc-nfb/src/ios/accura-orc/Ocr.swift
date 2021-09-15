package accura.kyc.plugin;

import android.app.Dialog;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Base64;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import accura.kyc.app.R;
import accura.kyc.plugin.adapter.BarCodeFormatListAdapter;

import com.accurascan.ocr.mrz.CameraView;
import com.accurascan.ocr.mrz.interfaces.OcrCallback;
import com.accurascan.ocr.mrz.model.BarcodeFormat;
import com.accurascan.ocr.mrz.model.CardDetails;
import com.accurascan.ocr.mrz.model.OcrData;
import com.accurascan.ocr.mrz.model.PDF417Data;
import com.accurascan.ocr.mrz.model.RecogResult;
import com.accurascan.ocr.mrz.motiondetection.SensorsActivity;
import com.accurascan.ocr.mrz.util.AccuraLog;
import com.docrecog.scan.MRZDocumentType;
import com.docrecog.scan.RecogEngine;
import com.docrecog.scan.RecogType;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.ref.WeakReference;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import static accura.kyc.plugin.ACCURAService.getImageUri;
import static accura.kyc.plugin.ACCURAService.getSaltString;

public class OcrActivity extends SensorsActivity implements OcrCallback {

    private static final String TAG = OcrActivity.class.getSimpleName();
    private CameraView cameraView;
    private View viewLeft, viewRight, borderFrame;
    private TextView tvTitle, tvScanMessage;
    private ImageView imageFlip;
    private int cardId;
    private int countryId;
    RecogType recogType;
    Dialog types_dialog;
    private String cardName;
    private boolean isBack = false;
    private MRZDocumentType mrzType;
    Resources res;

    private static class MyHandler extends Handler {
        private final WeakReference<OcrActivity> mActivity;

        public MyHandler(OcrActivity activity) {
            mActivity = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            OcrActivity activity = mActivity.get();
            if (activity != null) {
                String s = "";
                if (msg.obj instanceof String) s = (String) msg.obj;
                switch (msg.what) {
                    case 0:
                        activity.tvTitle.setText(s);
                        break;
                    case 1:
                        activity.tvScanMessage.setText(s);
                        break;
                    case 2:
                        if (activity.cameraView != null)
                            activity.cameraView.flipImage(activity.imageFlip);
                        break;
                    default:
                        break;
                }
            }
            super.handleMessage(msg);
        }
    }

    private Handler handler = new MyHandler(this);
    String type = "";
    Boolean needCallback = true;
    Bundle bundle;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        bundle = getIntent().getExtras();
        if (bundle.getString("app_orientation", "portrait").contains("portrait")) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        } else {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        }
        super.onCreate(savedInstanceState);
        res = getResources();
        if (bundle.containsKey("type")) {
            type = bundle.getString("type");
            Log.e("ttt", type);
        }
        ACCURAService.ocrCLProcess = true;
        setTheme(R.style.AppThemeNoActionBar);
        requestWindowFeature(Window.FEATURE_NO_TITLE); // Hide the window title.
        setContentView(R.layout.ocr_activity);
        AccuraLog.loge(TAG, "Start Camera Activity");
        init();

        recogType = RecogType.detachFrom(getIntent());
        if (getIntent().hasExtra(MRZDocumentType.class.getName())) {
            mrzType = MRZDocumentType.detachFrom(getIntent());
        } else {
            mrzType = MRZDocumentType.NONE;
        }
        Bundle bundle = getIntent().getExtras();
        Log.e("bundle", bundle.getInt("card_id") + "");
        Log.e("bundle", bundle.getInt("country_id") + "");
        Log.e("bundle", bundle.getString("card_name") + "");
        cardId = getIntent().getIntExtra("card_id", 0);
        countryId = getIntent().getIntExtra("country_id", 0);
        cardName = getIntent().getStringExtra("card_name");

        AccuraLog.loge(TAG, "RecogType " + recogType);
        AccuraLog.loge(TAG, "Card Id " + cardId);
        AccuraLog.loge(TAG, "Country Id " + countryId);

        initCamera();
        if (recogType == RecogType.BARCODE) barcodeFormatDialog();
    }

    private void initCamera() {
        AccuraLog.loge(TAG, "Initialized camera");
        //<editor-fold desc="To get status bar height">
        Rect rectangle = new Rect();
        Window window = getWindow();
        window.getDecorView().getWindowVisibleDisplayFrame(rectangle);
        int statusBarTop = rectangle.top;
        int contentViewTop = window.findViewById(Window.ID_ANDROID_CONTENT).getTop();
        int statusBarHeight = contentViewTop - statusBarTop;
        //</editor-fold>

        RelativeLayout linearLayout = findViewById(R.id.ocr_root); // layout width and height is match_parent

        cameraView = new CameraView(this);
        if (recogType == RecogType.OCR || recogType == RecogType.DL_PLATE) {
            // must have to set data for RecogType.OCR and RecogType.DL_PLATE
            cameraView.setCountryId(countryId).setCardId(cardId)
                    .setMinFrameForValidate(bundle.getInt("rg_setMinFrameForValidate", res.getInteger(R.integer.rg_setMinFrameForValidate))); // to set min frame for qatar Id card
        } else if (recogType == RecogType.PDF417) {
            // must have to set data RecogType.PDF417
            cameraView.setCountryId(countryId);
        } else if (recogType == RecogType.MRZ) {
            cameraView.setMRZDocumentType(mrzType);
        }
        cameraView.setRecogType(recogType)
                .setView(linearLayout) // To add camera view
                .setCameraFacing(bundle.getInt("rg_setCameraFacing", res.getInteger(R.integer.rg_setCameraFacing))) // To set front or back camera.
                .setOcrCallback(this)  // To get Update and Success Call back
                .setStatusBarHeight(statusBarHeight)  // To remove Height from Camera View if status bar visible
                .setFrontSide()
//                optional field
                .setEnableMediaPlayer(bundle.getBoolean("rg_setEnableMediaPlayer", res.getBoolean(R.bool.rg_setEnableMediaPlayer))) // false to disable default sound and default it is true
//                .setCustomMediaPlayer(MediaPlayer.create(this, com.accurascan.ocr.mrz.R.raw.beep)) // To add your custom sound and Must have to enable media player
                .init();  // initialized camera
    }

    private void init() {
        viewLeft = findViewById(R.id.view_left_frame);
        viewRight = findViewById(R.id.view_right_frame);
        borderFrame = findViewById(R.id.border_frame);
        tvTitle = findViewById(R.id.tv_title);
        tvScanMessage = findViewById(R.id.tv_scan_msg);
        imageFlip = findViewById(R.id.im_flip_image);
        View btn_flip = findViewById(R.id.btn_flip);
        btn_flip.setOnClickListener(v -> {
            if (cameraView != null) {
                cameraView.flipCamera();
            }
        });
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        if (cameraView != null) cameraView.onWindowFocusUpdate(hasFocus);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (cameraView != null) cameraView.onResume();
    }

    @Override
    protected void onPause() {
        if (cameraView != null) cameraView.onPause();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        AccuraLog.loge(TAG, "onDestroy");
        if (cameraView != null) cameraView.onDestroy();
        super.onDestroy();
        Runtime.getRuntime().gc(); // to clear garbage
    }

    /**
     * Override method call after camera initialized successfully
     * <p>
     * And update your border frame according to width and height
     * it's different for different card
     * <p>
     * Call {@link CameraView#startOcrScan(boolean isReset)} To start Camera Preview
     *
     * @param width  border layout width
     * @param height border layout height
     */
    @Override
    public void onUpdateLayout(int width, int height) {
        AccuraLog.loge(TAG, "Frame Size (wxh) : " + width + "x" + height);
        if (cameraView != null) cameraView.startOcrScan(false);

        //<editor-fold desc="To set camera overlay Frame">
        ViewGroup.LayoutParams layoutParams = borderFrame.getLayoutParams();
        layoutParams.width = width;
        layoutParams.height = height;
        borderFrame.setLayoutParams(layoutParams);
        ViewGroup.LayoutParams lpRight = viewRight.getLayoutParams();
        lpRight.height = height;
        viewRight.setLayoutParams(lpRight);
        ViewGroup.LayoutParams lpLeft = viewLeft.getLayoutParams();
        lpLeft.height = height;
        viewLeft.setLayoutParams(lpLeft);

        findViewById(R.id.ocr_frame).setVisibility(View.VISIBLE);

    }

    /**
     * Override this method after scan complete to get data from document
     *
     * @param result is scanned card data
     *               result instance of {@link OcrData} if recog type is {@link com.docrecog.scan.RecogType#OCR}
     *               or {@link com.docrecog.scan.RecogType#DL_PLATE} or {@link com.docrecog.scan.RecogType#BARCODE}
     *               result instance of {@link RecogResult} if recog type is {@link com.docrecog.scan.RecogType#MRZ}
     *               result instance of {@link PDF417Data} if recog type is {@link com.docrecog.scan.RecogType#PDF417}
     */
    @Override
    public void onScannedComplete(Object result) {
        Runtime.getRuntime().gc(); // To clear garbage
        AccuraLog.loge(TAG, "onScannedComplete: ");
        if (result != null) {
            if (result instanceof OcrData) {
                if (recogType == RecogType.OCR) {
                    if (isBack || !cameraView.isBackSideAvailable()) {
                        OcrData.setOcrResult((OcrData) result);
                        /**@recogType is {@link RecogType#OCR}*/
                        sendDataToResultActivity(RecogType.OCR);

                    } else {
                        isBack = true;
                        cameraView.setBackSide();
                        cameraView.flipImage(imageFlip);
                    }
                } else if (recogType == RecogType.DL_PLATE || recogType == RecogType.BARCODE) {
                    /**
                     * @recogType is {@link RecogType#DL_PLATE} or recogType == {@link RecogType#BARCODE}*/
                    OcrData.setOcrResult((OcrData) result);
                    sendDataToResultActivity(recogType);
                }
            } else if (result instanceof RecogResult) {
                /**
                 *  @recogType is {@link RecogType#MRZ}*/
                RecogResult.setRecogResult((RecogResult) result);
                sendDataToResultActivity(RecogType.MRZ);
            } else if (result instanceof CardDetails) {
                /**
                 *  @recogType is {@link RecogType#BANKCARD}*/
                CardDetails.setCardDetails((CardDetails) result);
                sendDataToResultActivity(RecogType.BANKCARD);
            } else if (result instanceof PDF417Data) {
                /**
                 *  @recogType is {@link RecogType#PDF417}*/
                if (isBack || !cameraView.isBackSideAvailable()) {
                    PDF417Data.setPDF417Result((PDF417Data) result);
                    sendDataToResultActivity(recogType);
                } else {
                    isBack = true;
                    cameraView.setBackSide();
                    cameraView.flipImage(imageFlip);
                }
            }
        } else Toast.makeText(this, "Failed", Toast.LENGTH_SHORT).show();
    }

    private void sendDataToResultActivity(RecogType recogType) {
        Log.e("needCallback", needCallback.toString());
        if (cameraView != null) cameraView.release(true);
        if (needCallback) {
//            if (type.contains("ocr")) {
            RecogResult recogResult = null;
            CardDetails cardDetails = null;
            PDF417Data barcodeData = PDF417Data.getPDF417Result();
            RecogType ocrTypes[] = {RecogType.BARCODE, RecogType.DL_PLATE, RecogType.OCR};
            String frontUri = null, backUri = null, faceUri = null;
            JSONObject results = new JSONObject();
            JSONObject frontResult = new JSONObject();
            JSONObject backResult = new JSONObject();
            OcrData data = null;
            type = recogType.toString();
            String fileDir = getFilesDir().getAbsolutePath();
            if (Arrays.asList(ocrTypes).contains(recogType)) {
                data = OcrData.getOcrResult();
                if (data.getFaceImage() != null) {
                    faceUri = getImageUri(data.getFaceImage(), "face", fileDir);
                }
                if (data.getFrontimage() != null) {
                    frontUri = getImageUri(data.getFrontimage(), "front", fileDir);
                }
                if (data.getBackimage() != null) {
                    backUri = getImageUri(data.getBackimage(), "back", fileDir);
                }
            }

            if (recogType == RecogType.MRZ) {
                recogResult = RecogResult.getRecogResult();
                if (recogResult != null) {
                    try {
                        frontResult.put("MRZ", recogResult.lines);
                        frontResult.put("Document Type", recogResult.docType);
                        frontResult.put("First Name", recogResult.givenname);
                        frontResult.put("Last Name", recogResult.surname);
                        frontResult.put("Document No.", recogResult.docnumber);
                        frontResult.put("Document check No.", recogResult.docchecksum);
                        frontResult.put("Correct Document check No.", recogResult.correctdocchecksum);
                        frontResult.put("Country", recogResult.country);
                        frontResult.put("Nationality", recogResult.nationality);
                        String s = (recogResult.sex.equals("M")) ? "Male" : ((recogResult.sex.equals("F")) ? "Female" : recogResult.sex);
                        frontResult.put("Sex", s);
                        frontResult.put("Date of Birth", recogResult.birth);
                        frontResult.put("Birth Check No.", recogResult.birthchecksum);
                        frontResult.put("Correct Birth Check No.", recogResult.correctbirthchecksum);
                        frontResult.put("Date of Expiry", recogResult.expirationdate);
                        frontResult.put("Expiration Check No.", recogResult.expirationchecksum);
                        frontResult.put("Correct Expiration Check No.", recogResult.correctexpirationchecksum);
                        frontResult.put("Date Of Issue", recogResult.issuedate);
                        frontResult.put("Department No.", recogResult.departmentnumber);
                        frontResult.put("Other ID", recogResult.otherid);
                        frontResult.put("Other ID Check", recogResult.otheridchecksum);
                        frontResult.put("Second Row Check No.", recogResult.secondrowchecksum);
                        frontResult.put("Correct Second Row Check No.", recogResult.correctsecondrowchecksum);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    
                    if (recogResult.faceBitmap != null) {
                        faceUri = getImageUri(recogResult.faceBitmap, "face", fileDir);
                    }
                    if (recogResult.docFrontBitmap != null) {
                        frontUri = getImageUri(recogResult.docFrontBitmap, "front", fileDir);
                    }
                    if (recogResult.docBackBitmap != null) {
                        backUri = getImageUri(recogResult.docBackBitmap, "back", fileDir);
                    }
                }
                
            }

            if (recogType == RecogType.BANKCARD) {
                cardDetails = CardDetails.getCardDetails();
                if (cardDetails.bitmap != null) {
                    frontUri = getImageUri(cardDetails.bitmap, "front", fileDir);
                    try {
                        frontResult.put("front_img", frontUri);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
                try {
                    frontResult.put("Expiry Date", cardDetails.expirationDate);
                    frontResult.put("Expiry Month", cardDetails.expirationMonth);
                    frontResult.put("Expiry Year", cardDetails.expirationYear);
                    frontResult.put("Card Type", cardDetails.cardType);
                    frontResult.put("Card Number", cardDetails.number);
                    frontResult.put("Owner", cardDetails.owner);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            if (barcodeData != null) {
                if (barcodeData.faceBitmap != null) {
                    faceUri = getImageUri(barcodeData.faceBitmap, "face", fileDir);
                }
                if (barcodeData.docFrontBitmap != null) {
                    frontUri = getImageUri(barcodeData.docFrontBitmap, "front", fileDir);
                }
                if (barcodeData.docBackBitmap != null) {
                    backUri = getImageUri(barcodeData.docBackBitmap, "back", fileDir);
                }
                try {
                    frontResult.put(getString(R.string.firstName), barcodeData.fname);
                    frontResult.put(getString(R.string.firstName), barcodeData.firstName);
                    frontResult.put(getString(R.string.firstName), barcodeData.firstName1);
                    frontResult.put(getString(R.string.lastName), barcodeData.lname);
                    frontResult.put(getString(R.string.lastName), barcodeData.lastName);
                    frontResult.put(getString(R.string.lastName), barcodeData.lastName1);
                    frontResult.put(getString(R.string.middle_name), barcodeData.mname);
                    frontResult.put(getString(R.string.middle_name), barcodeData.middleName);
                    frontResult.put(getString(R.string.addressLine1), barcodeData.address1);
                    frontResult.put(getString(R.string.addressLine2), barcodeData.address2);
                    frontResult.put(getString(R.string.ResidenceStreetAddress1), barcodeData.ResidenceAddress1);
                    frontResult.put(getString(R.string.ResidenceStreetAddress2), barcodeData.ResidenceAddress2);
                    frontResult.put(getString(R.string.city), barcodeData.city);
                    frontResult.put(getString(R.string.zipcode), barcodeData.zipcode);
                    frontResult.put(getString(R.string.birth_date), barcodeData.birthday);
                    frontResult.put(getString(R.string.birth_date), barcodeData.birthday1);
                    frontResult.put(getString(R.string.license_number), barcodeData.licence_number);
                    frontResult.put(getString(R.string.license_expiry_date), barcodeData.licence_expire_date);
                    frontResult.put(getString(R.string.sex), barcodeData.sex);
                    frontResult.put(getString(R.string.jurisdiction_code), barcodeData.jurisdiction);
                    frontResult.put(getString(R.string.license_classification), barcodeData.licenseClassification);
                    frontResult.put(getString(R.string.license_restriction), barcodeData.licenseRestriction);
                    frontResult.put(getString(R.string.license_endorsement), barcodeData.licenseEndorsement);
                    frontResult.put(getString(R.string.issue_date), barcodeData.issueDate);
                    frontResult.put(getString(R.string.organ_donor), barcodeData.organDonor);
                    frontResult.put(getString(R.string.height_in_ft), barcodeData.heightinFT);
                    frontResult.put(getString(R.string.height_in_cm), barcodeData.heightCM);
                    frontResult.put(getString(R.string.full_name), barcodeData.fullName);
                    frontResult.put(getString(R.string.full_name), barcodeData.fullName1);
                    frontResult.put(getString(R.string.weight_in_lbs), barcodeData.weightLBS);
                    frontResult.put(getString(R.string.weight_in_kg), barcodeData.weightKG);
                    frontResult.put(getString(R.string.name_prefix), barcodeData.namePrefix);
                    frontResult.put(getString(R.string.name_suffix), barcodeData.nameSuffix);
                    frontResult.put(getString(R.string.prefix), barcodeData.Prefix);
                    frontResult.put(getString(R.string.suffix), barcodeData.Suffix);
                    frontResult.put(getString(R.string.suffix), barcodeData.Suffix1);
                    frontResult.put(getString(R.string.eye_color), barcodeData.eyeColor);
                    frontResult.put(getString(R.string.hair_color), barcodeData.hairColor);
                    frontResult.put(getString(R.string.issue_time), barcodeData.issueTime);
                    frontResult.put(getString(R.string.number_of_duplicate), barcodeData.numberDuplicate);
                    frontResult.put(getString(R.string.unique_customer_id), barcodeData.uniqueCustomerId);
                    frontResult.put(getString(R.string.social_security_number), barcodeData.socialSecurityNo);
                    frontResult.put(getString(R.string.social_security_number), barcodeData.socialSecurityNo1);
                    frontResult.put(getString(R.string.under_18), barcodeData.under18);
                    frontResult.put(getString(R.string.under_19), barcodeData.under19);
                    frontResult.put(getString(R.string.under_21), barcodeData.under21);
                    frontResult.put(getString(R.string.permit_classification_code), barcodeData.permitClassification);
                    frontResult.put(getString(R.string.veteran_indicator), barcodeData.veteranIndicator);
                    frontResult.put(getString(R.string.permit_issue), barcodeData.permitIssue);
                    frontResult.put(getString(R.string.permit_expire), barcodeData.permitExpire);
                    frontResult.put(getString(R.string.permit_restriction), barcodeData.permitRestriction);
                    frontResult.put(getString(R.string.permit_endorsement), barcodeData.permitEndorsement);
                    frontResult.put(getString(R.string.court_restriction), barcodeData.courtRestriction);
                    frontResult.put(getString(R.string.inventory_control_no), barcodeData.inventoryNo);
                    frontResult.put(getString(R.string.race_ethnicity), barcodeData.raceEthnicity);
                    frontResult.put(getString(R.string.standard_vehicle_class), barcodeData.standardVehicleClass);
                    frontResult.put(getString(R.string.document_discriminator), barcodeData.documentDiscriminator);
                    frontResult.put(getString(R.string.ResidenceCity), barcodeData.ResidenceCity);
                    frontResult.put(getString(R.string.ResidenceJurisdictionCode), barcodeData.ResidenceJurisdictionCode);
                    frontResult.put(getString(R.string.ResidencePostalCode), barcodeData.ResidencePostalCode);
                    frontResult.put(getString(R.string.MedicalIndicatorCodes), barcodeData.MedicalIndicatorCodes);
                    frontResult.put(getString(R.string.NonResidentIndicator), barcodeData.NonResidentIndicator);
                    frontResult.put(getString(R.string.VirginiaSpecificClass), barcodeData.VirginiaSpecificClass);
                    frontResult.put(getString(R.string.VirginiaSpecificRestrictions), barcodeData.VirginiaSpecificRestrictions);
                    frontResult.put(getString(R.string.VirginiaSpecificEndorsements), barcodeData.VirginiaSpecificEndorsements);
                    frontResult.put(getString(R.string.PhysicalDescriptionWeight), barcodeData.PhysicalDescriptionWeight);
                    frontResult.put(getString(R.string.CountryTerritoryOfIssuance), barcodeData.CountryTerritoryOfIssuance);
                    frontResult.put(getString(R.string.FederalCommercialVehicleCodes), barcodeData.FederalCommercialVehicleCodes);
                    frontResult.put(getString(R.string.PlaceOfBirth), barcodeData.PlaceOfBirth);
                    frontResult.put(getString(R.string.StandardEndorsementCode), barcodeData.StandardEndorsementCode);
                    frontResult.put(getString(R.string.StandardRestrictionCode), barcodeData.StandardRestrictionCode);
                    frontResult.put(getString(R.string.JuriSpeciVehiClassiDescri), barcodeData.JuriSpeciVehiClassiDescri);
                    frontResult.put(getString(R.string.JuriSpeciRestriCodeDescri), barcodeData.JuriSpeciRestriCodeDescri);
                    frontResult.put(getString(R.string.ComplianceType), barcodeData.ComplianceType);
                    frontResult.put(getString(R.string.CardRevisionDate), barcodeData.CardRevisionDate);
                    frontResult.put(getString(R.string.HazMatEndorsementExpiryDate), barcodeData.HazMatEndorsementExpiryDate);
                    frontResult.put(getString(R.string.LimitedDurationDocumentIndicator), barcodeData.LimitedDurationDocumentIndicator);
                    frontResult.put(getString(R.string.FamilyNameTruncation), barcodeData.FamilyNameTruncation);
                    frontResult.put(getString(R.string.FirstNamesTruncation), barcodeData.FirstNamesTruncation);
                    frontResult.put(getString(R.string.MiddleNamesTruncation), barcodeData.MiddleNamesTruncation);
                    frontResult.put(getString(R.string.organ_donor_indicator), barcodeData.OrganDonorIndicator);
                    frontResult.put(getString(R.string.PermitIdentifier), barcodeData.PermitIdentifier);
                    frontResult.put(getString(R.string.AuditInformation), barcodeData.AuditInformation);
                    frontResult.put(getString(R.string.JurisdictionSpecific), barcodeData.JurisdictionSpecific);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            if (data != null) {
                OcrData.MapData frontData = data.getFrontData();
                OcrData.MapData backData = data.getBackData();
                if (frontData != null) {
                    List<OcrData.MapData.ScannedData> frontScanData = frontData.getOcr_data();
                    for (int i = 0; i < frontScanData.size(); i++) {
                        if (frontScanData.get(i).getKey() != null) {
                            try {
                                if (frontScanData.get(i).getKey().equalsIgnoreCase("signature")) {
                                    byte[] decodedString = Base64.decode(frontScanData.get(i).getKey_data(), android.util.Base64.DEFAULT);
                                    String path = getFilesDir().getAbsolutePath();
                                    OutputStream fOut = null;
                                    File file = new File(path, getSaltString() + "_signature.jpg");
                                    Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);

                                    frontResult.put(frontScanData.get(i).getKey(), "file://"+file.getAbsolutePath());

                                    try {
                                        fOut = new FileOutputStream(file);
                                    } catch (FileNotFoundException e) {
                                        e.printStackTrace();
                                    }
                                    decodedByte.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
                                    try {
                                        fOut.flush(); // Not really required
                                        fOut.close();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                } else {
                                    frontResult.put(frontScanData.get(i).getKey(), frontScanData.get(i).getKey_data());
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
                if (backData != null) {
                    List<OcrData.MapData.ScannedData> frontScanData = backData.getOcr_data();
                    for (int i = 0; i < frontScanData.size(); i++) {
                        if (frontScanData.get(i).getKey() != null) {
                            try {
                                Log.e("OCR", frontScanData.get(i).getKey());
                                backResult.put(frontScanData.get(i).getKey(), frontScanData.get(i).getKey_data());
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                    }
                }
            }
            try {
                if (faceUri != null) {
                    results.put("face", faceUri);
                }
                if (frontUri != null) {
                    results.put("front_img", frontUri);
                }
                if (backUri != null) {
                    results.put("back_img", backUri);
                }
                results.put("type", type);
                results.put("back_data", backResult);
                results.put("front_data", frontResult);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            ACCURAService.ocrCL.success(results);
//                cameraView.onDestroy();
            finish();
//            }
            return;
        }
    }

    /**
     * @param titleCode    to display scan card message on top of border Frame
     * @param errorMessage To display process message.
     *                     null if message is not available
     * @param isFlip       To set your customize animation after complete front scan
     */
    @Override
    public void onProcessUpdate(int titleCode, String errorMessage, boolean isFlip) {
        AccuraLog.loge(TAG, "onProcessUpdate :-> " + titleCode + "," + errorMessage + "," + isFlip);
        Message message;
        if (getTitleMessage(titleCode) != null) {
            /**
             *
             * 1. Scan Frontside of Card Name // for front side ocr
             * 2. Scan Backside of Card Name // for back side ocr
             * 3. Scan Card Name // only for single side ocr
             * 4. Scan Front Side of Document // for MRZ and PDF417
             * 5. Now Scan Back Side of Document // for MRZ and PDF417
             * 6. Scan Number Plate // for DL plate
             */

            message = new Message();
            message.what = 0;
            message.obj = getTitleMessage(titleCode);
            handler.sendMessage(message);
//            tvTitle.setText(title);
        }
        if (errorMessage != null) {
            message = new Message();
            message.what = 1;
            message.obj = getErrorMessage(errorMessage);
            handler.sendMessage(message);
//            tvScanMessage.setText(message);
        }
        if (isFlip) {
            message = new Message();
            message.what = 2;
            handler.sendMessage(message);//  to set default animation or remove this line to set your customize animation
        }

    }

    private String getTitleMessage(int titleCode) {
        Bundle bundle = getIntent().getExtras();
        if (titleCode < 0) return null;
        switch (titleCode) {
            case RecogEngine.SCAN_TITLE_OCR_FRONT:// for front side ocr;
                return String.format(bundle.getString("SCAN_TITLE_OCR_FRONT", res.getString(R.string.SCAN_TITLE_OCR_FRONT)), cardName);
            case RecogEngine.SCAN_TITLE_OCR_BACK: // for back side ocr
                return String.format(bundle.getString("SCAN_TITLE_OCR_BACK", res.getString(R.string.SCAN_TITLE_OCR_BACK)), cardName);
            case RecogEngine.SCAN_TITLE_OCR: // only for single side ocr
                return String.format(bundle.getString("SCAN_TITLE_OCR", res.getString(R.string.SCAN_TITLE_OCR)), cardName);
            case RecogEngine.SCAN_TITLE_MRZ_PDF417_FRONT:// for front side MRZ and PDF417
                if (recogType == RecogType.BANKCARD) {
                    return bundle.getString("SCAN_TITLE_MRZ_PDF417_FRONT_BANKCARD", res.getString(R.string.SCAN_TITLE_MRZ_PDF417_FRONT_BANKCARD));
                } else if (recogType == RecogType.BARCODE) {
                    return bundle.getString("SCAN_TITLE_MRZ_PDF417_FRONT_BARCODE", res.getString(R.string.SCAN_TITLE_MRZ_PDF417_FRONT_BARCODE));
                } else
                    return bundle.getString("SCAN_TITLE_MRZ_PDF417_FRONT_DEFAULT", res.getString(R.string.SCAN_TITLE_MRZ_PDF417_FRONT_DEFAULT));
            case RecogEngine.SCAN_TITLE_MRZ_PDF417_BACK: // for back side MRZ and PDF417
                return bundle.getString("SCAN_TITLE_MRZ_PDF417_BACK", res.getString(R.string.SCAN_TITLE_MRZ_PDF417_BACK));
            case RecogEngine.SCAN_TITLE_DLPLATE: // for DL plate
                return bundle.getString("SCAN_TITLE_DLPLATE", res.getString(R.string.SCAN_TITLE_DLPLATE));
            default:
                return "";
        }
    }

    private String getErrorMessage(String s) {
        Bundle bundle = getIntent().getExtras();
        switch (s) {
            case RecogEngine.ACCURA_ERROR_CODE_MOTION:
                return bundle.getString("ACCURA_ERROR_CODE_MOTION", res.getString(R.string.ACCURA_ERROR_CODE_MOTION));
            case RecogEngine.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME:
                return bundle.getString("ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME", res.getString(R.string.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME));
            case RecogEngine.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME:
                return bundle.getString("ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME", res.getString(R.string.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME));
            case RecogEngine.ACCURA_ERROR_CODE_PROCESSING:
                return bundle.getString("ACCURA_ERROR_CODE_PROCESSING", res.getString(R.string.ACCURA_ERROR_CODE_PROCESSING));
            case RecogEngine.ACCURA_ERROR_CODE_BLUR_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_BLUR_DOCUMENT", res.getString(R.string.ACCURA_ERROR_CODE_BLUR_DOCUMENT));
            case RecogEngine.ACCURA_ERROR_CODE_FACE_BLUR:
                return bundle.getString("ACCURA_ERROR_CODE_FACE_BLUR", res.getString(R.string.ACCURA_ERROR_CODE_FACE_BLUR));
            case RecogEngine.ACCURA_ERROR_CODE_GLARE_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_GLARE_DOCUMENT", res.getString(R.string.ACCURA_ERROR_CODE_GLARE_DOCUMENT));
            case RecogEngine.ACCURA_ERROR_CODE_HOLOGRAM:
                return bundle.getString("ACCURA_ERROR_CODE_HOLOGRAM", res.getString(R.string.ACCURA_ERROR_CODE_HOLOGRAM));
            case RecogEngine.ACCURA_ERROR_CODE_DARK_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_DARK_DOCUMENT", res.getString(R.string.ACCURA_ERROR_CODE_DARK_DOCUMENT));
            case RecogEngine.ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT", res.getString(R.string.ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT));
            case RecogEngine.ACCURA_ERROR_CODE_FACE:
                return bundle.getString("ACCURA_ERROR_CODE_FACE", res.getString(R.string.ACCURA_ERROR_CODE_FACE));
            case RecogEngine.ACCURA_ERROR_CODE_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_MRZ", res.getString(R.string.ACCURA_ERROR_CODE_MRZ));
            case RecogEngine.ACCURA_ERROR_CODE_PASSPORT_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_PASSPORT_MRZ", res.getString(R.string.ACCURA_ERROR_CODE_PASSPORT_MRZ));
            case RecogEngine.ACCURA_ERROR_CODE_ID_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_ID_MRZ", res.getString(R.string.ACCURA_ERROR_CODE_ID_MRZ));
            case RecogEngine.ACCURA_ERROR_CODE_VISA_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_VISA_MRZ", res.getString(R.string.ACCURA_ERROR_CODE_VISA_MRZ));
            case RecogEngine.ACCURA_ERROR_CODE_WRONG_SIDE:
                return bundle.getString("ACCURA_ERROR_CODE_WRONG_SIDE", res.getString(R.string.ACCURA_ERROR_CODE_WRONG_SIDE));
            case RecogEngine.ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE:
                return bundle.getString("ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE", res.getString(R.string.ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE));
            default:
                return s;
        }
    }

    @Override
    public void onError(final String errorMessage) {
        // stop ocr if failed
        tvScanMessage.setText(errorMessage);
        Runnable runnable = () -> Toast.makeText(OcrActivity.this, errorMessage, Toast.LENGTH_LONG).show();
        runOnUiThread(runnable);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == 101) {
                Runtime.getRuntime().gc(); // To clear garbage
                //<editor-fold desc="Call CameraView#startOcrScan(true) To start again Camera Preview
                //And CameraView#startOcrScan(false) To start first time">
                if (cameraView != null) {
                    isBack = false;
                    cameraView.setFrontSide();
                    AccuraLog.loge(TAG, "Rescan Document");
                    cameraView.startOcrScan(true);
                    if (types_dialog != null && types_dialog.isShowing()) types_dialog.dismiss();
                }
                //</editor-fold>
            }
        }
    }

    /**
     * Set Barcode selection Dialog to Scan only selected barcode format
     * See {@link BarcodeFormat} to get All Barcode format
     * And use Array List {@link BarcodeFormat#getList()}
     */
    int mposition = 0;

    private void barcodeFormatDialog() {
        List<BarcodeFormat> CODE_NAMES = BarcodeFormat.getList();
        if (getIntent().getExtras().containsKey("sub-type")) {
            if (cameraView != null) cameraView.stopCamera();
            int barcodeType = Integer.parseInt(getIntent().getExtras().getString("sub-type"));
            for (int i = 0; i < CODE_NAMES.size(); i++) {
                CODE_NAMES.get(i).isSelected = CODE_NAMES.get(i).formatsType == barcodeType;
            }
            cameraView.setBarcodeFormat(barcodeType);
            if (cameraView != null) cameraView.startCamera();
        }
    }
}