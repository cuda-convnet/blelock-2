//
//  BLUserView.m
//  blelock
//
//  Created by biliyuan on 15/8/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLUserView.h"
@interface BLUserView() <UITableViewDelegate, UITableViewDataSource>

@property UIView *view;
@property UINavigationBar *navigationBar;
@property UINavigationItem *navigationItem;
@property UIButton *backButton;
@property UIBarButtonItem *leftItem;
@property UITableView *setTableView;

@property (nonatomic, retain) id<BLUserViewDelegate> caller;

@end

@implementation BLUserView

@synthesize view = _view;
@synthesize navigationBar = _navigationBar;
@synthesize navigationItem = _navigationItem;
@synthesize backButton = _backButton;
@synthesize leftItem = _leftItem;
@synthesize setTableView = _setTableView;
@synthesize caller = _caller;
@synthesize img = _img;
@synthesize info = _info;

- (id) init
{
    self = [super init];
    if (self)
    {
        [self prepare];
    }
    return self;
}

-(id)initWithCaller:(id<BLUserViewDelegate>)userCaller
{
    self = [self init];
    if (self) {
        self.caller = userCaller;
    }
    return self;
}

-(void)prepare
{
    //初始化默认数据
    if (self.img == nil) {
        self.img = [UIImage imageNamed:@"users.jpg"];
    }
    if (self.info == nil) {
        self.info = [NSArray arrayWithObjects:@"用户",@"手机号码", nil];
    }
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
    [self.navigationItem setTitle:@"账户及设置"];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    //左边按钮：返回
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [self.backButton setBackgroundImage: [UIImage imageNamed : @"back.jpg"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    //把导航栏集合添加入导航栏中，设置动画关闭
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    [self.view addSubview:self.navigationBar];
    
    
    //设置列表
    self.setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), frame.size.width, frame.size.height-navframe.size.height) style:UITableViewStyleGrouped];
    [self.setTableView setDelegate:self];
    [self.setTableView setDataSource:self];
    [self.view addSubview:self.setTableView];
    [self addSubview: self.view];
    
    
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
            case 0:
            {
                cell.textLabel.text = @"用户";
                UIImageView *usersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [usersImageView setImage:self.img];
                usersImageView.layer.cornerRadius = 50;
                usersImageView.layer.masksToBounds = YES;
                
                UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
                userNameLabel.text = self.info[0];
                UILabel *userPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 60, 200, 30)];
                userPhoneLabel.text = self.info[1];
                userPhoneLabel.textColor = [UIColor lightGrayColor];
                [cell addSubview: userNameLabel];
                [cell addSubview: userPhoneLabel];
                [cell addSubview: usersImageView];
                
                break;
            }
            case 1:
                if(row == 0)
                {
                    cell.textLabel.text = @"安全手势";
                }else if(row == 1){
                    cell.textLabel.text = @"重置密码";
                }else{
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        return 100;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == 2) {
        return 1;
    }
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    if (section == 0) {
        return 0;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 0;
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

//用户信息按钮
- (void)goToUserInformation
{
    if ([self.caller respondsToSelector:@selector(goToUserInformationView)])
    {
        [self.caller goToUserInformationView];
    }

}




@end
