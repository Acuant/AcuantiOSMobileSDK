//
//  ViewController.swift
//  AcuantiOSSDKSwiftSample
//
//  Created by Tapas Behera on 7/27/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import UIKit

protocol RegionSelectionDelegate {
    func didSelectRegion(regionID: AcuantCardRegion)
}

protocol ResultCancelDelegate {
    func didFinishShowingResult()
}



class ViewController: UIViewController ,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate,AcuantFacialCaptureDelegate,RegionSelectionDelegate,ResultCancelDelegate{
    
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
    
    var instance:AcuantMobileSDKController!
    var progressHUD:ProgressHUD!
    var cardRegion : AcuantCardRegion!
    var cardType:AcuantCardType!
    var cardSide:Int!
    var barcodeString:String!
    var resultData:AcuantCardResult!
    var facialData:AcuantFacialData!
    var capturingData:Bool!
    var matchingFace:Bool!
    var faceImage:NSData!
    var facialAlertController:UIAlertController!
    var dataCapturefailed:Bool!
    
    @IBOutlet var backCardImageView: UIImageView!
    @IBOutlet var frontCardImageView: UIImageView!
    @IBOutlet var frontImageViewLabel: UILabel!
    @IBOutlet var backImageViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI Initialization  starts
        resetUI()
        
        //UI Initialization ends
        
        // Create and add the view to the screen.
        progressHUD = ProgressHUD(text: "Validating key")
        self.view.addSubview(progressHUD)
        instance = AcuantMobileSDKController.initAcuantMobileSDK(withLicenseKey: "XXXXXXXXXXXX", andDelegate: self)
        self.view.isUserInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UI
    func resetUI(){
        frontCardImageView.layer.cornerRadius = 8.0
        frontCardImageView.clipsToBounds = true
        frontCardImageView.isHidden=true;
        frontCardImageView.image = nil;
        frontCardImageView.layer.borderWidth=2
        frontImageViewLabel.isHidden=true
        
        backCardImageView.layer.cornerRadius = 8.0
        backCardImageView.clipsToBounds = true
        backCardImageView.isHidden=true;
        backCardImageView.image = nil;
        backCardImageView.layer.borderWidth=2
        backImageViewLabel.isHidden=true;
        
    }
    
    func resetData(){
        capturingData = false;
        matchingFace = false;
        dataCapturefailed = false;
        barcodeString=nil;
        resultData = nil;
        facialData = nil;
        faceImage = nil;
    }
    
    
    //Show Camera
    func showCamera(){
        if(cardType==AcuantCardTypeDriversLicenseCard){
            if(instance.isAssureIDAllowed()){
                instance.setWidth(2024);
            }else{
                instance.setWidth(1250);
            }
            
            instance.showManualCameraInterface(in: self, delegate: self, cardType: cardType, region: cardRegion, andBackSide: true)
        }else if(cardType==AcuantCardTypePassportCard){
            instance.setWidth(1478);
            instance.showManualCameraInterface(in: self, delegate: self, cardType: cardType, region:cardRegion, andBackSide: false)
        }else if(cardType==AcuantCardTypeMedicalInsuranceCard){
            instance.setWidth(1500);
            instance.showManualCameraInterface(in: self, delegate: self, cardType: cardType, region:cardRegion, andBackSide: true)
        }

    }
    
    //show barcodeCamera
    func showBarcodeCamera(){
        instance.showBarcodeCameraInterface(in: self, delegate: self, cardType: cardType, andRegion: cardRegion);
    }
    
