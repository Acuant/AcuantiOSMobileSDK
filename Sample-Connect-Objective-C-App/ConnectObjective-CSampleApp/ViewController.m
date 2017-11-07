//
//  ViewController.m
//  ConnectObjective-CSampleApp
//
//  Created by Tapas Behera on 8/8/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

#import "ViewController.h"
#import <AcuantMobileSDK/AcuantMobileSDKController.h>
#import "ProgressHUD.h"
#import "ResultViewController.h"

@interface ViewController ()<ResultCancelDelegate,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate>

@property(nonatomic,strong) AcuantMobileSDKController* instance;
@property(nonatomic,strong) NSDictionary* resultData;
@property(nonatomic) int side; // 0 front , 1 back
@property(nonatomic) AcuantCardType cardType;

@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,strong) NSString* subscription;
@property(nonatomic,strong) NSString* url;

@property(nonatomic,strong) IBOutlet UIImageView* frontCardImageView;
@property(nonatomic,strong) IBOutlet UILabel* frontImageViewLabel;
@property(nonatomic,strong) IBOutlet UILabel* backImageViewLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backCardImageView;
@property (strong, nonatomic) IBOutlet UIButton *processButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _username = @"XXXXXXXXXXXX";
    _password = @"XXXXXXXXXXXX";
    _subscription = @"XXXXXXXXXXXX";
    _url = @"https://devconnect.assureid.net/AssureIDService";
    
    [self hideFrontUI];
    [self hideUIBack];
    [self hideProcessButton];
    _side = 0;
    
    //UI Initialization ends
    
    // Create and add the view to the screen.
    
    [ProgressHUD show:@"Validating key"];
    self.view.userInteractionEnabled=NO;
    _instance = [AcuantMobileSDKController initAcuantMobileSDKWithUsername:_username password:_password subscription:_subscription url:_url andDelegate:self];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showFrontUI{
    _frontCardImageView.layer.cornerRadius = 8.0;
    _frontCardImageView.clipsToBounds = YES;
    _frontCardImageView.hidden=NO;
    _frontCardImageView.userInteractionEnabled=YES;
    _frontCardImageView.image = nil;
    _frontCardImageView.layer.borderWidth=2;
    _frontImageViewLabel.hidden=NO;
}

-(void)hideFrontUI{
    _frontCardImageView.layer.cornerRadius = 8.0;
    _frontCardImageView.clipsToBounds = YES;
    _frontCardImageView.hidden=YES;
    _frontCardImageView.image = nil;
    _frontCardImageView.layer.borderWidth=2;
    _frontImageViewLabel.hidden=YES;
}


-(void) showBackUI{
    _backCardImageView.layer.cornerRadius = 8.0;
    _backCardImageView.clipsToBounds = YES;
    _backCardImageView.hidden=NO;
    _backCardImageView.image = nil;
    _backCardImageView.layer.borderWidth=2;
    _backImageViewLabel.hidden=false;
}
-(void)hideUIBack{
    
    _backCardImageView.layer.cornerRadius = 8.0;
    _backCardImageView.clipsToBounds = YES;
    _backCardImageView.userInteractionEnabled=YES;
    _backCardImageView.hidden=YES;
    _backCardImageView.image = nil;
    _backCardImageView.layer.borderWidth=2;
    _backImageViewLabel.hidden=YES;
    
}
-(void) showProcessButton{
    _processButton.hidden=NO;
    _processButton.enabled=YES;
}

-(void) hideProcessButton{
    _processButton.hidden=YES;
}

-(void) resetData{
    _side = 0;
    _resultData = nil;
    _backCardImageView.image = nil;
    _frontCardImageView.image = nil;
}

// UI Callbacks
-(void) didFinishShowingResult{
    [self resetData];
    [self hideProcessButton];
    [self hideFrontUI];
    [self hideUIBack];
}

