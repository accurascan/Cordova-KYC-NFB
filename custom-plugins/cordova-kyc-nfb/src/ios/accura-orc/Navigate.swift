package accura.kyc.plugin;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;

import com.accurascan.facedetection.utils.AccuraLivenessLog;
import com.accurascan.ocr.mrz.model.ContryModel;
import com.accurascan.ocr.mrz.util.AccuraLog;
import com.docrecog.scan.MRZDocumentType;
import com.docrecog.scan.RecogEngine;
import com.docrecog.scan.RecogType;
import com.google.gson.Gson;

import java.util.List;

import accura.kyc.app.R;

public class NavigateActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_navigate);
        Bundle bundle = getIntent().getExtras();
        List<ContryModel> modelList = null;
        try {
            RecogEngine recogEngine = new RecogEngine();
            AccuraLog.enableLogs(false); // make sure to disable logs in release mode
            AccuraLivenessLog.setDEBUG(false);
            recogEngine.setDialog(false); // setDialog(false) To set your custom dialog for license validation
            RecogEngine.SDKModel sdkModel = recogEngine.initEngine(this);
            if (sdkModel.i >= 0) {
                // if OCR enable then get card list
                Resources res = getResources();
                recogEngine.setBlurPercentage(this, bundle.getInt("rg_setBlurPercentage", res.getInteger(R.integer.rg_setBlurPercentage)));
                recogEngine.setFaceBlurPercentage(this, bundle.getInt("rg_setFaceBlurPercentage", res.getInteger(R.integer.rg_setFaceBlurPercentage)));
                recogEngine.setGlarePercentage(this, bundle.getInt("rg_setGlarePercentage_0", res.getInteger(R.integer.rg_setGlarePercentage_0)), bundle.getInt("rg_setGlarePercentage_1", res.getInteger(R.integer.rg_setGlarePercentage_1)));
                recogEngine.isCheckPhotoCopy(this, bundle.getBoolean("rg_isCheckPhotoCopy", res.getBoolean(R.bool.rg_isCheckPhotoCopy)));
                recogEngine.SetHologramDetection(this, bundle.getBoolean("rg_SetHologramDetection", res.getBoolean(R.bool.rg_SetHologramDetection)));
                recogEngine.setLowLightTolerance(this, bundle.getInt("rg_setLowLightTolerance", res.getInteger(R.integer.rg_setLowLightTolerance)));
                recogEngine.setMotionThreshold(this, bundle.getInt("rg_setMotionThreshold", res.getInteger(R.integer.rg_setMotionThreshold)));
                Intent ocr = new Intent(this, OcrActivity.class);
                ocr.putExtras(bundle);
                if (bundle.getString("type").equalsIgnoreCase("ocr")) {
                    int cardType = bundle.getInt("card_type", 0);
                    if (cardType == 1) {
                        RecogType.PDF417.attachTo(ocr);
                    } else if (cardType == 2) {
                        RecogType.DL_PLATE.attachTo(ocr);
                    } else {
                        RecogType.OCR.attachTo(ocr);
                    }
                } else if (bundle.getString("type").equalsIgnoreCase("mrz")) {
                    String mrzType = bundle.getString("sub-type");
                    switch (mrzType) {
                        case "passport_mrz":
                            RecogType.MRZ.attachTo(ocr);
                            MRZDocumentType.PASSPORT_MRZ.attachTo(ocr);
                            ocr.putExtra("card_name", getResources().getString(R.string.passport_mrz));
                            break;
                        case "id_mrz":
                            RecogType.MRZ.attachTo(ocr);
                            MRZDocumentType.ID_CARD_MRZ.attachTo(ocr);
                            ocr.putExtra("card_name", getResources().getString(R.string.id_mrz));
                            break;
                        case "visa_mrz":
                            RecogType.MRZ.attachTo(ocr);
                            MRZDocumentType.VISA_MRZ.attachTo(ocr);
                            ocr.putExtra("card_name", getResources().getString(R.string.visa_mrz));
                            break;
                        default:
                            RecogType.MRZ.attachTo(ocr);
                            MRZDocumentType.NONE.attachTo(ocr);
                            ocr.putExtra("card_name", getResources().getString(R.string.other_mrz));
                    }
                } else if (bundle.getString("type").equalsIgnoreCase("bankcard")) {
                    RecogType.BANKCARD.attachTo(ocr);
                    ocr.putExtras(getIntent().getExtras());
                    ocr.putExtra("card_name", getResources().getString(R.string.bank_card));
                } else if (bundle.getString("type").equalsIgnoreCase("barcode")) {
                    RecogType.BARCODE.attachTo(ocr);
                    ocr.putExtras(getIntent().getExtras());
                    ocr.putExtra("card_name", "Barcode");
                } else {

                }
                startActivity(ocr);
            } else {
                ACCURAService.ocrCL.error("No Licence Found");
                this.finish();
            }

        } catch (Exception e) {
            Log.e("ee", e.getLocalizedMessage());
            ACCURAService.ocrCL.error("No Action Found");
            this.finish();
        }
    }
    @Override
    protected void onResume() {
        super.onResume();
        if (ACCURAService.ocrCLProcess) {
            ACCURAService.ocrCLProcess = false;
            this.finish();
        }
    }
}