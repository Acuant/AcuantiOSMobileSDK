//
//  ISGViewController.m
//  AcuantServiceSample
//
//  Created by Diego Arena on 5/31/13.
//  Copyright (c) 2013 Codigodelsur. All rights reserved.
//

#import "ISGViewController.h"
#import "SVProgressHUD.h"
#import "ISGResultScreenViewController.h"
#import "ISGRegionViewController.h"
#import "UIAlertController+Custom.h"
#import "UIDevice+Resolutions.h"
#import <QuartzCore/QuartzCore.h>
#import <AcuantMobileSDK/AcuantMobileSDKController.h>
#import "AcuantMobileSDK/AcuantFacialData.h"
#import "AcuantMobileSDK/AcuantFacialCaptureDelegate.h"
#import "AcuantMobileSDK/AcuantFacialRecognitionViewController.h"
#import "ConfirmationViewController.h"

@interface ISGViewController () <UITextFieldDelegate,AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate, ISGRegionViewControllerDelegate,AcuantFacialCaptureDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *frontImage;
@property (strong, nonatomic) IBOutlet UILabel *frontImageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *backImageLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (strong, nonatomic) IBOutlet UITextField *licenseKeyText;
@property (strong, nonatomic) IBOutlet UILabel *licenseKeyLabel;
@property (strong, nonatomic) IBOutlet UIButton *activateButton;
@property (strong, nonatomic) IBOutlet UIButton *driverLicenseButton;
@property (strong, nonatomic) IBOutlet UIButton *driverLicenseWithFacialButton;
@property (strong, nonatomic) IBOutlet UIButton *passportButton;
@property (strong, nonatomic) IBOutlet UIButton *medicalInsuranceButton;
@property (strong, nonatomic) NSString *barcodeString;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) AcuantMobileSDKController *instance;
@property (nonatomic) AcuantCardRegion cardRegion;
@property (nonatomic) AcuantCardType cardType;
@property (nonatomic) NSUInteger sideTouch;
@property (nonatomic) BOOL canValidate;
@property (nonatomic) BOOL isLandscape;
@property (nonatomic) BOOL wasValidated;
@property (nonatomic) BOOL isBarcodeSide;
@property (nonatomic) BOOL isCameraTouched;
@property (nonatomic) BOOL canShowBackButton;
@property (nonatomic) UIInterfaceOrientation orientation;
@property (strong, nonatomic) ISGResultScreenViewController *resultViewController;
@property (strong, nonatomic) NSString *selfieMatched;
@property (nonatomic) BOOL capturingData;
@property (nonatomic) BOOL validatingSelfie;
@property (nonatomic) BOOL isFacialFlow;
@property (nonatomic,strong) NSString* TID;
@property (nonatomic) BOOL frontImageConfirmed;
@end

