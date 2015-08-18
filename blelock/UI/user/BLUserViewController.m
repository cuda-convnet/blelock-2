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

@interface BLUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *setTableView;

@end

@implementation BLUserViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    //导航栏
    self.navigationItem.title = @"账户及设置";
    
    _setTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _setTableView.delegate = self;
    _setTableView.dataSource = self;
    [view addSubview:_setTableView];
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
    r1.size.height = rect.size.height - [self.topLayoutGuide length];
    _setTableView.frame = r1;
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
                UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
                userNameLabel.text = @"人间四月天";
                UILabel *userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 200, 30)];
                userPhoneLabel.text = @"1515****690";
                userPhoneLabel.textColor = [UIColor lightGrayColor];
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
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 20)];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    headerLabel.textColor = [UIColor blueColor];
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