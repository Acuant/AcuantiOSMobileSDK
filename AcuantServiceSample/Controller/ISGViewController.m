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
#import "UIAlertView+Custom.h"
#import "UIDevice+Resolutions.h"
#import <QuartzCore/QuartzCore.h>
#import <AcuantMobileSDK/AcuantMobileSDKController.h>

@interface ISGViewController () <UITextFieldDelegate,AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate, UIAlertViewDelegate, ISGRegionViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *frontImage;
@property (strong, nonatomic) IBOutlet UILabel *frontImageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *backImageLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (strong, nonatomic) IBOutlet UITextField *licenseKeyText;
@property (strong, nonatomic) IBOutlet UILabel *licenseKeyLabel;
@property (strong, nonatomic) IBOutlet UIButton *activateButton;
@property (strong, nonatomic) IBOutlet UIButton *driverLicenseButton;
@property (strong, nonatomic) IBOutlet UIButton *passportButton;
@property (strong, nonatomic) IBOutlet UIButton *medicalInsuranceButton;
@property (strong, nonatomic) NSString *barcodeString;
@property (strong, nonatomic) AcuantMobileSDKController *instance;
@property (nonatomic) AcuantCardRegion region;
@property (nonatomic) AcuantCardType cardType;
@property (nonatomic) NSUInteger sideTouch;
@property (nonatomic) BOOL canValidate;
@property (nonatomic) BOOL isLandscape;
@property (nonatomic) BOOL wasValidated;
@property (nonatomic) BOOL isBarcodeSide;
@property (nonatomic) BOOL isCameraTouched;
@property (nonatomic) BOOL canShowBackButton;
@property (nonatomic) UIInterfaceOrientation orientation;
@end

@implementation ISGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    _wasValidated = NO;
    NSString *licenseKey = [[NSUserDefaults standardUserDefaults]valueForKey:@"LICENSEKEY"];
    //Obtain the main controller instance
    _instance = [AcuantMobileSDKController initAcuantMobileSDKWithLicenseKey:licenseKey andDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _licenseKeyText.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"LICENSEKEY"];
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
    _cardType = AcuantCardTypeDriversLicenseCard;
    _isBarcodeSide = NO;
    
    ISGRegionViewController *regionListView = [[ISGRegionViewController alloc]initWithNibName:@"ISGRegionViewController" bundle:nil];
    regionListView.delegate = self;
    [self presentViewController:regionListView animated:YES completion:nil];
}
- (IBAction)captureMedicInsurance:(id)sender {
    _cardType = AcuantCardTypeMedicalInsuranceCard;
    _isBarcodeSide = NO;
    
    [_frontImage setImage:nil];
    [_frontImageLabel setText:@"Tap to capture front side"];
    [_backImage setImage:nil];
    [_backImageLabel setText:@"Tap to capture back side \n (optional)"];
    _barcodeString = nil;
    [self cardHolderPositions];
    [_sendRequestButton setEnabled:NO];
    [_sendRequestButton setHidden:NO];
    _frontImage.layer.masksToBounds = YES;
    _frontImage.layer.cornerRadius = 10.0f;
    _frontImage.layer.borderWidth = 1.0f;
    
    _backImage.layer.masksToBounds = YES;
    _backImage.layer.cornerRadius = 10.0f;
    _backImage.layer.borderWidth = 1.0f;
    [_backImage setUserInteractionEnabled:YES];
}
- (IBAction)capturePassport:(id)sender {
    _isBarcodeSide = NO;
    
    _cardType = AcuantCardTypePassportCard;
    [_backImageLabel setText:@""];
    [_backImage setImage:nil];
    [_frontImage setImage:nil];
    [_frontImageLabel setText:@"Tap to capture card"];
    _barcodeString = nil;
    [self cardHolderPositions];
    [_sendRequestButton setEnabled:NO];
    [_sendRequestButton setHidden:NO];
    _frontImage.layer.masksToBounds = YES;
    _frontImage.layer.cornerRadius = 10.0f;
    _frontImage.layer.borderWidth = 1.0f;
    
    _backImage.layer.masksToBounds = NO;
    _backImage.layer.cornerRadius = 10.0f;
    _backImage.layer.borderWidth = 0.0f;
    [_backImage setUserInteractionEnabled:NO];
}