    //Facial flow
    func captureSelfie(){
        matchingFace = true;
        facialAlertController = UIAlertController(title: "AcuantSwiftSample", message:
            "Please position your face in front of the front camera and blink when red rectangle appears.", preferredStyle: UIAlertController.Style.alert)
        facialAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {(alert: UIAlertAction!) in
            self.showSelfiCaptureInterface();
        }))
        
        self.present(facialAlertController, animated: true, completion: nil)
    }
    
    //Facial capture
    func showSelfiCaptureInterface(){
        let screenRect : CGRect = UIScreen.main.bounds;
        let screenWidth : CGFloat = screenRect.size.width;
        var messageFrame : CGRect = CGRect(x:0,y:50,width:screenWidth,height:20);
        
        let message : NSMutableAttributedString = NSMutableAttributedString.init(string: "Get closer until Red Rectangle appears and Blink");
        message.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range: NSMakeRange(0, message.length));
        let range : NSRange = NSMakeRange(17,13) ;
        var font : UIFont =  UIFont.systemFont(ofSize: 13)
        var boldFont : UIFont = UIFont.boldSystemFont(ofSize: 14)
        
        if(DeviceType.IS_IPHONE_5){
            font = UIFont.systemFont(ofSize:11);
            boldFont = UIFont.boldSystemFont(ofSize:12);
        }
        message.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        message.addAttribute(NSAttributedString.Key.font,value:font, range: NSMakeRange(0, message.length))
        message.addAttribute(NSAttributedString.Key.font,value:boldFont, range: range)
        
        let orientation : UIDeviceOrientation = UIDevice.current.orientation;
        if(UIDevice.current.orientation.isLandscape){
            let screenHeight  : CGFloat = screenRect.size.height;
            messageFrame = CGRect(x:0,y:50,width:screenHeight,height:20);
            
        }
        AcuantFacialRecognitionViewController.presentFacialCaptureInterface(with: self, withSDK: instance, in: self, withCancelButton: true,withCancelButtonRect: CGRect.init(x: 10, y: 20, width: 75, height: 20), withWaterMark: "Powered by Acuant", withBlinkMessage: message, in: messageFrame);
    }
    
    
    // UI Callbacks
    func didSelectRegion(regionID: AcuantCardRegion) {
        cardRegion = regionID
        resetUI()
        if(cardRegion==AcuantCardRegionUnitedStates || cardRegion==AcuantCardRegionCanada){
            frontCardImageView.isHidden = false;
            frontImageViewLabel.isHidden = false;
        }else{
            frontCardImageView.isHidden = false;
            backCardImageView.isHidden = false;
            frontImageViewLabel.isHidden=false;
            backImageViewLabel.isHidden=false;
        }
    }
    func didFinishShowingResult() {
        cardRegion = AcuantCardRegionUnitedStates
        resetUI()
        resetData()
    }
    
    
    func showBackButton() -> Bool {
        return true;
    }
    
    
    //User Actions
    @IBAction func driversLicenseTapped(_ sender: Any) {
        resetData();
        cardType = AcuantCardTypeDriversLicenseCard
        performSegue(withIdentifier: "toRegionSelection", sender: nil)
        
    }
    
    @IBAction func passportTapped(_ sender: Any) {
        resetData();
        cardType = AcuantCardTypePassportCard
        cardRegion = AcuantCardRegionUnitedStates
        frontCardImageView.isHidden = false
        frontImageViewLabel.isHidden = false
        
        backCardImageView.isHidden = true
        backImageViewLabel.isHidden = true
    }
    
    @IBAction func medicalCardTapped(_ sender: Any) {
        resetData();
        cardType = AcuantCardTypeMedicalInsuranceCard
        cardRegion = AcuantCardRegionUnitedStates
        frontCardImageView.isHidden = false
        frontImageViewLabel.isHidden = false
        backCardImageView.isHidden = false
        backImageViewLabel.isHidden = false
    }
    
    
    @IBAction func processTapped(_ sender: Any) {
        let errorMessage : String = validateState()
        if(errorMessage == ""){
            capturingData = true;
            if(instance.isFacialEnabled() == false || cardType == AcuantCardTypeMedicalInsuranceCard){
                if(progressHUD == nil){
                    progressHUD = ProgressHUD(text: "Capturing data")
                    self.view.addSubview(progressHUD)
                    
                }else{
                    progressHUD.text = "Capturing data";
                    progressHUD.show()
                }
            }else{
                captureSelfie()
            }
            
            let options : AcuantCardProcessRequestOptions  = AcuantCardProcessRequestOptions.defaultRequestOptions(for: cardType);
            
            //Optionally, configure the options to the desired value
            options.autoDetectState = true;
            options.stateID = -1;
            options.reformatImage = true;
            options.reformatImageColor = 0;
            options.dpi = Int32(150.0);
            options.cropImage = false;
            options.faceDetection = true;
            options.signatureDetection = true;
            options.region = self.cardRegion;
            instance.processFrontCardImage(frontCardImageView.image, backCardImage: backCardImageView.image, andStringData: barcodeString, with: self, with: options)
            self.view.isUserInteractionEnabled = false
            
            
            
        }else{
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                errorMessage, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func frontImageTapped(_ sender: Any) {
        print("front image tapped")
        cardSide=0
        showCamera()
    }
    
    @IBAction func backImageTapped(_ sender: Any) {
        print("back image tapped")
        cardSide=1
        showCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegionSelection"{
            let destinationVC :RegionSelectionViewController = segue.destination as! RegionSelectionViewController
            destinationVC.selectionDelegate = self
        }else if segue.identifier == "toResult"{
            let destinationVC :ResultViewController = segue.destination as! ResultViewController
            destinationVC.cancelDelegate = self
            destinationVC.cardType=cardType
            destinationVC.cardData=resultData
            destinationVC.region=cardRegion
            destinationVC.facialData = facialData
        }
        
    }
    
    func imageForHelpImageView() -> UIImage! {
        let image = UIImage(named:"PDF417.png")
        return image;
    }
    
    //Data validation
    func validateState()->String{
        var retValue : String!
        retValue = "";
        if(frontCardImageView.image==nil){
            retValue = "Please provide a front image";
        }else if(cardType==AcuantCardTypeDriversLicenseCard && cardRegion==AcuantCardRegionUnitedStates && (barcodeString=="" || barcodeString==nil)){
            retValue = "Please scan the barcode in the drivers license";
        }else if(cardType==AcuantCardTypeDriversLicenseCard && cardRegion==AcuantCardRegionCanada && (barcodeString=="" || barcodeString==nil)){
            retValue = "Please scan the barcode in the drivers license";
        }else if(cardType==AcuantCardTypeDriversLicenseCard && cardRegion != AcuantCardRegionUnitedStates && cardRegion != AcuantCardRegionCanada && backCardImageView.image==nil){
            retValue = "Please provide a back image";
        }
        return retValue;
    }
    
    
    
    // Web service callbacks
    func mobileSDKWasValidated(_ wasValidated: Bool) {
        self.view.isUserInteractionEnabled = true
        progressHUD.hide()
        if(wasValidated){
            print("valid license key")
        }else{
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                "License key is not valid", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didFinishValidatingImage(with result: AcuantCardResult!) {
        if((result as? AcuantFacialData) != nil){
            matchingFace = false;
            print("facial completed")
            facialData = result as! AcuantFacialData
        }
        if(capturingData == false && matchingFace == false){
            progressHUD.hide()
            performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
    
    func didFinishProcessingCard(with result: AcuantCardResult!) {
        self.view.isUserInteractionEnabled = true
        if ((result as? AcuantDriversLicenseCard) != nil) {
            capturingData=false;
            let data : AcuantDriversLicenseCard = result as! AcuantDriversLicenseCard;
            resultData = data;
            if(data.faceImage != nil){
                faceImage = data.faceImage! as NSData;
            }
        }else if((result as? AcuantPassaportCard) != nil){
            capturingData = false;
            let data : AcuantPassaportCard = result as! AcuantPassaportCard;
            resultData = data;
            if(data.faceImage != nil){
                faceImage = data.faceImage! as NSData;
            }
        }else if((result as? AcuantMedicalInsuranceCard) != nil){
            capturingData = false;
            let data : AcuantMedicalInsuranceCard = result as! AcuantMedicalInsuranceCard;
            resultData = data;
        }
        if(capturingData == false && matchingFace == false){
            progressHUD.hide()
            performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
    // Capture Callbacks
    func didCaptureCropImage(_ cardImage: UIImage!, scanBackSide: Bool, andCardType cardType: AcuantCardType, withImageMetrics imageMetrics: [AnyHashable : Any]!) {
        print("didCaptureCropImage");
        if(cardSide==0){
            frontImageViewLabel.isHidden=true;
            frontCardImageView.image=cardImage
            if(cardType==AcuantCardTypeDriversLicenseCard && (cardRegion==AcuantCardRegionUnitedStates || cardRegion==AcuantCardRegionCanada)){
                let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                    "Scan the barcode in the backside of the drivers license", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(alert: UIAlertAction!) in
                    self.showBarcodeCamera()
                    self.cardSide=1
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }else if(cardType==AcuantCardTypeDriversLicenseCard){
                let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                    "Scan the backside of the drivers license", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(alert: UIAlertAction!) in
                    self.showCamera()
                    self.cardSide=1
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }else if(cardSide==1){
            backImageViewLabel.isHidden=true;
            backCardImageView.image=cardImage
        }
    }
    
    
    func didFailToCaptureCropImage() {
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                "Failed to capture Image.Please try again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didCaptureData(_ data: String!) {
        print("didCaptureData");
        barcodeString=data;
    }
    
    
    //Facial call backs
    func didCancelFacialRecognition() {
        
    }
    
    func shouldShowFacialTimeoutAlert() -> Bool {
        return false
    }
    
    func didFinishFacialRecognition(_ image: UIImage!) {
        self.view.isUserInteractionEnabled = false;
        if(progressHUD == nil){
            progressHUD = ProgressHUD(text: "Capturing data")
            self.view.addSubview(progressHUD)
            
        }else{
            progressHUD.text = "Capturing data";
            progressHUD.show()
        }
        DispatchQueue.global(qos: .background).async{
            while(self.capturingData && self.dataCapturefailed == false){
                Thread.sleep(forTimeInterval: 1)
            }
            if(self.dataCapturefailed == true){
                return;
            }
            DispatchQueue.main.async{
                //Selfie Image
                let frontSideImage :UIImage = image;
                //DL Photo
                let dlPhoto : NSData = self.faceImage;
                
                //Obtain the default AcuantCardProcessRequestOptions object for the type of card you want to process (License card for this example)
                let options : AcuantCardProcessRequestOptions = AcuantCardProcessRequestOptions.defaultRequestOptions(for: AcuantCardTypeFacial);
                
                // Now, perform the request
                self.instance.validatePhotoOne(frontSideImage, withImage: dlPhoto as Data?, with: self, with: options);
                
            }
        }
    }
    
    
    func didTimeoutFacialRecognition(_ lastImage: UIImage!) {
        
    }
    
    func facialRecognitionTimeout() -> Int32 {
        return 20;
    }
    
    func imageForFacialBackButton() -> UIImage! {
        return nil
    }
    
    
    func messageToBeShownAfterFaceRectangleAppears() -> NSAttributedString! {
        return nil;
    }
    
    func frameWhereMessageToBeShownAfterFaceRectangleAppears() -> CGRect {
        return CGRect.zero;
    }
    
    // Errors
    func didFailWithError(_ error: AcuantError!) {
        progressHUD.hide()
        dataCapturefailed=true;
        self.view.isUserInteractionEnabled = true
        if(facialAlertController != nil && facialAlertController.isBeingPresented){
            facialAlertController.dismiss(animated: false){
                self.showErrorAlert(error)
            }
        }else{
            showErrorAlert(error);
        }
        
    }
    
    func showErrorAlert(_ error: AcuantError!){
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                error.errorMessage, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