@implementation ISGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedConfirmationNotification:)
                                                 name:@"ConfirmationNotification"
                                               object:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    self.wasValidated = NO;
    NSString *licenseKey = [[NSUserDefaults standardUserDefaults]valueForKey:@"LICENSEKEY"];
    //Obtain the main controller instance
    self.instance = [AcuantMobileSDKController initAcuantMobileSDKWithLicenseKey:licenseKey andDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.licenseKeyText.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"LICENSEKEY"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews
{
    [self cardHolderPositions];
    [self optionsButtonsPositions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    [self cardHolderPositions];
    [self optionsButtonsPositions];
    return YES;
}

#pragma mark -
#pragma mark IBAction
- (IBAction)captureDriverLicense:(id)sender {
    _frontImageConfirmed = NO;
    self.cardType = AcuantCardTypeDriversLicenseCard;
    self.isBarcodeSide = NO;
    _isFacialFlow = NO;
    ISGRegionViewController *regionListView = [[ISGRegionViewController alloc]initWithNibName:@"ISGRegionViewController" bundle:nil];
    regionListView.delegate = self;
    [self presentViewController:regionListView animated:YES completion:nil];
}

- (IBAction)captureDriverLicenseWithFacial:(id)sender {
    _frontImageConfirmed = NO;
    self.cardType = AcuantCardTypeDriversLicenseCard;
    self.isBarcodeSide = NO;
    _isFacialFlow = YES;
    ISGRegionViewController *regionListView = [[ISGRegionViewController alloc]initWithNibName:@"ISGRegionViewController" bundle:nil];
    regionListView.delegate = self;
    [self presentViewController:regionListView animated:YES completion:nil];
}
- (IBAction)captureMedicInsurance:(id)sender {
    _frontImageConfirmed = NO;
    self.cardType = AcuantCardTypeMedicalInsuranceCard;
    self.isBarcodeSide = NO;
    _isFacialFlow = NO;
    [self.frontImage setImage:nil];
    [self.frontImageLabel setText:@"Tap to capture front side"];
    [self.backImage setImage:nil];
    [self.backImageLabel setText:@"Tap to capture back side \n (optional)"];
    self.barcodeString = nil;
    [self cardHolderPositions];
    [self.sendRequestButton setEnabled:NO];
    [self.sendRequestButton setHidden:NO];
    self.frontImage.layer.masksToBounds = YES;
    self.frontImage.layer.cornerRadius = 10.0f;
    self.frontImage.layer.borderWidth = 1.0f;
    
    self.backImage.layer.masksToBounds = YES;
    self.backImage.layer.cornerRadius = 10.0f;
    self.backImage.layer.borderWidth = 1.0f;
    [self.backImage setUserInteractionEnabled:YES];
}
- (IBAction)capturePassport:(id)sender {
    _frontImageConfirmed = NO;
    self.isBarcodeSide = NO;
    _isFacialFlow = NO;
    self.cardType = AcuantCardTypePassportCard;
    [self.backImageLabel setText:@""];
    [self.backImage setImage:nil];
    [self.frontImage setImage:nil];
    [self.frontImageLabel setText:@"Tap to capture card"];
    self.barcodeString = nil;
    [self cardHolderPositions];
    [self.sendRequestButton setEnabled:NO];
    [self.sendRequestButton setHidden:NO];
    self.frontImage.layer.masksToBounds = YES;
    self.frontImage.layer.cornerRadius = 10.0f;
    self.frontImage.layer.borderWidth = 1.0f;
    
    self.backImage.layer.masksToBounds = NO;
    self.backImage.layer.cornerRadius = 10.0f;
    self.backImage.layer.borderWidth = 0.0f;
    [self.backImage setUserInteractionEnabled:NO];
}
- (IBAction)capturePassportWithFacial:(id)sender {
    _frontImageConfirmed = NO;
    self.isBarcodeSide = NO;
    _isFacialFlow = YES;
    self.cardType = AcuantCardTypePassportCard;
    [self.backImageLabel setText:@""];
    [self.backImage setImage:nil];
    [self.frontImage setImage:nil];
    [self.frontImageLabel setText:@"Tap to capture card"];
    self.barcodeString = nil;
    [self cardHolderPositions];
    [self.sendRequestButton setEnabled:NO];
    [self.sendRequestButton setHidden:NO];
    self.frontImage.layer.masksToBounds = YES;
    self.frontImage.layer.cornerRadius = 10.0f;
    self.frontImage.layer.borderWidth = 1.0f;
    
    self.backImage.layer.masksToBounds = NO;
    self.backImage.layer.cornerRadius = 10.0f;
    self.backImage.layer.borderWidth = 0.0f;
    [self.backImage setUserInteractionEnabled:NO];
}

- (IBAction)frontImage:(id)sender {
    if (self.cardType) {
        self.sideTouch = FrontSide;
        self.isCameraTouched = YES;
        _frontImageConfirmed=NO;
        [self showCameraInterface];
    }
}
- (IBAction)backImage:(id)sender {
    if (self.cardType) {
        self.sideTouch = BackSide;
        self.isCameraTouched = YES;
        [self showCameraInterface];
    }
}

- (IBAction)sendRequest:(id)sender {
    self.view.userInteractionEnabled = NO;
    if(!_isFacialFlow){
        [SVProgressHUD showWithStatus:@"Capturing Data"];
    }
    
    //Obtain the front side of the card image
    UIImage *frontSideImage = [self frontSideCardImage];
    //Optionally, Obtain the back side of the image
    UIImage *backSideImage =[self backSideCardImage];
    
    //Obtain the default AcuantCardProcessRequestOptions object for the type of card you want to process (License card for this example)
    AcuantCardProcessRequestOptions *options = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:self.cardType];
    
    //Optionally, configure the options to the desired value
    options.autoDetectState = YES;
    options.stateID = -1;
    options.reformatImage = YES;
    options.reformatImageColor = 0;
    options.DPI = 150.0f;
    options.cropImage = NO;
    options.faceDetection = YES;
    options.signatureDetection = YES;
    options.region = self.cardRegion;
    options.imageSource = 101;
    _capturingData = YES;
    // Now, perform the request
    [self.instance processFrontCardImage:frontSideImage
                           BackCardImage:backSideImage
                           andStringData:self.barcodeString
                            withDelegate:self
                             withOptions:options];
    if(_isFacialFlow){
        [self captureSelfie];
    }
    
}

- (IBAction)activateAction:(id)sender {
    [self.licenseKeyText resignFirstResponder];
    self.canValidate = NO;
    if (![self.licenseKeyText.text isEqualToString:@""]) {
        [self.instance activateLicenseKey:self.licenseKeyText.text];
        [self.instance setLicenseKey:self.licenseKeyText.text];
    }else{
        [UIAlertController showSimpleAlertWithTitle:@"Error"
                                            Message:@"The license key cannot be empty."
                                        FirstButton:ButtonOK
                                       SecondButton:nil
                                       FirstHandler:nil
                                      SecondHandler:nil
                                                Tag:0
                                     ViewController:self
                                        Orientation:UIDeviceOrientationUnknown];
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.licenseKeyText.text forKey:@"LICENSEKEY"];
}

#pragma mark -
#pragma mark Private Methods
-(UIInterfaceOrientation)orientation{
    
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationPortrait;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
            break;
        default:
            return UIInterfaceOrientationPortrait;
            break;
    }
}

