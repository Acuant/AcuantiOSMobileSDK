//
//  AcuantMedicCardDataStore.h
//
//  Created by Diego Arena on 11/19/12.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcuantCardResult.h"

@interface AcuantMedicalInsuranceCard : AcuantCardResult

@property (nonatomic, strong) NSString      *contractCode;
@property (nonatomic, strong) NSString      *transactionId;
@property (nonatomic, strong) NSString      *copayEr;
@property (nonatomic, strong) NSString      *copayOv;
@property (nonatomic, strong) NSString      *copaySp;
@property (nonatomic, strong) NSString      *copayUc;
@property (nonatomic, strong) NSString      *coverage;
@property (nonatomic, strong) NSString      *dateOfBirth;
@property (nonatomic, strong) NSString      *deductible;
@property (nonatomic, strong) NSString      *effectiveDate;
@property (nonatomic, strong) NSString      *employer;
@property (nonatomic, strong) NSString      *expirationDate;
@property (nonatomic, strong) NSString      *firstName;
@property (nonatomic, strong) NSString      *middleName;
@property (nonatomic, strong) NSString      *lastName;
@property (nonatomic, strong) NSString      *groupName;
@property (nonatomic, strong) NSString      *groupNumber;
@property (nonatomic, strong) NSString      *issuerNumber;
@property (nonatomic, strong) NSString      *memberId;
@property (nonatomic, strong) NSString      *memberName;
@property (nonatomic, strong) NSString      *NamePrefix;
@property (nonatomic, strong) NSString      *NameSuffix;
@property (nonatomic, strong) NSString      *PlanCode;
@property (nonatomic, strong) NSString      *other;
@property (nonatomic, strong) NSString      *payerId;
@property (nonatomic, strong) NSString      *planAdmin;
@property (nonatomic, strong) NSString      *planProvider;
@property (nonatomic, strong) NSString      *planType;
@property (nonatomic, strong) NSString      *rxBin;
@property (nonatomic, strong) NSString      *rxGroup;
@property (nonatomic, strong) NSString      *rxId;
@property (nonatomic, strong) NSString      *rxPcn;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *city;
@property (nonatomic, strong) NSString      *fullAddress;
@property (nonatomic, strong) NSString      *state;
@property (nonatomic, strong) NSString      *street;
@property (nonatomic, strong) NSString      *zip;
@property (nonatomic, strong) NSString      *phoneNumber;
@property (nonatomic, strong) NSString      *email;
@property (nonatomic, strong) NSString      *webAddress;
@property (nonatomic, strong) NSData        *reformattedImage;
@property (nonatomic, strong) NSData        *reformattedImageTwo;

@end