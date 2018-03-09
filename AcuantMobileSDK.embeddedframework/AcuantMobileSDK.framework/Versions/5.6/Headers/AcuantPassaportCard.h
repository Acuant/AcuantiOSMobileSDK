//
//  AcuantPassaportCard.h
//  AcuantMobileSDK
//
//  Created by Diego Arena on 8/19/13.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcuantCardResult.h"

@interface AcuantPassaportCard : AcuantCardResult

@property (nonatomic, strong) NSString  *dateOfBirth4;
@property (nonatomic, strong) NSString  *transactionId;
@property (nonatomic, strong) NSString  *dateOfBirth;
@property (nonatomic, strong) NSString  *country;
@property (nonatomic, strong) NSString  *countryLong;
@property (nonatomic, strong) NSString  *expirationDate4;
@property (nonatomic, strong) NSString  *expirationDate;
@property (nonatomic, strong) NSString  *end_POB;
@property (nonatomic, strong) NSString  *issueDate4;
@property (nonatomic, strong) NSString  *issueDate;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *address2;
@property (nonatomic, strong) NSString  *nameFirst;
@property (nonatomic, strong) NSString  *nameLast;
@property (nonatomic, strong) NSString  *nameMiddle;
@property (nonatomic, strong) NSString  *nationality;
@property (nonatomic, strong) NSString  *nationalityLong;
@property (nonatomic, strong) NSString  *nameFirst_NonMRZ;
@property (nonatomic, strong) NSString  *nameLast_NonMRZ;
@property (nonatomic, strong) NSString  *passportNumber;
@property (nonatomic, strong) NSString  *personalNumber;
@property (nonatomic, strong) NSString  *sex;
@property (nonatomic, strong) NSData    *faceImage;
@property (nonatomic, strong) NSData    *signImage;
@property (nonatomic, strong) NSString  *authenticationResult;
@property (nonatomic, strong) NSArray  *authenticationResultSummaryList;
@property (nonatomic, strong) NSString  *authenticationObject;
@property (nonatomic, strong) NSData    *passportImage;
@end
