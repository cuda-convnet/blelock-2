
//  BLHouseView.m
//  blelock
//
//  Created by NetEase on 15/8/6.
//  Copyright (c) 2015年 Netease. All rights reserved.


#import "BLHouseView.h"
#import "BLKey.h"

@interface BLHouseView() <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property BLKey *blKey;
@property (nonatomic, assign) id<BLHouseViewDelegate> caller;

@end

@implementation BLHouseView

- (id)init {
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (id)initWithCaller:(id<BLHouseViewDelegate>)houseCaller {
    self = [self init];
    if (self) {
        self.caller = houseCaller;
    }
    return self;
}

- (void)prepare {
    //Creates the view that the controller manages.
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect navframe = CGRectMake(0, 0, frame.size.width, 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    //设置列表
    UITableView *houseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-navframe.size.height) style:UITableViewStyleGrouped];
    [houseTableView setDelegate:self];
    [houseTableView setDataSource:self];
    houseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    [view addSubview:houseTableView];
    
    [self addSubview: view];
}

//列表需要的方法
//列表内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0:{
                cell.textLabel.text = @"杭州市西湖区文一路38号翠苑四区28幢";
                break;
            }
            case 1:{
                //cell.textLabel.text = @"钥匙主人";
                UIImageView *usersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [usersImageView setImage:[UIImage imageNamed:@"lin.jpg"]];
                usersImageView.layer.cornerRadius = 50;
                usersImageView.layer.masksToBounds = YES;
                
                UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
                userNameLabel.text = @"林小志";
                UILabel *userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 200, 30)];
                userPhoneLabel.text = @"(135***4245)";
                userPhoneLabel.textColor = [UIColor lightGrayColor];
                [cell addSubview: userNameLabel];
                [cell addSubview: userPhoneLabel];
                [cell addSubview: usersImageView];
                break;
            }
            case 2:{
                UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 300, 30)];
                timeLabel.text = @"到期时间 2015-07-14";
                UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 300, 30)];
                numberLabel.text = @"剩余次数 10次";
                [cell.contentView addSubview: timeLabel];
                [cell.contentView addSubview: numberLabel];
                break;
            }
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Tells the delegate that the specified row is now selected.
    NSLog(@"hello");
}
//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    headerLabel.backgroundColor = [UIColor greenColor];
    headerLabel.textColor = [UIColor blueColor];
    switch (section) {
        case 0:
            headerLabel.text = @"    地址信息";
            return headerLabel;
            break;
        case 1:
            headerLabel.text = @"    钥匙主人";
            return headerLabel;
            break;
        case 2:
            headerLabel.text = @"    使用限制";
            return headerLabel;
            break;
        default:
            return nil;
            break;
    }
}
//列表排版
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44;
        case 1:
            return 100;
        case 2:
            return 80;
        default:
            return 44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeader:(NSInteger)section {
    return 44;
}
//代理让control实现
- (void)deleteAndGoback:(NSString *) keyID {
    if ([self.caller respondsToSelector:@selector(deleteAndGobackView:)]) {
        [self.caller deleteAndGobackView:keyID];
    }
}

@end
