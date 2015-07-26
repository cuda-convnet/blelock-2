//
//  BLLoginViewController.m
//  blelock
//
//  Created by liudongdong on 15/7/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLLoginViewController.h"

@interface BLLoginViewController () < UITextFieldDelegate >

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *mobilephoneLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation BLLoginViewController

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor lightGrayColor];
    
    _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _avatarImageView.backgroundColor = [UIColor greenColor];
    [view addSubview:_avatarImageView];
    
    _mobilephoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _mobilephoneLabel.text = @"13813888888";
    _mobilephoneLabel.textColor = [UIColor blackColor];
    _mobilephoneLabel.textAlignment = NSTextAlignmentCenter;
    _mobilephoneLabel.font = [UIFont systemFontOfSize:14.0f];
    _mobilephoneLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_mobilephoneLabel];
    
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
    
    CGRect r2 = _mobilephoneLabel.frame;
    r2.size.width = rect.size.width;
    r2.size.height = 44.0f;
    r2.origin.x = 0.0f;
    r2.origin.y = CGRectGetMaxY(_avatarImageView.frame) + 20.0f;
    _mobilephoneLabel.frame = r2;
    
    CGRect r3 = _passwordTextField.frame;
    r3.size.width = rect.size.width;
    r3.size.height = 44.0f;
    r3.origin.x = 0.0f;
    r3.origin.y = CGRectGetMaxY(_mobilephoneLabel.frame) + 20.0f;
    _passwordTextField.frame = r3;
    
    CGRect r4 = _loginButton.frame;
    r4.origin.x = 20.0f;
    r4.origin.y = CGRectGetMaxY(_passwordTextField.frame) + 20.0f;
    r4.size.width = rect.size.width - r4.origin.x * 2;
    r4.size.height = 44.0f;
    _loginButton.frame = r4;
    
}

#pragma mark - login Button Action

- (void)loginButtonAction:(id)sender {

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
