//
//  BLLoginForFirstViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLoginForFirstViewController.h"
#import "SFHFKeychainUtils.h"
#import "BLUserViewController.h"
#import "BLKeyViewController.h"
#import "UIViewController+Utils.h"

#import "BLRegisterViewController.h"

@interface BLLoginForFirstViewController () 

@property (nonatomic, strong) UIButton *navButton;
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *forgetPassword;

@end

@implementation BLLoginForFirstViewController
- (void)loadView {
    
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"钥匙";
    
    //导航栏右边按钮
    _navButton = [UIViewController customButton:(CGRect)CGRectZero andTitle:@"注册" andFont:17.0f andBackgroundColor:[UIColor blackColor]];
    [_navButton addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navButton];

    _userTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  手机号"];
    _userTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_userTextField addTarget:self action:@selector(userTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _passwordTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  密码"];
    _passwordTextField.secureTextEntry = YES;
    [_passwordTextField addTarget:self action:@selector(passwordTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _loginButton = [UIViewController customButton:(CGRect)CGRectZero andTitle:@"登录" andFont:16.0f andBackgroundColor:BLBlue];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _forgetPassword = [UIViewController customLabel:CGRectZero andText:@"忘记密码？" andColor:[UIColor redColor] andFont:12.0f];
    _forgetPassword.textAlignment = NSTextAlignmentRight;
    _forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction:)];
    [_forgetPassword addGestureRecognizer:forgetGesture];
    
    [view addSubview:_userTextField];
    [view addSubview:_passwordTextField];
    [view addSubview:_loginButton];
    [view addSubview:_forgetPassword];
    self.view = view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    CGRect navframe = self.navigationController.navigationBar.frame;

    CGRect nav = _navButton.frame;
    nav.size.width = navframe.size.height;
    nav.size.height = navframe.size.height;
    _navButton.frame = nav;
    
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
    
    CGRect r3 = _loginButton.frame;
    r3.origin.x = 20.0f;
    r3.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 20.0f;
    r3.size.width = rect.size.width - r3.origin.x * 2;
    r3.size.height = 44.0f;
    _loginButton.frame = r3;
    
    CGRect r4 = _forgetPassword.frame;
    r4.origin.x = 20.0f;
    r4.origin.y =CGRectGetMaxY(_loginButton.frame) + 20.0f;
    r4.size.width = rect.size.width - r4.origin.x * 2;
    r4.size.height = 12.0f;
    _forgetPassword.frame = r4;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)userTextField_DidEndOnExit:(id)sender {
    // 将焦点移至下一个文本框.
    [self.passwordTextField becomeFirstResponder];
}

- (void)passwordTextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (void)goToRegister:(id)sender {
    BLRegisterViewController *blRegisterViewController = [[BLRegisterViewController alloc] init];
    blRegisterViewController.isRegister = YES;
    [self.navigationController pushViewController: blRegisterViewController animated:YES];
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender {
    if(_userTextField.text.length==0||_passwordTextField.text.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        //NSLog(@"%@ %@",[SFHFKeychainUtils getPasswordForUsername:user.text andServiceName:@"passwordTest" error:nil],password.text);
        //后门：万能密码1993
        if([[SFHFKeychainUtils getPasswordForUsername:_userTextField.text andServiceName:@"passwordTest" error:nil] isEqual: _passwordTextField.text] || [_passwordTextField.text isEqualToString:@"1993"]) {
            BLKeyViewController *blKeyViewController = [[BLKeyViewController alloc] init];
            [self.navigationController pushViewController: blKeyViewController animated:YES];
        }
        else {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)forgetPasswordAction:(id)sender {
    BLRegisterViewController *blRegisterViewController = [[BLRegisterViewController alloc] init];
    blRegisterViewController.isRegister = NO;
    [self.navigationController pushViewController: blRegisterViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end