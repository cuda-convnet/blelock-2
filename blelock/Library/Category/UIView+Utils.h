//
//  UIView+Utils.h
//  auction
//
//  Created by Teemo on 15/5/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>



#define kScreenWidth				([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight				([UIScreen mainScreen].bounds.size.height)
#define kScreenScale                ([UIScreen mainScreen].scale)

#define HALVINGLINE_HEIGHT          (1.0f/[UIScreen mainScreen].scale)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_NETWORK_OK               ([Reachability isNetworkOK])
#define IS_WIFI                     ([Reachability isWifiNetwork])




@interface UIView (Utils)

//- (void)onTapWithTarget:(id)target andListener:(SEL)listener;
//- (UITapGestureRecognizer*)addTapGestureWithTarget:(id)target selector:(SEL)selector;
//+(UITextField*)defaultTextField:(NSString*)placeHoleder
//                      superView:(UIView*)superView;
+ (UIView *)customView:(CGRect)frame andColor:(UIColor *)color;
//+ (UITextField *)customTextField:(CGRect)frame andPlaceHolder:(NSString *)placeHoleder andFont:(UIFont *)font andTextColor:(UIColor *)color ;
//+ (UILabel *)customLabel:(CGRect)frame andText:(NSString *)text andAlignment:(NSTextAlignment)alignment andTextColor:(UIColor *)color andFont:(UIFont *)font;
//+ (UIButton *)customButton:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFont:(UIFont *)font;
//+ (UITextView *)customTextView:(CGRect)frame andFont:(UIFont *)font andTextColor:(UIColor *)color ;

-(void)dissmissKeyboard;

//- (UIView *)findFirstResponder;
//
//- (void) findFirstResponderAndResign;
//
//- (void)showInfoFullScreen:(NSString *)info;


@end
