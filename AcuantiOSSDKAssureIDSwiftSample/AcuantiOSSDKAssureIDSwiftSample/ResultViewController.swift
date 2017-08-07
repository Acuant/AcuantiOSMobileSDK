//
//  ResultViewController.swift
//  AcuantiOSSDKSwiftSample
//
//  Created by Tapas Behera on 7/28/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import UIKit

enum AssureIDResult : Int{
    case Unknown = 0;
    case Passed = 1;
    case Failed = 2;
    case Skipped = 3;
    case Caution = 4;
    case Attention = 5;
}


class ResultViewController: UIViewController{
    
    var cancelDelegate:ResultCancelDelegate!
    var cardData:NSDictionary!
    var cardType:AcuantCardType!
    var separator: String!
    var username:String!
    var password:String!
    
    @IBOutlet var frontImage: UIImageView!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var faceImage: UIImageView!
    @IBOutlet var signImage: UIImageView!
    
    @IBOutlet var resultTextView: UITextView!
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion:{
            self.cancelDelegate.didFinishShowingResult()
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        separator = "  -  "
        initializeUI();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeUI(){
        var fieldString : String = "";
        
        let Result : Int = cardData["Result"] as! Int
        
        let Alerts  = cardData["Alerts"]
        
        if(Result==0 || Result==1 || Result==2){
            if(Result==0){
                fieldString = "Authentication Result : Unknown\n"
            }else if(Result==1){
                fieldString = "Authentication Result : Passed\n"
            }else if(Result==2){
                fieldString = "Authentication Result : Failed\n"
            }else{
                for alert in Alerts as! [[String:String]]{
                    fieldString.append("Alert"+separator+alert["Key"]!)
                }
            }
        }
        
        
        let fieldArray = cardData["Fields"]
        
        
        var faceImageURL : String = "";
        var signatureImageURL : String = "";
        
        for field in fieldArray as! [NSDictionary] {
            let key : String = field["Name"]! as! String
            let value : String = field["Value"]! as! String
            if(key=="Photo"){
                faceImageURL = value
            }else if(key=="Signature"){
                signatureImageURL = value
            }else{
                var str : String =   key + separator + value
                str.append("\n")
                fieldString.append(str);
            }
        }
        
        
        resultTextView.text = fieldString
        if(faceImageURL != ""){
            faceImage.downloadedFrom(urlStr: faceImageURL, username: username, password: password)
        }
        
        if(signatureImageURL != ""){
            signImage.downloadedFrom(urlStr: signatureImageURL, username: username, password: password)
        }
        
        
        let images = cardData["Images"]
        for imageDict in images as! [NSDictionary]{
            if(imageDict["Side"] != nil){
                let side : Int = imageDict["Side"] as! Int;
                if(side == 0 && imageDict["Uri"] != nil){
                    frontImage.downloadedFrom(urlStr: imageDict["Uri"]! as! String, username: username, password: password)
                }else if(side == 1 && imageDict["Uri"] != nil){
                    backImage.downloadedFrom(urlStr: imageDict["Uri"]! as! String, username: username, password: password)
                }
            }
        }
        
    }
}
