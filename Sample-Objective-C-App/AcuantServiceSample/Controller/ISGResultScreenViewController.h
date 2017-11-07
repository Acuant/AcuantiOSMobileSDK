//
//  ISGResultScreenViewController.h
//  AcuantServiceSample
//
//  Created by Diego Arena on 7/11/13.
//  Copyright (c) 2013 Codigodelsur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AcuantMobileSDK/AcuantMobileSDKController.h>

@interface ISGResultScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *faceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (strong, nonatomic) IBOutlet UIImageView *frontImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) UIImage *faceImage;
@property (strong, nonatomic) NSData *faceImageData;
@property (strong, nonatomic) UIImage *signatureImage;
@property (strong, nonatomic) UIImage *frontImage;
@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) NSString *result;
@property (nonatomic) AcuantCardType cardType;

@end
