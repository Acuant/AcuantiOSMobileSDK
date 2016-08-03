//
//  ConfirmationViewController.m
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 5/3/16.
//  Copyright © 2016 DB-Interactive. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <AcuantMobileSDK/AcuantCardType.h>


@interface ConfirmationViewController ()

@property (strong, nonatomic)  UIImage *originalImage;
@property (strong, nonatomic)  NSString *messageText;
@property (nonatomic)  BOOL scanBackSide;
@property (nonatomic)  BOOL failed;

@end

@implementation ConfirmationViewController

- (IBAction)confirmTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:_originalImage forKey:@"OriginalImage"];
    if(_scanBackSide){
        [userInfo setObject:@"YES" forKey:@"scanBackSide"];
    }else{
        [userInfo setObject:@"NO" forKey:@"scanBackSide"];
    }
    _scanBackSide = NO;
    [userInfo setObject:@"YES" forKey:@"Confirmed"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ConfirmationNotification"
     object:nil userInfo:userInfo];
}

- (IBAction)retryTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    //[userInfo setObject:_originalImage forKey:@"OriginalImage"];
    [userInfo setObject:@"NO" forKey:@"scanBackSide"];
    [userInfo setObject:@"NO" forKey:@"Confirmed"];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ConfirmationNotification"
     object:nil userInfo:userInfo];

}

-(id)initWithImage:(UIImage*)image andMessage:(NSString*)message scanBackSide:(BOOL)scanBackSide  failed:(BOOL)failed{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self = [super initWithNibName:@"ConfirmationViewController-ipad" bundle:nil];
    }else{
        self = [super initWithNibName:@"ConfirmationViewController" bundle:nil];
    }
    if(self){
        _originalImage = image;
        _messageText = message;
        _scanBackSide = scanBackSide;
        _failed = failed;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupUI];
}


-(void)setupUI{
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat centerX = screenWidth/2;
    CGFloat centerY = screenHeight/2;
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    
    _confirmButton.layer.cornerRadius = 10.0f;
    _retryButton.layer.cornerRadius = 10.0f;
    
    _imagePreview.image = _originalImage;
    _messageLabel.text = _messageText;
    
    if(_failed){
        _confirmButton.hidden=YES;
        CGFloat imageHeight;
        CGFloat imageWidth;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             imageHeight = 0.7*screenHeight;
             imageWidth = 0.7*screenWidth;
        }else{
             imageHeight = 0.7*screenHeight;
             imageWidth = 0.7*screenWidth;
        }
        CGFloat space = 10.0f;
        
        _imagePreview.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        _imagePreview.center = centerPoint;
        
        _retryButton.frame = CGRectMake(_imagePreview.frame.origin.x,_imagePreview.frame.origin.y+_imagePreview.frame.size.height+space,imageWidth,_retryButton.frame.size.height);
        
        
        _confirmButton.frame = CGRectMake(_retryButton.frame.origin.x,_retryButton.frame.origin.y+_retryButton.frame.size.height+space,imageWidth,_confirmButton.frame.size.height);
        
        _messageLabel.frame = CGRectMake(_imagePreview.frame.origin.x,_imagePreview.frame.origin.y-space-_messageLabel.frame.size.height,imageWidth,_messageLabel.frame.size.height);
        
        
    }else{
        CGFloat imageHeight;
        CGFloat imageWidth;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             imageHeight = 0.4*screenHeight;
             imageWidth = 0.9*screenWidth;
        }else{
             imageHeight = 0.35*screenHeight;
             imageWidth = 0.9*screenWidth;
        }
        CGFloat space = 20.0f;
        
        _imagePreview.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        _imagePreview.center = centerPoint;
        
        _confirmButton.frame = CGRectMake(_imagePreview.frame.origin.x,_imagePreview.frame.origin.y+_imagePreview.frame.size.height+space,_imagePreview.frame.size.width,_retryButton.frame.size.height);
        
        
        _retryButton.frame = CGRectMake(_confirmButton.frame.origin.x,_confirmButton.frame.origin.y+_confirmButton.frame.size.height+space,_confirmButton.frame.size.width,_confirmButton.frame.size.height);
        
        _messageLabel.frame = CGRectMake(_imagePreview.frame.origin.x,_imagePreview.frame.origin.y-space-_messageLabel.frame.size.height,_imagePreview.frame.size.width,_messageLabel.frame.size.height);
        
         _confirmButton.hidden=NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