- (void)optionsButtonsPositions{
    if (!self.isCameraTouched) {
        if (UIInterfaceOrientationIsLandscape([self orientation])) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.driverLicenseButton setFrame:CGRectMake(110, 70, 200, 44)];
                [self.passportButton setFrame:CGRectMake(412, 70, 200, 44)];
                [self.medicalInsuranceButton setFrame:CGRectMake(714, 70, 200, 44)];
            }else{
                if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina4){
                    [self.driverLicenseButton setFrame:CGRectMake(35, 60, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(447, 60, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina47){
                    [self.driverLicenseButton setFrame:CGRectMake(45, 60, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(487, 60, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina55){
                    [self.driverLicenseButton setFrame:CGRectMake(45, 60, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(487, 60, 83, 24)];
                }
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.driverLicenseButton setFrame:CGRectMake(76, 95, 200, 44)];
                [self.passportButton setFrame:CGRectMake(284, 95, 200, 44)];
                [self.medicalInsuranceButton setFrame:CGRectMake(492, 95, 200, 44)];
            }else{
                if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina4){
                    [self.driverLicenseButton setFrame:CGRectMake(2, 75, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(236, 75, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina47){
                    [self.driverLicenseButton setFrame:CGRectMake(12, 75, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(276, 75, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina55){
                    [self.driverLicenseButton setFrame:CGRectMake(12, 75, 97, 24)];
                    [self.passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [self.medicalInsuranceButton setFrame:CGRectMake(276, 75, 83, 24)];
                }
            }
        }
    }
}

-(void)cardHolderPositions{
    if (!self.isCameraTouched) {
        
        int widthiPhone = (UIInterfaceOrientationIsPortrait([self orientation])) ? self.view.frame.size.width - 90 : self.view.frame.size.height - 90;
        int heightiPhone = (self.cardType == AcuantCardTypePassportCard) ? widthiPhone*0.7 : widthiPhone*0.631;
        int widthiPad = (UIInterfaceOrientationIsPortrait([self orientation])) ? self.view.frame.size.width - 342 : self.view.frame.size.height - 342;
        int heightiPad = (self.cardType == AcuantCardTypePassportCard) ? widthiPad*0.7 : widthiPad*0.631;
        int centerX = self.view.frame.size.width / 2;
        
        if (UIInterfaceOrientationIsLandscape([self orientation])) {
            centerX = self.view.frame.size.width / 2;
            if (self.cardType == AcuantCardTypeMedicalInsuranceCard || (self.cardType == AcuantCardTypeDriversLicenseCard && [self.backImage image] != nil)){
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [self.frontImage setFrame:CGRectMake(centerX - 456, 250, widthiPad, heightiPad)];
                    [self.frontImageLabel setFrame:CGRectMake(centerX - 456, 250, widthiPad, heightiPad)];
                    [self.backImage setFrame:CGRectMake(centerX + 30, 250, widthiPad, heightiPad)];
                    [self.backImageLabel setFrame:CGRectMake(centerX + 30, 250, widthiPad, heightiPad)];
                }else{
                    [self.frontImage setFrame:CGRectMake(centerX - 253, 100, widthiPhone, heightiPhone)];
                    [self.frontImageLabel setFrame:CGRectMake(centerX - 253, 100, widthiPhone, heightiPhone)];
                    [self.backImage setFrame:CGRectMake(centerX + 30, 100, widthiPhone, heightiPhone)];
                    [self.backImageLabel setFrame:CGRectMake(centerX + 30, 100, widthiPhone, heightiPhone)];
                }
            }else{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [self.frontImage setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [self.frontImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [self.backImage setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [self.backImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                }else{
                    [self.frontImage setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [self.frontImageLabel setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [self.backImage setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [self.backImageLabel setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                }
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.frontImage setFrame:CGRectMake(centerX - widthiPad/2, 200, widthiPad, heightiPad)];
                [self.frontImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 200, widthiPad, heightiPad)];
                [self.backImage setFrame:CGRectMake(centerX - widthiPad/2, 600, widthiPad, heightiPad)];
                [self.backImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 600, widthiPad, heightiPad)];
            }else{
                [self.frontImage setFrame:CGRectMake(centerX- widthiPhone/2, 184, widthiPhone, heightiPhone)];
                [self.frontImageLabel setFrame:CGRectMake(centerX- widthiPhone/2, 184, widthiPhone, heightiPhone)];
                [self.backImage setFrame:CGRectMake(centerX- widthiPhone/2, self.frontImageLabel.frame.origin.y+self.frontImageLabel.frame.size.height+20, widthiPhone, heightiPhone)];
                [self.backImageLabel setFrame:CGRectMake(centerX- widthiPhone/2, self.frontImageLabel.frame.origin.y+self.frontImageLabel.frame.size.height+20, widthiPhone, heightiPhone)];
            }
        }
    }
}

-(UIImage *)frontSideCardImage{
    return [self.frontImage image];
}

-(UIImage *)backSideCardImage{
    return [self.backImage image];
}

-(void)showCameraInterface{
    //Set the width and hegiht (set both is required to can use the resize) to resize the image.
    // Check if is an iPod/iPhone device to Show the camera Interface
    // or iPad device to Show popover camera interface.
    //If you will use the manual camera interface must use the methods
    //showManualCardCaptureInterfaceInViewController
    
    //Use the following methods to customize the appear and final message.
    //[self.instance setInitialMessage:@"ALING AND TAP" frame:CGRectMake(0, 0, 0, 0) backgroundColor:[UIColor redColor] duration:10.0 orientation: AcuantHUDPortrait];
    //[self.instance setCapturingMessage:@"Capturing Message" frame:CGRectMake(0, 0, 0, 0) backgroundColor:nil duration:10.0 orientation: AcuantHUDLandscape];
    if (self.cardType == AcuantCardTypePassportCard) {
        [self.instance setWidth:1478];
    }else{
        [self.instance setWidth:1250];
    }
    self.canShowBackButton = YES;
    //Uncomment to Capture backside image of the Barcode
    //[self.instance setCanCropBarcode:YES];
    //[self.instance setCanShowMessage:YES];
    if (self.cardType != AcuantCardTypePassportCard) {
        if(!_frontImageConfirmed){
            [self.instance showManualCameraInterfaceInViewController:self delegate:self cardType:self.cardType region:self.cardRegion andBackSide:NO];
        }else{
            [self.instance showManualCameraInterfaceInViewController:self delegate:self cardType:self.cardType region:self.cardRegion andBackSide:YES];
        }
    }else{
        //comment the line below if the auto camera interface above is uncommented
        [self.instance showManualCameraInterfaceInViewController:self delegate:self cardType:self.cardType region:self.cardRegion andBackSide:NO];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (IBAction)hideTextfield:(id)sender {
    UITextField *textField = (UITextField*)sender;
    self.canValidate = YES;
    [textField resignFirstResponder];
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    UITextField *textField = (UITextField*)sender;
    if (self.canValidate) {
        self.wasValidated = NO;
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"LICENSEKEY"];
        [self.instance setLicenseKey:textField.text];
    }
}
#pragma mark -
#pragma mar Region Delegate

- (void)setRegion:(AcuantCardRegion)region{
    self.cardRegion = region;
    if (self.cardRegion == AcuantCardRegionCanada || self.cardRegion == AcuantCardRegionUnitedStates) {
        [self.frontImage setImage:nil];
        [self.frontImageLabel setText:@"Tap to capture front side"];
        [self.backImage setImage:nil];
        [self.backImageLabel setText:@""];
        self.barcodeString = nil;
        [self cardHolderPositions];
        [self.sendRequestButton setEnabled:NO];
        [self.sendRequestButton setHidden:NO];
        self.frontImage.layer.masksToBounds = YES;
        self.frontImage.layer.cornerRadius = 10.0f;
        self.frontImage.layer.borderWidth = 1.0f;
        
        self.backImage.layer.masksToBounds = NO;
        self.backImage.layer.cornerRadius = 10.0f;
        self.backImage.layer.borderWidth = 0.0f;
        [self.backImage setUserInteractionEnabled:NO];
    }else{
        [self.frontImage setImage:nil];
        [self.frontImageLabel setText:@"Tap to capture front side"];
        [self.backImage setImage:nil];
        [self.backImageLabel setText:@""];
        self.barcodeString = nil;
        [self cardHolderPositions];
        [self.sendRequestButton setEnabled:NO];
        [self.sendRequestButton setHidden:NO];
        self.frontImage.layer.masksToBounds = YES;
        self.frontImage.layer.cornerRadius = 10.0f;
        self.frontImage.layer.borderWidth = 1.0f;
        
        self.backImage.layer.masksToBounds = NO;
        self.backImage.layer.cornerRadius = 10.0f;
        self.backImage.layer.borderWidth = 0.0f;
        [self.backImage setUserInteractionEnabled:NO];
    }
}

#pragma mark -
#pragma mark General Delegates
-(void)mobileSDKWasValidated:(BOOL)wasValidated{
    self.wasValidated = YES;
}
-(void)didFailWithError:(AcuantError *)error{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];
    NSString *message;
    int tag = 0;
    switch (error.errorType) {
        case AcuantErrorTimedOut:
            message = error.errorMessage;
            break;
        case AcuantErrorUnknown:
            message = error.errorMessage;
            break;
        case AcuantErrorUnableToProcess:
            message = error.errorMessage;
            break;
        case AcuantErrorInternalServerError:
            message = error.errorMessage;
            break;
        case AcuantErrorCouldNotReachServer:
            message = error.errorMessage;
            break;
        case AcuantErrorUnableToAuthenticate:
            message = error.errorMessage;
            break;
        case AcuantErrorAutoDetectState:
            message = error.errorMessage;
            [self.frontImage setImage:self.originalImage];
            break;
        case AcuantErrorWebResponse:
            message = error.errorMessage;
            break;
        case AcuantErrorUnableToCrop:
            message = error.errorMessage;
            [self.frontImage setImage:self.originalImage];
            break;
        case AcuantErrorInvalidLicenseKey:
            message = error.errorMessage;
            break;
        case AcuantErrorInactiveLicenseKey:
            message = error.errorMessage;
            break;
        case AcuantErrorAccountDisabled:
            message = error.errorMessage;
            break;
        case AcuantErrorOnActiveLicenseKey:
            message = error.errorMessage;
            break;
        case AcuantErrorValidatingLicensekey:
            return;
            break;
        case AcuantErrorCameraUnauthorized:
            message = error.errorMessage;
            tag = 7388467;
            break;
        default:
            return;
            break;
    }
    [UIAlertController showSimpleAlertWithTitle:@"AcuantiOSMobileSDK"
                                        Message:message
                                    FirstButton:ButtonOK
                                   SecondButton:nil
                                   FirstHandler:^(UIAlertAction *action) {
                                       if (tag == 1) {
                                           self.sideTouch = BackSide;
                                           self.isCameraTouched = YES;
                                           [self showCameraInterface];
                                       }else if(tag == 7388467) {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }
                                   }
                                  SecondHandler:nil
                                            Tag:tag
                                 ViewController:self
                                    Orientation:UIDeviceOrientationUnknown];
}

#pragma mark -
#pragma mark CardCapturing Delegate
-(void)didCaptureData:(NSString *)data{
    self.isCameraTouched = NO;
    [self.backImage setImage:nil];
    self.barcodeString = data;
    //Enable to see the string
    //    [UIAlertView showSimpleAlertWithTitle:@"AcuantMobileSDK" Message:data  FirstButton:ButtonOK SecondButton:@"Copy" Delegate:self Tag:2];
    [self.sendRequestButton setEnabled:YES];
    [self.sendRequestButton setHidden:NO];
}

-(void)didCaptureCropImage:(UIImage *)cardImage scanBackSide:(BOOL)scanBackSide{
    
    NSString* message;
    if(self.cardType == AcuantCardTypePassportCard){
        message = @"Please make sure all the text on the Passport image is readable, otherwise retry.";
    }else{
        message = @"Please make sure all the text on the ID image is readable, otherwise retry.";
    }
    
    ConfirmationViewController* confirmVC = [[ConfirmationViewController alloc] initWithImage:cardImage andMessage:message scanBackSide:scanBackSide failed:NO];
    if ([self presentedViewController]) {
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:confirmVC animated:YES completion:nil];
            });
        }];
    } else {
        [self presentViewController:confirmVC animated:YES completion:nil];
        
    }
}

-(void)didFailToCaptureCropImage{
    NSString* message;
    if(self.cardType == AcuantCardTypePassportCard){
        message = @"Unable to detect the passport, please retry.";
    }else{
        message = @"Unable to detect the ID, please retry.";
    }
    
    UIImage* helpImage ;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"HelpScreenTip_ipad" ofType:@"png"];
        helpImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }else{
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"HelpScreenTip_iphone" ofType:@"png"];
        helpImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    ConfirmationViewController* confirmVC = [[ConfirmationViewController alloc] initWithImage:helpImage andMessage:message scanBackSide:NO failed:YES];
    if ([self presentedViewController]) {
        [[self presentedViewController] dismissViewControllerAnimated:NO completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:confirmVC animated:YES completion:nil];
            });
        }];
    } else {
        [self presentViewController:confirmVC animated:YES completion:nil];
        
    }
}


