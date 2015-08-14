//
//  BLRegisterViewController.m
//  blelock
//
//  Created by NetEase on 15/8/13.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLRegisterViewController.h"
#import "BLLoginViewController.h"
#import "BLInitManager.h"

@interface BLRegisterViewController ()

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *getCaptchaButton;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation BLRegisterViewController

- (void)loadView {
    //CGRect navframe = self.navigationController.navigationBar.frame;
    if (_isRegister) {
        self.navigationItem.title = @"注册";
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"  设置密码";
    }else {
        self.navigationItem.title = @"忘记密码";
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _passwordTextField.placeholder = @"  新的密码";
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    
    _userTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _userTextField.placeholder = @"  手机号";
    _userTextField.textColor = [UIColor blackColor];
    [_userTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_userTextField setBorderStyle:UITextBorderStyleNone];
    [_userTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userTextField.returnKeyType = UIReturnKeyDone;
    _userTextField.backgroundColor = [UIColor whiteColor];
    _userTextField.delegate = self;
    [view addSubview:_userTextField];
    
    
    _passwordTextField.textColor = [UIColor blackColor];
    [_passwordTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.delegate = self;
    [view addSubview:_passwordTextField];
    
    _confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _confirmPasswordTextField.placeholder = @"  确认密码";
    _confirmPasswordTextField.textColor = [UIColor blackColor];
    [_confirmPasswordTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_confirmPasswordTextField setBorderStyle:UITextBorderStyleNone];
    [_confirmPasswordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    _confirmPasswordTextField.backgroundColor = [UIColor whiteColor];
    _confirmPasswordTextField.delegate = self;
    [view addSubview:_confirmPasswordTextField];
    
    _captchaTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _captchaTextField.placeholder = @"  验证码";
    _captchaTextField.textColor = [UIColor blackColor];
    [_captchaTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_captchaTextField setBorderStyle:UITextBorderStyleNone];
    [_captchaTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _captchaTextField.returnKeyType = UIReturnKeyDone;
    _captchaTextField.backgroundColor = [UIColor whiteColor];
    _captchaTextField.delegate = self;
    [view addSubview:_captchaTextField];
    
    _getCaptchaButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_getCaptchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCaptchaButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    _getCaptchaButton.backgroundColor = [UIColor lightGrayColor];
    [_getCaptchaButton addTarget:self action:@selector(getCaptchaAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_getCaptchaButton];
    
    _confirmButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.backgroundColor = [UIColor lightGrayColor];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_confirmButton];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _userTextField.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = [self.topLayoutGuide length] + 30.0f;
    r1.size.width = rect.size.width;
    r1.size.height = 44.0f;
    _userTextField.frame = r1;
    
    CGRect r2 = _passwordTextField.frame;
    r2.origin.x = 0.0f;
    r2.origin.y = CGRectGetMaxY(_userTextField.frame)+5.0f;
    r2.size.width = rect.size.width;
    r2.size.height = 44.0f;
    _passwordTextField.frame = r2;
    
    CGRect r3 = _confirmPasswordTextField.frame;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_passwordTextField.frame)+5.0f;
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    _confirmPasswordTextField.frame = r3;
    
    CGRect r4 = _captchaTextField.frame;
    r4.origin.x = 0.0f;
    r4.origin.y = CGRectGetMaxY(_confirmPasswordTextField.frame)+5.0f;
    r4.size.width = rect.size.width;
    r4.size.height = 44.0f;
    _captchaTextField.frame = r4;
    
    CGRect r5 = _getCaptchaButton.frame;
    r5.origin.x = rect.size.width - 20.0f - 60.0f;
    r5.origin.y = CGRectGetMaxY(_confirmPasswordTextField.frame) + 12.0f;
    r5.size.width = 60.0f;
    r5.size.height = 30.0f;
    _getCaptchaButton.frame = r5;
    
    CGRect r6 = _confirmButton.frame;
    r6.origin.x = 20.0f;
    r6.origin.y = CGRectGetMaxY(_captchaTextField.frame) + 20.0f;
    r6.size.width = rect.size.width - r6.origin.x * 2;
    r6.size.height = 44.0f;
    _confirmButton.frame = r6;
}

- (void)getCaptchaAction:(id)sender {
    //获取验证码
}

- (void)confirmAction:(id)sender {
    if (_isRegister) {
        //确认注册信息
    } else {
        //确认修改密码
    }
    // 弹出栈中所有页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end