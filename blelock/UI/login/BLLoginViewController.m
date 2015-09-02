//
//  BLLoginViewController.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLoginViewController.h"
#import "SFHFKeychainUtils.h"
#import "BLUser.h"
#import "UIViewController+Utils.h"

#import "BLLoginForFirstViewController.h"
#import "BLRegisterViewController.h"
#import "BLKeyViewController.h"


@interface BLLoginViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *mobilephoneLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *forgetPassword;
@property (nonatomic, strong) UILabel *otherUser;
@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) BLUser *user;
@property (nonatomic, assign) BOOL change;

@end

@implementation BLLoginViewController

- (void)loadView {
    //数据初始化
//    _user = [[BLUser alloc]init];
//    _user.img = @"users";
//    _user.mobile = @"13813888888";
//    _change = NO;

    
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"钥匙";
    
    //导航栏右边按钮
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(goToRegister:)];
    self.navigationItem.rightBarButtonItem = navRightButton;
    
    _avatarImageView = [UIViewController customImageView:CGRectZero];
    
    _mobilephoneLabel = [UIViewController customLabel:CGRectZero andText:nil andColor:[UIColor blackColor] andFont:14.0f];
    
    _passwordTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"  密码"];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    
    _loginButton = [UIViewController customButton:(CGRect)CGRectZero andTitle:@"登录" andFont:17.0f andBackgroundColor:[UIColor lightGrayColor]];
    [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    _forgetPassword = [UIViewController customLabel:CGRectZero andText:@"忘记密码？" andColor:[UIColor redColor] andFont:12.0f];
    _forgetPassword.textAlignment = NSTextAlignmentRight;
    _forgetPassword.userInteractionEnabled = YES;
    UITapGestureRecognizer *forgetGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPasswordAction:)];
    [_forgetPassword addGestureRecognizer:forgetGesture];
    
    _otherUser = [UIViewController customLabel:CGRectZero andText:@"使用其他账户登录" andColor:[UIColor grayColor] andFont:12.0f];
    _otherUser.userInteractionEnabled = YES;
    //要申请多个，还是可以重复利用
    UITapGestureRecognizer *otherGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherUserAction:)];
    [_otherUser addGestureRecognizer:otherGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

    
    [view addSubview:_avatarImageView];
    [view addSubview:_mobilephoneLabel];
    [view addSubview:_passwordTextField];
    [view addSubview:_loginButton];
    [view addSubview:_forgetPassword];
    [view addSubview:_otherUser];
    self.view = view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self saveNSUserDefaults];  //调用此方法将各种数据存储到NSUserDefautls中，在下面定义
    [self readNSUserDefaults];  //调用此方法从NSUserDefautls中读取各种数据，在下面定义
    [self dismissKeyBoard];
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

//保存数据到NSUserDefaults
- (void)saveNSUserDefaults
{
    _user = [[BLUser alloc]init];
    _user.img = @"users";
    _user.mobile = @"13813888888";
    _change = NO;
    NSString *img = @"users";
    NSString *mobile = @"13813888888";
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:img forKey:@"img"];
    [userDefaults setObject:mobile forKey:@"mobile"];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefaults synchronize];
    
}

//从NSUserDefaults中读取数据
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //读取数据到各个label中
    
    //读取NSString类型的数据
    NSString *img = [userDefaultes stringForKey:@"img"];
    NSString *mobile = [userDefaultes stringForKey:@"mobile"];
    [_avatarImageView setImage:[UIImage imageNamed:img]];
    _mobilephoneLabel.text = mobile;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)textDidChange:(id)sender {
    _loginButton.backgroundColor = BLBlue;
    _change = YES;
}

//textFieldDelegate方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender {
    
    if (_change) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        if(_passwordTextField.text.length == 0) {
            _alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            _alertView.tag = 0;
            [_alertView show];
        }
        else {
            //NSLog(@"%@ %@",[SFHFKeychainUtils getPasswordForUsername:user.text andServiceName:@"passwordTest" error:nil],password.text);
            //后门：万能密码1993
            if([[SFHFKeychainUtils getPasswordForUsername:_mobilephoneLabel.text andServiceName:@"passwordTest" error:nil] isEqual: _passwordTextField.text] || [_passwordTextField.text isEqualToString:@"1"]) {
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
