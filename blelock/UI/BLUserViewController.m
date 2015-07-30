//
//  BLUserViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLUserViewController.h"

@interface BLUserViewController ()

@end

@implementation BLUserViewController

- (void) loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor lightGrayColor];
}

- (void)viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

@end