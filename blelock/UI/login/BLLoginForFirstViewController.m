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

@interface BLLoginForFirstViewController () 

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITextField *userTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation BLLoginForFirstViewController
- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor lightGrayColor];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatarImageView.backgroundColor = [UIColor blueColor];
    [view addSubview:_avatarImageView];
    
    _userTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _userTextField.placeholder = @"请输入用户名：";
    _userTextField.textColor = [UIColor blackColor];
    [_userTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_userTextField setBorderStyle:UITextBorderStyleNone];
    [_userTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userTextField.returnKeyType = UIReturnKeyDone;
    _userTextField.backgroundColor = [UIColor whiteColor];
    _userTextField.delegate = self;
    [view addSubview:_userTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTextField.placeholder = @"请输入密码：";
    _passwordTextField.textColor = [UIColor blackColor];
    [_passwordTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.delegate = self;
    [view addSubview:_passwordTextField];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor blueColor];
    _loginButton.layer.cornerRadius = 5.0f;
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_loginButton];
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.backgroundColor = [UIColor blueColor];
    _registerButton.layer.cornerRadius = 5.0f;
    [_registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_registerButton];
    
    self.view = view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _avatarImageView.frame;
    r1.size.width = 44.0f;
    r1.size.height = 44.0f;
    r1.origin.x = (rect.size.width - r1.size.width) / 2.0f;
    r1.origin.y = [self.topLayoutGuide length] + 30.0f;
    _avatarImageView.frame = r1;
    
    CGRect r2 = _userTextField.frame;
    r2.size.width = rect.size.width;
    r2.size.height = 44.0f;
    r2.origin.x = 0.0f;
    r2.origin.y = CGRectGetMaxY(_avatarImageView.frame) + 20.0f;
    _userTextField.frame = r2;
    
    CGRect r3 = _passwordTextField.frame;
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_userTextField.frame) + 20.0f;
    _passwordTextField.frame = r3;
    
    CGRect r4 = _loginButton.frame;
    r4.origin.x = 20.0f;
    r4.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 20.0f;
    r4.size.width = rect.size.width - r4.origin.x * 2;
    r4.size.height = 44.0f;
    _loginButton.frame = r4;
    
    CGRect r5 = _registerButton.frame;
    r5.origin.x = 20.0f;
    r5.origin.y = CGRectGetMaxY(_loginButton.frame) + 20.0f;
    r5.size.width = rect.size.width - r5.origin.x * 2;
    r5.size.height = 44.0f;
    _registerButton.frame = r5;

    
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
- (void)registerButtonAction:(id)sender {
    BLUserViewController * blUserViewController = [[BLUserViewController alloc]init];
    //    //要不要拿到外面去作为属性呢？？？？？？？外面又不要用，不用拿出去
    //    [self.navigationController pushViewController: blUserViewController animated:YES];
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