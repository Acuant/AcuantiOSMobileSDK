//
//  UIImageView+LoadImage.h
//  ConnectObjective-CSampleApp
//
//  Created by Tapas Behera on 8/8/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

-(void) downloadedFromurlStr:(NSString*)urlStr username:(NSString*)username password:(NSString*)password;

@end
