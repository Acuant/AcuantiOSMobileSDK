//
//  UIAlertView+Custom.m
//  AcuantMobileSDKSample
//
//  Created by Diego Arena on 5/9/14.
//  Copyright (c) 2014 Diego Arena. All rights reserved.
//

#import "UIAlertController+Custom.h"

@implementation UIAlertController (Custom)
+(void)showSimpleAlertWithTitle:(NSString*)title Message:(NSString*)message FirstButton:(NSString*)firstButton SecondButton:(NSString*)secondButton FirstHandler:(void (^)(UIAlertAction *action))firstHandler SecondHandler:(void (^)(UIAlertAction *action))secondHandler Tag:(int)tag ViewController:(UIViewController *)view Orientation:(UIDeviceOrientation)orientation{
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
    
    BOOL isUnknown = NO;
    
    float angle = 0;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI/2.0;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = M_PI + M_PI/2.0;
            break;
        case UIDeviceOrientationPortrait:
            angle = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIDeviceOrientationUnknown:
            isUnknown = YES;
            break;
        default:
            switch ([[UIDevice currentDevice] orientation]) {
                case UIDeviceOrientationLandscapeLeft:
                    angle = M_PI/2.0;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    angle = M_PI + M_PI/2.0;
                    break;
                case UIDeviceOrientationPortrait:
                    angle = 0;
                    break;
                case UIDeviceOrientationPortraitUpsideDown:
                    angle = M_PI;
                    break;
                default:
                    break;
                    
            }
            break;
    }
    
    if (!isUnknown) {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:0.0];
        alert.view.transform = CGAffineTransformRotate(alert.view.transform, angle);
        [UIView commitAnimations];
        
        [alert.view setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
        [alert.view.layer setCornerRadius:5.0f];
    }
    
    [view presentViewController:alert animated:NO completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
