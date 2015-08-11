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
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSArray *userInformation;


@end

@implementation BLUserViewController

- (void) loadView
{
    self.blUserView = [[BLUserView alloc] initWithCaller:self];
    self.userImage = [UIImage imageNamed:@"users.jpg"];
    self.userInformation = [NSArray arrayWithObjects:@"人间四月天",@"151****4690", nil];
    self.blUserView.img = self.userImage;
    self.blUserView.info = self.userInformation;
    [self.navigationController setNavigationBarHidden:YES];
    self.view = self.blUserView;
    
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