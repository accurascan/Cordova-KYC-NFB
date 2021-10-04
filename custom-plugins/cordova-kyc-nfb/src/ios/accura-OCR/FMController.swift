import UIKit
import AccuraKYC

class FMController: UIViewController, FacematchData {
    var livenessConfigs:[String: Any] = [:]
    var commandDelegate:CDVCommandDelegate? = nil
    var cordovaViewController:UIViewController? = nil
    var audioPath: URL? = nil
    var isFacematchDone = false
    func facematchData(_ FaceImage: UIImage!) {
        isFacematchDone = true
        if gl.face1 == nil {
            var results:[String: Any] = [:]
            results["status"] = false
            results["with_face"] = gl.withFace
            gl.face1 = FaceImage
            if gl.face1Detect == nil {
                if let img1 = ACCURAService.getImageUri(img: gl.face1!, name: nil) {
                    results["img_1"] = img1
                }
                
            } else {
                if let img1 = ACCURAService.getImageUri(img: ACCURAService.resizeImage(image: gl.face1!, targetSize: gl.face1Detect!.bound), name: nil) {
                    results["img_1"] = img1
                }
            }
            if results.index(forKey: "img_1") != nil {
                let pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: results
                )
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: gl.ocrClId
                )
            } else {
                let pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: "Error found in data. Please try again"
                )
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: gl.ocrClId
                )
            }
            closeMe()
            
        } else {
            gl.face1Detect = EngineWrapper.detectSourceFaces(gl.face1)
            gl.face2 = FaceImage
            gl.face2Detect = EngineWrapper.detectTargetFaces(FaceImage, feature1: gl.face1Detect!.feature)
            let score = EngineWrapper.identify(gl.face1Detect!.feature, featurebuff2: gl.face2Detect!.feature)
            var results:[String: Any] = [:]
            results["status"] = true
            results["score"] = score*100
            results["with_face"] = gl.withFace
            if !gl.withFace {
                if let img1 = ACCURAService.getImageUri(img: gl.face1!, name: nil) {
                    results["img_1"] = img1
                }
                if let img2 = ACCURAService.getImageUri(img: gl.face2!, name: nil) {
                    results["img_2"] = img2
                }
                
            } else {
                if let img1 = ACCURAService.getImageUri(img: ACCURAService.resizeImage(image: gl.face2!, targetSize: gl.face2Detect!.bound), name: nil) {
                    results["detect"] = img1
                }
            }
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: results
            )
            self.commandDelegate!.send(
                pluginResult,
                callbackId: gl.ocrClId
            )
            ACCURAService.cleanFaceData()
            closeMe()
        }
    }
    func closeMe() {
        self.win!.rootViewController = cordovaViewController!
    }
    var win: UIWindow? = nil
    
    func facematchViewDisappear() {
        if !isFacematchDone {
           closeMe()
        }
        if gl.face2 != nil {
            EngineWrapper.faceEngineClose()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ScanConfigs.accuraConfigs.index(forKey: "with_face") != nil {
            gl.withFace = ScanConfigs.accuraConfigs["with_face"] as! Bool
            if gl.withFace {
                if ScanConfigs.accuraConfigs.index(forKey: "face_uri") != nil {
                    if let face = ACCURAService.getImageFromUri(path: ScanConfigs.accuraConfigs["face_uri"] as! String) {
                        gl.face1 = face
                        gl.face1Detect = EngineWrapper.detectSourceFaces(gl.face1)
                    }
                } 
                if ScanConfigs.accuraConfigs.index(forKey: "face_base64") != nil {
                    let newImageData = Data(base64Encoded: ScanConfigs.accuraConfigs["face_base64"] as! String)
                    if let newImageData = newImageData {
                        gl.face1 = UIImage(data: newImageData)
                        gl.face1Detect = EngineWrapper.detectSourceFaces(gl.face1)
                    }
                }
            } else {
                if ScanConfigs.accuraConfigs.index(forKey: "face1") == nil {
                    let pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_ERROR,
                        messageAs: "Missing face1 configration"
                    )
                    self.commandDelegate!.send(
                        pluginResult,
                        callbackId: gl.ocrClId
                    )
                    closeMe()
                    return
                }
                if ScanConfigs.accuraConfigs.index(forKey: "face2") != nil {
                    let isFace2 = ScanConfigs.accuraConfigs["face2"] as! Bool
                    if isFace2 {
                        if gl.face1 == nil {
                            let pluginResult = CDVPluginResult(
                                status: CDVCommandStatus_ERROR,
                                messageAs: "Please first take Face1 Photo"
                            )
                            self.commandDelegate!.send(
                                pluginResult,
                                callbackId: gl.ocrClId
                            )
                            closeMe()
                            return
                        } else {
                            gl.face1Detect = EngineWrapper.detectSourceFaces(gl.face1)
                        }
                    }
                } else {
                    let pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_ERROR,
                        messageAs: "Missing face2 configration"
                    )
                    self.commandDelegate!.send(
                        pluginResult,
                        callbackId: gl.ocrClId
                    )
                    closeMe()
                    return
                }
            }
            
        } else {
            let pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: "Missing with_face configration"
            )
            self.commandDelegate!.send(
                pluginResult,
                callbackId: gl.ocrClId
            )
            closeMe()
            return
        }
        startFC()
    }
    
    func startFC() {
        let liveness = Facematch()
        // To customize your screen theme and feed back messages
        liveness.setBackGroundColor(FaceMatchConfigs.backgroundColor)
        if livenessConfigs["livenessBackground"] != nil {
            liveness.setBackGroundColor(livenessConfigs["livenessBackground"] as! String)
        }
        liveness.setCloseIconColor(LivenessConfigs.livenessCloseIconColor)
        if livenessConfigs["livenessCloseIconColor"] != nil {
            liveness.setCloseIconColor(livenessConfigs["livenessCloseIconColor"] as! String)
        }
        liveness.setFeedbackBackGroundColor(LivenessConfigs.livenessfeedbackBackground)
        if livenessConfigs["livenessfeedbackBackground"] != nil {
            liveness.setFeedbackBackGroundColor(livenessConfigs["livenessfeedbackBackground"] as! String)
        }
        liveness.setFeedbackTextColor(LivenessConfigs.livenessfeedbackTextColor)
        if livenessConfigs["livenessfeedbackTextColor"] != nil {
            liveness.setFeedbackTextColor(livenessConfigs["livenessfeedbackTextColor"] as! String)
        }
        liveness.setFeedbackTextSize(Float(LivenessConfigs.feedbackTextSize))
        if livenessConfigs["feedbackTextSize"] != nil {
            liveness.setFeedbackTextSize(livenessConfigs["feedbackTextSize"] as! Float)
        }
        liveness.setFeedBackframeMessage(LivenessConfigs.feedBackframeMessage)
        if livenessConfigs["feedBackframeMessage"] != nil {
            liveness.setFeedBackframeMessage(livenessConfigs["feedBackframeMessage"] as! String)
        }
        liveness.setFeedBackAwayMessage(LivenessConfigs.feedBackAwayMessage)
        if livenessConfigs["feedBackAwayMessage"] != nil {
            liveness.setFeedBackAwayMessage(livenessConfigs["feedBackAwayMessage"] as! String)
        }
        liveness.setFeedBackOpenEyesMessage(LivenessConfigs.feedBackOpenEyesMessage)
        if livenessConfigs["feedBackOpenEyesMessage"] != nil {
            liveness.setFeedBackOpenEyesMessage(livenessConfigs["feedBackOpenEyesMessage"] as! String)
        }
        liveness.setFeedBackCloserMessage(LivenessConfigs.feedBackCloserMessage)
        if livenessConfigs["feedBackCloserMessage"] != nil {
            liveness.setFeedBackCloserMessage(livenessConfigs["feedBackCloserMessage"] as! String)
        }
        liveness.setFeedBackCenterMessage(LivenessConfigs.feedBackCenterMessage)
        if livenessConfigs["feedBackCenterMessage"] != nil {
            liveness.setFeedBackCenterMessage(livenessConfigs["feedBackCenterMessage"] as! String)
        }
        liveness.setFeedbackMultipleFaceMessage(LivenessConfigs.feedBackMultipleFaceMessage)
        if livenessConfigs["feedBackMultipleFaceMessage"] != nil {
            liveness.setFeedbackMultipleFaceMessage(livenessConfigs["feedBackMultipleFaceMessage"] as! String)
        }
        liveness.setFeedBackFaceSteadymessage(LivenessConfigs.feedBackHeadStraightMessage)
        if livenessConfigs["feedBackHeadStraightMessage"] != nil {
            liveness.setFeedBackFaceSteadymessage(livenessConfigs["feedBackHeadStraightMessage"] as! String)
        }
        liveness.setFeedBackLowLightMessage(LivenessConfigs.feedBackLowLightMessage)
        if livenessConfigs["feedBackLowLightMessage"] != nil {
            liveness.setFeedBackLowLightMessage(livenessConfigs["feedBackLowLightMessage"] as! String)
        }
        liveness.setFeedBackBlurFaceMessage(LivenessConfigs.feedBackBlurFaceMessage)
        if livenessConfigs["feedBackBlurFaceMessage"] != nil {
            liveness.setFeedBackBlurFaceMessage(livenessConfigs["feedBackBlurFaceMessage"] as! String)
        }
        liveness.setFeedBackGlareFaceMessage(LivenessConfigs.feedBackGlareFaceMessage)
        if livenessConfigs["feedBackGlareFaceMessage"] != nil {
            liveness.setFeedBackGlareFaceMessage(livenessConfigs["feedBackGlareFaceMessage"] as! String)
        }
        
        liveness.isShowLogoImage(LivenessConfigs.isShowLogo)
        if livenessConfigs.index(forKey: "isShowLogo") != nil {
            liveness.isShowLogoImage(livenessConfigs["isShowLogo"] as! Bool)
        }
        liveness.setLogoImage("ic_logo.png")
        
        liveness.setFeedBackProcessingMessage(LivenessConfigs.feedBackProcessingMessage)
        if livenessConfigs.index(forKey: "feedBackProcessingMessage") != nil {
            liveness.setFeedBackProcessingMessage(livenessConfigs["feedBackProcessingMessage"] as! String)
        }
        
        // 0 for clean face and 100 for Blurry face
        liveness.setBlurPercentage(Int32(LivenessConfigs.setBlurPercentage)) // set blure percentage -1 to remove this filter
        
        if livenessConfigs["setBlurPercentage"] != nil {
            liveness.setBlurPercentage(livenessConfigs["setBlurPercentage"] as! Int32)
        }
        
        var glarePerc0 = Int32(LivenessConfigs.setGlarePercentage_0)
        if livenessConfigs["setGlarePercentage_0"] != nil {
            glarePerc0 = livenessConfigs["setGlarePercentage_0"] as! Int32
        }
        var glarePerc1 = Int32(LivenessConfigs.setGlarePercentage_1)
        if livenessConfigs["setGlarePercentage_1"] != nil {
            glarePerc1 = livenessConfigs["setGlarePercentage_1"] as! Int32
        }
        // Set min and max percentage for glare
        liveness.setGlarePercentage(glarePerc0, glarePerc1) //set glaremin -1 and glaremax -1 to remove this filter
        // Do any additional setup after loading the view.
        liveness.setFacematch(self)
    }
    

}
