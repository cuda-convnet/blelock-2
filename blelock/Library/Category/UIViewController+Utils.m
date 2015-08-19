//
//  UIViewController+Utils.m
//  blelock
//
//  Created by NetEase on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+ (UIView *)customView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = BLGray;
    return view;
}

+ (UIButton *)customButton:(NSString *)title andFont:(CGFloat)font andBackgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.backgroundColor = backgroundColor;
    return button;
}

+ (UITextField*)customTextField:(NSString*)placeHoleder {
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectZero];
    textField.placeholder = placeHoleder;
    textField.font = [UIFont systemFontOfSize: 16.0f];
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor whiteColor];   //  背景颜色：白色
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.clearButtonMode = UITextFieldViewModeAlways;     //  清除按钮
    return textField;
}

+ (UILabel *)customLabel:(NSString *)text andColor:(UIColor *)color andFont:(CGFloat)font {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}


@end
