//
//  UIViewController+Utils.m
//  blelock
//
//  Created by NetEase on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+ (UIView *)customView:(CGRect)frame andColor:(UIColor *)color {
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

@end
