import Foundation
import UIKit
import AccuraKYC
struct gl {
    static var livenessConf:[String: Any] = [:]
    static var ocrClId = "0"
    static var face1: UIImage? = nil
    static var face2: UIImage? = nil
    static var face1Detect: NSFaceRegion? = nil
    static var face2Detect: NSFaceRegion? = nil
    static var withFace = false
    static var type = ""
    static var audio: URL? = nil
    static var PDFDetectFace: UIImage? = nil
    static var PDFFrontSide: UIImage? = nil
    static var PDFBackSide: UIImage? = nil
}
@objc(ACCURAService) class ACCURAService : CDVPlugin {
    static func cleanFaceData() {
        gl.face1 = nil
        gl.face2 = nil
        gl.face1Detect = nil
        gl.face2Detect = nil
        gl.withFace = false
        LivenessConfigs.isLivenessGetVideo = false
        print(LivenessConfigs.livenessVideo)
        if LivenessConfigs.livenessVideo != "" {
            if FileManager.default.fileExists(atPath: LivenessConfigs.livenessVideo) {
                do {
                    try FileManager.default.removeItem(atPath: LivenessConfigs.livenessVideo)
                } catch {
                    print(error.localizedDescription)
                }
                
            } else {
                print(LivenessConfigs.livenessVideo)
            }
        }
        
        LivenessConfigs.livenessVideo = ""
    }
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    static func getImageFromUri(path: String) -> UIImage? {
        print(path)
        if let img = UIImage.init(contentsOfFile: path.replacingOccurrences(of: "file://", with: "")) {
            return img;
        }
        return nil
    }
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    static func getImageUri(img: UIImage, name: String?) -> String? {
        var file = ACCURAService.randomString(length: 6)
        if let filename = name {
            file = filename
        }
        if let data = img.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(file).jpg")
            try? data.write(to: filename)
            print(filename.absoluteString)
            return filename.absoluteString
        }
        
        return nil
    }
    static func resizeImage(image: UIImage, targetSize: CGRect) -> UIImage {
       let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
       var newX = targetSize.origin.x - (targetSize.size.width * 0.4)
       var newY = targetSize.origin.y - (targetSize.size.height * 0.4)
       var newWidth = targetSize.size.width * 1.8
       var newHeight = targetSize.size.height * 1.8
       if newX < 0 {
           newX = 0
       }
       if newY < 0 {
           newY = 0
       }
       if newX + newWidth > image.size.width{
           newWidth = image.size.width - newX
       }
       if newY + newHeight > image.size.height{
           newHeight = image.size.height - newY
       }
       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
       let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
       let image1: UIImage = UIImage(cgImage: imageRef)
       return image1
   }
    
    @objc(cleanFaceMatch:)
    func cleanFM(command: CDVInvokedUrlCommand) {
        ACCURAService.cleanFaceData()
    }
    
    @objc(getMetadata:)
    func getMetadata(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR
        )
        var accuraCameraWrapper: AccuraCameraWrapper? = nil
        var results:[String: Any] = [:]
        results["isValid"] = false
        accuraCameraWrapper = AccuraCameraWrapper.init()
        let sdkModel = accuraCameraWrapper!.loadEngine(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String)
        if sdkModel!.i > 0 {
            var countries:[Any] = []
            results["sdk_version"] = ""
            results["isValid"] = true
            results["isOCR"] = sdkModel!.isOCREnable
            results["isOCREnable"] = sdkModel!.isOCREnable
            results["isBarcode"] = sdkModel!.isBarcodeEnable
            results["isBankCard"] = sdkModel!.isBankCardEnable
            results["isMRZ"] = sdkModel!.isMRZEnable
            results["countries"] = countries
            if  sdkModel!.isBarcodeEnable {
                var barcodes:[[String: String]] = []
                barcodes.append(["name": "ALL FORMATS","type": "ALL FORMATS"])
                barcodes.append(["name": "EAN-8", "type": "EAN-8"])
                barcodes.append(["name": "EAN-13", "type": "EAN-13"])
                barcodes.append(["name": "PDF417", "type": "PDF417"])
                barcodes.append(["name": "AZTEC", "type": "AZTEC"])
                barcodes.append(["name": "CODE 128", "type": "CODE 128"])
                barcodes.append(["name": "CODE 39", "type": "CODE 39"])
                barcodes.append(["name": "CODE 93", "type": "CODE 93"])
                barcodes.append(["name": "DATA MATRIX", "type": "DATA MATRIX"])
                barcodes.append(["name": "QR CODE", "type": "QR CODE"])
                barcodes.append(["name": "UPC-E", "type": "UPC-E"])
                barcodes.append(["name": "UPC-A", "type": "UPC-A"])
                barcodes.append(["name": "CODABAR", "type": "CODABAR"])
                results["barcodes"] = barcodes
            }
        }
        pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: results
        )
        self.commandDelegate!.send(
            pluginResult,
            callbackId: command.callbackId
        )
        
    }
    
    @objc(startMRZ:)
    func startMRZ(command: CDVInvokedUrlCommand) {
        gl.ocrClId = command.callbackId
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.mrzType = command.argument(at: 1) as! String
        ScanConfigs.mrzCountryList = command.argument(at: 2) as! String
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 3) as! String
        gl.type = "mrz"
        let viewController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.commandDelegate = self.commandDelegate
        viewController.isCheckScanOCR = false
        viewController.isCheckCardMRZ = true
        viewController.countryid = 0
        if ScanConfigs.mrzType == "passport_mrz" {
            viewController.MRZDocType = 1
        } else if ScanConfigs.mrzType == "id_mrz" {
            viewController.MRZDocType = 2
        } else if ScanConfigs.mrzType == "visa_mrz" {
            viewController.MRZDocType = 3
        } else {
            viewController.MRZDocType = 0
        }
        viewController.cordovaViewController = self.viewController
        viewController.win = self.viewController.view.window
        checkForDownloadMedia(vc: viewController)
    }
    
    @objc(startBankCard:)
    func startBankCard(command: CDVInvokedUrlCommand) {
        gl.ocrClId = command.callbackId
        gl.type = "bankcard"
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 1) as! String
        let viewController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.commandDelegate = self.commandDelegate
        viewController.isCheckScanOCR = true
