
//  BLHouseView.m
//  blelock
//
//  Created by NetEase on 15/8/6.
//  Copyright (c) 2015年 Netease. All rights reserved.


#import "BLHouseView.h"
#import "BLKey.h"

@interface BLHouseView() <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property UIView *view;
@property UINavigationBar *navigationBar;
@property UINavigationItem *navigationItem;
@property UIButton *backButton;
@property UIButton *changeButton;
@property UIBarButtonItem *leftItem;
@property UIBarButtonItem *rightItem;
@property UITableView *houseTableView;
@property UIButton *deleteButton;
//视觉图出来后，需修改
@property NSString *houseName;
@property BLKey *blKey;

@property (nonatomic, retain) id<BLHouseViewDelegate> caller;

@end

@implementation BLHouseView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self prepare];
    }
    return self;
}

-(id)initWithCaller:(id<BLHouseViewDelegate>)houseCaller
{
    self = [self init];
    if (self) {
        self.caller = houseCaller;
    }
    return self;
}

-(void)prepare
{
    //初始化默认数据
    self.houseName = @"翠苑四区";
    //Creates the view that the controller manages.
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navframe = CGRectMake(0, 0, frame.size.width, 44);
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航栏
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, rectStatus.size.height, frame.size.width, navframe.size.height)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //创建一个导航栏集合
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [self.navigationItem setTitle:self.houseName];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    //左边按钮：返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [self.backButton setBackgroundImage: [UIImage imageNamed : @"back.jpg"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    //右边按钮：修改
    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [self.changeButton setBackgroundImage: [UIImage imageNamed : @"change.png"] forState:UIControlStateNormal];
    [self.changeButton addTarget:self action:@selector(goToChange) forControlEvents:UIControlEventTouchUpInside];
    self.rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.changeButton];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [self.view addSubview:self.navigationBar];
    
    
    //设置列表
    self.houseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), frame.size.width, frame.size.height-navframe.size.height) style:UITableViewStyleGrouped];
    [self.houseTableView setDelegate:self];
    [self.houseTableView setDataSource:self];
    self.houseTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];

    [self.view addSubview:self.houseTableView];
    
    
    //删除按钮
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 520 ,350,44)];
    [self.deleteButton setTitle:@"删除这把钥匙" forState:UIControlStateNormal];
    self.deleteButton.backgroundColor = [UIColor blueColor];
    [self.deleteButton addTarget:self action:@selector(goToDeleteTheKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteButton];
    [self addSubview: self.view];
}


//列表需要的方法
//列表内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0:
            {
                
                cell.textLabel.text = @"杭州市西湖区文一路38号翠苑四区28幢";
                break;
            }
            case 1:
            {
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
            case 2:
            {
                UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
                timeLabel.text = @"  到期时间                        2015-07-14";
                UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 300, 30)];
                numberLabel.text = @"  剩余次数                               10次";
                [cell addSubview: timeLabel];
                [cell addSubview: numberLabel];
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
    NSLog(@"hello");
}
//section头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 20)];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeader:(NSInteger)section
{
    return 44;
}

//alter需要的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString: @"编辑钥匙名字"] && buttonIndex == 1)
    {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        self.houseName = tf.text;
        [self.navigationItem setTitle:self.houseName];
        NSLog(@"%@", self.houseName);
    }else if ([alertView.title isEqualToString: @"确认删除"] && buttonIndex == 1)
    {
        self.keyIDForDelete = self.houseName;
        NSLog(@"进行删除操作");
    }
}

//代理让control实现
- (void) deleteAndGoback:(NSString *) keyID
{
    if ([self.caller respondsToSelector:@selector(deleteAndGobackView)])
    {
        [self.caller deleteAndGobackView:keyID];
    }
    
}



//按钮跳转
//返回按钮
- (void)goBack
{
    if ([self.caller respondsToSelector:@selector(goBackView)])
    {
        [self.caller goBackView];
    }
    
    
}
//修改按钮
- (void)goToChange
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"编辑钥匙名字" message:nil delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alter setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alter show];
}
//删除按钮
- (void)goToDeleteTheKey
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"确认删除" message:@"您确定要删除这把钥匙：翠苑四区" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alter show];
}





@end
