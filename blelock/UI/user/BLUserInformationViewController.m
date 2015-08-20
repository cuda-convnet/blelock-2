//
//  BLUserInformationViewController.m
//  blelock
//
//  Created by NetEase on 15/8/19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLUserInformationViewController.h"
#import "UIViewController+Utils.h"


@interface BLUserInformationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *setTableView;

@end

@implementation BLUserInformationViewController

- (void)loadView {
    
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"我的资料";
    
    _setTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    
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
    r1.size.height = 312.0f;
    _setTableView.frame = r1;
}


//列表需要的方法
//列表内容

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0: {
                UIImageView *usersImageView = [UIViewController customImageView:CGRectMake(120, 0, 100, 100) andImage:_user.img];
                [cell.contentView addSubview: usersImageView];
                break;
            }
            case 1: {
                cell.textLabel.text = @"姓名";
                UILabel *userNameLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.name andColor:[UIColor blackColor] andFont:16.0f];
                userNameLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: userNameLabel];
                break;
            }
            case 2: {
                cell.textLabel.text = @"性别";
                UILabel *userGenderLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.gender andColor:[UIColor blackColor] andFont:16.0f];
                userGenderLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: userGenderLabel];
                break;
            }
            case 3:{
                cell.textLabel.text = @"手机";
                UILabel *userPhoneLabel = [UIViewController customLabel:CGRectMake(120, 0, 150, 30) andText:_user.mobile andColor:[UIColor blackColor] andFont:16.0f];
                userPhoneLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview: userPhoneLabel];
                break;
            }
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

@end