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
#import "BLKeyViewController.h"
#import "BLUser.h"
#import "UIViewController+Utils.h"

@interface BLLoginViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *mobilephoneLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *forgetPassword;
@property (nonatomic, strong) UILabel *otherUser;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) BLUser *user;

@end

@implementation BLLoginViewController

- (void)loadView {
    //数据初始化
    _user = [[BLUser alloc]init];
    _user.img = [UIImage imageNamed:@"users.jpg"];
    _user.mobile = @"13813888888";

    CGRect navframe = self.navigationController.navigationBar.frame;
    self.title = @"钥匙";
    //右边按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goToRegister:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIView *view = [UIViewController customView:CGRectZero andColor:[UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1]];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _mobilephoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _forgetPassword = [[UILabel alloc] initWithFrame:CGRectZero];
    _otherUser = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _avatarImageView.backgroundColor = [UIColor clearColor];
    [_avatarImageView setImage:_user.img];
    
    
    _mobilephoneLabel.text = _user.mobile;
    _mobilephoneLabel.textColor = [UIColor blackColor];
    _mobilephoneLabel.textAlignment = NSTextAlignmentCenter;
    _mobilephoneLabel.font = [UIFont systemFontOfSize:14.0f];
    _mobilephoneLabel.backgroundColor = [UIColor clearColor];
    
    
    _passwordTextField.placeholder = @"  密码：";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textColor = [UIColor blackColor];
    [_passwordTextField setFont:[UIFont systemFontOfSize:16.0f]];
    [_passwordTextField setBorderStyle:UITextBorderStyleNone];
    [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.delegate = self;
    [_passwordTextField addTarget:self action:@selector(TextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    

    _forgetPassword.text = @"忘记密码？";
    _forgetPassword.textColor = [UIColor redColor];
    _forgetPassword.textAlignment = NSTextAlignmentRight;
    _forgetPassword.font = [UIFont systemFontOfSize:12.0f];
    _forgetPassword.backgroundColor = [UIColor clearColor];
    _forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction:)];
    [_forgetPassword addGestureRecognizer:forgetGesture];
    
    _otherUser.text = @"使用其他账户登录";
    _otherUser.textColor = [UIColor grayColor];
    _otherUser.textAlignment = NSTextAlignmentCenter;
    _otherUser.font = [UIFont systemFontOfSize:12.0f];
    _otherUser.backgroundColor = [UIColor clearColor];
    _otherUser.userInteractionEnabled = YES;
    UITapGestureRecognizer *otherGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherUserAction:)];
    [_otherUser addGestureRecognizer:otherGesture];
    
    [view addSubview:_avatarImageView];
    [view addSubview:_mobilephoneLabel];
    [view addSubview:_passwordTextField];
    [view addSubview:_loginButton];
    [view addSubview:_forgetPassword];
    [view addSubview:_otherUser];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.view = view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
    // Do any additional setup after loading the view.


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
    r2.origin.y = CGRectGetMaxY(_avatarImageView.frame) + 18.0f;
    r2.size.width = rect.size.width - r2.origin.x * 2;
    r2.size.height = 44.0f;
    _mobilephoneLabel.frame = r2;
    
    CGRect r3 = _passwordTextField.frame;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_mobilephoneLabel.frame) + 18.0f;
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    _passwordTextField.frame = r3;
    
    CGRect r4 = _loginButton.frame;
    r4.origin.x = 20.0f;
    r4.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 18.0f;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if(_mobilephoneLabel.text.length==0||_passwordTextField.text.length==0)
    {
        _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        _alertView.tag = 0;
        [_alertView show];
    }
    else
    {
        //NSLog(@"%@ %@",[SFHFKeychainUtils getPasswordForUsername:user.text andServiceName:@"passwordTest" error:nil],password.text);
        //后门：万能密码1993
        if([[SFHFKeychainUtils getPasswordForUsername:_mobilephoneLabel.text andServiceName:@"passwordTest" error:nil] isEqual: _passwordTextField.text] || [_passwordTextField.text isEqualToString:@"1993"]) {
            BLKeyViewController *blKeyViewController = [[BLKeyViewController alloc] init];
            [self.navigationController pushViewController: blKeyViewController animated:YES];
        }
        else
        {
            _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码不正确，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            _alertView.tag = -1;
            [_alertView show];
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

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (_alertView.tag == 1) {
//        BLKeyViewController *blKeyViewController = [[BLKeyViewController alloc] init];
//        [self.navigationController pushViewController: blKeyViewController animated:YES];
//    }
//}

@end
