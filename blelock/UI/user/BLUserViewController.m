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

#import "BLLoginForFirstViewController.h"

@interface BLUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) UIButton *quitButton;

@end

@implementation BLUserViewController

- (void)loadView {

    UIView *view = [UIViewController customView];
    self.title = @"账户及设置";
    
    _setTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    
    _quitButton = [UIViewController customButton:@"退出登录" andFont:16.0f andBackgroundColor:BLBlue];
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
    r1.origin.y = [self.topLayoutGuide length];
    r1.size.width = rect.size.width;
    r1.size.height = 316.0f;
    _setTableView.frame = r1;
    
    CGRect r2 = _quitButton.frame;
    r2.origin.x = 20.0f;
    r2.origin.y = CGRectGetMaxY(_setTableView.frame)+20.0f;
    r2.size.width = rect.size.width - 40.0f;
    r2.size.height = 44.0f;
    _quitButton.frame = r2;
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
                UIImageView *usersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [usersImageView setImage:[UIImage imageNamed:@"users.jpg"]];
                usersImageView.layer.cornerRadius = 50;
                usersImageView.layer.masksToBounds = YES;
                
                UILabel *userNameLabel =[UIViewController customLabel:@"人间四月天" andColor:[UIColor blackColor] andFont:16.0f];
                userNameLabel.frame = CGRectMake(100, 20, 200, 30);
                
                UILabel *userPhoneLabel = [UIViewController customLabel:@"1515****690" andColor:[UIColor lightGrayColor] andFont:16.0f];
                userPhoneLabel.frame = CGRectMake(100, 50, 200, 30);
                
                [cell.contentView addSubview: userNameLabel];
                [cell.contentView addSubview: userPhoneLabel];
                [cell.contentView addSubview: usersImageView];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Tells the delegate that the specified row is now selected.
    [_setTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"hello");
}
//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *headerLabel = [UIViewController customLabel:nil andColor:BLBlue andFont:15.0f];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.backgroundColor = BLGray;
    headerLabel.frame = CGRectMake(130, 5, 150, 20);
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:
            headerLabel.text = @"    设置";
            return headerLabel;
            break;
        case 2:
            headerLabel.text = @"    其他";
            return headerLabel;
            break;
        default:
            return nil;
            break;
    }
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
    if (section == 0) {
        return 0;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

@end