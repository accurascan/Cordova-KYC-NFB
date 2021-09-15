package accura.kyc.plugin;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.pm.ActivityInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.accurascan.ocr.mrz.CameraView;
import com.accurascan.ocr.mrz.interfaces.OcrCallback;
import com.accurascan.ocr.mrz.model.RecogResult;
import com.accurascan.ocr.mrz.motiondetection.SensorsActivity;
import com.accurascan.ocr.mrz.util.AccuraLog;
import com.docrecog.scan.MRZDocumentType;
import com.docrecog.scan.RecogEngine;
import com.docrecog.scan.RecogType;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.WeakReference;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;
import java.util.List;

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
    private String mrzCountryList;
    RecogType recogType;
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

    public int R(String name, String type) {
        return getResources().getIdentifier(name, type, getPackageName());
    }

    boolean isSetBackSide = false;
    String isCustomMediaURL = null;

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
        }
        ACCURAService.ocrCLProcess = true;
        setTheme(R("AppThemeNoActionBar", "style"));
        requestWindowFeature(Window.FEATURE_NO_TITLE); // Hide the window title.
        setContentView(R("ocr_activity", "layout"));
        AccuraLog.loge(TAG, "Start Camera Activity");
        init();
        try {
            RecogEngine recogEngine = new RecogEngine();
            boolean isLogEnable = bundle.getBoolean("enableLogs", false);
            AccuraLog.enableLogs(isLogEnable); // make sure to disable logs in release mode
            if (isLogEnable) {
                AccuraLog.refreshLogfile(getApplicationContext());
            }
            recogEngine.setDialog(false); // setDialog(false) To set your custom dialog for license validation
            RecogEngine.SDKModel sdkModel = recogEngine.initEngine(this);
            if (sdkModel.i >= 0) {
                // if OCR enable then get card list
                Resources res = getResources();
                recogEngine.setBlurPercentage(this, bundle.getInt("rg_setBlurPercentage", res.getInteger(R("rg_setBlurPercentage", "integer"))));
                recogEngine.setFaceBlurPercentage(this, bundle.getInt("rg_setFaceBlurPercentage", res.getInteger(R("rg_setFaceBlurPercentage", "integer"))));
                recogEngine.setGlarePercentage(this, bundle.getInt("rg_setGlarePercentage_0", res.getInteger(R("rg_setGlarePercentage_0", "integer"))), bundle.getInt("rg_setGlarePercentage_1", res.getInteger(R("rg_setGlarePercentage_1", "integer"))));
                recogEngine.isCheckPhotoCopy(this, bundle.getBoolean("rg_isCheckPhotoCopy", res.getBoolean(R("rg_isCheckPhotoCopy", "bool"))));
                recogEngine.SetHologramDetection(this, bundle.getBoolean("rg_SetHologramDetection", res.getBoolean(R("rg_SetHologramDetection", "bool"))));
                recogEngine.setLowLightTolerance(this, bundle.getInt("rg_setLowLightTolerance", res.getInteger(R("rg_setLowLightTolerance", "integer"))));
                recogEngine.setMotionThreshold(this, bundle.getInt("rg_setMotionThreshold", res.getInteger(R("rg_setMotionThreshold", "integer"))));
                if (bundle.getString("type").equalsIgnoreCase("mrz")) {
                    String mrz = bundle.getString("sub-type");
                    mrzCountryList = bundle.getString("country-list");
                    switch (mrz) {
                        case "passport_mrz":
                            recogType = RecogType.MRZ;
                            mrzType = MRZDocumentType.PASSPORT_MRZ;
                            cardName = getResources().getString(R("passport_mrz", "string"));
                            break;
                        case "id_mrz":
                            recogType = RecogType.MRZ;
                            mrzType = MRZDocumentType.ID_CARD_MRZ;
                            cardName = getResources().getString(R("id_mrz", "string"));
                            break;
                        case "visa_mrz":
                            recogType = RecogType.MRZ;
                            mrzType = MRZDocumentType.VISA_MRZ;
                            cardName = getResources().getString(R("visa_mrz", "string"));
                            break;
                        default:
                            recogType = RecogType.MRZ;
                            mrzType = MRZDocumentType.NONE;
                            cardName = getResources().getString(R("other_mrz", "string"));
                    }
                }
            } else {
                ACCURAService.ocrCL.error("No Licence Found");
                this.finish();
                ACCURAService.ocrCLProcess = false;
            }

        } catch (Exception e) {
            ACCURAService.ocrCL.error("No Action Found");
            this.finish();
            ACCURAService.ocrCLProcess = false;
        }
        if (mrzType == null) {
            mrzType = MRZDocumentType.NONE;
        }
        cardId = bundle.getInt("card_id", 0);
        countryId = bundle.getInt("country_id", 0);
        if (cardName == null) {
            cardName = bundle.getString("card_name", "");
        }

        AccuraLog.loge(TAG, "RecogType " + recogType);
        AccuraLog.loge(TAG, "Card Id " + cardId);
        AccuraLog.loge(TAG, "Country Id " + countryId);

        initCamera();
    }

    private void initCamera() {
        AccuraLog.loge(TAG, "Initialized camera");

        RelativeLayout linearLayout = findViewById(R("ocr_root", "id")); // layout width and height is match_parent

        cameraView = new CameraView(this);
        if (recogType == RecogType.MRZ) {
            cameraView.setMRZDocumentType(mrzType);
            cameraView.setMRZCountryCodeList(mrzCountryList);
        }
        cameraView.setRecogType(recogType)
                .setView(linearLayout) // To add camera view
                .setCameraFacing(bundle.getInt("rg_setCameraFacing", res.getInteger(R("rg_setCameraFacing", "integer")))) // To set front or back camera.
                .setOcrCallback(this)  // To get Update and Success Call back

//                optional field
                .setEnableMediaPlayer(bundle.getBoolean("rg_setEnableMediaPlayer", res.getBoolean(R("rg_setEnableMediaPlayer", "bool"))));// false to disable default sound and default it is true

        // initialized camera
        isSetBackSide = bundle.getBoolean("rg_setBackSide", false);
        isCustomMediaURL = bundle.getString("rg_customMediaURL", null);
        if (isSetBackSide) {
//            isBack = true;
            cameraView.setBackSide();
        } else {
//            if (isSetBackSide) {
//                Toast.makeText(getApplicationContext(), "")
//            }
            cameraView.setFrontSide();
        }
        recycleOldData();
        if (isCustomMediaURL != null) {
            ACCURAService.ocrCLProcess = true;
            mediaTask = new getMediaByURL().execute(isCustomMediaURL);
        } else {
            cameraView.init();
        }
    }

    public void recycleOldData() {
        try {
            if (RecogResult.getRecogResult() != null) {
                RecogResult.getRecogResult().docFrontBitmap.recycle();
                RecogResult.getRecogResult().faceBitmap.recycle();
                RecogResult.getRecogResult().docBackBitmap.recycle();
            }

        } catch (Exception ignored) {
        }
        RecogResult.setRecogResult(null);
    }

    AsyncTask<String, Integer, String> mediaTask = null;
    ProgressDialog progressDialog = null;

    public class getMediaByURL extends AsyncTask<String, Integer, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            progressDialog = new ProgressDialog(OcrActivity.this);
            progressDialog.setCancelable(false);
            progressDialog.setButton(DialogInterface.BUTTON_NEGATIVE, "Cancel", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    if (mediaTask != null) {
                        mediaTask.cancel(true);
                    }
                }
            });
            progressDialog.setTitle("Downloading Media File");
            progressDialog.show();
        }

        @Override
        protected void onCancelled() {
            super.onCancelled();
            ACCURAService.ocrCL.error("Media downloading cancelled");
            finish();
            ACCURAService.ocrCLProcess = false;
        }

        @Override
        protected String doInBackground(String... aurl) {
            int count;
            try {
                URL url = new URL(aurl[0]);
                URLConnection conexion = url.openConnection();
                conexion.connect();
                int lenghtOfFile = conexion.getContentLength();
                InputStream input = new BufferedInputStream(url.openStream());
                String path = getFilesDir().getAbsolutePath() + File.separator + "media_sound.mp3";
                File soundFile = new File(path);
                if (soundFile.exists()) {
                    if (!soundFile.delete()) {
                        return null;
                    }
                }
                OutputStream output = new FileOutputStream(soundFile.getAbsolutePath());
                byte data[] = new byte[1024];
                long total = 0;
                while ((count = input.read(data)) != -1) {
                    total += count;
                    publishProgress((int) ((total * 100) / lenghtOfFile));
                    output.write(data, 0, count);
                }

                output.flush();
                output.close();
                input.close();
                return soundFile.getAbsolutePath();
            } catch (Exception e) {
                return null;
            }
        }

        @Override
        protected void onPostExecute(String sound) {
            super.onPostExecute(sound);
            progressDialog.hide();
            if (sound != null) {
                File file = new File(sound);
                try {
                    cameraView.setCustomMediaPlayer(MediaPlayer.create(getApplicationContext(), Uri.fromFile(file)));
                    cameraView.init();
                } catch (Exception e) {
                    ACCURAService.ocrCL.error("Failed to open custom media");
                    finish();
                    ACCURAService.ocrCLProcess = false;
                }
            } else {
                ACCURAService.ocrCL.error("Failed to fetch custom media");
                finish();
                ACCURAService.ocrCLProcess = false;
            }
        }
    }

    private void init() {
        viewLeft = findViewById(R("view_left_frame", "id"));
        viewRight = findViewById(R("view_right_frame", "id"));
        borderFrame = findViewById(R("border_frame", "id"));
        tvTitle = findViewById(R("tv_title", "id"));
        tvScanMessage = findViewById(R("tv_scan_msg", "id"));
        imageFlip = findViewById(R("im_flip_image", "id"));
        View btn_flip = findViewById(R("btn_flip", "id"));
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
        Log.e("onDestroy", "onDestroy");
        if (cameraView != null) cameraView.stopCamera();
        if (cameraView != null) cameraView.onDestroy();
        if (progressDialog != null) {
            progressDialog.dismiss();
        }
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

        findViewById(R("ocr_frame", "id")).setVisibility(View.VISIBLE);

    }

    @Override
    public void onScannedComplete(Object result) {
        Runtime.getRuntime().gc(); // To clear garbage
        AccuraLog.loge(TAG, "onScannedComplete: ");
        if (result != null) {
            if (result instanceof RecogResult) {
                /**
                 *  @recogType is {@link RecogType#MRZ}*/
                RecogResult.setRecogResult((RecogResult) result);
                sendDataToResultActivity(RecogType.MRZ);
            }
        } else Toast.makeText(this, "Failed", Toast.LENGTH_SHORT).show();
    }

    private void sendDataToResultActivity(RecogType recogType) {
        if (cameraView != null) cameraView.release(true);
        if (needCallback) {
            RecogResult recogResult = null;
            String frontUri = null, backUri = null, faceUri = null;
            JSONObject results = new JSONObject();
            JSONObject frontResult = new JSONObject();
            JSONObject mrzResult = new JSONObject();
            JSONObject backResult = new JSONObject();
            type = recogType.toString();
            String fileDir = getFilesDir().getAbsolutePath();
            if (recogType == RecogType.MRZ) {
                recogResult = RecogResult.getRecogResult();
                if (recogResult != null) {
                    frontResult = setMRZData(recogResult);
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
                results.put("mrz_data", mrzResult);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            ACCURAService.ocrCL.success(results);
            finish();
            ACCURAService.ocrCLProcess = false;
            return;
        }
    }

    public JSONObject setMRZData(RecogResult recogResult) {
        JSONObject frontResult = new JSONObject();
        try {
            frontResult.put("mrz", recogResult.lines);
            frontResult.put("passportType", recogResult.docType);
            frontResult.put("givenNames", recogResult.givenname);
            frontResult.put("surName", recogResult.surname);
            frontResult.put("passportNumber", recogResult.docnumber);
            frontResult.put("passportNumberChecksum", recogResult.docchecksum);
            frontResult.put("correctPersonalChecksum", recogResult.correctdocchecksum);
            frontResult.put("country", recogResult.country);
            frontResult.put("nationality", recogResult.nationality);
            String s = (recogResult.sex.equals("M")) ? "Male" : ((recogResult.sex.equals("F")) ? "Female" : recogResult.sex);
            frontResult.put("sex", s);
            frontResult.put("birth", recogResult.birth);
            frontResult.put("birthChecksum", recogResult.birthchecksum);
            frontResult.put("correctBirthChecksum", recogResult.correctbirthchecksum);
            frontResult.put("expirationDate", recogResult.expirationdate);
            frontResult.put("expirationDateChecksum", recogResult.expirationchecksum);
            frontResult.put("correctExpirationChecksum", recogResult.correctexpirationchecksum);
            frontResult.put("issueDate", recogResult.issuedate);
            frontResult.put("departmentNumber", recogResult.departmentnumber);
            frontResult.put("personalNumber", recogResult.otherid);
            frontResult.put("personalNumber2", recogResult.otherid2);
            frontResult.put("personalNumberChecksum", recogResult.otheridchecksum);
            frontResult.put("secondRowChecksum", recogResult.secondrowchecksum);
            frontResult.put("correctSecondrowChecksum", recogResult.correctsecondrowchecksum);
            frontResult.put("retval", recogResult.ret);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return frontResult;
    }

    public String getBase64Uri(String base64Str) {
        byte[] decodedString = Base64.decode(base64Str, android.util.Base64.DEFAULT);
        String path = getFilesDir().getAbsolutePath();
        OutputStream fOut = null;
        File file = new File(path, getSaltString() + "_signature.jpg");
        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);

        try {
            fOut = new FileOutputStream(file);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        decodedByte.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
        try {
            fOut.flush(); // Not really required
            fOut.close();
            return "file://" + file.getAbsolutePath();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
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
                return String.format(bundle.getString("SCAN_TITLE_OCR_FRONT", res.getString(R("SCAN_TITLE_OCR_FRONT", "string"))), cardName);
            case RecogEngine.SCAN_TITLE_OCR_BACK: // for back side ocr
                return String.format(bundle.getString("SCAN_TITLE_OCR_BACK", res.getString(R("SCAN_TITLE_OCR_BACK", "string"))), cardName);
            case RecogEngine.SCAN_TITLE_OCR: // only for single side ocr
                return String.format(bundle.getString("SCAN_TITLE_OCR", res.getString(R("SCAN_TITLE_OCR", "string"))), cardName);
            case RecogEngine.SCAN_TITLE_MRZ_PDF417_FRONT:// for front side MRZ and PDF417
                    return bundle.getString("SCAN_TITLE_MRZ_PDF417_FRONT", res.getString(R("SCAN_TITLE_MRZ_PDF417_FRONT", "string")));
            case RecogEngine.SCAN_TITLE_MRZ_PDF417_BACK: // for back side MRZ and PDF417
                return bundle.getString("SCAN_TITLE_MRZ_PDF417_BACK", res.getString(R("SCAN_TITLE_MRZ_PDF417_BACK", "string")));
            case RecogEngine.SCAN_TITLE_DLPLATE: // for DL plate
                return bundle.getString("SCAN_TITLE_DLPLATE", res.getString(R("SCAN_TITLE_DLPLATE", "string")));
            default:
                return "";
        }
    }

    private String getErrorMessage(String s) {
        Bundle bundle = getIntent().getExtras();
        switch (s) {
            case RecogEngine.ACCURA_ERROR_CODE_MOTION:
                return bundle.getString("ACCURA_ERROR_CODE_MOTION", res.getString(R("ACCURA_ERROR_CODE_MOTION", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME:
                return bundle.getString("ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME", res.getString(R("ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME:
                return bundle.getString("ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME", res.getString(R("ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_PROCESSING:
                return bundle.getString("ACCURA_ERROR_CODE_PROCESSING", res.getString(R("ACCURA_ERROR_CODE_PROCESSING", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_BLUR_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_BLUR_DOCUMENT", res.getString(R("ACCURA_ERROR_CODE_BLUR_DOCUMENT", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_FACE_BLUR:
                return bundle.getString("ACCURA_ERROR_CODE_FACE_BLUR", res.getString(R("ACCURA_ERROR_CODE_FACE_BLUR", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_GLARE_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_GLARE_DOCUMENT", res.getString(R("ACCURA_ERROR_CODE_GLARE_DOCUMENT", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_HOLOGRAM:
                return bundle.getString("ACCURA_ERROR_CODE_HOLOGRAM", res.getString(R("ACCURA_ERROR_CODE_HOLOGRAM", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_DARK_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_DARK_DOCUMENT", res.getString(R("ACCURA_ERROR_CODE_DARK_DOCUMENT", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT:
                return bundle.getString("ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT", res.getString(R("ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_FACE:
                return bundle.getString("ACCURA_ERROR_CODE_FACE", res.getString(R("ACCURA_ERROR_CODE_FACE", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_MRZ", res.getString(R("ACCURA_ERROR_CODE_MRZ", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_PASSPORT_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_PASSPORT_MRZ", res.getString(R("ACCURA_ERROR_CODE_PASSPORT_MRZ", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_ID_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_ID_MRZ", res.getString(R("ACCURA_ERROR_CODE_ID_MRZ", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_VISA_MRZ:
                return bundle.getString("ACCURA_ERROR_CODE_VISA_MRZ", res.getString(R("ACCURA_ERROR_CODE_VISA_MRZ", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_WRONG_SIDE:
                return bundle.getString("ACCURA_ERROR_CODE_WRONG_SIDE", res.getString(R("ACCURA_ERROR_CODE_WRONG_SIDE", "string")));
            case RecogEngine.ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE:
                return bundle.getString("ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE", res.getString(R("ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE", "string")));
            default:
                return s;
        }
    }

    @Override
    public void onError(final String errorMessage) {
        // stop ocr if failed
        if (errorMessage.equalsIgnoreCase("Back Side not available") && isSetBackSide) {
            ACCURAService.ocrCL.error(errorMessage);
            finish();
            ACCURAService.ocrCLProcess = false;
        }
        tvScanMessage.setText(errorMessage);
    }

}