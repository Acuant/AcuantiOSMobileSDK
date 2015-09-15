//
//  ISGRegionViewController.m
//  AcuantiOSMobileSampleSDK
//
//  Created by Diego Arena on 6/17/15.
//  Copyright (c) 2015 Diego Arena. All rights reserved.
//

#import "ISGRegionViewController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ISGRegionViewController ()
@property (strong, nonatomic) NSMutableDictionary *regions;
@property (strong, nonatomic) NSMutableArray *keys;

@end

@implementation ISGRegionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _regions = [NSMutableDictionary dictionary];
    _keys = [NSMutableArray array];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    _regions = [NSMutableDictionary dictionaryWithDictionary:@{@"United States": @(AcuantCardRegionUnitedStates).stringValue, @"Canada": @(AcuantCardRegionCanada).stringValue, @"Europe": @(AcuantCardRegionEurope).stringValue, @"Africa": @(AcuantCardRegionAfrica).stringValue, @"Asia": @(AcuantCardRegionAsia).stringValue, @"Latin America": @(AcuantCardRegionAmerica).stringValue, @"Australia": @(AcuantCardRegionAustralia)}];
    _keys = [NSMutableArray arrayWithArray:@[@"United States", @"Canada", @"Europe", @"Africa", @"Asia", @"Latin America", @"Australia"]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    int regionNo = 0;
    int w = self.view.frame.size.width;
    int h = self.view.frame.size.height / (_keys.count + 1);
    int y = 0;
    
    for (NSString *key in _keys){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self
                   action:@selector(tapRegion:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTag:regionNo];
        y = y + h;
        if (regionNo == 0){
            y = y/2;
        }
        [button setTitle:key forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, y, w, h)];
        [self.view addSubview:button];
        regionNo ++;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate{
    NSArray *subviews = [self.view subviews];
    for (int i=0; i<[subviews count]; i++)
    {
        [[subviews objectAtIndex:i] removeFromSuperview];
    }
    return YES;
}


-(void)tapRegion:(UIButton*)sender{
    NSLog(@"Tap Region %@", [_keys objectAtIndex:sender.tag]);
    if ([self.delegate respondsToSelector:(@selector(setRegion:))]) {
        [self.delegate setRegion:[[_regions objectForKey:[_keys objectAtIndex:sender.tag]] intValue]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
