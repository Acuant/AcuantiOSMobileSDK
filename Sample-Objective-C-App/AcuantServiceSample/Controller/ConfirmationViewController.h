//
//  ConfirmationViewController.h
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 5/3/16.
//  Copyright © 2016 DB-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imagePreview;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *retryButton;
@property (strong, nonatomic) NSDictionary *imageMetrics;

- (IBAction)confirmTapped:(id)sender;

- (IBAction)retryTapped:(id)sender;


-(id)initWithImage:(UIImage*)image andMessage:(NSString*)message scanBackSide:(BOOL)scanBackSide failed:(BOOL)failed;
@end
