//
//  AcuantCardCaptureController
//  AcuantCardCapture Framework for iOS
//
//  Created by Acuant on 11/19/12.
//  Copyright (c) 2015 Acuant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AcuantCardProcessRequestOptions.h"
#import "AcuantError.h"
#import "AcuantCardResult.h"
#import "AcuantMedicalInsuranceCard.h"
#import "AcuantDriversLicenseCard.h"
#import "AcuantPassaportCard.h"
#import "AcuantCardType.h"
#import "AcuantDeviceLocationTestResult.h"

//#import "AcuantCardDataRequestError.h"

typedef enum{
    AcuantHUDLandscape = 0,
    AcuantHUDPortrait = 1
} AcuantHUDOrientation;


@protocol AcuantMobileSDKControllerCapturingDelegate <NSObject>

@required

/**
 Called to inform the delegate that a card image was captured
 @param cardImage the card image
 */
- (void)didCaptureCropImage:(UIImage*)cardImage scanBackSide:(BOOL)scanBackSide andCardType:(AcuantCardType)cardType withImageMetrics:(NSDictionary*)imageMetrics;

/**
 Called to inform the delegate that a barcode image was captured
 @param data the barcode string
 */
- (void)didCaptureData:(NSString*)data;


/**
 Called to inform delegate that the request failed.
 @param error the reason why the request failed
 @discussion the delegate is in charge of analysing the error sent and inform the user.
 */
- (void)didFailWithError:(AcuantError*)error;

@optional

/**
 Called to inform the delegate that a card image photo is taken even happened
 */
- (void)didTakeCardPhoto;

/**
 Called to inform the delegate that a card image was captured
 @param cardImage the card image
 */
- (void)didCaptureCropImage:(UIImage*)cardImage andData:(NSString*)data scanBackSide:(BOOL)scanBackSide withImageMetrics:(NSDictionary*)imageMetrics;


/**
 Called to inform the delegate that a card image was captured with some problems
 @param cardImage the card image
 */
-(void)didFailToCaptureCropImage;

/**
 Called to inform the delegate that a card image was captured
 @param cardImage the full image
 */
- (void)didCaptureOriginalImage:(UIImage*)cardImage;

/**
 Called to inform the delegate that the time of the barcode scan expired
 @param croppedImage : The cropped Image
 @param originalImage : the original Image
 */
- (void)barcodeScanTimeOut:(UIImage*)croppedImage withImageMetrics:(NSDictionary*)imageMetrics andOriginalImage:(UIImage*)originalImage;


/**
 Called to inform the delegate that the back button on the barcode interface is pressed
 @param croppedImage : The cropped Image
 @param originalImage : the original Image
 */

- (void)didCancelToCaptureData:(UIImage*)croppedImage withImageMetrics:(NSDictionary*)imageMetrics andOriginalImage:(UIImage*)originalImage;

/**
 Called to inform the delegate that the user pressed the back button
 */
- (void)didPressBackButton;

/**
 Called to inform the delegate that the framework was validated
 */
- (void)mobileSDKWasValidated:(BOOL)wasValidated;

/**
 Called to inform the delegate that the capture interface did appear
 */
- (void)cardCaptureInterfaceDidAppear;

/**
 Called to inform the delegate that the capture interface did disappear
 */
- (void)cardCaptureInterfaceDidDisappear;

/**
 Called to inform the delegate that the capture interface will disappear
 */
- (void)cardCaptureInterfaceWillDisappear;

/**
 Called to obtain the flashlight button image displayed in the card capture interface
 @return the flashlight button image
 @discussion if this method is not implemented or nil is returned, we'll display a white rounded button with "flash" text
 @discussion this delegate method is only called when presenting the card capture interface full screen. If card capture interface is presented in a UIPopOverController, this method is not called at all because a Cancel UIBarButtonItem in the UINavigationBar is used instead.
 */
- (UIImage*)imageForFlashlightButton;

/**
 Called to obtain the flashlight button off image displayed in the card capture interface
 @return the flashlight off button image
 @discussion if this method is not implemented or nil is returned, we'll display a white rounded button with "Off" text
 @discussion this delegate method is only called when presenting the card capture interface full screen. If card capture interface is presented in a UIPopOverController, this method is not called at all because a Cancel UIBarButtonItem in the UINavigationBar is used instead.
 */
- (UIImage*)imageForFlashlightOffButton;


/**
 Called to obtain the flashlight button position in the screen.
 @return the point where the flashlight button should be positioned
 @discussion in case this method is not implemented by the delegate, we'll set a default location for the button though we encourage you to set the position manually.
 @discussion if your application supports multiple screen sizes then you are in charge of returning the correct position for each screen size.
 */
- (CGRect)frameForFlashlightButton;

