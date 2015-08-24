//
//  BLUserNameChange.m
//  blelock
//
//  Created by NetEase on 15/8/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLUserNameChangeViewController.h"
#import "UIViewController+Utils.h"

@interface BLUserNameChangeViewController ()

@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITextField *userNewNameTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) BOOL change;



@end

@implementation BLUserNameChangeViewController

- (void)loadView {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"修改姓名";
    _change = NO;
    
    //导航栏按钮
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    
    _hintLabel = [UIViewController customLabel:CGRectZero andText:@"请使用您的真实姓名，否则好友无法分享钥匙给您！" andColor:[UIColor grayColor] andFont:10.0f];
    
    _userNewNameTextField = [UIViewController customTextField:CGRectZero andPlaceHolder:@"我的姓名"];
    _userNewNameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [_userNewNameTextField addTarget:self action:@selector(lastTextField_DidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _confirmButton = [UIViewController customButton:CGRectZero andTitle:@"确定" andFont:16.0f andBackgroundColor:[UIColor lightGrayColor]];
    [_confirmButton addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_hintLabel];
    [view addSubview:_userNewNameTextField];
    [view addSubview:_confirmButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.view = view;
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
    [self dismissKeyBoard];
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _hintLabel.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = [self.topLayoutGuide length];
    r1.size.width = rect.size.width;
    r1.size.height = 44.0f;
    _hintLabel.frame = r1;
    
    CGRect r2 = _userNewNameTextField.frame;
    r2.origin.x = 0.0f;
    r2.origin.y = CGRectGetMaxY(_hintLabel.frame);
    r2.size.width = rect.size.width;
    r2.size.height = 44.0f;
    _userNewNameTextField.frame = r2;
    
    CGRect r3 = _confirmButton.frame;
    r3.origin.x = 20.0f;
    r3.origin.y = CGRectGetMaxY(_userNewNameTextField.frame)+20.0f;
    r3.size.width = rect.size.width - 40.0f;
    r3.size.height = 44.0f;
    _confirmButton.frame = r3;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lastTextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (void)textDidChange:(id)sender {
    _confirmButton.backgroundColor = BLBlue;
    _change = YES;
}

- (void)changeName:(id)sender {
    if (_change) {
        [_delegate changeUserName:_userNewNameTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
