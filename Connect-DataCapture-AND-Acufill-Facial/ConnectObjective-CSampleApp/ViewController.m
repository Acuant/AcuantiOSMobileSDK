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
#import <AcuantMobileSDK/AcuantFacialRecognitionViewController.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface ViewController ()<ResultCancelDelegate,AcuantMobileSDKControllerCapturingDelegate,AcuantMobileSDKControllerProcessingDelegate,AcuantFacialCaptureDelegate>

@property(nonatomic) BOOL acufillValidated;
@property(nonatomic) BOOL acufillValidating;
@property(nonatomic) BOOL capturingData;
@property(nonatomic,strong) AcuantMobileSDKController* connect_instance;
@property(nonatomic,strong) AcuantMobileSDKController* acufill_instance;
@property(nonatomic,strong) NSDictionary* resultData;
@property(nonatomic) int side; // 0 front , 1 back
@property(nonatomic) AcuantCardType cardType;

@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,strong) NSString* subscription;
@property(nonatomic,strong) NSString* connectURL;
@property(nonatomic,strong) NSString* acufillURL;
@property(nonatomic,strong) NSString* acufillLicenseKey;
@property(nonatomic,strong) UIImage* faceImage;
@property(nonatomic,strong) AcuantFacialData* facialData;

@property(nonatomic,strong) IBOutlet UIImageView* frontCardImageView;
@property(nonatomic,strong) IBOutlet UILabel* frontImageViewLabel;
@property(nonatomic,strong) IBOutlet UILabel* backImageViewLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backCardImageView;
@property (strong, nonatomic) IBOutlet UIButton *processButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _acufillValidated = NO;
    _acufillValidating = NO;
    _capturingData=NO;
    _username = @"XXXXXXXXXXXX";
    _password = @"XXXXXXXXXXXX";
    _subscription = @"XXXXXXXXXXXX";
    _connectURL = @"https://devconnect.assureid.net/AssureIDService";
    _acufillURL=@"cssnwebservices.com";
    _acufillLicenseKey=@"XXXXXXXXXXXX";
    
    [self hideFrontUI];
    [self hideUIBack];
    [self hideProcessButton];
    _side = 0;
    
    //UI Initialization ends
    
    // Create and add the view to the screen.
    
    [ProgressHUD show:@"Validating key"];
    _connect_instance = [AcuantMobileSDKController initAcuantMobileSDKWithUsername:_username password:_password subscription:_subscription url:_connectURL andDelegate:self];

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
    _capturingData=NO;
    _resultData = nil;
    _facialData=nil;
    _faceImage=nil;
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
        _capturingData = YES;
        AcuantCardProcessRequestOptions* options  = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:_cardType];
        
        [_connect_instance processCardWithOptions:options frontImage:_frontCardImageView.image backImage:_backCardImageView.image barcodeString:nil];
        
        [self captureSelfie];
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
    if(_connect_instance!=nil){
        [_connect_instance setCloudAddress:_connectURL];
        [_connect_instance showManualCameraInterfaceInViewController:self delegate:self cardType:AcuantCardTypeDriversLicenseCard region:AcuantCardRegionUnitedStates andBackSide:YES];
    }
}

//Method to bring up the Selfie capturing interface
- (void)showSelfiCaptureInterface{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGRect messageFrame = CGRectMake(0,50,screenWidth,20);
    
    NSMutableAttributedString* message = [[NSMutableAttributedString alloc] initWithString:@"Get closer until Red Rectangle appears and Blink"];
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, message.length)];
    NSRange range=[message.string rangeOfString:@"Red Rectangle"];
    UIFont *font = [UIFont systemFontOfSize:13];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:14];
    
    if(IS_IPHONE_5){
        font = [UIFont systemFontOfSize:11];
        boldFont = [UIFont boldSystemFontOfSize:12];
    }
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [message addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, message.length)];
    [message addAttribute:NSFontAttributeName value:boldFont range:range];
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(UIDeviceOrientationIsLandscape(orientation)){
        CGFloat screenHeight = screenRect.size.height;
        messageFrame = CGRectMake(0,50,screenHeight,20);
        
    }
    
    [AcuantFacialRecognitionViewController
     presentFacialCaptureInterfaceWithDelegate:self withSDK:_acufill_instance inViewController:self withCancelButton:YES withWaterMark:@"Powered by Acuant" withBlinkMessage:message inRect:messageFrame];
}