/**
 Called to show or not show the flashlight button in the card capture interface
 @return show or not show the flashlight button
 @discussion if this method is not implemented or nil is returned, we'll display a the button with "flash" text
 */
- (BOOL)showFlashlightButton;

/**
 Called to show or not show the iPad brackets on the card capture interface
 @return show or not show the iPad brackets
 @discussion if this method is not implemented, we'll not display a brackets on the view
 */
- (BOOL)showiPadBrackets;

/**
 
 Called to obtain the back button image displayed in the card capture interface
 @return the back button image
 @discussion if this method is not implemented or nil is returned, we'll display a white rounded button with "back" text
 */
- (UIImage*)imageForBackButton;

/**
 Called to obtain the back button position in the screen.
 @return the point where the back button should be positioned
 @discussion in case this method is not implemented by the delegate, we'll set a default location for the button though we encourage you to set the position manually.
 @discussion if your application supports multiple screen sizes then you are in charge of returning the correct position for each screen size.
 */
- (CGRect)frameForBackButton;

/**
 Called to show or not show the back button in the card capture interface
 @return show or not show the back button
 @discussion if this method is not implemented or nil is returned, we'll display a the button with "back" text
 */
- (BOOL)showBackButton;


/**
 Called to crop or not crop the barcode side image when the back button is pressed in the barcode screen
 @return crop or not crop the barcode side on back pressed
 @discussion if this method is not implemented or nil is returned, we'll not crop the barcode side when the back button is pressed
 */
-(BOOL)canCropBarcodeOnBackPressed;

-(BOOL)startScanningBarcodeAfterTap;

/**
 Called to obtain the help image displayed in the card capture interface
 @return the help image
 @discussion if this method is not implemented or nil is returned, we'll not display a help image view
 */
- (UIImage*)imageForHelpImageView;

/**
 Called to obtain the help image position in the screen.
 @return the point where the help image should be positioned
 @discussion in case this method is not implemented by the delegate, we'll set a default location for the help image though we encourage you to set the position manually.
 @discussion if your application supports multiple screen sizes then you are in charge of returning the correct position for each screen size.
 */
- (CGRect)frameForHelpImageView;

/**
 Called to obtain the watermark Message displayed in the card capture interface
 @return the watermark Message
 @discussion if this method is not implemented or nil is returned, we'll not display a watermark Message view
 */
- (NSString*)stringForWatermarkLabel;

/**
 Called to obtain the watermark label position in the screen.
 @return the point where the watermark label should be positioned
 @discussion in case this method is not implemented by the delegate, we'll set a default location for the help image though we encourage you to set the position manually.
 @discussion if your application supports multiple screen sizes then you are in charge of returning the correct position for each screen size.
 */
- (CGRect)frameForWatermarkView;

/**
 These methods control the attributes of the status bar when this view controller is shown.
 */
- (BOOL)cameraPrefersStatusBarHidden;


@end

@protocol AcuantMobileSDKControllerProcessingDelegate <NSObject>

@required

/**
 Called to inform delegate that the request completed succesfully.
 @param result the data parsed from the validation images
 */
- (void)didFinishValidatingImageWithResult:(AcuantCardResult*)result;

/**
 Called to inform delegate that the request completed succesfully.
 @param result the data parsed from the card image
 */
- (void)didFinishProcessingCardWithResult:(AcuantCardResult*)result;

/**
 Called to inform delegate that the request failed.
 @param error the reason why the request failed
 @discussion the delegate is in charge of analysing the error sent and inform the user.
 */
- (void)didFailWithError:(AcuantError*)error;

@optional

/**
 Called to inform the delegate that the framework was validated
 */
- (void)mobileSDKWasValidated:(BOOL)wasValidated;

/**
 Called to inform delegate that the AssureID request completed succesfully.
 @param result the data parsed from the card image
 */
- (void)didFinishProcessingCardWithAssureIDResult:(id)json;

- (void)didDeleteInstance:(NSString*)instanceID;

-(void)failToDeleteInstanceWithError:(AcuantError*)error;


/**
 Called to inform delegate that the AssureID request failed.
 @param error the reason why the request failed
 @discussion the delegate is in charge of analysing the error sent and inform the user.
 */
- (void)didFailProcessingAssureIDWithError:(AcuantError*)error;


@end

@interface AcuantMobileSDKController : NSObject{}

@property (weak, nonatomic) id<AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate> mobileSDKDelegate;


+(AcuantMobileSDKController*)initAcuantMobileSDKWithUsername:(NSString*)username password:(NSString*)password subscription:(NSString*)subscription url:(NSString*)serverURL  andDelegate:(id<AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate>)delegate;



