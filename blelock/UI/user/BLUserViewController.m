//
//  BLUserViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLUserViewController.h"
#import "BLKeyViewController.h"
#import "UIViewController+Utils.h"
#import "BLUser.h"

#import "BLLoginForFirstViewController.h"
#import "BLUserInformationViewController.h"

@interface BLUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) UIImageView *usersImageView;


@property (nonatomic, strong) BLUser *user;

@end

@implementation BLUserViewController

- (void)loadView {
    //数据加载
    _user = [[BLUser alloc]init];
    _user.img = @"users";
    _user.name = @"田雨橙";
    _user.gender = @"女";
    _user.mobile = @"1515****690";
    
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"账户及设置";
    
    //导航栏按钮
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    
    _setTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    
    _quitButton = [UIViewController customButton:CGRectZero andTitle:@"退出登录" andFont:16.0f andBackgroundColor:BLBlue];
    [_quitButton addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_setTableView];
    [view addSubview:_quitButton];
    
    self.view = view;
}

- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
    
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _setTableView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = 0.0f;
    r1.size.width = rect.size.width;
    r1.size.height = 336.0f;
    _setTableView.frame = r1;
    
    CGRect r2 = _quitButton.frame;
    r2.origin.x = 20.0f;
    r2.origin.y = CGRectGetMaxY(_setTableView.frame)+20.0f;
    r2.size.width = rect.size.width - 40.0f;
    r2.size.height = 44.0f;
    _quitButton.frame = r2;
}

//从NSUserDefaults中读取数据
-(void)readNSUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    //读取数据到各个label中
    
    //读取NSString类型的数据
    NSString *img = [userDefaultes stringForKey:@"img"];
    NSLog(@"%@",img);
    [_usersImageView setImage:[UIImage imageNamed:img]];
    
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)quitAction:(id)sender {
    BLLoginForFirstViewController *blLoginForFirstViewController = [[BLLoginForFirstViewController alloc]init];
    [self.navigationController pushViewController: blLoginForFirstViewController animated:YES];
}

//列表需要的方法
//列表内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0: {
                _usersImageView = [UIViewController customImageView:CGRectMake(0, 0, 100, 100) andImage:nil];
                
                UILabel *userNameLabel =[UIViewController customLabel:CGRectZero andText:_user.name andColor:[UIColor blackColor] andFont:16.0f];
                userNameLabel.frame = CGRectMake(100, 20, 200, 30);
                
                UILabel *userPhoneLabel = [UIViewController customLabel:CGRectZero andText:_user.mobile andColor:[UIColor lightGrayColor] andFont:16.0f];
                userPhoneLabel.frame = CGRectMake(100, 50, 200, 30);
                [self readNSUserDefaults];
                
                [cell.contentView addSubview: userNameLabel];
                [cell.contentView addSubview: userPhoneLabel];
                [cell.contentView addSubview: _usersImageView];
                break;
            }
            case 1:
                if (row == 0) {
                    cell.textLabel.text = @"安全手势";
                } else if (row == 1) {
                    cell.textLabel.text = @"重置密码";
                } else {
                    cell.textLabel.text = @"消息推送";
                }
                break;
            case 2:
                cell.textLabel.text =  @"关于";
                break;
            default:
                break;
        }
    }
    return cell;
}
//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    return view;
}

//列表排版
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0||section == 2) {
        return 1;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Tells the delegate that the specified row is now selected.
    [_setTableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0: {
            BLUserInformationViewController *blUserInformationViewController = [[BLUserInformationViewController alloc] init];
            blUserInformationViewController.user = _user;
            [self.navigationController pushViewController: blUserInformationViewController animated:YES];
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0:
                    NSLog(@"安全手势");
                    break;
                case 1:
                    NSLog(@"重置密码");
                    break;
                case 2:
                    NSLog(@"消息推送");
                    break;
                default:
                    break;
            }
            break;
        }
        case 2: {
            NSLog(@"关于");
            break;
        }
        default:
            break;
    }
}


@end