- (IBAction)captureTapped:(id)sender {
    [self showFrontUI];
    [self hideUIBack];
    [self resetData];
}
- (IBAction)processTapped:(id)sender {
    self.view.userInteractionEnabled=NO;
    NSString* errorMessage = [self validateState];
    if([errorMessage isEqualToString:@""]){
        [ProgressHUD show:@"Capturing data..."];
        AcuantCardProcessRequestOptions* options  = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:_cardType];
        
        [_instance processCardWithOptions:options frontImage:_frontCardImageView.image backImage:_backCardImageView.image barcodeString:nil];
        
        
    }else{
        UIAlertController* alertController = [[UIAlertController alloc] init];
        [alertController setTitle:@"ConnectExample"];
        [alertController setMessage:errorMessage];
        UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        [alertController addAction:dismissButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (IBAction)frontImageTapped:(id)sender {
    _side = 0;
    [self showCamera];
}

- (IBAction)backImageTapped:(id)sender {
    _side = 1;
    [self showCamera];
}

//Show Camera
-(void) showCamera{
    if(_instance!=nil){
        [_instance showManualCameraInterfaceInViewController:self delegate:self cardType:AcuantCardTypeDriversLicenseCard region:AcuantCardRegionUnitedStates andBackSide:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResult"]){
        ResultViewController* destinationVC = (ResultViewController*)[segue destinationViewController];
        destinationVC.cancelDelegate = self;
        destinationVC.cardData=_resultData;
        destinationVC.cardType=_cardType;
        destinationVC.username=_username;
        destinationVC.password=_password;
    }
    
}


//Data validation
-(NSString*) validateState{
    NSString* retValue=@"";
    if(_frontCardImageView.image==nil){
        retValue = @"Please provide an ID image";
    }
    return retValue;
}

// Web service callbacks
-(void) mobileSDKWasValidated:(BOOL)wasValidated{
    self.view.userInteractionEnabled=YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
    if(!wasValidated){
        
        UIAlertController* alertController = [[UIAlertController alloc] init];
        [alertController setTitle:@"ConnectExample"];
        [alertController setMessage:@"Credntials are not valid"];
        UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        [alertController addAction:dismissButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void) didFinishProcessingCardWithResult:(AcuantCardResult *)result{
    
}

-(void) didFinishProcessingCardWithAssureIDResult:(id)json{
    self.view.userInteractionEnabled=YES;
    _resultData=json;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
        [self performSegueWithIdentifier:@"toResult" sender:nil];
    });
}


// Capture Callbacks

- (BOOL)showBackButton{
    return YES;
}

-(void) didCaptureCropImage:(UIImage *)cardImage scanBackSide:(BOOL)scanBackSide andCardType:(AcuantCardType)cardType{
    _cardType=cardType;
    if(cardType == AcuantCardTypeDriversLicenseCard){
        if(_side==0){
            _frontCardImageView.image=cardImage;
            _frontImageViewLabel.hidden=YES;
            UIAlertController* alertController = [[UIAlertController alloc] init];
            [alertController setTitle:@"ConnectExample"];
            [alertController setMessage:@"Scan the backside of the drivers license"];
            UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [self showCamera];
                                                _side=1;
                                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                            }];
            
            [alertController addAction:dismissButton];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self showBackUI];
            _backCardImageView.image=cardImage;
            _backImageViewLabel.hidden=YES;
            [self showProcessButton];
        }
    }else{
        _frontCardImageView.image=cardImage;
        _frontImageViewLabel.hidden=YES;
        [self showProcessButton];
    }
    
}

-(void) didCaptureData:(NSString *)data{
    
}


-(void) didFailToCaptureCropImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [[UIAlertController alloc] init];
        [alert setTitle:@"ConnectExample"];
        [alert setMessage:@"Failed to capture Image.Please try again"];
        UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        [alert addAction:dismissButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(void) didFinishValidatingImageWithResult:(AcuantCardResult *)result{
    
}


// Errors
-(void) didFailWithError:(AcuantError *)error {
    [ProgressHUD dismiss];
    self.view.userInteractionEnabled=YES;
    [self showErrorAlert:error];
    
}

-(void) showErrorAlert:(AcuantError*)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [[UIAlertController alloc] init];
        [alert setTitle:@"ConnectExample"];
        [alert setMessage:error.errorMessage];
        UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
        {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:dismissButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    });

}



@end
