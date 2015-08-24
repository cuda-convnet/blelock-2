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

+ (UIView *)customView:(CGRect)frame andBackgroundColor:(UIColor *)backgroundColor;
+ (UIImageView *)customImageView:(CGRect)frame andImage:(NSString *)img;
+ (UIButton *)customButton:(CGRect)frame andTitle:(NSString *)title andFont:(CGFloat)font andBackgroundColor:(UIColor *)backgroundColor;
+ (UIButton *)customButton:(CGRect)frame andImg:(NSString *)img;
+ (UITextField*)customTextField:(CGRect)frame andPlaceHolder:(NSString*)placeHolder;
+ (UILabel *)customLabel:(CGRect)frame andText:(NSString *)text andColor:(UIColor *)color andFont:(CGFloat)font;
+ (UITableView *)customTableView:(CGRect)frame andDelegate:(id)delegate;

- (void)addNavLeftButtonWithText:(NSString*)text target:(id) target action:(SEL)action;
- (void)dismissKeyBoard;
@end