-(void)receivedConfirmationNotification:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    BOOL scanBackSide;
    if([[userInfo objectForKey:@"scanBackSide"] isEqualToString:@"YES"]){
        scanBackSide = YES;
    }else{
        scanBackSide = NO;
    }
    
    BOOL confirmed;
    if([[userInfo objectForKey:@"Confirmed"] isEqualToString:@"YES"]){
        confirmed = YES;
    }else{
        confirmed = NO;
    }
    UIImage* image = [userInfo objectForKey:@"OriginalImage"];
    if(confirmed){
        [self imageCapturedCorrectly:image scanBackSide:scanBackSide];
    }else{
        [self showCameraInterface];
    }
}

-(void)imageCapturedCorrectly:(UIImage*)cardImage scanBackSide:(BOOL)scanBackSide{
    if(!_frontImageConfirmed){
        _frontImageConfirmed = YES;
    }
    self.isCameraTouched = NO;
    [self.instance dismissCardCaptureInterface];
    self.isBarcodeSide = scanBackSide;
    switch (self.sideTouch) {
        case FrontSide:
            [self.frontImage setImage:cardImage];
            break;
        case BackSide:
            [self.backImage setImage:cardImage];
            [self.frontImageLabel setText:@""];
            [self.backImageLabel setText:@""];
            [self cardHolderPositions];
            self.frontImage.layer.masksToBounds = YES;
            self.frontImage.layer.cornerRadius = 10.0f;
            self.frontImage.layer.borderWidth = 1.0f;
            
            self.backImage.layer.masksToBounds = YES;
            self.backImage.layer.cornerRadius = 10.0f;
            self.backImage.layer.borderWidth = 1.0f;
            [self.backImage setUserInteractionEnabled:YES];
            break;
        default:
            break;
    }
    [self.sendRequestButton setEnabled:YES];
    [self.sendRequestButton setHidden:NO];
    if (scanBackSide) {
        self.sideTouch = BackSide;
        [UIAlertController showSimpleAlertWithTitle:@"AcuantiOSMobileSDKSample"
                                            Message:@"Scan the backside of the license."
                                        FirstButton:ButtonOK
                                       SecondButton:nil
                                       FirstHandler:^(UIAlertAction *action) {
                                           self.sideTouch = BackSide;
                                           self.isCameraTouched = YES;
                                           self.canShowBackButton = NO;
                                           if (self.cardRegion == AcuantCardRegionUnitedStates || self.cardRegion == AcuantCardRegionCanada) {
                                               [self.instance showBarcodeCameraInterfaceInViewController:self delegate:self cardType:self.cardType andRegion:self.cardRegion];
                                           }else{
                                               [self.instance showManualCameraInterfaceInViewController:self delegate:self cardType:self.cardType region:self.cardRegion andBackSide:YES];
                                           }
                                       }
                                      SecondHandler:nil
                                                Tag:1
                                     ViewController:self
                                        Orientation:UIDeviceOrientationUnknown];
    }
}

