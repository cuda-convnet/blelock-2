//
//  BLUserViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLUserViewController.h"
#import "BLKeyViewController.h"
#import "BLUserView.h"

@interface BLUserViewController () <BLUserViewDelegate>

@property (nonatomic, strong) BLUserView *blUserView;

@end

@implementation BLUserViewController
{
    UIImage *userImage;
    NSArray *userInformation;
}
@synthesize blUserView = _blUserView;



- (void) loadView
{
    userImage = [UIImage imageNamed:@"users.jpg"];
    userInformation = [NSArray arrayWithObjects:@"人间四月天",@"151****4690", nil];
    _blUserView = [[BLUserView alloc] initWithCaller:self userImage:userImage userInformation:userInformation];
    [self.navigationController setNavigationBarHidden:YES];
    self.view = _blUserView;
    
}

- (void) viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void) goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) goToUserInformationView
{
    NSLog(@"hi");
}



@end