-(void)captureSelfie{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connect Example"
                                                                   message:@"Please position your face in front of the front camera and blink when red rectangle appears."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *firstButtonAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            [alert removeFromParentViewController];
                                            [self showSelfiCaptureInterface];
                                        }];
    
    [alert addAction:firstButtonAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toResult"]){
        ResultViewController* destinationVC = (ResultViewController*)[segue destinationViewController];
        destinationVC.cancelDelegate = self;
        destinationVC.cardData=_resultData;
        destinationVC.cardType=_cardType;
        destinationVC.username=_username;
        destinationVC.password=_password;
        destinationVC.facialData=_facialData;
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
    if(!wasValidated){
        UIAlertController* alertController = [[UIAlertController alloc] init];
        [alertController setTitle:@"ConnectExample"];
        if(_acufillValidating==NO){
            [alertController setMessage:@"Credntials are not valid"];
        }else{
            [alertController setMessage:@"License key is not valid"];
        }
        UIAlertAction* dismissButton = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                        }];
        
        [alertController addAction:dismissButton];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if(_acufillValidated==NO && _acufillValidating==NO){
        self.view.userInteractionEnabled=NO;
        _acufillValidating=YES;
        _acufill_instance = [AcuantMobileSDKController initAcuantMobileSDKWithLicenseKey:_acufillLicenseKey delegate:self andCloudAddress:_acufillURL];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
    });
    _acufillValidated = YES;
    
}

-(void) didFinishProcessingCardWithResult:(AcuantCardResult *)result{
    
}

-(void) didFinishProcessingCardWithAssureIDResult:(id)json{
    _resultData=json;
    NSArray* fields = [_resultData objectForKey:@"Fields"];
    for(NSDictionary* field in fields){
        if([[field objectForKey:@"Name"] isEqualToString:@"Photo"]){
            NSString* faceImageURL = [field objectForKey:@"Value"];
            [self downloadedFromurlStr:faceImageURL username:_username password:_password];
        }
    }
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
    self.view.userInteractionEnabled = YES;
    _facialData=(AcuantFacialData*)result;
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
        [self performSegueWithIdentifier:@"toResult" sender:nil];
    });
    
}

-(void)didFinishFacialRecognition:(UIImage*)image{
    self.view.userInteractionEnabled = NO;
    [ProgressHUD show:@"Capturing data..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        while(_capturingData){
            [NSThread sleepForTimeInterval:0.1f];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //Selfie Image
            UIImage *frontSideImage = image;
            //DL Photo
            NSData *dlPhoto =UIImageJPEGRepresentation(_faceImage,1.0);
            
            if(frontSideImage==nil || _faceImage==nil){
                self.view.userInteractionEnabled = YES;
                _facialData=nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"toResult" sender:nil];
                });
                return;
            }
            
            //Obtain the default AcuantCardProcessRequestOptions object for the type of card you want to process (License card for this example)
            AcuantCardProcessRequestOptions *options = [AcuantCardProcessRequestOptions defaultRequestOptionsForCardType:AcuantCardTypeFacial];
            
            // Now, perform the request
            [_acufill_instance setCloudAddress:_acufillURL];
            [_acufill_instance validatePhotoOne:frontSideImage withImage:dlPhoto
                               withDelegate:self
                                withOptions:options];
            
        });
    });
    
}

-(void)didCancelFacialRecognition{
    
}

-(void)didTimeoutFacialRecognition:(UIImage*)lastImage{
    [self didFinishFacialRecognition:lastImage];
}

-(int)facialRecognitionTimeout{
    return 20; // returns timeout in seconds
}

-(NSAttributedString*)messageToBeShownAfterFaceRectangleAppears{
    return [[NSAttributedString alloc] initWithString:@"Analyzing.." attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
}

-(CGRect)frameWhereMessageToBeShownAfterFaceRectangleAppears{
    return CGRectZero; // By default the message will be shown below the instruction message
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


-(void) downloadedFromurlStr:(NSString*)urlStr username:(NSString*)username password:(NSString*)password {
    NSData* loginData = [[NSString stringWithFormat:@"%@:%@",username,password] dataUsingEncoding:kCFStringEncodingUTF8];
    NSString* base64LoginData = [loginData base64EncodedStringWithOptions:0];
    
    // create the request
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"%@%@",@"Basic ",base64LoginData] forHTTPHeaderField:@"Authorization"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,    NSURLResponse *response, NSError *error) {
        if(error==nil && data!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                _capturingData=NO;
                _faceImage=[UIImage imageWithData:data];
            });
        }
    }] resume];
}

@end
