//
//  AcuantCardProcessRequestOptions.h
//
//  Created by Diego Arena on 11/19/12.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcuantCardRegion.h"
#import "AcuantCardType.h"

@interface AcuantCardProcessRequestOptions : NSObject

@property (nonatomic) BOOL                          faceDetection;      //If true, server will try to detect and crop the face from the card. Default is NO.
@property (nonatomic) BOOL                          signatureDetection; //If true, server will try to detect and crop the signature from the card. Default is NO.
@property (nonatomic) AcuantCardRegion                region; // Default is United States.
@property (nonatomic) int                           DPI; // Default is 0.
@property (nonatomic) int                           stateID; // Default is -1.
@property (nonatomic) BOOL                          autoDetectState; // Default is YES.
@property (nonatomic) BOOL                          reformatImage; // Default is NO.
@property (nonatomic) int                           reformatImageColor; // Default is 0.
@property (nonatomic) BOOL                          cropImage; // Default is NO.
@property (nonatomic) BOOL                          assureIDWebService; // Default is NO.
@property (nonatomic) BOOL                          logtransaction; //Default is NO;
@property (nonatomic) int                           imageSettings;
@property (nonatomic,readonly) AcuantCardType        processingType; //This is the type of card you're trying to process.

/**
 Use this method to obtain a default request options object that you can use later to parse a card
 @param type the type of card from which you want to obtain the default values. If invalid type is provided, method will return nil.
 @return a newly initialized object
 */
+ (AcuantCardProcessRequestOptions*)defaultRequestOptionsForCardType:(AcuantCardType)type;

@end
