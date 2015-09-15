//
//  ISGResultScreenViewController.h
//  AcuantServiceSample
//
//  Created by Diego Arena on 7/11/13.
//  Copyright (c) 2013 Codigodelsur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AcuantMobileSDK/AcuantCardRegion.h>

@protocol ISGRegionViewControllerDelegate <NSObject>

@required
- (void)setRegion:(AcuantCardRegion)region;

@end

@interface ISGRegionViewController : UIViewController

@property (nonatomic, strong) id<ISGRegionViewControllerDelegate> delegate;
@end