- (IBAction)frontImage:(id)sender {
    if (_cardType) {
        _sideTouch = FrontSide;
        _isCameraTouched = YES;
        [self showCameraInterface];
    }
}
- (IBAction)backImage:(id)sender {
    if (_cardType) {
        _sideTouch = BackSide;
        _isCameraTouched = YES;
        [self showCameraInterface];
    }
}

- (IBAction)sendRequest:(id)sender {
    self.view.userInteractionEnabled = NO;
    [SVProgressHUD showWithStatus:@"Capturing Data"];
    
    //Obtain the front side of the card image
    UIImage *frontSideImage = [self frontSideCardImage];
    //Optionally, Obtain the back side of the image
    UIImage *backSideImage =[self backSideCardImage];
    
    //Obtain the default AcuantCardProcessRequestOptions object for the type of card you want to process (License card for this example)
    AcuantCardProcessRequestOptions *options = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:_cardType];
    
    //Optionally, configure the options to the desired value
    options.autoDetectState = YES;
    options.stateID = -1;
    options.reformatImage = YES;
    options.reformatImageColor = 0;
    options.DPI = 150.0f;
    options.cropImage = NO;
    options.faceDetection = YES;
    options.signatureDetection = YES;
    options.region = _region;
    options.imageSource = 101;
    
    // Now, perform the request
    [_instance processFrontCardImage:frontSideImage
                       BackCardImage:backSideImage
                       andStringData:_barcodeString
                        withDelegate:self
                         withOptions:options];
    
}

