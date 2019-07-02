//
//  ViewController.swift
//  AcuantiOSSDKSwiftSample
//
//  Created by Tapas Behera on 7/27/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import UIKit

protocol ResultCancelDelegate {
    func didFinishShowingResult()
}



class ViewController: UIViewController ,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate,ResultCancelDelegate{
    
    
    
    
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
    var resultData:Any!
    var side:Int! // 0 front , 1 back
    var cardType:AcuantCardType!
    
    var username : String = "XXXXXXXXXXXX"
    var password : String = "XXXXXXXXXXXX"
    var subscription : String = "XXXXXXXXXXXX"
    var url : String = "https://devconnect.assureid.net/AssureIDService"
    
    @IBOutlet var backCardImageView: UIImageView!
    @IBOutlet var frontCardImageView: UIImageView!
    @IBOutlet var frontImageViewLabel: UILabel!
    @IBOutlet var backImageViewLabel: UILabel!
    
    @IBOutlet var processButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI Initialization  starts
        hideFrontUI()
        hideBackUI()
        hideProcessButton()
        side = 0;
        
        //UI Initialization ends
        
        // Create and add the view to the screen.
        if(username == "" || password == "" || subscription == "" || url == ""){
            return;
        }
        DispatchQueue.main.async() {
            self.progressHUD = ProgressHUD(text: "Validating key")
            self.view.addSubview(self.progressHUD)
        }
        instance = AcuantMobileSDKController.initAcuantMobileSDK(withUsername: username, password:password, subscription:subscription, url:url, andDelegate: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UI
    func showFrontUI(){
        frontCardImageView.layer.cornerRadius = 8.0
        frontCardImageView.clipsToBounds = true
        frontCardImageView.isHidden=false;
        frontCardImageView.image = nil;
        frontCardImageView.layer.borderWidth=2
        frontImageViewLabel.isHidden=false
    }
    func hideFrontUI(){
        frontCardImageView.layer.cornerRadius = 8.0
        frontCardImageView.clipsToBounds = true
        frontCardImageView.isHidden=true;
        frontCardImageView.image = nil;
        frontCardImageView.layer.borderWidth=2
        frontImageViewLabel.isHidden=true
    }
    
    func showBackUI(){
        backCardImageView.layer.cornerRadius = 8.0
        backCardImageView.clipsToBounds = true
        backCardImageView.isHidden=false;
        backCardImageView.image = nil;
        backCardImageView.layer.borderWidth=2
        backImageViewLabel.isHidden=false;
    }
    
    func hideBackUI(){
        backCardImageView.layer.cornerRadius = 8.0
        backCardImageView.clipsToBounds = true
        backCardImageView.isHidden=true;
        backCardImageView.image = nil;
        backCardImageView.layer.borderWidth=2
        backImageViewLabel.isHidden=true;
    }
    
    
    func showProcessButton(){
        processButton.isHidden=false;
        processButton.isUserInteractionEnabled=true;
        processButton.isEnabled=true;
    }
    
    func hideProcessButton(){
        processButton.isHidden=true;
    }
    
    func resetData(){
        side = 0;
        resultData = nil;
        backCardImageView.image = nil;
        frontCardImageView.image = nil;
    }
    
    
    //Show Camera
    func showCamera(){
        if(instance != nil){
            instance.showManualCameraInterface(in: self, delegate: self, cardType: AcuantCardTypeDriversLicenseCard, region:AcuantCardRegionUnitedStates, andBackSide: true)
        }
    }
    
    
    // UI Callbacks
    func didFinishShowingResult() {
        resetData()
        hideProcessButton()
        hideFrontUI()
        hideBackUI()
    }
    
    
    func showBackButton() -> Bool {
        return true;
    }
    
    
    //User Actions
    @IBAction func captureTapped(_ sender: Any) {
        showFrontUI()
        hideBackUI()
        resetData()
    }
    
    @IBAction func processTapped(_ sender: Any) {
        let errorMessage : String = validateState()
        if(errorMessage == ""){
            DispatchQueue.main.async() {
                if(self.progressHUD == nil){
                    self.progressHUD = ProgressHUD(text: "Capturing data")
                    self.view.addSubview(self.progressHUD)
                    
                }else{
                    self.progressHUD.text = "Capturing data";
                    self.progressHUD.show()
                }
            }
            
            let options : AcuantCardProcessRequestOptions  = AcuantCardProcessRequestOptions.defaultRequestOptions(for: cardType);
            instance.processCard(with: options, frontImage: frontCardImageView.image, back: backCardImageView.image, barcodeString: nil)
            
        }else{
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                errorMessage, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    @IBAction func frontImageTapped(_ sender: Any) {
        side = 0;
        showCamera()
    }
    
    @IBAction func backImageTapped(_ sender: Any) {
        side = 1;
        showCamera()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let destinationVC :ResultViewController = segue.destination as! ResultViewController
            destinationVC.cancelDelegate = self
            destinationVC.cardData=resultData as! NSDictionary
            destinationVC.cardType=cardType
            destinationVC.username=username
            destinationVC.password=password
        }
        
    }
    
    
    //Data validation
    func validateState()->String{
        var retValue : String!
        retValue = "";
        if(frontCardImageView.image==nil){
            retValue = "Please provide an ID image";
        }
        return retValue;
    }
    
    
    
    // Web service callbacks
    func mobileSDKWasValidated(_ wasValidated: Bool) {
        DispatchQueue.main.async() {
            self.progressHUD.hide()
        }
        if(wasValidated){
            print("valid license key")
        }else{
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                "Credntials are not valid", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didFinishProcessingCard(with result: AcuantCardResult!) {
        
        
    }
    
    func didFinishProcessingCard(withAssureIDResult json: Any!) {
        resultData=json;
        DispatchQueue.main.async() {
            self.progressHUD.hide()
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
    }
    
    // Capture Callbacks
    func didCaptureCropImage(_ cardImage: UIImage!, scanBackSide: Bool, andCardType cardType: AcuantCardType, withImageMetrics imageMetrics: [AnyHashable : Any]!) {
        self.cardType=cardType
        if(cardType == AcuantCardTypeDriversLicenseCard){
            if(side==0){
                frontCardImageView.image=cardImage
                let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                    "Scan the backside of the drivers license", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler:{(alert: UIAlertAction!) in
                    self.showCamera()
                    self.side=1
                }))
                self.present(alertController, animated: true, completion: nil)
            }else{
                showBackUI()
                backCardImageView.image=cardImage
                backImageViewLabel.isHidden=true
                showProcessButton();
            }
        }else{
            frontCardImageView.image=cardImage
            showProcessButton();
        }
        
    }
    
    func didCaptureData(_ data: String!) {
        
    }
    
    
    func didFailToCaptureCropImage() {
        DispatchQueue.main.async() {
            let alertController = UIAlertController(title: "AcuantSwiftSample", message:
                "Failed to capture Image.Please try again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func didFinishValidatingImage(with result: AcuantCardResult!) {
        
    }
    
    
    // Errors
    func didFailWithError(_ error: AcuantError!) {
        if(progressHUD != nil){
            progressHUD.hide()
        }
        showErrorAlert(error)
        
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