//Method to bring up the Selfie capturing interface
- (void)showSelfiCaptureInterface{
    [AcuantFacialRecognitionViewController
 presentFacialCatureInterfaceWithDelegate:self inViewController:self withCancelButton:YES withWatherMark:@"Powered by Acuant" withBlinkMessage:@"Blink Slowly" inRect:CGRectZero andFontSize:17];
}


-(void)didCaptureOriginalImage:(UIImage *)cardImage{
    self.originalImage = cardImage;
}

-(void)barcodeScanTimeOut{
    
    [_instance pauseScanningBarcodeCamera];
    
    [UIAlertController showSimpleAlertWithTitle:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                                        Message:@"Unable to scan the barcode?"
                                    FirstButton:@"Yes"
                                   SecondButton:@"Try Again"
                                   FirstHandler:^(UIAlertAction *action) {
                                       [_instance dismissCardCaptureInterface];
                                   }
                                  SecondHandler:^(UIAlertAction *action) {
                                      [_instance resumeScanningBarcodeCamera];
                                  }
                                            Tag:1
                                 ViewController:self.presentedViewController.presentedViewController
                                    Orientation:[UIDevice currentDevice].orientation];
}

-(void)didPressBackButton{
    [self.instance dismissCardCaptureInterface];
    self.isCameraTouched = NO;
    [self cardHolderPositions];
    [self optionsButtonsPositions];
}

