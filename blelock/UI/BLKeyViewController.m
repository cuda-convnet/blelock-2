//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyViewController.h"
#import "BLUserViewController.h"
#import "BLKeyView.h"
@interface BLKeyViewController ()<BLKeyViewDelegate>

@property (nonatomic, strong) BLKeyView * blKeyView;

@end

@implementation BLKeyViewController
//@synthesize navigationBar = _navigationBar;
{
    NSArray *array;
}
@synthesize blKeyView = _blKeyView;

- (void) loadView {
    
    array = [NSArray arrayWithObjects:@"翠苑四区",@"工商管理楼", @"土木科技楼", @"阿木的家", @"网易六楼", @"网易宿舍837", @"浙大玉泉", @"浙大紫金港", @"浙大西溪", @"浙大曹主", nil];
    _blKeyView = [[BLKeyView alloc] initWithCaller:self data:array];
    [self.navigationController setNavigationBarHidden:YES];
    self.view = _blKeyView;

}

- (void) viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}




//导航栏里右按钮
- (void)gotoBLUserView
{
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    [self.navigationController pushViewController: blUserViewController animated:YES];
}


-(void) touchButtonAction{
    
}







@end