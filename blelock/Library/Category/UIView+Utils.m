//
//  UIView+Utils.m
//  auction
//
//  Created by Teemo on 15/5/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "UIView+Utils.h"
//#import "Masonry.h"
//#import "ViewInfo.h"
//#import "FontInfo.h"
//#import "ColorInfo.h"
//#import <MBProgressHUD.h>
@implementation UIView (Utils)

//- (void)onTapWithTarget:(id)target andListener:(SEL)listener {
//    [self setUserInteractionEnabled:YES];
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:listener];
//    [self addGestureRecognizer:tapGesture];
//}
//
//- (UITapGestureRecognizer*)addTapGestureWithTarget:(id)target selector:(SEL)selector
//{
//    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
//    [self addGestureRecognizer:tapGestureRecognizer];
//    return tapGestureRecognizer;
//}
//
//+(UITextField*)defaultTextField:(NSString*)placeHoleder
//                      superView:(UIView*)superView
//{
//    UITextField *textField = [[UITextField alloc]init];
//    textField.font = TEXTFIELD_COMMON_FONT;
//    textField.textColor = TEXTFIELD_COMMON_COLOR;
//    textField.backgroundColor = [UIColor whiteColor];   //  背景颜色：白色
//    textField.placeholder =placeHoleder;
//    textField.textAlignment = NSTextAlignmentCenter;
//    //  边框颜色及大小
//    textField.layer.borderWidth = COMMON_LAYER_BORDER_WIDTH;
//    textField.layer.borderColor = [TEXTFIELD_LAYER_COLOR CGColor];
//    
//    textField.clearButtonMode = UITextFieldViewModeAlways;     //  清除按钮
//    
// 
//    [superView addSubview:textField];
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(superView);
//        make.width.equalTo(superView);
//        make.height.equalTo(@(TEXTFIELD_COMMON_HEIGHT));
//    }];
//    return textField;
//}
//
+ (UIView *)customView:(CGRect)frame andColor:(UIColor *)color
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

//+ (UITextField *)customTextField:(CGRect)frame andPlaceHolder:(NSString *)placeHoleder andFont:(UIFont *)font andTextColor:(UIColor *)color
//{
//    UITextField * textfield = [[UITextField alloc]initWithFrame:frame];
//    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHoleder attributes:@{NSForegroundColorAttributeName:RGB(0xc0, 0xc0, 0xc0),NSFontAttributeName:COMMON_FONT(14)}];
//    textfield.backgroundColor = [UIColor clearColor];
//    textfield.font = font;
//    textfield.textColor = color;
//    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
//    textfield.returnKeyType = UIReturnKeyNext;
//    return textfield;
//}
//
//+ (UITextView *)customTextView:(CGRect)frame andFont:(UIFont *)font andTextColor:(UIColor *)color
//{
//    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
//    textView.backgroundColor = [UIColor clearColor];
//    textView.font = font;
//    textView.textColor = color;
//    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    textView.autocorrectionType = UITextAutocorrectionTypeNo;
//    textView.returnKeyType = UIReturnKeyNext;
//    return textView;
//}
//
//+ (UILabel *)customLabel:(CGRect)frame andText:(NSString *)text andAlignment:(NSTextAlignment)alignment andTextColor:(UIColor *)color andFont:(UIFont *)font
//{
//    UILabel * label = [[UILabel alloc]initWithFrame:frame];
//    label.text = text;
//    label.textColor = color;
//    label.textAlignment = alignment;
//    label.font = font;
//    return label;
//}
//
//+ (UIButton *)customButton:(CGRect)frame andTitle:(NSString *)title andTitleColor:(UIColor *)color andFont:(UIFont *)font
//{
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = frame;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:color forState:UIControlStateNormal];
//    button.titleLabel.font = font;
//    return button;
//}

-(void)dissmissKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//- (UIView *)findFirstResponder
//{
//    if (self.isFirstResponder) {
//        return self;
//    }
//    for (UIView *subView in self.subviews) {
//        UIView *firstResponder = [subView findFirstResponder];
//        if (firstResponder != nil) {
//            return firstResponder;
//        }
//    }
//    return nil;
//}
//
//- (void) findFirstResponderAndResign
//{
//    [[self findFirstResponder]resignFirstResponder];
//}
//
//
//- (void)showInfoFullScreen:(NSString *)info
//{
//    if(info == nil)
//        return;
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    hud.cornerRadius=3;
//    hud.labelText=info;
//    hud.labelColor=RGB(0xff, 0xff, 0xff);
//    hud.labelFont =COMMON_FONT(14);
//    hud.color =[UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.5];
//    hud.mode = MBProgressHUDModeText;
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:1];
//}

@end
