//
//  UIAlertView+Custom.m
//  AcuantMobileSDKSample
//
//  Created by Diego Arena on 5/9/14.
//  Copyright (c) 2014 Diego Arena. All rights reserved.
//

#import "UIAlertController+Custom.h"

@implementation UIAlertController (Custom)
+(void)showSimpleAlertWithTitle:(NSString*)title Message:(NSString*)message FirstButton:(NSString*)firstButton SecondButton:(NSString*)secondButton FirstHandler:(void (^)(UIAlertAction *action))firstHandler SecondHandler:(void (^)(UIAlertAction *action))secondHandler Tag:(int)tag ViewController:(UIViewController *)view{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *firstButtonAction = [UIAlertAction
                                        actionWithTitle:firstButton
                                        style:UIAlertActionStyleCancel
                                        handler:firstHandler];
    [alert addAction:firstButtonAction];
    
    if (secondButton) {
        UIAlertAction *secondButtonAction = [UIAlertAction
                                             actionWithTitle:secondButton
                                             style:UIAlertActionStyleDefault
                                             handler:secondHandler];
        [alert addAction:secondButtonAction];
    }
        
    [view presentViewController:alert animated:NO completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