-(void)cardCaptureInterfaceWillDisappear{
    self.isCameraTouched = NO;
    [self cardHolderPositions];
    [self optionsButtonsPositions];
}

//-(void)cardCaptureInterfaceDidDisappear{
//    self.isCameraTouched = NO;
//    [self cardHolderPositions];
//    [self optionsButtonsPositions];
//}

- (UIImage*)imageForBackButton{
    UIImage *image = [UIImage imageNamed:@"BackButton.png"];
    return image;
}

//- (CGRect)frameForBackButton
// {
// NSLog(@"reached frameForBackButton");
// return CGRectMake(50, 50, 100, 100);
// }
//
- (BOOL)showBackButton{
    return self.canShowBackButton;
}

-(BOOL)showiPadBrackets{
    return YES;
}

-(UIImage *)imageForHelpImageView{
    UIImage *image = [UIImage imageNamed:@"PDF417.png"];
    return  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone? image : nil);
}

//-(CGRect)frameForHelpImageView{
//    UIImage *image = [UIImage imageNamed:@"PDF417.png"];
//    CGRect frame = CGRectMake(self.view.frame.size.width/2 - image.size.width/2, self.view.frame.size.height/2 - image.size.height/2 + 20 , image.size.width, image.size.height);
//
//    return frame;
//}

-(NSString *)stringForWatermarkLabel{
    NSString *string = @"Powered by Acuant";
    return string;
}

-(BOOL)showFlashlightButton{
    return NO;
}

-(UIImage*)imageForFlashlightOffButton{
    return nil;
}

-(void)didFinishFacialRecognition:(UIImage*)image{
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"Capturing Data"];
    
    //Selfie Image
    UIImage *frontSideImage = image;
    //DL Photo
    UIImage *backSideImage =_resultViewController.faceImage;
    
    //Obtain the default AcuantCardProcessRequestOptions object for the type of card you want to process (License card for this example)
    AcuantCardProcessRequestOptions *options = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:AcuantCardTypeFacial];
    
    //Optionally, configure the options to the desired value
    options.autoDetectState = YES;
    options.stateID = -1;
    options.reformatImage = YES;
    options.reformatImageColor = 0;
    options.DPI = 150.0f;
    options.cropImage = NO;
    options.faceDetection = YES;
    options.signatureDetection = YES;
    options.region = self.cardRegion;
    options.imageSource = 101;
    
    // Now, perform the request
    [self.instance processFrontCardImage:frontSideImage
                           BackCardImage:backSideImage
                           andStringData:nil
                            withDelegate:self
                             withOptions:options];
}

