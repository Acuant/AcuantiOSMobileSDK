//
//  AcuantProcessingError.h
//  AcuantMobileSDK
//
//  Created by Diego Arena on 9/6/13.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
	AcuantErrorCouldNotReachServer = 0, //check internet connection
	AcuantErrorUnableToAuthenticate = 1, //keyLicense are incorrect
	AcuantErrorUnableToProcess = 2, //image received by the server was unreadable, take a new one
	AcuantErrorInternalServerError = 3, //there was an error in our server, try again later
	AcuantErrorUnknown = 4, //there was an error but we were unable to determine the reason, try again later
    AcuantErrorTimedOut = 5, //request timed out, may be because internet connection is too slow
    AcuantErrorAutoDetectState = 6, //Error when try to detect the state
    AcuantErrorWebResponse = 7, //the json was received by the server contain error
    AcuantErrorUnableToCrop = 8, //the received image can't be cropped.
    AcuantErrorInvalidLicenseKey = 9, //Is an invalid license key.
    AcuantErrorInactiveLicenseKey = 10, //Is an inative license key.
    AcuantErrorAccountDisabled = 11, //Is an account disabled.
    AcuantErrorOnActiveLicenseKey = 12, //there was an error on activation key.
    AcuantErrorValidatingLicensekey = 13, //The validation is still in process.
    AcuantErrorCameraUnauthorized = 14, //The privacy settings are preventing us from accessing your camera.
    AcuantErrorOpenCamera = 15, //There are an error when the camera is opened.
    AcuantErrorIncorrectDocumentScanned = 16,
    AcuantErrorGatewayTimeout = 17
    
} AcuantErrorType;

@interface AcuantError : NSObject
@property (nonatomic) AcuantErrorType errorType;
@property (nonatomic, strong) NSString *errorMessage;

+ (AcuantError*)instanceWithError:(AcuantErrorType)errorType andMessage:(NSString*)errorMessage;
@end
