//
//  UIAlertView+Custom.h
//  AcuantMobileSDKSample
//
//  Created by Diego Arena on 5/9/14.
//  Copyright (c) 2014 Diego Arena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ButtonOK @"OK"
#define ButtonCancel @"Cancel"
#define ButtonYES @"YES"
#define ButtonNO @"NO"
#define ButtonNil nil

@interface UIAlertView (Custom)
+(void)showSimpleAlertWithTitle:(NSString*)title Message:(NSString*)message FirstButton:(NSString*)firstButton SecondButton:(NSString*)secondButton Delegate:(id)delegate Tag:(int)tag;

@end