-(void)didCancelFacialRecognition{
    _validatingSelfie = NO;
    [self presentResultView];
}

#pragma mark -
#pragma mark CardProcessing Delegate

- (void)didFinishValidatingImageWithResult:(AcuantFacialData*)result{
    [SVProgressHUD dismiss];
     self.view.userInteractionEnabled = YES;
    _resultViewController.result = [NSString stringWithFormat:@"%@\nFTID - %@\nTID - %@",_resultViewController.result,result.transactionId,_TID];
    if(result.isFacialEnabled==YES){
        NSLog(@"Success");
        _selfieMatched = result.isMatch ? @"1" : @"0";
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFacial Matched - %@",_resultViewController.result,_selfieMatched];
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFacial Enabled - 1",_resultViewController.result];
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFace Liveness Detection - %@",_resultViewController.result,result.faceLivelinessDetection ? @"1" : @"0"];
        _validatingSelfie = NO;
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFacial Match Confidence Rating - %@",_resultViewController.result,result.facialMatchConfidenceRating];
        _validatingSelfie = NO;
        [self presentResultView];
    }else{
        _selfieMatched = result.isMatch ? @"1" : @"0";
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFacial Matched - %@",_resultViewController.result,_selfieMatched];
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFacial Enabled - 0",_resultViewController.result];
        _resultViewController.result = [NSString stringWithFormat:@"%@\nFace Liveness Detection - %@",_resultViewController.result,result.faceLivelinessDetection ? @"1" : @"0"];
        _validatingSelfie = NO;
        [self presentResultView];
    }
    
}

