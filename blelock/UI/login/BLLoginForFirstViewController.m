//
//  BLLoginForFirstViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/27.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLoginForFirstViewController.h"
#import "BLRegisterViewController.h"
#import "SFHFKeychainUtils.h"
#import "BLUserViewController.h"

@interface BLLoginForFirstViewController () 

@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *forgetPassword;

@end

@implementation BLLoginForFirstViewController
- (void)loadView {
    //导航栏
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.navigationItem.title = @"钥匙";
    //右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    
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
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTextField.placeholder = @"  密码";
    _passwordTextField.textColor = [UIColor blackColor];
    [_passwordTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.delegate = self;
    [view addSubview:_passwordTextField];

    _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_loginButton];
    
    _forgetPassword = [[UILabel alloc] initWithFrame:CGRectZero];
    _forgetPassword.text = @"忘记密码？";
    _forgetPassword.textColor = [UIColor redColor];
    _forgetPassword.textAlignment = NSTextAlignmentRight;
    _forgetPassword.font = [UIFont systemFontOfSize:12.0f];
    _forgetPassword.backgroundColor = [UIColor clearColor];
    _forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction:)];
    [_forgetPassword addGestureRecognizer:forgetGesture];
    [view addSubview:_forgetPassword];
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

- (void)goToRegister:(id)sender {
    BLRegisterViewController *blRegisterViewController = [[BLRegisterViewController alloc] init];
    blRegisterViewController.isRegister = YES;
    [self.navigationController pushViewController: blRegisterViewController animated:YES];
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender
{
    if(_userTextField.text.length==0||_passwordTextField.text.length==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请键入用户名或密码" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        //NSLog(@"%@ %@",[SFHFKeychainUtils getPasswordForUsername:user.text andServiceName:@"passwordTest" error:nil],password.text);
        if([[SFHFKeychainUtils getPasswordForUsername:_userTextField.text andServiceName:@"passwordTest" error:nil] isEqual: _passwordTextField.text])
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆成功" message:nil delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"用户名或密码不正确" delegate:self cancelButtonTitle:@"OK,I know" otherButtonTitles:nil];
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