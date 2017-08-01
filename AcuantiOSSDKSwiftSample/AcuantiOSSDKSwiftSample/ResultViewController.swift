//
//  ResultViewController.swift
//  AcuantiOSSDKSwiftSample
//
//  Created by Tapas Behera on 7/28/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

import UIKit


class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var cancelDelegate:ResultCancelDelegate!
    var cardData:AcuantCardResult!
    var cardType:AcuantCardType!
    var region:AcuantCardRegion!
    var dataArray:[String]!
    var separator: String!
    var facialData:AcuantFacialData!
    
    @IBOutlet var frontImage: UIImageView!
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var faceImage: UIImageView!
    @IBOutlet var signImage: UIImageView!
    
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
        if (self.cardType == AcuantCardTypeDriversLicenseCard) {
            let data : AcuantDriversLicenseCard = cardData as! AcuantDriversLicenseCard;
            
            if(data.faceImage != nil){
                faceImage.image = UIImage(data:data.faceImage!,scale:1.0);
            }
            if(data.signatureImage != nil){
                signImage.image = UIImage(data:data.signatureImage!,scale:1.0);
            }
            if(data.licenceImage != nil){
                frontImage.image = UIImage(data:data.licenceImage!,scale:1.0)
            }
            if(data.licenceImageTwo != nil){
                backImage.image = UIImage(data:data.licenceImageTwo!,scale:1.0);
            }
            
            var authSummary:String = ""
            var c = 0;
            if(data.authenticationResultSummaryList != nil && data.authenticationResultSummaryList.count>0){
                for summary in data.authenticationResultSummaryList{
                    if(c==0){
                        authSummary = summary as! String
                    }else{
                        authSummary = authSummary + "," + (summary as! String)
                    }
                    c = c + 1;
                }
            }
            if(data.authenticationResult == nil){
                data.authenticationResult = "";
            }
            dataArray = ["Authentication Result"+separator+data.authenticationResult,
                         "Authentication Summary"+separator+authSummary,
                         "First Name"+separator+data.nameFirst,
                        "Middle Name"+separator+data.nameMiddle,
                        "Last Name"+separator+data.nameLast,
                        "Name Suffix"+separator+data.nameSuffix,
                        "ID"+separator+data.licenceId,
                        "License"+separator+data.license,
                        "DOB Long"+separator+data.dateOfBirth4,
                        "DOB Short"+separator+data.dateOfBirth,
                        "Date Of Birth Local"+separator+data.dateOfBirthLocal,
                        "Issue Date Long"+separator+data.issueDate4,
                        "Issue Date Short"+separator+data.issueDate,
                        "Issue Date Local"+separator+data.issueDateLocal,
                        "Expiration Date Long"+separator+data.expirationDate4,
                        "Expiration Date Short"+separator+data.expirationDate,
                        "Eye Color"+separator+data.eyeColor,
                        "Hair Color"+separator+data.hairColor,
                        "Height"+separator+data.height,
                        "Weight"+separator+data.weight,
                        "Address"+separator+data.address,
                        "Address 2"+separator+data.address2,
                        "Address 3"+separator+data.address3,
                        "Address 4"+separator+data.address4,
                        "Address 5"+separator+data.address5,
                        "Address 6"+separator+data.address6,
                        "City"+separator+data.city,
                        "Zip"+separator+data.zip,
                        "State"+separator+data.state,
                        "County"+separator+data.county,
                        "Country Short"+separator+data.countryShort,
                        "Country Long"+separator+data.idCountry,
                        "Class"+separator+data.licenceClass,
                        "Restriction"+separator+data.restriction,
                        "Sex"+separator+data.sex,
                        "Audit"+separator+data.audit,
                        "Endorsements"+separator+data.endorsements,
                        "Fee"+separator+data.fee,
                        "CSC"+separator+data.csc,
                        "SigNum"+separator+data.sigNum,
                        "Text1"+separator+data.text1,
                        "Text2"+separator+data.text2,
                        "Text3"+separator+data.text3,
                        "Type"+separator+data.type,
                        "Doc Type"+separator+data.docType,
                        "Father Name"+separator+data.fatherName,
                        "Mother Name"+separator+data.motherName,
                        "NameFirst_NonMRZ"+separator+data.nameFirst_NonMRZ,
                        "NameLast_NonMRZ"+separator+data.nameLast_NonMRZ,
                        "NameLast1"+separator+data.nameLast1,
                        "NameLast2"+separator+data.nameLast2,
                        "NameMiddle_NonMRZ"+separator+data.nameMiddle_NonMRZ,
                        "NameSuffix_NonMRZ"+separator+data.nameSuffix_NonMRZ,
                        "Document Detected Name"+separator+data.documentDetectedName,
                        "Document Detected Name Short"+separator+data.documentDetectedNameShort,
                        "Nationality"+separator+data.nationality,
                        "Original"+separator+data.original,
                        "PlaceOfBirth"+separator+data.placeOfBirth,
                        "PlaceOfIssue"+separator+data.placeOfIssue,
                        "Social Security"+separator+data.socialSecurity,
                        "TID"+separator+data.transactionId] as [String];
            
            if(facialData != nil){
                dataArray.append("faceLivelinessDetection"+separator+String(facialData.faceLivelinessDetection));
                dataArray.append("Face Matched"+separator+String(facialData.isMatch));
                dataArray.append("facialMatchConfidenceRating"+separator+String(facialData.facialMatchConfidenceRating));
                dataArray.append("FTID"+separator+facialData.transactionId);
            }
        }else if (self.cardType == AcuantCardTypePassportCard) {
            let data : AcuantPassaportCard = cardData as! AcuantPassaportCard;
            
            if(data.faceImage != nil){
                faceImage.image = UIImage(data:data.faceImage!,scale:1.0);
            }
            if(data.signImage != nil){
                signImage.image = UIImage(data:data.signImage!,scale:1.0);
            }
            if(data.passportImage != nil){
                frontImage.image = UIImage(data:data.passportImage!,scale:1.0)
            }
            var authSummary:String = ""
            var c = 0;
            if(data.authenticationResultSummaryList != nil && data.authenticationResultSummaryList.count>0){
                for summary in data.authenticationResultSummaryList{
                    if(c==0){
                        authSummary = summary as! String
                    }else{
                        authSummary = authSummary + "," + (summary as! String)
                    }
                    c = c + 1;
                }
            }
            if(data.authenticationResult == nil){
                data.authenticationResult = "";
            }
            dataArray = ["Authentication Result"+separator+data.authenticationResult,
                         "Authentication Summary"+separator+authSummary,
                         "First Name"+separator+data.nameFirst,
                         "Middle Name"+separator+data.nameMiddle,
                         "Last Name"+separator+data.nameLast,
                         "DOB Short"+separator+data.dateOfBirth,
                         "Issue Date Long"+separator+data.issueDate4,
                         "Issue Date Short"+separator+data.issueDate,
                         "Expiration Date Long"+separator+data.expirationDate4,
                         "Expiration Date Short"+separator+data.expirationDate,
                         "Address"+separator+data.address,
                         "Address 2"+separator+data.address2,
                         "Sex"+separator+data.sex,
                         "NameFirst_NonMRZ"+separator+data.nameFirst_NonMRZ,
                         "NameLast_NonMRZ"+separator+data.nameLast_NonMRZ,
                         "TID"+separator+data.transactionId] as [String];
            
            if(facialData != nil){
                dataArray.append("faceLivelinessDetection"+separator+String(facialData.faceLivelinessDetection));
                dataArray.append("Face Matched"+separator+String(facialData.isMatch));
                dataArray.append("facialMatchConfidenceRating"+separator+String(facialData.facialMatchConfidenceRating));
                dataArray.append("FTID"+separator+facialData.transactionId);
            }
        }else if (self.cardType == AcuantCardTypeMedicalInsuranceCard) {
            let data : AcuantMedicalInsuranceCard = cardData as! AcuantMedicalInsuranceCard;
            
            if(data.reformattedImage != nil){
                frontImage.image = UIImage(data:data.reformattedImage!,scale:1.0)
            }
            if(data.reformattedImageTwo != nil){
                backImage.image = UIImage(data:data.reformattedImageTwo!,scale:1.0);
            }
            
            dataArray = ["First Name"+separator+data.firstName,
                         "Middle Name"+separator+data.middleName,
                         "Last Name"+separator+data.lastName,
                         "DOB Short"+separator+data.dateOfBirth,
                         "Copay ER"+separator+data.copayEr,
                         "Copay OV"+separator+data.copayOv,
                         "Copay UC"+separator+data.copayUc,
                         "Copay SP"+separator+data.copaySp,
                         "City"+separator+data.city,
                         "Contract Code"+separator+data.contractCode,
                         "Coverage"+separator+data.coverage,
                         "Deductible"+separator+data.deductible,
                         "Effective Date"+separator+data.effectiveDate,
                         "Expiration Date Short"+separator+data.expirationDate,
                         "Email"+separator+data.email,
                         "Employer"+separator+data.employer,
                         "Full Address"+separator+data.fullAddress,
                         "Group Name"+separator+data.groupName,
                         "Group Number"+separator+data.groupNumber,
                         "Issuer Number"+separator+data.issuerNumber,
                         "Member ID"+separator+data.memberId,
                         "Member Name"+separator+data.memberName,
                         "Name"+separator+data.name,
                         "Name Prefix"+separator+data.namePrefix,
                         "Name Suffix"+separator+data.nameSuffix,
                         "Other"+separator+data.other,
                         "Payer ID"+separator+data.payerId,
                         "Phone Number"+separator+data.phoneNumber,
                         "Plan Admin"+separator+data.planAdmin,
                         "Plan provider"+separator+data.planProvider,
                         "Plan Type"+separator+data.planType,
                         "RX BIN"+separator+data.rxBin,
                         "RX GROUP"+separator+data.rxGroup,
                         "RX ID"+separator+data.rxId,
                         "RX PCN"+separator+data.rxPcn,
                         "Sate"+separator+data.state,
                         "Street"+separator+data.street,
                         "Zip"+separator+data.zip,
                         "TID"+separator+data.transactionId] as [String];
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        if((dataArray[indexPath.row].range(of: "Authentication Result") != nil) || (dataArray[indexPath.row].range(of: "Authentication Summary") != nil)){
            
            cell.textLabel?.text = dataArray[indexPath.row];
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            
        }else{
            cell.textLabel?.text = dataArray[indexPath.row];
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        return cell
    }
    
}
