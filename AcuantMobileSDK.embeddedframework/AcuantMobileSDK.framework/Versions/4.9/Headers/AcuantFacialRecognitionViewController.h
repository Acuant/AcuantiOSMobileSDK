//
//  AcuantFacialRecognitionViewController.h
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 4/20/16.
//  Copyright © 2016 DB-Interactive. All rights reserved.
//
//

#import "AcuantFacialCaptureDelegate.h"

@interface AcuantFacialRecognitionViewController

@property (nonatomic) BOOL cancelButtonVisible;

+(id)presentFacialCatureInterfaceWithDelegate:(id<AcuantFacialCaptureDelegate>)delegate inViewController:(UIViewController*)parentVC withCancelButton:(BOOL)cancelVisible withWatherMark:(NSString* )watermarkText
                            withBlinkMessage:(NSString*)message
                                      inRect:(CGRect)rect andFontSize:(NSUInteger)size;

@end
