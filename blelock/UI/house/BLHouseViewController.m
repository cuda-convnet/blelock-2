//
//  BLHouseViewController.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLHouseViewController.h"

@interface BLHouseViewController()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *houseTableView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) BLKey *key;

@end

@implementation BLHouseViewController

- (id)initWithKey:(BLKey *)myKey {
    self = [self init];
    self.key = myKey;
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    //导航栏
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.title = _key.alias;
    //右边按钮：修改
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [_rightButton setBackgroundImage: [UIImage imageNamed : @"change.png"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(goToChange) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];

    //设置列表
    _houseTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_houseTableView setDelegate:self];
    [_houseTableView setDataSource:self];
    //_houseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    [view addSubview:_houseTableView];

    //删除按钮
    _deleteButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_deleteButton setTitle:@"删除这把钥匙" forState:UIControlStateNormal];
    _deleteButton.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    [_deleteButton addTarget:self action:@selector(goToDeleteTheKey) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_deleteButton];
    self.view = view;
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _houseTableView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = [self.topLayoutGuide length];
    r1.size.width = rect.size.width;
    r1.size.height = 284.0f;
    _houseTableView.frame = r1;
    
    CGRect r2 = _deleteButton.frame;
    r2.origin.x = 20.0f;
    r2.origin.y = CGRectGetMaxY(_houseTableView.frame)+100.0f;
    r2.size.width = rect.size.width-40.0f;
    r2.size.height = 44.0f;
    _deleteButton.frame = r2;
    
}


- (void)viewDidLoad {
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void)goBackView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteAndGobackView:(NSString *)keyID {
    NSLog(@"删掉：%@",keyID);
}

//修改按钮
- (void)goToChange {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"编辑钥匙名字" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alter setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alter show];
}

//删除按钮
- (void)goToDeleteTheKey {
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"您确定要删除这把钥匙：翠苑四区" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alter show];
}

//alter需要的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString: @"编辑钥匙名字"] && buttonIndex == 1) {
        //得到输入框
        UITextField *tf = [alertView textFieldAtIndex:0];
        self.key.alias = tf.text;
        self.title = tf.text;
        } else if ([alertView.title isEqualToString: @"确认删除"] && buttonIndex == 1) {
        //self.keyIDForDelete = self.blKey.alias;
        NSLog(@"进行删除操作");
    }
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
                cell.textLabel.text = _key.lock.house.inaccurateAddress;
                break;
            }
            case 1:{
                //cell.textLabel.text = @"钥匙主人";
                UIImageView *usersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [usersImageView setImage:_key.owner.img];
                usersImageView.layer.cornerRadius = 50;
                usersImageView.layer.masksToBounds = YES;
                
                UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
                userNameLabel.text = _key.owner.name;
                UILabel *userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 200, 30)];
                userPhoneLabel.text = _key.owner.mobile;
                userPhoneLabel.textColor = [UIColor lightGrayColor];
                [cell addSubview: userNameLabel];
                [cell addSubview: userPhoneLabel];
                [cell addSubview: usersImageView];
                break;
            }
            case 2:{
                UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
                timeLabel.text = @"   到期时间";
                UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 300, 30)];
                numberLabel.text = @"   剩余次数";
                UILabel *time= [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 280, 30)];
                time.text = @"2015-07-14";
                 time.textAlignment = NSTextAlignmentRight;
                UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 280, 30)];
                number.textAlignment = NSTextAlignmentRight;
                number.text = @"10次";
                [cell.contentView addSubview: timeLabel];
                [cell.contentView addSubview: numberLabel];
                [cell.contentView addSubview: time];
                [cell.contentView addSubview: number];
                break;
            }
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_houseTableView deselectRowAtIndexPath:indexPath animated:NO];
    //Tells the delegate that the specified row is now selected.
    NSLog(@"hello");
}

//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    headerLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    headerLabel.textColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
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

@end
