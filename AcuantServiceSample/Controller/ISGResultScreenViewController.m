//
//  ISGResultScreenViewController.m
//  AcuantServiceSample
//
//  Created by Diego Arena on 7/11/13.
//  Copyright (c) 2013 Codigodelsur. All rights reserved.
//

#import "ISGResultScreenViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PSRT_HEIGHT
@interface ISGResultScreenViewController ()

@property (strong, nonatomic) IBOutlet UIView *TextFooterView;
@property (strong, nonatomic) IBOutlet UIScrollView *resultScroll;
@property (strong, nonatomic) IBOutlet UILabel *resultText;
@property (strong, nonatomic) IBOutlet UIView *imagesHeaderView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@end


@implementation ISGResultScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _faceImageView.image = _faceImage;
    
    _signatureImageView.image = _signatureImage;
    
    _frontImageView.image = _frontImage;
    _backImageView.image = _backImage;
    
    if (_frontImage) {
        _frontImageView.layer.masksToBounds = YES;
        _frontImageView.layer.cornerRadius = 10.0f;
        _frontImageView.layer.borderWidth = 1.0f;
    }
    if (_backImage) {
        _backImageView.layer.masksToBounds = YES;
        _backImageView.layer.cornerRadius = 10.0f;
        _backImageView.layer.borderWidth = 1.0f;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self positions];
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

-(void)positions{
    int heightiPad = (_cardType == AcuantCardTypePassportCard)?194:182;
    int heightiPhone = (_cardType == AcuantCardTypePassportCard)?89:83;
    int widthiPad = 288;
    int widthiPhone = 133;
    CGSize viewSize = self.view.frame.size;
    
    if (UIInterfaceOrientationIsLandscape([self orientation])) {
        //Back Button
        int x = viewSize.width - ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 42:50);
        int y = 0;
        int width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 42:50;
        int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 26:19;
        [_backButton setFrame:CGRectMake(x, y, width, height)];
        
        //Frontside card
        x = 20;
        y = 10;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? widthiPad:widthiPhone;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? heightiPad:heightiPhone;
        [_frontImageView setFrame:CGRectMake(x, y, width, height)];
        
        //Face Image
        x = _frontImageView.frame.origin.x + _frontImageView.frame.size.width + 20;
        y = 10;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 139:68;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 139:68;
        [_faceImageView setFrame:CGRectMake(x, y, width, height)];
        
        //Backside Card
        x = _faceImageView.frame.origin.x + _faceImageView.frame.size.width + 20;
        y = 10;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? widthiPad:widthiPhone;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? heightiPad:heightiPhone;
        [_backImageView setFrame:CGRectMake(x, y, width, height)];

        //signature Image
        x = _backImageView.image == nil ? _faceImageView.frame.origin.x + _faceImageView.frame.size.width + 20 : _backImageView.frame.origin.x + _backImageView.frame.size.width + 20;
        y = 10;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 142:129;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 76:47;
        [_signatureImageView setFrame:CGRectMake(x, y, width, height)];
        
        //Container views
        //Top
        x = 0;
        y = 10;
        width = viewSize.width;
        height = _frontImageView.frame.origin.y + _frontImageView.frame.size.height + 10;
        [_imagesHeaderView setFrame:CGRectMake(x, y, width, height)];
        
        //bottom
        x = _imagesHeaderView.frame.origin.x;
        y = _imagesHeaderView.frame.origin.y + _imagesHeaderView.frame.size.height;
        width = viewSize.width;
        height = viewSize.height - y;
        [_TextFooterView setFrame:CGRectMake(x, y, width, height)];
        
        //Result Text        
        CGSize maximumLabelSize = CGSizeMake(290, MAXFLOAT);
        
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        
        NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:14]};
        CGRect labelBounds = [_result boundingRectWithSize:maximumLabelSize
                                                  options:options
                                               attributes:attr
                                                  context:nil];

        CGSize messageSize = labelBounds.size;
        x = 0;
        y = 0;
        width = viewSize.width - 40;
        height = messageSize.height + 10;
        [_resultText setFrame:CGRectMake(x, y, width, height)];
        [_resultText setText:_result];
        
        //Result Text Scroll
        x = 20;
        y = 0;
        width = _TextFooterView.frame.size.width - 40;
        height = _TextFooterView.frame.size.height;
        [_resultScroll setFrame:CGRectMake(x, y, width, height)];
        [_resultScroll setContentSize:_resultText.frame.size];
    }else{
        //Back Button
        int x = viewSize.width - ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 42:50);
        int y = 10;
        int width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 42:50;
        int height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 26:19;
        [_backButton setFrame:CGRectMake(x, y, width, height)];
        
        //Front and Back cards
        x = 20;
        y = 36;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? widthiPad:widthiPhone;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? heightiPad:heightiPhone;
        [_frontImageView setFrame:CGRectMake(x, y, width, height)];
        
        
        //Backside Card
        x = _frontImageView.frame.origin.x + _frontImageView.frame.size.width + 10;
        y = 36;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? widthiPad:widthiPhone;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? heightiPad:heightiPhone;
        [_backImageView setFrame:CGRectMake(x, y, width, height)];
        
        // face Image
        x = _frontImageView.frame.origin.x;
        y = _frontImageView.frame.origin.y + _frontImageView.frame.size.height + 20;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 139:68;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 139:68;
        [_faceImageView setFrame:CGRectMake(x, y, width, height)];
        
        //signature Image
        x = _faceImageView.frame.origin.x;
        y = _faceImageView.frame.origin.y + _faceImageView.frame.size.height + 20;
        width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 142:129;
        height = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 76:47;
        [_signatureImageView setFrame:CGRectMake(x, y, width, height)];
        
        //Container views
        //Top
        x = 0;
        y = 25;
        width = viewSize.width;
        if (_cardType == AcuantCardTypeMedicalInsuranceCard) {
            height = _frontImageView.frame.origin.y + _frontImageView.frame.size.height + 10;
        }else{
            height = _signatureImageView.frame.origin.y + _signatureImageView.frame.size.height + 10;
        }
        [_imagesHeaderView setFrame:CGRectMake(x, y, width, height)];
        
        //bottom
        x = _imagesHeaderView.frame.origin.x;
        y = _imagesHeaderView.frame.origin.y + _imagesHeaderView.frame.size.height;
        width = self.view.frame.size.width;
        height = self.view.frame.size.height - y;
        [_TextFooterView setFrame:CGRectMake(x, y, width, height)];
        
        //Result Text
        CGSize maximumLabelSize = CGSizeMake(290, MAXFLOAT);
        
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        
        NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:14]};
        CGRect labelBounds = [_result boundingRectWithSize:maximumLabelSize
                                                   options:options
                                                attributes:attr
                                                   context:nil];
        
        CGSize messageSize = labelBounds.size;
        x = 0;
        y = 0;
        width = viewSize.width - 40;
        height = messageSize.height + 10;
        [_resultText setFrame:CGRectMake(x, y, width, height)];
        [_resultText setText:_result];
        
        //Result Text Scroll
        x = 20;
        y = 0;
        width = _TextFooterView.frame.size.width - 40;
        height = _TextFooterView.frame.size.height;
        [_resultScroll setFrame:CGRectMake(x, y, width, height)];
        [_resultScroll setContentSize:_resultText.frame.size];
    }
}


@end
