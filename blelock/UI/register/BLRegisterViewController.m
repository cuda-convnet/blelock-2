//
//  BLRegisterViewController.m
//  blelock
//
//  Created by NetEase on 15/8/13.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLRegisterViewController.h"

@implementation BLRegisterViewController

- (void)loadView {
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.navigationItem.title = @"注册";
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor lightGrayColor];
    
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end