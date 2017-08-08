//
//  UIImage+LoadImage.m
//  ConnectObjective-CSampleApp
//
//  Created by Tapas Behera on 8/8/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

#import "UIImageView+LoadImage.h"

@implementation UIImageView (LoadImage)

-(void) downloadedFromurlStr:(NSString*)urlStr username:(NSString*)username password:(NSString*)password {
    NSData* loginData = [[NSString stringWithFormat:@"%@:%@",username,password] dataUsingEncoding:kCFStringEncodingUTF8];
    NSString* base64LoginData = [loginData base64EncodedStringWithOptions:0];
    
    // create the request
    NSURL* url = [[NSURL alloc] initWithString:urlStr];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"%@%@",@"Basic ",base64LoginData] forHTTPHeaderField:@"Authorization"];
    __weak UIImageView* weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,    NSURLResponse *response, NSError *error) {
        if(error==nil && data!=nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.image=[UIImage imageWithData:data];
                [weakSelf setHidden:NO];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setHidden:YES];
            });
        }
    }] resume];
}


@end
