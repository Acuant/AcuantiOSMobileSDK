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
    var dataArray:[String]! = Array()
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
            dataArray.append("Authentication Result"+separator+data.authenticationResult)
            dataArray.append("Authentication Summary"+separator+authSummary)
            dataArray.append("First Name"+separator+data.nameFirst)
            dataArray.append("Middle Name"+separator+data.nameMiddle)
            dataArray.append("Last Name"+separator+data.nameLast)
            dataArray.append("Name Suffix"+separator+data.nameSuffix)
            dataArray.append("ID"+separator+data.licenceId)
            dataArray.append("License"+separator+data.license)
            dataArray.append("DOB Long"+separator+data.dateOfBirth4)
            dataArray.append("DOB Short"+separator+data.dateOfBirth)
            dataArray.append(            "Date Of Birth Local"+separator+data.dateOfBirthLocal)
            dataArray.append(            "Issue Date Long"+separator+data.issueDate4)
            dataArray.append(            "Issue Date Short"+separator+data.issueDate)
            dataArray.append(            "Issue Date Local"+separator+data.issueDateLocal)
            dataArray.append(            "Expiration Date Long"+separator+data.expirationDate4)
            dataArray.append(            "Expiration Date Short"+separator+data.expirationDate)
            dataArray.append(            "Eye Color"+separator+data.eyeColor)
            dataArray.append(            "Hair Color"+separator+data.hairColor)
            dataArray.append(            "Height"+separator+data.height)
            dataArray.append(            "Weight"+separator+data.weight)
            dataArray.append(            "Address"+separator+data.address)
            dataArray.append(            "Address 2"+separator+data.address2)
            dataArray.append(            "Address 3"+separator+data.address3)
            dataArray.append("Address 4"+separator+data.address4)
            dataArray.append("Address 5"+separator+data.address5)
            dataArray.append("Address 6"+separator+data.address6)
            dataArray.append("City"+separator+data.city)
            dataArray.append("Zip"+separator+data.zip)
            dataArray.append("State"+separator+data.state)
            dataArray.append("County"+separator+data.county)
            dataArray.append("Country Short"+separator+data.countryShort)
            dataArray.append("Country Long"+separator+data.idCountry)
            dataArray.append("Class"+separator+data.licenceClass)
            dataArray.append("Restriction"+separator+data.restriction)
            dataArray.append("Sex"+separator+data.sex)
            dataArray.append("Audit"+separator+data.audit)
            dataArray.append("Endorsements"+separator+data.endorsements)
            dataArray.append("Fee"+separator+data.fee)
            dataArray.append("CSC"+separator+data.csc)
            dataArray.append("SigNum"+separator+data.sigNum)
            dataArray.append("Text1"+separator+data.text1)
            dataArray.append("Text2"+separator+data.text2)
            dataArray.append("Text3"+separator+data.text3)
            dataArray.append("Type"+separator+data.type)
            dataArray.append("Doc Type"+separator+data.docType)
            dataArray.append("Father Name"+separator+data.fatherName)
            dataArray.append("Mother Name"+separator+data.motherName)
            dataArray.append("NameFirst_NonMRZ"+separator+data.nameFirst_NonMRZ)
            dataArray.append("NameLast_NonMRZ"+separator+data.nameLast_NonMRZ)
            dataArray.append("NameLast1"+separator+data.nameLast1)
            dataArray.append("NameLast2"+separator+data.nameLast2)
            dataArray.append("NameMiddle_NonMRZ"+separator+data.nameMiddle_NonMRZ)
            dataArray.append("NameSuffix_NonMRZ"+separator+data.nameSuffix_NonMRZ)
            dataArray.append("Document Detected Name"+separator+data.documentDetectedName)
            dataArray.append("Document Detected Name Short"+separator+data.documentDetectedNameShort)
            dataArray.append("Nationality"+separator+data.nationality)
            dataArray.append("Original"+separator+data.original)
             dataArray.append("PlaceOfBirth"+separator+data.placeOfBirth)
             dataArray.append("PlaceOfIssue"+separator+data.placeOfIssue)
             dataArray.append("Social Security"+separator+data.socialSecurity)
             dataArray.append("TID"+separator+data.transactionId)
            
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
            dataArray.append("Authentication Result"+separator+data.authenticationResult)
             dataArray.append("Authentication Summary"+separator+authSummary)
             dataArray.append("First Name"+separator+data.nameFirst)
             dataArray.append("Middle Name"+separator+data.nameMiddle)
             dataArray.append("Last Name"+separator+data.nameLast)
             dataArray.append("DOB Short"+separator+data.dateOfBirth)
             dataArray.append("Issue Date Long"+separator+data.issueDate4)
             dataArray.append("Issue Date Short"+separator+data.issueDate)
             dataArray.append("Expiration Date Long"+separator+data.expirationDate4)
             dataArray.append("Expiration Date Short"+separator+data.expirationDate)
             dataArray.append("Address"+separator+data.address)
             dataArray.append("Address 2"+separator+data.address2)
             dataArray.append("Sex"+separator+data.sex)
             dataArray.append("NameFirst_NonMRZ"+separator+data.nameFirst_NonMRZ)
             dataArray.append("NameLast_NonMRZ"+separator+data.nameLast_NonMRZ)
             dataArray.append("TID"+separator+data.transactionId)
            
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
            
            dataArray.append("First Name"+separator+data.firstName)
            dataArray.append("Middle Name"+separator+data.middleName)
            dataArray.append("Last Name"+separator+data.lastName)
            dataArray.append("DOB Short"+separator+data.dateOfBirth)
            dataArray.append("Copay ER"+separator+data.copayEr)
            dataArray.append("Copay OV"+separator+data.copayOv)
            dataArray.append("Copay UC"+separator+data.copayUc)
            dataArray.append("Copay SP"+separator+data.copaySp)
            dataArray.append("City"+separator+data.city)
            dataArray.append("Contract Code"+separator+data.contractCode)
            dataArray.append("Coverage"+separator+data.coverage)
            dataArray.append("Deductible"+separator+data.deductible)
            dataArray.append("Effective Date"+separator+data.effectiveDate)
            dataArray.append("Expiration Date Short"+separator+data.expirationDate)
            dataArray.append("Email"+separator+data.email)
            dataArray.append("Employer"+separator+data.employer)
            dataArray.append("Full Address"+separator+data.fullAddress)
            dataArray.append("Group Name"+separator+data.groupName)
            dataArray.append("Group Number"+separator+data.groupNumber)
            dataArray.append("Issuer Number"+separator+data.issuerNumber)
            dataArray.append("Member ID"+separator+data.memberId)
            dataArray.append("Member Name"+separator+data.memberName)
            dataArray.append("Name"+separator+data.name)
            dataArray.append("Name Prefix"+separator+data.namePrefix)
            dataArray.append("Name Suffix"+separator+data.nameSuffix)
            dataArray.append("Other"+separator+data.other)
            dataArray.append("Payer ID"+separator+data.payerId)
            dataArray.append("Phone Number"+separator+data.phoneNumber)
            dataArray.append("Plan Admin"+separator+data.planAdmin)
            dataArray.append("Plan provider"+separator+data.planProvider)
            dataArray.append("Plan Type"+separator+data.planType)
            dataArray.append("RX BIN"+separator+data.rxBin)
            dataArray.append("RX GROUP"+separator+data.rxGroup)
            dataArray.append("RX ID"+separator+data.rxId)
            dataArray.append("RX PCN"+separator+data.rxPcn)
            dataArray.append("Sate"+separator+data.state)
            dataArray.append("Street"+separator+data.street)
            dataArray.append("Zip"+separator+data.zip)
            dataArray.append("TID"+separator+data.transactionId)
            
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