/**
 Use this method to obtain an instance of the AcuantMobileSDKController if Username and password is correct
 @param key your License Key
 @param delegate your delegate
 @param cloudAddress your cloud Address
 @discussion never try to alloc/init this class, always obtain an instance through this method.
 @return the AcuantMobileSDKController instance
 */
+ (AcuantMobileSDKController*)initAcuantMobileSDKWithLicenseKey:(NSString*)key delegate:(id<AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate>)delegate andCloudAddress:(NSString*)cloudAddress;

/**
 Use this method to obtain an instance of the AcuantMobileSDKController if License key is correct
 @param key your License Key
 @param delegate your delegate
 @discussion never try to alloc/init this class, always obtain an instance through this method.
 @return the AcuantMobileSDKController instance
 */
+ (AcuantMobileSDKController*)initAcuantMobileSDKWithLicenseKey:(NSString*)key andDelegate:(id<AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate>)delegate;

/**
 Use this method to obtain an instance of the AcuantMobileSDKController if License key was set
 @discussion never try to alloc/init this class, always obtain an instance through this method.
 @return the AcuantMobileSDKController instance
 */
+ (AcuantMobileSDKController*)initAcuantMobileSDK;

/**
 Use this method to obtain an instance of the AcuantMobileSDKController if License key is correct and show the camera interface after the key was validated and approved
 @param key your License Key
 @param viewController the UIViewController object from which we'll present the card capture interface
 @param delegate the delegate of the card capture interface
 @param typeCard the type of the card capture interface
 @param region the region of the card and type of capture interface
 @param isBarcodeSide the side of the card and type of capture interface
 @discussion never try to alloc/init this class, always obtain an instance through this method.
 @return the AcuantMobileSDKController instance
 */
+ (AcuantMobileSDKController*)initAcuantMobileSDKWithLicenseKey:(NSString*)key AndShowCardCaptureInterfaceInViewController:(UIViewController*)vc delegate:(id<AcuantMobileSDKControllerCapturingDelegate, AcuantMobileSDKControllerProcessingDelegate>)delegate typeCard:(AcuantCardType)typeCard region:(AcuantCardRegion)region isBarcodeSide:(BOOL)isBarcodeSide;


/**
 Use this method to present the manual card capture interface.
 @param viewController the UIViewController object from which we'll present the card capture interface
 @param delegate the delegate of the card capture interface
 @param typeCard the type of the card capture interface
 @param region the region of the card and type of capture interface
 @discussion a valid viewController is required
 */
- (void)showManualCameraInterfaceInViewController:(UIViewController*)vc delegate:(id<AcuantMobileSDKControllerCapturingDelegate>)delegate cardType:(AcuantCardType)cardType region:(AcuantCardRegion)region andBackSide:(BOOL)isBackSide;

/**
 Use this method to present the auto card capture interface.
 @param viewController the UIViewController object from which we'll present the card capture interface
 @param delegate the delegate of the card capture interface
 @param typeCard the type of the card capture interface
 @discussion a valid viewController is required
 */
/*- (void)showAutoCameraInterfaceInViewController:(UIViewController*)vc delegate:(id<AcuantMobileSDKControllerCapturingDelegate>)delegate cardType:(AcuantCardType)cardType;*/


/**
 Use this method to present the barcode card capture interface.
 @param viewController the UIViewController object from which we'll present the card capture interface
 @param delegate the delegate of the card capture interface
 @param typeCard the type of the card capture interface
 @param region the region of the card and type of capture interface
 @discussion a valid viewController is required
 */
- (void)showBarcodeCameraInterfaceInViewController:(UIViewController*)vc delegate:(id<AcuantMobileSDKControllerCapturingDelegate>)delegate cardType:(AcuantCardType)cardType andRegion:(AcuantCardRegion)region;


/**
 Use this method to dismiss the card capture interface
 @discussion You cannot use [UIPopOverController dismissPopoverAnimated:] method to dismiss the UIPopOverController
 */
- (void)dismissCardCaptureInterface;

/**
 Use this method to start the camera
 @discussion you don't need to call this method after presenting the camera interface
 @discussion if we're already capturing video this method does nothing
 */
- (void)startCamera;

/**
 Use this method to stop the camera
 @discussion if camera is already stop, this method does nothing
 */
- (void)stopCamera;

/**
 Use this method to pause the scanning of the barcode
 @discussion if the scanning is already stopped, this method does nothing
 */
- (void)pauseScanningBarcodeCamera;

/**
 Use this method to resume the scanning of the barcode
 @discussion if the scanning is already running this method does nothing
 */
- (void)resumeScanningBarcodeCamera;

/**
 Use this method to configure the License key
 @param key your LicenseKey
 @discussion you are in charge of setting License key on each application launch as part of the setup of the framework
 */
- (void)setLicenseKey:(NSString *)key;

/**
 Use this method to configure the Cloud Address of the server
 @param setCloudAddress the Cloud Address string including protocol, for example: https://myserver.com/
 */