//        viewController.countryid = 31
        viewController.cardType = 3
        viewController.cordovaViewController = self.viewController
        viewController.win = self.viewController.view.window
        checkForDownloadMedia(vc: viewController)
    }
    
    @objc(startBarcode:)
    func startBarcode(command: CDVInvokedUrlCommand) {
        gl.ocrClId = command.callbackId
        gl.type = "barcode"
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.barcodeType = command.argument(at: 1) as! String
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 2) as! String
        let viewController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.commandDelegate = self.commandDelegate
        viewController.isBarCode = true
        viewController.cordovaViewController = self.viewController
        viewController.win = self.viewController.view.window
        checkForDownloadMedia(vc: viewController)
    }
    
    @objc(startOcrWithCard:)
    func startOcrWithCard(command: CDVInvokedUrlCommand) {
        gl.type = "ocr"
        gl.ocrClId = command.callbackId
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.CountryId = command.argument(at: 1) as! Int
        ScanConfigs.CardId = command.argument(at: 2) as! Int
        ScanConfigs.CardName = command.argument(at: 3) as! String
        ScanConfigs.CardType = command.argument(at: 4) as! Int
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 5) as! String
        let viewController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.cardType = command.argument(at: 4) as! Int
        viewController.commandDelegate = self.commandDelegate
        viewController.isCheckScanOCR = true
        viewController.countryid = command.argument(at: 1) as! Int
        viewController.cardid = command.argument(at: 2) as! Int
        viewController.docName = command.argument(at: 3) as! String
        if viewController.cardType == 1 {
            viewController.isBarCode = true
        }
        viewController.cordovaViewController = self.viewController
        viewController.win = self.viewController.view.window
        checkForDownloadMedia(vc: viewController)
    }
    
    @objc(startLiveness:)
    func startLiveness(command: CDVInvokedUrlCommand) {
        //set liveness url
        gl.type = "lv"
        gl.ocrClId = command.callbackId
        gl.face1 = nil
        gl.face2 = nil
        gl.face1Detect = nil
        gl.face2Detect = nil
        gl.withFace = true
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 2) as! String
        let LVController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "LVController") as! LVController
        LVController.commandDelegate = self.commandDelegate
        LVController.livenessConfigs = command.argument(at: 1) as! [String: Any]
        LVController.cordovaViewController = self.viewController
        LVController.win = self.viewController.view.window
        let nav = NavigationController(rootViewController: LVController)
        self.viewController.view.window?.rootViewController = nav
    }
    
    
    
    @objc(startFaceMatch:)
    func startFaceMatch(command: CDVInvokedUrlCommand) {
        gl.type = "fm"
        gl.ocrClId = command.callbackId
        gl.withFace = true
        let fmInit = EngineWrapper.isEngineInit()
        if !fmInit{
            EngineWrapper.faceEngineInit()
        }
        let fmValue = EngineWrapper.getEngineInitValue() //get engineWrapper load status
        if fmValue == -20{
            sendError(msg: "Key not found")
            return
        }else if fmValue == -15{
            sendError(msg: "License Invalid")
            return
        }
        ScanConfigs.accuraConfigs = command.argument(at: 0) as! [String: Any]
        ScanConfigs.accuraConfigs["app_orientation"] = command.argument(at: 2) as! String
        let FMController = UIStoryboard(name: "MainStoryboard_iPhone", bundle: nil).instantiateViewController(withIdentifier: "FMController") as! FMController
        FMController.commandDelegate = self.commandDelegate
        FMController.livenessConfigs = command.argument(at: 1) as! [String: Any]
        FMController.cordovaViewController = self.viewController
        FMController.win = self.viewController.view.window
        
        let nav = NavigationController(rootViewController: FMController)
        self.viewController.view.window?.rootViewController = nav
        
    }
    
    func checkForDownloadMedia(vc: UIViewController) {
        gl.audio = nil
        if ScanConfigs.accuraConfigs.index(forKey: "rg_customMediaURL") != nil{
            let audioUrl = URL(string: ScanConfigs.accuraConfigs["rg_customMediaURL"] as! String)
            if let url = audioUrl {
                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                loadingIndicator.center = self.viewController.view.center
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.gray
                loadingIndicator.startAnimating();
                self.viewController.view.addSubview(loadingIndicator)
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent("alert.mp3")
                print(destinationUrl)

                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    do {
                        try FileManager.default.removeItem(at: destinationUrl)
                    } catch {
                        loadingIndicator.removeFromSuperview()
                    }
                    
                }
                URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        
                        gl.audio = destinationUrl
                        DispatchQueue.main.async { [self] in
                            loadingIndicator.removeFromSuperview()
                            let nav = UINavigationController(rootViewController: vc)
                            self.viewController.view.window?.rootViewController = nav
                        }
                    } catch let error as NSError {
                        gl.audio = nil
                        DispatchQueue.main.async { [self] in
                            loadingIndicator.removeFromSuperview()
                            let nav = NavigationController(rootViewController: vc)
                            self.viewController.view.window?.rootViewController = nav
                        }
                    }
                }).resume()
            } else {
                let nav = NavigationController(rootViewController: vc)
                self.viewController.view.window?.rootViewController = nav
            }

        } else {
            let nav = NavigationController(rootViewController: vc)
            self.viewController.view.window?.rootViewController = nav
        }
    }
    
    
    func sendError(msg: String) {
        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: msg
        )
        self.commandDelegate!.send(
            pluginResult,
            callbackId: gl.ocrClId
        )
    }
}
class NavigationController: UINavigationController {

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return getCurrentOrientation(isMask: true) as! UIInterfaceOrientationMask
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return getCurrentOrientation(isMask: false) as! UIInterfaceOrientation
    }
    
    func getCurrentOrientation(isMask: Bool) -> Any {
        let orientastion = ScanConfigs.accuraConfigs["app_orientation"] as! String
        if gl.type == "fm" || gl.type == "lv" {
            if isMask {
                return UIInterfaceOrientationMask.portrait
            } else {
                return UIInterfaceOrientation.portrait
            }
        }
        if(orientastion.contains("portrait")) {
            if isMask {
                return UIInterfaceOrientationMask.portrait
            } else {
                return UIInterfaceOrientation.portrait
            }
        } else {
            if isMask {
                return UIInterfaceOrientationMask.landscape
            } else {
                return UIInterfaceOrientation.landscapeRight
            }
        }
    }

}

