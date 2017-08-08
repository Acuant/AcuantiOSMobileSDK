//
//  AcuantCardResult.h
//
//  Created by Diego Arena on 11/19/12.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcuantDeviceLocationTestResult.h"

@interface AcuantCardResult : NSObject

@property (nonatomic) AcuantDeviceLocationTestResult  idLocationStateTestResult;
@property (nonatomic) AcuantDeviceLocationTestResult  idLocationCountryTestResult;
@property (nonatomic) AcuantDeviceLocationTestResult  idLocationCityTestResult;
@property (nonatomic) AcuantDeviceLocationTestResult  idLocationZipcodeTestResult;

-(id)initWithDictionary:(NSDictionary*)dictionary;


@end
