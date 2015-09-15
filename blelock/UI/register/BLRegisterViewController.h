//
//  BLRegisterViewController.h
//  blelock
//
//  Created by NetEase on 15/8/13.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLRegisterViewController:UIViewController<UITextFieldDelegate>

//YES:注册 NO:忘记密码
@property (nonatomic,assign) BOOL isRegister;

@end