-(void)didFinishProcessingCardWithResult:(AcuantCardResult *)result{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];
    NSString *message;
    UIImage *faceimage;
    UIImage *signatureImage;
    UIImage *frontImage;
    
    UIImage *backImage;
    if (self.cardType == AcuantCardTypeMedicalInsuranceCard) {
        AcuantMedicalInsuranceCard *data = (AcuantMedicalInsuranceCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nLast Name - %@ \nMiddle Name - %@ \nMemberID - %@ \nGroup No. - %@ \nContract Code - %@ \nCopay ER - %@ \nCopay OV - %@ \nCopay SP - %@ \nCopay UC - %@ \nCoverage - %@ \nDate of Birth - %@ \nDeductible - %@ \nEffective Date - %@ \nEmployer - %@ \nExpire Date - %@ \nGroup Name - %@ \nIssuer Number - %@ \nOther - %@ \nPayer ID - %@ \nPlan Admin - %@ \nPlan Provider - %@ \nPlan Type - %@ \nRX Bin - %@ \nRX Group - %@ \nRX ID - %@ \nRX PCN - %@ \nTelephone - %@ \nWeb - %@ \nEmail - %@ \nAddress - %@ \nCity - %@ \nZip - %@ \nState - %@\nTID - %@", data.firstName, data.lastName, data.middleName, data.memberId, data.groupNumber, data.contractCode, data.copayEr, data.copayOv, data.copaySp, data.copayUc, data.coverage, data.dateOfBirth, data.deductible, data.effectiveDate, data.employer, data.expirationDate, data.groupName, data.issuerNumber, data.other, data.payerId, data.planAdmin, data.planProvider, data.planType, data.rxBin, data.rxGroup, data.rxId, data.rxPcn, data.phoneNumber, data.webAddress, data.email, data.fullAddress, data.city, data.zip, data.state,data.transactionId];
        
        frontImage = [UIImage imageWithData:data.reformattedImage];
        backImage = [UIImage imageWithData:data.reformattedImageTwo];
        
    }else if (self.cardType == AcuantCardTypeDriversLicenseCard) {
        AcuantDriversLicenseCard *data = (AcuantDriversLicenseCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nMiddle Name - %@ \nLast Name - %@ \nName Suffix - %@ \nID - %@ \nLicense - %@ \nDOB Long - %@ \nDOB Short - %@ \nDate Of Birth Local - %@ \nIssue Date Long - %@ \nIssue Date Short - %@ \nIssue Date Local - %@ \nExpiration Date Long - %@ \nExpiration Date Short - %@ \nEye Color - %@ \nHair Color - %@ \nHeight - %@ \nWeight - %@ \nAddress - %@ \nAddress 2 - %@ \nAddress 3 - %@ \nAddress 4 - %@ \nAddress 5 - %@ \nAddress 6  - %@ \nCity - %@ \nZip - %@ \nState - %@ \nCounty - %@ \nCountry Short - %@ \nCountry Long - %@ \nClass - %@ \nRestriction - %@ \nSex - %@ \nAudit - %@ \nEndorsements - %@ \nFee - %@ \nCSC - %@ \nSigNum - %@ \nText1 - %@ \nText2 - %@ \nText3 - %@ \nType - %@ \nDoc Type - %@ \nFather Name - %@ \nMother Name - %@ \nNameFirst_NonMRZ - %@ \nNameLast_NonMRZ - %@ \nNameLast1 - %@ \nNameLast2 - %@ \nNameMiddle_NonMRZ - %@ \nNameSuffix_NonMRZ - %@ \nDocument Detected Name - %@ \nDocument Detected Name Short - %@ \nNationality - %@ \nOriginal - %@ \nPlaceOfBirth - %@ \nPlaceOfIssue - %@ \nSocial Security - %@", data.nameFirst, data.nameMiddle, data.nameLast, data.nameSuffix, data.licenceId, data.license, data.dateOfBirth4, data.dateOfBirth, data.dateOfBirthLocal, data.issueDate4, data.issueDate, data.issueDateLocal, data.expirationDate4, data.expirationDate, data.eyeColor, data.hairColor, data.height, data.weight, data.address, data.address2, data.address3, data.address4, data.address5, data.address6, data.city, data.zip, data.state, data.county, data.countryShort, data.idCountry, data.licenceClass, data.restriction, data.sex, data.audit, data.endorsements, data.fee, data.CSC, data.sigNum, data.text1, data.text2, data.text3, data.type, data.docType, data.fatherName, data.motherName, data.nameFirst_NonMRZ, data.nameLast_NonMRZ, data.nameLast1, data.nameLast2, data.nameMiddle_NonMRZ, data.nameSuffix_NonMRZ, data.documentDetectedName, data.documentDetectedNameShort, data.nationality, data.original, data.placeOfBirth, data.placeOfIssue, data.socialSecurity];
        _TID = data.transactionId;
        if(!_isFacialFlow){
            message = [NSString stringWithFormat:@"%@\nTID - %@",message,_TID];
        }
        //if (self.cardRegion == AcuantCardRegionUnitedStates || self.cardRegion == AcuantCardRegionCanada) {
            message = [NSString stringWithFormat:@"%@ \nIsBarcodeRead - %hhd \nIsIDVerified - %hhd \nIsOcrRead - %hhd \nDocument Verification Confidence Rating - %@", message, data.isBarcodeRead, data.isIDVerified, data.isOcrRead, data.documentVerificationRating];
        //}
        
        faceimage = [UIImage imageWithData:data.faceImage];
        signatureImage = [UIImage imageWithData:data.signatureImage];
        frontImage = [UIImage imageWithData:data.licenceImage];
        backImage = [UIImage imageWithData:data.licenceImageTwo];
    }else if (self.cardType == AcuantCardTypePassportCard){
        AcuantPassaportCard *data = (AcuantPassaportCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nMiddle Name - %@ \nLast Name - %@ \nPassport Number - %@ \nPersonal Number - %@ \nSex - %@ \nCountry Long - %@ \nNationality Long - %@ \nDOB Long - %@ \nIssue Date Long - %@ \nExpiration Date Long - %@ \nPlace of Birth - %@", data.nameFirst, data.nameMiddle, data.nameLast, data.passportNumber, data.personalNumber, data.sex, data.countryLong, data.nationalityLong, data.dateOfBirth4, data.issueDate4, data.expirationDate4, data.end_POB];
        _TID = data.transactionId;
        if(!_isFacialFlow){
            message = [NSString stringWithFormat:@"%@\nTID - %@",message,_TID];
        }
        
        faceimage = [UIImage imageWithData:data.faceImage];
        frontImage = [UIImage imageWithData:data.passportImage];
        signatureImage = [UIImage imageWithData:data.signImage];
    }else{
        message =@"Error";
    }
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        _resultViewController = [[ISGResultScreenViewController alloc]initWithNibName:@"CSSNResultScreen_iPhone" bundle:nil];
    }else{
        _resultViewController = [[ISGResultScreenViewController alloc]initWithNibName:@"CSSNResultScreen_iPad" bundle:nil];
    }
    _resultViewController.result = message;
    _resultViewController.faceImage = faceimage;
    _resultViewController.signatureImage = signatureImage;
    _resultViewController.frontImage = frontImage;
    _resultViewController.backImage = backImage;
    _resultViewController.cardType = self.cardType;
    _capturingData = NO;
    [self presentResultView];
}

-(void)presentResultView{
    if(!_capturingData && !_validatingSelfie){
        [self presentViewController:_resultViewController animated:YES completion:nil];
    }
}

-(void)captureSelfie{
    if(_instance.isFacialEnabled){
        _validatingSelfie = YES;
        [UIAlertController showSimpleAlertWithTitle:@"AcuantiOSMobileSDK"
                                            Message:@"Please position your face in front of the front camera and blink when red rectangle appears."
                                        FirstButton:ButtonOK
                                       SecondButton:ButtonCancel
                                       FirstHandler:^(UIAlertAction *action) {
                                           [self showSelfiCaptureInterface];
                                       }
                                      SecondHandler:nil
                                                Tag:1
                                     ViewController:self
                                        Orientation:UIDeviceOrientationUnknown];
        
    }else{
        _validatingSelfie = NO;
    }
}
@end
