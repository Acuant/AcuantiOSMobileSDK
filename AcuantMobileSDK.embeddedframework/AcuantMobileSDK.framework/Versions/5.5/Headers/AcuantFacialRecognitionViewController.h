//
//  AcuantFacialRecognitionViewController.h
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 4/20/16.
//  Copyright © 2016 DB-Interactive. All rights reserved.
//
//

#import "AcuantFacialCaptureDelegate.h"
#import "AcuantMobileSDKController.h"

@interface AcuantFacialRecognitionViewController

@property (nonatomic) BOOL cancelButtonVisible;

+(id)presentFacialCaptureInterfaceWithDelegate:(id<AcuantFacialCaptureDelegate>)delegate withSDK:(AcuantMobileSDKController*)sdkController inViewController:(UIViewController*)parentVC withCancelButton:(BOOL)cancelVisible withCancelButtonRect:(CGRect) cancelRect withWaterMark:(NSString* )watermarkText
                            withBlinkMessage:(NSAttributedString*)message
                                        inRect:(CGRect)rect;

@end
