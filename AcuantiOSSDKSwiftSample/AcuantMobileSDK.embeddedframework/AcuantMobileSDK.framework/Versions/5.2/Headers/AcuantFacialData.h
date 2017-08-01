//
//  AcuantFacialData.h
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 4/20/16.
//  Copyright © 2016 DB-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcuantCardResult.h"

@interface AcuantFacialData : AcuantCardResult

@property (nonatomic, assign) BOOL  isMatch;
@property (nonatomic, assign) BOOL  faceLivelinessDetection;
@property (nonatomic, strong) NSString  *transactionId;
@property (nonatomic, strong) NSString  *errorMessage;
@property (nonatomic) int facialMatchConfidenceRating;

@end