- (IBAction)activateAction:(id)sender {
    [_licenseKeyText resignFirstResponder];
    _canValidate = NO;
    if (![_licenseKeyText.text isEqualToString:@""]) {
        [_instance activateLicenseKey:_licenseKeyText.text];
        [_instance setLicenseKey:_licenseKeyText.text];
    }else{
        [UIAlertView showSimpleAlertWithTitle:@"Error" Message:@"The license key cannot be empty." FirstButton:ButtonOK SecondButton:ButtonNil Delegate:self Tag:0];
    }
    [[NSUserDefaults standardUserDefaults]setObject:_licenseKeyText.text forKey:@"LICENSEKEY"];
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
    if (!_isCameraTouched) {
        if (UIInterfaceOrientationIsLandscape([self orientation])) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [_driverLicenseButton setFrame:CGRectMake(110, 70, 200, 44)];
                [_passportButton setFrame:CGRectMake(412, 70, 200, 44)];
                [_medicalInsuranceButton setFrame:CGRectMake(714, 70, 200, 44)];
            }else{
                if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina4){
                    [_driverLicenseButton setFrame:CGRectMake(35, 60, 97, 24)];
                    [_passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(447, 60, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina47){
                    [_driverLicenseButton setFrame:CGRectMake(45, 60, 97, 24)];
                    [_passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(487, 60, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina55){
                    [_driverLicenseButton setFrame:CGRectMake(45, 60, 97, 24)];
                    [_passportButton setFrame:CGRectMake(268, 60, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(487, 60, 83, 24)];
                }
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [_driverLicenseButton setFrame:CGRectMake(76, 95, 200, 44)];
                [_passportButton setFrame:CGRectMake(284, 95, 200, 44)];
                [_medicalInsuranceButton setFrame:CGRectMake(492, 95, 200, 44)];
            }else{
                if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina4){
                    [_driverLicenseButton setFrame:CGRectMake(2, 75, 97, 24)];
                    [_passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(236, 75, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina47){
                    [_driverLicenseButton setFrame:CGRectMake(12, 75, 97, 24)];
                    [_passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(276, 75, 83, 24)];
                }else if ([[UIDevice currentDevice]resolution] == UIDeviceResolution_iPhoneRetina55){
                    [_driverLicenseButton setFrame:CGRectMake(12, 75, 97, 24)];
                    [_passportButton setFrame:CGRectMake(137, 75, 60, 24)];
                    [_medicalInsuranceButton setFrame:CGRectMake(276, 75, 83, 24)];
                }
            }
        }
    }
}

-(void)cardHolderPositions{
    if (!_isCameraTouched) {
        
        int heightiPad = (_cardType == AcuantCardTypePassportCard)?301:259;
        int heightiPhone = (_cardType == AcuantCardTypePassportCard)?158:143;
        int widthiPad = 426;
        int widthiPhone = 223;
        int centerX = self.view.frame.size.width / 2;
        
        if (UIInterfaceOrientationIsLandscape([self orientation])) {
            centerX = [[[UIDevice currentDevice]systemVersion] hasPrefix:@"7"]? self.view.frame.size.height / 2:self.view.frame.size.width / 2;
            if (_cardType == AcuantCardTypeMedicalInsuranceCard || (_cardType == AcuantCardTypeDriversLicenseCard && [_backImage image] != nil)){
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [_frontImage setFrame:CGRectMake(centerX - 456, 250, widthiPad, heightiPad)];
                    [_frontImageLabel setFrame:CGRectMake(centerX - 456, 250, widthiPad, heightiPad)];
                    [_backImage setFrame:CGRectMake(centerX + 30, 250, widthiPad, heightiPad)];
                    [_backImageLabel setFrame:CGRectMake(centerX + 30, 250, widthiPad, heightiPad)];
                }else{
                    [_frontImage setFrame:CGRectMake(centerX - 253, 100, widthiPhone, heightiPhone)];
                    [_frontImageLabel setFrame:CGRectMake(centerX - 253, 100, widthiPhone, heightiPhone)];
                    [_backImage setFrame:CGRectMake(centerX + 30, 100, widthiPhone, heightiPhone)];
                    [_backImageLabel setFrame:CGRectMake(centerX + 30, 100, widthiPhone, heightiPhone)];
                }
            }else{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [_frontImage setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [_frontImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [_backImage setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                    [_backImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 250, widthiPad, heightiPad)];
                }else{
                    [_frontImage setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [_frontImageLabel setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [_backImage setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                    [_backImageLabel setFrame:CGRectMake(centerX - widthiPhone/2, 100, widthiPhone, heightiPhone)];
                }
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [_frontImage setFrame:CGRectMake(centerX - widthiPad/2, 200, widthiPad, heightiPad)];
                [_frontImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 200, widthiPad, heightiPad)];
                [_backImage setFrame:CGRectMake(centerX - widthiPad/2, 600, widthiPad, heightiPad)];
                [_backImageLabel setFrame:CGRectMake(centerX - widthiPad/2, 600, widthiPad, heightiPad)];
            }else{
                [_frontImage setFrame:CGRectMake(centerX- widthiPhone/2, 143, widthiPhone, heightiPhone)];
                [_frontImageLabel setFrame:CGRectMake(centerX- widthiPhone/2, 143, widthiPhone, heightiPhone)];
                [_backImage setFrame:CGRectMake(centerX- widthiPhone/2, 353, widthiPhone, heightiPhone)];
                [_backImageLabel setFrame:CGRectMake(centerX- widthiPhone/2, 353, widthiPhone, heightiPhone)];
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
    //[_instance setInitialMessage:@"ALING AND TAP" frame:CGRectMake(0, 0, 0, 0) backgroundColor:nil duration:10.0 orientation: AcuantHUDLandscape];
    /*[_instance setCapturingMessage:@"Capturing Message" frame:CGRectMake(0, 0, 0, 0) backgroundColor:nil duration:10.0 orientation: AcuantHUDLandscape];*/
    if (_cardType == AcuantCardTypePassportCard) {
        [_instance setWidth:1478];
    }else{
        [_instance setWidth:1012];
    }
    _canShowBackButton = YES;
    if (_sideTouch == BackSide && _cardType == AcuantCardTypeDriversLicenseCard) {
        _canShowBackButton = NO;
    }
    //Uncomment to Capture backside image of the Barcode
    //[_instance setCanCropBarcode:YES];
    //[_instance setCanShowMessage:YES];
    [_instance showCameraInterfaceInViewController:self delegate:self cardType:_cardType region:_region isBarcodeSide:_isBarcodeSide];
}


#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        _sideTouch = BackSide;
        _isCameraTouched = YES;
        [self showCameraInterface];
    }
    if (alertView.tag == 2) {
        if (buttonIndex != 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string =self.barcodeString;
        }
    }
    if (alertView.tag == 7388467)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (IBAction)hideTextfield:(id)sender {
    UITextField *textField = (UITextField*)sender;
    _canValidate = YES;
    [textField resignFirstResponder];
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    UITextField *textField = (UITextField*)sender;
    if (_canValidate) {
        _wasValidated = NO;
        [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"LICENSEKEY"];
        [_instance setLicenseKey:textField.text];
    }
}
#pragma mark -
#pragma mar Region Delegate

- (void)setRegion:(AcuantCardRegion)region{
    _region = region;
    if (_region == AcuantCardRegionCanada || _region == AcuantCardRegionUnitedStates) {
        [_frontImage setImage:nil];
        [_frontImageLabel setText:@"Tap to capture front side"];
        [_backImage setImage:nil];
        [_backImageLabel setText:@""];
        _barcodeString = nil;
        [self cardHolderPositions];
        [_sendRequestButton setEnabled:NO];
        [_sendRequestButton setHidden:NO];
        _frontImage.layer.masksToBounds = YES;
        _frontImage.layer.cornerRadius = 10.0f;
        _frontImage.layer.borderWidth = 1.0f;
        
        _backImage.layer.masksToBounds = NO;
        _backImage.layer.cornerRadius = 10.0f;
        _backImage.layer.borderWidth = 0.0f;
        [_backImage setUserInteractionEnabled:NO];
    }else{
        [_frontImage setImage:nil];
        [_frontImageLabel setText:@"Tap to capture front side"];
        [_backImage setImage:nil];
        [_backImageLabel setText:@""];
        _barcodeString = nil;
        [self cardHolderPositions];
        [_sendRequestButton setEnabled:NO];
        [_sendRequestButton setHidden:NO];
        _frontImage.layer.masksToBounds = YES;
        _frontImage.layer.cornerRadius = 10.0f;
        _frontImage.layer.borderWidth = 1.0f;
        
        _backImage.layer.masksToBounds = NO;
        _backImage.layer.cornerRadius = 10.0f;
        _backImage.layer.borderWidth = 0.0f;
        [_backImage setUserInteractionEnabled:NO];
    }
}

#pragma mark -
#pragma mark General Delegates
-(void)mobileSDKWasValidated:(BOOL)wasValidated{
    _wasValidated = YES;
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
            break;
        case AcuantErrorWebResponse:
            message = error.errorMessage;
            break;
        case AcuantErrorUnableToCrop:
            message = error.errorMessage;
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
    [UIAlertView showSimpleAlertWithTitle:@"AcuantiOSMobileSDK" Message:message  FirstButton:ButtonOK SecondButton:ButtonNil Delegate:self Tag:tag];
}

#pragma mark -
#pragma mark CardCapturing Delegate
-(void)didCaptureData:(NSString *)data{
    _isCameraTouched = NO;
    [_backImage setImage:nil];
    self.barcodeString = data;
    //Enable to see the string
    //    [UIAlertView showSimpleAlertWithTitle:@"AcuantMobileSDK" Message:data  FirstButton:ButtonOK SecondButton:@"Copy" Delegate:self Tag:2];
    [_sendRequestButton setEnabled:YES];
    [_sendRequestButton setHidden:NO];
}

-(void)didCaptureImage:(UIImage *)cardImage scanBackSide:(BOOL)scanBackSide{
    _isCameraTouched = NO;
    [_instance dismissCardCaptureInterface];
    _isBarcodeSide = scanBackSide;
    switch (_sideTouch) {
        case FrontSide:
            [_frontImage setImage:cardImage];
            break;
        case BackSide:
            [_backImage setImage:cardImage];
            [_frontImageLabel setText:@""];
            [_backImageLabel setText:@""];
            [self cardHolderPositions];
            _frontImage.layer.masksToBounds = YES;
            _frontImage.layer.cornerRadius = 10.0f;
            _frontImage.layer.borderWidth = 1.0f;
            
            _backImage.layer.masksToBounds = YES;
            _backImage.layer.cornerRadius = 10.0f;
            _backImage.layer.borderWidth = 1.0f;
            [_backImage setUserInteractionEnabled:YES];
            break;
        default:
            break;
    }
    [_sendRequestButton setEnabled:YES];
    [_sendRequestButton setHidden:NO];
    if (scanBackSide) {
        _sideTouch = BackSide;
        [UIAlertView showSimpleAlertWithTitle:@"AcuantiOSMobileSDKSample" Message:@"Scan the backside of the license."  FirstButton:ButtonOK SecondButton:nil Delegate:self Tag:1];
    }
}

-(void)didPressBackButton{
    [_instance dismissCardCaptureInterface];
    _isCameraTouched = NO;
    [self cardHolderPositions];
    [self optionsButtonsPositions];
}

-(void)cardCaptureInterfaceWillDisappear{
    _isCameraTouched = NO;
    [self cardHolderPositions];
    [self optionsButtonsPositions];
}

//-(void)cardCaptureInterfaceDidDisappear{
//    _isCameraTouched = NO;
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
    return _canShowBackButton;
}

- (NSString *)stringForBarcodeErrorMessage{
    NSString *string = @"Unable to scan the barcode?";
    return string;
}
- (NSString *)stringForBarcodeTitleError{
    NSString *string = @"AcuantiOSMobileSDKSample";
    return string;
}
- (int)timeForBarcodeErrorMessage{
    return 10;
}
- (BOOL)isHiddenBarcodeErrorMessage{
    return NO;
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

#pragma mark -
#pragma mark CardProcessing Delegate
-(void)didFinishProcessingCardWithResult:(AcuantCardResult *)result{
    self.view.userInteractionEnabled = YES;
    [SVProgressHUD dismiss];
    NSString *message;
    UIImage *faceimage;
    UIImage *signatureImage;
    UIImage *frontImage;
    
    UIImage *backImage;
    if (_cardType == AcuantCardTypeMedicalInsuranceCard) {
        AcuantMedicalInsuranceCard *data = (AcuantMedicalInsuranceCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nLast Name - %@ \nMiddle Name - %@ \nMemberID - %@ \nGroup No. - %@ \nContract Code - %@ \nCopay ER - %@ \nCopay OV - %@ \nCopay SP - %@ \nCopay UC - %@ \nCoverage - %@ \nDate of Birth - %@ \nDeductible - %@ \nEffective Date - %@ \nEmployer - %@ \nExpire Date - %@ \nGroup Name - %@ \nIssuer Number - %@ \nOther - %@ \nPayer ID - %@ \nPlan Admin - %@ \nPlan Provider - %@ \nPlan Type - %@ \nRX Bin - %@ \nRX Group - %@ \nRX ID - %@ \nRX PCN - %@ \nTelephone - %@ \nWeb - %@ \nEmail - %@ \nAddress - %@ \nCity - %@ \nZip - %@ \nState - %@", data.firstName, data.lastName, data.middleName, data.memberId, data.groupNumber, data.contractCode, data.copayEr, data.copayOv, data.copaySp, data.copayUc, data.coverage, data.dateOfBirth, data.deductible, data.effectiveDate, data.employer, data.expirationDate, data.groupName, data.issuerNumber, data.other, data.payerId, data.planAdmin, data.planProvider, data.planType, data.rxBin, data.rxGroup, data.rxId, data.rxPcn, data.phoneNumber, data.webAddress, data.email, data.fullAddress, data.city, data.zip, data.state];
        
        frontImage = [UIImage imageWithData:data.reformattedImage];
        backImage = [UIImage imageWithData:data.reformattedImageTwo];
        
    }else if (_cardType == AcuantCardTypeDriversLicenseCard) {
        AcuantDriversLicenseCard *data = (AcuantDriversLicenseCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nMiddle Name - %@ \nLast Name - %@ \nName Suffix - %@ \nID - %@ \nLicense - %@ \nDOB Long - %@ \nDOB Short - %@ \nDate Of Birth Local - %@ \nIssue Date Long - %@ \nIssue Date Short - %@ \nIssue Date Local - %@ \nExpiration Date Long - %@ \nExpiration Date Short - %@ \nEye Color - %@ \nHair Color - %@ \nHeight - %@ \nWeight - %@ \nAddress - %@ \nAddress 2 - %@ \nAddress 3 - %@ \nAddress 4 - %@ \nAddress 5 - %@ \nAddress 6  - %@ \nCity - %@ \nZip - %@ \nState - %@ \nCounty - %@ \nCountry Short - %@ \nCountry Long - %@ \nClass - %@ \nRestriction - %@ \nSex - %@ \nAudit - %@ \nEndorsements - %@ \nFee - %@ \nCSC - %@ \nSigNum - %@ \nText1 - %@ \nText2 - %@ \nText3 - %@ \nType - %@ \nDoc Type - %@ \nFather Name - %@ \nMother Name - %@ \nNameFirst_NonMRZ - %@ \nNameLast_NonMRZ - %@ \nNameLast1 - %@ \nNameLast2 - %@ \nNameMiddle_NonMRZ - %@ \nNameSuffix_NonMRZ - %@ \nDocument Detected Name - %@ \nDocument Detected Name Short - %@ \nNationality - %@ \nOriginal - %@ \nPlaceOfBirth - %@ \nPlaceOfIssue - %@ \nSocial Security - %@ \nIsAddressCorrected - %hhd \nIsAddressVerified - %hhd", data.nameFirst, data.nameMiddle, data.nameLast, data.nameSuffix, data.licenceId, data.license, data.dateOfBirth4, data.dateOfBirth, data.dateOfBirthLocal, data.issueDate4, data.issueDate, data.issueDateLocal, data.expirationDate4, data.expirationDate, data.eyeColor, data.hairColor, data.height, data.weight, data.address, data.address2, data.address3, data.address4, data.address5, data.address6, data.city, data.zip, data.state, data.county, data.countryShort, data.idCountry, data.licenceClass, data.restriction, data.sex, data.audit, data.endorsements, data.fee, data.CSC, data.sigNum, data.text1, data.text2, data.text3, data.type, data.docType, data.fatherName, data.motherName, data.nameFirst_NonMRZ, data.nameLast_NonMRZ, data.nameLast1, data.nameLast2, data.nameMiddle_NonMRZ, data.nameSuffix_NonMRZ, data.documentDetectedName, data.documentDetectedNameShort, data.nationality, data.original, data.placeOfBirth, data.placeOfIssue, data.socialSecurity, data.isAddressCorrected, data.isAddressVerified];
        if (_region == AcuantCardRegionUnitedStates || _region == AcuantCardRegionCanada) {
            message = [NSString stringWithFormat:@"%@ \nIsBarcodeRead - %hhd \nIsIDVerified - %hhd \nIsOcrRead - %hhd \nDocument Verification Confidence Rating - %@", message, data.isBarcodeRead, data.isIDVerified, data.isOcrRead, data.documentVerificationRating];
        }
        
        faceimage = [UIImage imageWithData:data.faceImage];
        signatureImage = [UIImage imageWithData:data.signatureImage];
        frontImage = [UIImage imageWithData:data.licenceImage];
        backImage = [UIImage imageWithData:data.licenceImageTwo];
    }else if (_cardType == AcuantCardTypePassportCard){
        AcuantPassaportCard *data = (AcuantPassaportCard*)result;
        message =[NSString stringWithFormat:@"First Name - %@ \nMiddle Name - %@ \nLast Name - %@ \nPassport Number - %@ \nPersonal Number - %@ \nSex - %@ \nCountry Long - %@ \nNationality Long - %@ \nDOB Long - %@ \nIssue Date Long - %@ \nExpiration Date Long - %@ \nPlace of Birth - %@", data.nameFirst, data.nameMiddle, data.nameLast, data.passportNumber, data.personalNumber, data.sex, data.countryLong, data.nationalityLong, data.dateOfBirth4, data.issueDate4, data.expirationDate4, data.end_POB];
        
        faceimage = [UIImage imageWithData:data.faceImage];
        frontImage = [UIImage imageWithData:data.passportImage];
        signatureImage = [UIImage imageWithData:data.signImage];
    }else{
        message =@"Error";
    }
    
    ISGResultScreenViewController *resultViewController;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        resultViewController = [[ISGResultScreenViewController alloc]initWithNibName:@"CSSNResultScreen_iPhone" bundle:nil];
    }else{
        resultViewController = [[ISGResultScreenViewController alloc]initWithNibName:@"CSSNResultScreen_iPad" bundle:nil];
    }
    resultViewController.result = message;
    resultViewController.faceImage = faceimage;
    resultViewController.signatureImage = signatureImage;
    resultViewController.frontImage = frontImage;
    resultViewController.backImage = backImage;
    resultViewController.cardType = _cardType;
    
    [self presentViewController:resultViewController animated:YES completion:nil];
    //    [self showSimpleAlertWithMessage:message];
}
@end
