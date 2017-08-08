//
//  ResultViewController.m
//  ConnectObjective-CSampleApp
//
//  Created by Tapas Behera on 8/8/17.
//  Copyright © 2017 Acuant. All rights reserved.
//

#import "ResultViewController.h"
#import "UIImageView+LoadImage.h"

typedef enum AssureIDResult
{
    Unknown = 0,
    Passed = 1,
    Failed = 2,
    Skipped = 3,
    Caution = 4,
    Attention = 5

}AssureIDResult;

@interface ResultViewController ()

@property(nonatomic,strong) IBOutlet UIImageView* frontCardImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backCardImageView;
@property(nonatomic,strong) IBOutlet UIImageView* faceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *signImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _separator = @"-";
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_cancelDelegate didFinishShowingResult];
}

-(void)initUI{
    NSString* resultStr = @"";
    NSString* faceImageURL=@"";
    NSString* signImageURL=@"";
    NSArray* alerts = [_cardData objectForKey:@"Alerts"];
    int Result = [[_cardData objectForKey:@"Result"] intValue] ;
    NSArray* images = [_cardData objectForKey:@"Images"];
    NSArray* fields = [_cardData objectForKey:@"Fields"];
    if(Result==Passed || Result==Failed || Result==Unknown){
        if(Result==Passed){
            resultStr =  [[[@"Authentication Result" stringByAppendingString:_separator] stringByAppendingString:@"Passed"] stringByAppendingString:@"\n"];
        }else if(Result==Failed){
            resultStr =  [[[@"Authentication Result" stringByAppendingString:_separator] stringByAppendingString:@"Failed"] stringByAppendingString:@"\n"];
        }else if(Result==Unknown){
            resultStr =  [[[@"Authentication Result" stringByAppendingString:_separator] stringByAppendingString:@"Unknown"] stringByAppendingString:@"\n"];
        }
    }else{
        for(NSDictionary* alert in alerts){
            if([[alert objectForKey:@"Result"] intValue]==Result){
                resultStr =  [resultStr stringByAppendingString:[[[@"Alert" stringByAppendingString:_separator] stringByAppendingString:[alert objectForKey:@"Key"]] stringByAppendingString:@"\n"]];
            }
        }
    }
    
    for(NSDictionary* field in fields){
        NSString* f = [NSString stringWithFormat:@"%@%@%@",[field objectForKey:@"Name"],_separator,[field objectForKey:@"Value"]];
        if([[field objectForKey:@"Name"] isEqualToString:@"Photo"]){
            faceImageURL = [field objectForKey:@"Value"];
        }else if([[field objectForKey:@"Name"] isEqualToString:@"Signature"]){
            signImageURL = [field objectForKey:@"Value"];
        }else{
            resultStr =  [[resultStr stringByAppendingString:f] stringByAppendingString:@"\n"];
        }
        
        
    }
    if(![faceImageURL isEqualToString:@""]){
        [_faceImageView downloadedFromurlStr:faceImageURL username:_username password:_password];
    }
    if(![signImageURL isEqualToString:@""]){
        [_signImageView downloadedFromurlStr:signImageURL username:_username password:_password];
    }
    
    for(NSDictionary* imageDict in images){
        if([imageDict objectForKey:@"Side"]){
            int side = [[imageDict objectForKey:@"Side"] intValue];
            if(side==0 && [imageDict objectForKey:@"Uri"]){
                [_frontCardImageView downloadedFromurlStr:[imageDict objectForKey:@"Uri"] username:_username password:_password];
            }else if(side==1 && [imageDict objectForKey:@"Uri"]){
                [_backCardImageView downloadedFromurlStr:[imageDict objectForKey:@"Uri"] username:_username password:_password];
            }
        }
    }
    _resultTextView.text=resultStr;
}


@end
