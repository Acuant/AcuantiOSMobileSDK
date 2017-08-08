//
//  ResultViewController.h
//  ConnectObjective-CSampleApp
//
//  Created by Tapas Behera on 8/8/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <AcuantMobileSDK/AcuantMobileSDKController.h>
#import <AcuantMobileSDK/AcuantFacialData.h>


@interface ResultViewController : UIViewController

@property(nonatomic,weak) id<ResultCancelDelegate> cancelDelegate;
@property(nonatomic,strong) NSDictionary* cardData;
@property(nonatomic) AcuantCardType cardType;
@property(nonatomic,strong) NSString* separator;
@property(nonatomic,strong) NSString* username;
@property(nonatomic,strong) NSString* password;
@property(nonatomic,strong) AcuantFacialData* facialData;


@end
