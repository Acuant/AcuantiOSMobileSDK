//
//  UIAlertView+Custom.m
//  AcuantMobileSDKSample
//
//  Created by Diego Arena on 5/9/14.
//  Copyright (c) 2014 Diego Arena. All rights reserved.
//

#import "UIAlertView+Custom.h"

@implementation UIAlertView (Custom)
+(void)showSimpleAlertWithTitle:(NSString*)title Message:(NSString*)message FirstButton:(NSString*)firstButton SecondButton:(NSString*)secondButton Delegate:(id)delegate Tag:(int)tag{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:delegate
                                         cancelButtonTitle:firstButton
                                         otherButtonTitles:(secondButton != nil ? secondButton: nil) , nil];
    alert.tag = tag;
    [alert show];
}

@end
