//
//  UIViewController+Utils.h
//  blelock
//
//  Created by NetEase on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BLBlue     ([UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1])
#define BLGray     ([UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1])

@interface UIViewController (Utils)

+ (UIView *)customView;
+ (UIButton *)customButton:(NSString *)title andFont:(CGFloat)font andBackgroundColor:(UIColor *)backgroundColor;
+ (UITextField *)customTextField:(NSString *)placeHoleder;
+ (UILabel *)customLabel:(NSString *)text andColor:(UIColor *)color andFont:(CGFloat)font;


@end
