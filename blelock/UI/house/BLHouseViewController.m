//
//  BLHouseViewController.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLHouseViewController.h"
#import "UIViewController+Utils.h"

@interface BLHouseViewController()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *houseTableView;
@property (nonatomic, strong) UIButton *deleteButton;



@end

@implementation BLHouseViewController
/////////////////要改
- (id)initWithKey:(BLKey *)myKey {
    self = [self init];
    self.key = myKey;
    return self;
}

- (void)loadView {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = _key.alias;
    
    //导航栏按钮
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = navLeftButton;

    //右边按钮：修改
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed : @"change.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goToChange)];
    self.navigationItem.rightBarButtonItem = navRightButton;

    //设置列表
    _houseTableView = [UIViewController customTableView:CGRectZero andDelegate:self];
    //_houseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    

    //删除按钮
    _deleteButton = [UIViewController customButton:CGRectZero andTitle:@"删除这把钥匙" andFont:16.0f andBackgroundColor:BLBlue];
    _deleteButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [_deleteButton addTarget:self action:@selector(goToDeleteTheKey) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_houseTableView];
    [view addSubview:_deleteButton];
    self.view = view;
    
    
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _houseTableView.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = 0.0f;
    r1.size.width = rect.size.width;
    r1.size.height = 348.0f;
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

- (void)goBack {
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
                UIImageView *usersImageView = [UIViewController customImageView:CGRectMake(0, 0, 100, 100) andImage:_key.owner.img];
                UILabel *userNameLabel = [UIViewController customLabel:CGRectMake(0, 30, 380, 30) andText:_key.owner.name andColor:[UIColor blackColor] andFont:16.0f];
                UILabel *userPhoneLabel = [UIViewController customLabel:CGRectMake(0, 60, 380, 30) andText:_key.owner.mobile andColor:[UIColor lightGrayColor] andFont:16.0f];
                userNameLabel.textAlignment = NSTextAlignmentRight;
                userPhoneLabel.textAlignment = NSTextAlignmentRight;
                
                [cell addSubview: userNameLabel];
                [cell addSubview: userPhoneLabel];
                [cell addSubview: usersImageView];
                break;
            }
            case 2:{
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                UILabel *timeLabel = [UIViewController customLabel:CGRectMake(0, 10, 300, 30) andText:@"   到期时间" andColor:[UIColor blackColor] andFont:16.0f];
                UILabel *numberLabel = [UIViewController customLabel:CGRectMake(0, 40, 300, 30) andText:@"   剩余次数" andColor:[UIColor blackColor] andFont:16.0f];
                UILabel *time = [UIViewController customLabel:CGRectMake(0, 10, 380, 30) andText:[dateFormatter stringFromDate:_key.expiredDate] andColor:[UIColor blackColor] andFont:16.0f];
                

                NSString *numberText = [[NSString alloc]initWithFormat:@"%d %@", _key.maxTimes-_key.usedTimes, @"次"];
                UILabel *number = [UIViewController customLabel:CGRectMake(0, 40, 380, 30) andText:numberText andColor:[UIColor blackColor] andFont:16.0f];
                timeLabel.textAlignment = NSTextAlignmentLeft;
                numberLabel.textAlignment = NSTextAlignmentLeft;
                time.textAlignment = NSTextAlignmentRight;
                number.textAlignment = NSTextAlignmentRight;
                
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
    UILabel *headerLabel = [UIViewController customLabel:CGRectZero andText:nil andColor:BLBlue andFont:15.0f];
    headerLabel.backgroundColor = BLGray;
    headerLabel.textAlignment = NSTextAlignmentLeft;
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
