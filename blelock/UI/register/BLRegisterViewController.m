//
//  BLRegisterViewController.m
//  blelock
//
//  Created by NetEase on 15/8/13.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLRegisterViewController.h"
#import "UIViewController+Utils.h"

#import "BLLoginViewController.h"



@interface BLRegisterViewController ()

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *confirmPasswordTextField;
@property (nonatomic, strong) UITextField *captchaTextField;
@property (nonatomic, strong) UIButton *getCaptchaButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation BLRegisterViewController

- (void)loadView {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    //CGRect navframe = self.navigationController.navigationBar.frame;
    if (_isRegister) {
        self.title = @"注册";
        _passwordTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  设置密码"];
    }else {
        self.title = @"忘记密码";
        _passwordTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  新的密码"];
    }
    
    _userTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  手机号"];
    _userTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_userTextField addTarget:self action:@selector(userTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _passwordTextField.secureTextEntry = YES;
    [_passwordTextField addTarget:self action:@selector(passwordTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _confirmPasswordTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  确认密码"];
    _confirmPasswordTextField.secureTextEntry = YES;
    [_confirmPasswordTextField addTarget:self action:@selector(confirmPasswordTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _captchaTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  验证码"];
    _captchaTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_captchaTextField addTarget:self action:@selector(captchaTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _getCaptchaButton = [UIViewController customButton:(CGRect)CGRectZero andTitle:@"获取验证码" andFont:10.0f andBackgroundColor:BLBlue];
    [_getCaptchaButton addTarget:self action:@selector(getCaptchaAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmButton = [UIViewController customButton:(CGRect)CGRectZero andTitle:@"确定" andFont:16.0f andBackgroundColor:BLBlue];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_userTextField];
    [view addSubview:_passwordTextField];
    [view addSubview:_confirmPasswordTextField];
    [view addSubview:_captchaTextField];
    [view addSubview:_getCaptchaButton];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}

- (void)userTextField_DidEndOnExit:(id)sender {
    // 将焦点移至下一个文本框.
    
    [self.passwordTextField becomeFirstResponder];
}

- (void)passwordTextField_DidEndOnExit:(id)sender {
    [self.confirmPasswordTextField becomeFirstResponder];
}

- (void)confirmPasswordTextField_DidEndOnExit:(id)sender {
    [self.captchaTextField becomeFirstResponder];
}

- (void)captchaTextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (void)getCaptchaAction:(id)sender {
    if (_userTextField.text.length != 0) {
        _getCaptchaButton.backgroundColor = [UIColor lightGrayColor];
        //获取验证码
    }
}

- (void)confirmAction:(id)sender {
    if ([self isRightInput]) {
        if (_isRegister) {
            //确认注册信息
        } else {
            //确认修改密码
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)isRightInput{
    NSUInteger l1 = _userTextField.text.length;
    NSUInteger l2 = _passwordTextField.text.length;
    NSUInteger l3 = _captchaTextField.text.length;
    if (l1 == 0) {
        _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        _alertView.tag = 1;
        [_alertView show];
        [self.userTextField becomeFirstResponder];
    } else if (l2 == 0) {
        _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        _alertView.tag = 2;
        [_alertView show];
        [self.passwordTextField becomeFirstResponder];
    } else if (l3 == 0) {
        _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        _alertView.tag = 3;
        [_alertView show];
        [self.captchaTextField becomeFirstResponder];
    } else if (![_passwordTextField.text isEqualToString:_confirmPasswordTextField.text]){
        _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不同，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        _alertView.tag = 4;
        [_alertView show];
        [self.passwordTextField becomeFirstResponder];
    }else {
        return YES;
    }
    return NO;
}

@end