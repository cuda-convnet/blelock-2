//
//  UIViewController+Utils.m
//  blelock
//
//  Created by NetEase on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

+ (UIView *)customView:(CGRect)frame andBackgroundColor:(UIColor *)backgroundColor {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

+ (UIImageView *)customImageView:(CGRect)frame andImage:(NSString *)img {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:img];
    imageView.layer.cornerRadius = frame.size.height/2.0f;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

+ (UIButton *)customButton:(CGRect)frame andTitle:(NSString *)title andFont:(CGFloat)font andBackgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    button.backgroundColor = backgroundColor;
    return button;
}

+ (UIButton *)customButton:(CGRect)frame andImg:(NSString *)img {
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    return button;
}

+ (UITextField*)customTextField:(CGRect)frame andPlaceHolder:(NSString*)placeHolder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.font = [UIFont systemFontOfSize: 16.0f];
    textField.textColor = [UIColor blackColor];
    textField.backgroundColor = [UIColor whiteColor];   //  背景颜色：白色
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.clearButtonMode = UITextFieldViewModeAlways;     //  清除按钮
    return textField;
}

+ (UILabel *)customLabel:(CGRect)frame andText:(NSString *)text andColor:(UIColor *)color andFont:(CGFloat)font {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (text != nil) {
        label.text = text;
    }
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UITableView *)customTableView:(CGRect)frame andDelegate:(id)delegate {
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    return tableView;
}


@end
