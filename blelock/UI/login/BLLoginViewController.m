//
//  BLLoginViewController.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLLoginForFirstViewController.h"
#import "BLRegisterViewController.h"
#import "SFHFKeychainUtils.h"
#import "BLInitManager.h"

@interface BLLoginViewController ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *mobilephoneLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *forgetPassword;
@property (nonatomic, strong) UILabel *otherUser;

@end

@implementation BLLoginViewController

- (void)loadView {
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.navigationItem.title = @"钥匙";
//    //导航栏统一初始化操作，以后放到第一个页面
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    self.navigationController.navigationBar.translucent = NO;//导航栏不透明
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    //右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatarImageView.backgroundColor = [UIColor clearColor];
    UIImage *img = [UIImage imageNamed:@"users.jpg"];
    [_avatarImageView setImage:img];
    [view addSubview:_avatarImageView];
    
    _mobilephoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _mobilephoneLabel.text = @"13813888888";
    _mobilephoneLabel.textColor = [UIColor blackColor];
    _mobilephoneLabel.textAlignment = NSTextAlignmentCenter;
    _mobilephoneLabel.font = [UIFont systemFontOfSize:14.0f];
    _mobilephoneLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_mobilephoneLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTextField.placeholder = @"  密码：";
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
    
    _otherUser = [[UILabel alloc] initWithFrame:CGRectZero];
    _otherUser.text = @"使用其他账户登录";
    _otherUser.textColor = [UIColor grayColor];
    _otherUser.textAlignment = NSTextAlignmentCenter;
    _otherUser.font = [UIFont systemFontOfSize:12.0f];
    _otherUser.backgroundColor = [UIColor clearColor];
    _otherUser.userInteractionEnabled = YES;
    UITapGestureRecognizer *otherGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherUserAction:)];
    [_otherUser addGestureRecognizer:otherGesture];
    [view addSubview:_otherUser];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;

    CGRect r1 = _avatarImageView.frame;
    r1.origin.x = (rect.size.width - 60.0f) / 2.0f;
    r1.origin.y = [self.topLayoutGuide length] + 30.0f;
    r1.size.width = 60.0f;
    r1.size.height = 60.0f;
    _avatarImageView.layer.cornerRadius = r1.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.frame = r1;
    
    CGRect r2 = _mobilephoneLabel.frame;
    r2.origin.x = 20.0f;
    r2.origin.y = CGRectGetMaxY(_avatarImageView.frame) + 20.0f;
    r2.size.width = rect.size.width - r2.origin.x * 2;
    r2.size.height = 44.0f;
    _mobilephoneLabel.frame = r2;
    
    CGRect r3 = _passwordTextField.frame;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_mobilephoneLabel.frame) + 20.0f;
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    _passwordTextField.frame = r3;
    
    CGRect r4 = _loginButton.frame;
    r4.origin.x = 20.0f;
    r4.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 20.0f;
    r4.size.width = rect.size.width - r4.origin.x * 2;
    r4.size.height = 44.0f;
    _loginButton.frame = r4;
    
    CGRect r5 = _forgetPassword.frame;
    r5.origin.x = 20.0f;
    r5.origin.y =CGRectGetMaxY(_loginButton.frame) + 20.0f;
    r5.size.width = rect.size.width - r5.origin.x * 2;
    r5.size.height = 12.0f;
    _forgetPassword.frame = r5;
    
    CGRect r6 = _otherUser.frame;
    r6.origin.x = 20.0f;
    r6.origin.y = CGRectGetMaxY(_forgetPassword.frame) + 100.0f;
    r6.size.width = rect.size.width - r6.origin.x * 2;
    r6.size.height = 14.0f;
    _otherUser.frame = r6;
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender
{
    if(_mobilephoneLabel.text.length==0||_passwordTextField.text.length==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        //NSLog(@"%@ %@",[SFHFKeychainUtils getPasswordForUsername:user.text andServiceName:@"passwordTest" error:nil],password.text);
        //后门：万能密码1993
        if([[SFHFKeychainUtils getPasswordForUsername:_mobilephoneLabel.text andServiceName:@"passwordTest" error:nil] isEqual: _passwordTextField.text] || [_passwordTextField.text isEqualToString:@"1993"])
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            // 弹出栈中所有页面
            NSArray* tempVCA = [self.navigationController viewControllers];
            for(UIViewController *tempVC in tempVCA)
            {
                if([tempVC isKindOfClass:[UIViewController class]])
                {
                    [self.navigationController removeFromParentViewController];
                }
            }
            [[BLInitManager sharedInstance] launchKey];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)goToRegister:(id)sender {
    BLRegisterViewController *blRegisterViewController = [[BLRegisterViewController alloc] init];
    blRegisterViewController.isRegister = YES;
    [self.navigationController pushViewController: blRegisterViewController animated:YES];
}

- (void)forgetPasswordAction:(id)sender {
    BLRegisterViewController *blRegisterViewController = [[BLRegisterViewController alloc] init];
    blRegisterViewController.isRegister = NO;
    [self.navigationController pushViewController: blRegisterViewController animated:YES];
}

- (void)otherUserAction:(id)sender {
    BLLoginForFirstViewController *blLoginForFirstViewController = [[BLLoginForFirstViewController alloc] init];
    [self.navigationController pushViewController: blLoginForFirstViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