- (void)setCloudAddress:(NSString *)serverBaseURL;


-(BOOL)isSDKValidated;

/**
 Use this method to set the width of the cropped image
 @param width the width of the cropped card
 @discussion you need to set the height with setHeight:(int)height to crop the image with these values
 */
-(void)setWidth:(int)width;
-(int)getWidth;

/**
 Use it to enable or disable the barcode Cropping
 @param canCropBarcode boolean enable or disable the barcode Cropping
 */
-(void)setCanCropBarcode:(BOOL)canCropBarcode;


/**
 Use it to enable or disable the capturing of original Image
 @param canCaptureOriginal boolean enable or disable capturing original Image
 */

-(void)setCanCaptureOriginalImage:(BOOL)canCaptureOriginal;

/**
 Use get if the original image is allowed to capture
 */

-(BOOL)getCanCaptureOriginalImage;

/**
 Use it to enable or disable the Initial Message on Barcode Camera
 @param canShowMessage boolean enable or disable the Initial Message
 */
-(void)setCanShowMessage:(BOOL)canShowMessage;

/**
 Called to set a customize appear message, background color, time lenght and frame.
 @discussion in case this method in not implementd by the delegate, we'll set a default message, background color, time lenght and frame.
 */
-(void)setInitialMessage:(NSString*)message frame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor duration:(int)timeLenght orientation:(AcuantHUDOrientation)orientation;

/**
 Called to set a customize finaly message, background color, time lenght and frame.
 @discussion in case this method in not implementd by the delegate, we'll set a default message, background color, time lenght and frame.
 */
-(void)setCapturingMessage:(NSString*)message frame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor duration:(int)timeLenght orientation:(AcuantHUDOrientation)orientation;


/**
 Use this method to process a card.
 @param frontImage the front image of the card.
 @param backImage the back image of the card.
 @param stringData the string data of the back side of the card.
 @param delegate the delegate of the process request
 @param options the options of the process request.
 @discussion you must always provide a front image, back image is optional
 @discussion use the options object to indicate the type of card you're trying to process (i.e. License, Medical). Processing will fail if you don't provide this parameter.
 @discussion you're encourage to provide a delegate to be informed about what happened with your processing request. You can change the delegate using the cardProcessingDelegate property of this class.
 @discussion you should call this method only once and wait until your delegate is informed. If you call this method while we're already processing a card, we'll ignore your second call.
 @discussion The recommended size to this images is 1250 width and relative height to the width.
 */
- (void)processFrontCardImage:(UIImage*)frontImage
                BackCardImage:(UIImage*)backImage
                andStringData:(NSString*)stringData
                 withDelegate:(id<AcuantMobileSDKControllerProcessingDelegate>)delegate
                  withOptions:(AcuantCardProcessRequestOptions*)options;


/**
 Use this method to do facial match.
 @param selfieImage The captured selfie Image.
 @param imageTwo Face Image from ID or Passport card
 @param delegate the delegate of the process request
 @param options the options of the process request.
 @discussion you must always provide a selfieImage and a face image to match
 @discussion use the options object to indicate the type as AcuantCardTypeFacial. Processing will fail if you don't provide this parameter.
 @discussion you're encourage to provide a delegate to be informed about what happened with your processing request. You can change the delegate using the cardProcessingDelegate property of this class.
 @discussion you should call this method only once and wait until your delegate is informed. If you call this method while we're already processing a card, we'll ignore your second call.
 */
-(void)validatePhotoOne:(UIImage *)selfieImage
              withImage:(NSData *)imageTwo
           withDelegate:(id<AcuantMobileSDKControllerProcessingDelegate>)delegate
            withOptions:(AcuantCardProcessRequestOptions*)option;

-(void)enableLocationTracking;
-(NSString*)getDeviceStreetAddress;
-(NSString*)getDeviceState;
-(NSString*)getDeviceArea;
-(NSString*)getDeviceCountry;
-(NSString*)getDeviceCity;
-(NSString*)getDeviceZipCode;
-(NSString*)getDeviceCountryCode;

-(BOOL)isFacialEnabled;
-(BOOL)isAssureIDAllowed;
-(void)setLiveFace:(BOOL)liveFace;
-(BOOL)isLivefaceDetected;

-(void)StopContinousBarcodeCapture;
- (void)startContinousBarcodeCaptureWithDelegate:(UIViewController<AcuantMobileSDKControllerCapturingDelegate>*)delegate;


-(void)processCardWithOptions:(AcuantCardProcessRequestOptions*)options frontImage:(UIImage*)frontImage backImage:(UIImage*)backImage barcodeString:(NSString*)dataString;

-(void)deleteAssureIDInstance:(NSString*)instanceID;

@end
