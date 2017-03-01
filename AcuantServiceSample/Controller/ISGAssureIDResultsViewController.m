//
//  ISGAssureIDResultsViewController.m
//  AcuantiOSMobileSDK
//
//  Created by Tapas Behera on 2/24/17.
//  Copyright © 2017 DB-Interactive. All rights reserved.
//

#import "ISGAssureIDResultsViewController.h"
#import "SVProgressHUD.h"

@interface ISGAssureIDResultsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *faceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (strong, nonatomic) IBOutlet UIImageView *frontImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UITextView *resultView;

@property (nonatomic,strong) NSString* assureIDUsername;
@property (nonatomic,strong)  NSString* assureIDPassword;

@end

@implementation ISGAssureIDResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _assureIDUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"AssureID_Username"];
    _assureIDPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"AssureID_Password"];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_jsonDict!=nil){
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)loadData{
    _resultView.text = [NSString stringWithFormat:@"%@",_jsonDict];
    NSArray* images = [_jsonDict objectForKey:@"Images"];
    for(NSDictionary* imageDict in images){
        if([imageDict objectForKey:@"Side"]){
            int side = [[imageDict objectForKey:@"Side"] intValue];
            if(side==0 && [imageDict objectForKey:@"Uri"]){
                [self downloadImageWithURL:[imageDict objectForKey:@"Uri"] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        _frontImageView.image = image;
                        
                    }
                }];
            }else if(side==1 && [imageDict objectForKey:@"Uri"]){
                [self downloadImageWithURL:[imageDict objectForKey:@"Uri"] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        _backImageView.image = image;
                    }
                }];
            }
        }
    }
    
    NSArray* fields = [_jsonDict objectForKey:@"Fields"];
    for(NSDictionary* dict in fields){
        if([dict objectForKey:@"IsImage"]){
            int IsImage = [[dict objectForKey:@"IsImage"] intValue];
            if(IsImage==1 && [dict objectForKey:@"Value"]){
                if([dict objectForKey:@"Key"]){
                    if([[dict objectForKey:@"Key"] isEqualToString:@"Signature"]){
                        [self downloadImageWithURL:[dict objectForKey:@"Value"] completionBlock:^(BOOL succeeded, UIImage *image) {
                            if (succeeded) {
                                _signatureImageView.image = image;
                            }
                        }];
                    }else if([[dict objectForKey:@"Key"] isEqualToString:@"Photo"]){
                        [self downloadImageWithURL:[dict objectForKey:@"Value"] completionBlock:^(BOOL succeeded, UIImage *image) {
                            if (succeeded) {
                                _faceImageView.image = image;
                            }
                        }];
                    }
                }
            }
        }
    }
    
}


- (void)downloadImageWithURL:(NSString *)urlStr completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@",_assureIDUsername,_assureIDPassword];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                                   
                               } else{
                                   
                                   completionBlock(NO,nil);
                                   
                               }
                           }];
}

@end
