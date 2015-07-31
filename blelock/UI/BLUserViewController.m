//
//  BLUserViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/30.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLUserViewController.h"
#import "BLKeyViewController.h"

@interface BLUserViewController ()

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *setTableView;

@end

@implementation BLUserViewController


- (void) loadView
{
    //Creates the view that the controller manages.
    CGRect frame = [UIScreen mainScreen].bounds;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navframe = self.navigationController.navigationBar.frame;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    //导航栏
    
    [self.navigationController setNavigationBarHidden:YES];
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, rectStatus.size.height, frame.size.width, navframe.size.height)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"账户及设置"];
    [_navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    //左边按钮：返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [backButton setBackgroundImage: [UIImage imageNamed : @"back.jpg"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    navigationItem.leftBarButtonItem = leftItem;
        //把导航栏集合添加入导航栏中，设置动画关闭
    [_navigationBar pushNavigationItem:navigationItem animated:NO];
    [view addSubview:_navigationBar];
    
    //设置列表
    _setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationBar.frame), frame.size.width, frame.size.height-navframe.size.height) style:UITableViewStyleGrouped];
    [_setTableView setDelegate:self];
    [_setTableView setDataSource:self];
    //[_setTableView.tableHeaderView setHidden:YES];
    //[_setTableView.tableHeaderView removeFromSuperview];
    //_setTableView.tableHeaderView = nil;
    [view addSubview:_setTableView];
    self.view = view;
}

- (void)viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
                cell.textLabel.text =  @"用户名";
                break;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    if (section == 0) {
        return nil;
    }
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 150, 20)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    headerLabel.textColor = [UIColor blueColor];
    
    headerLabel.text = @"Section";
    
    return headerLabel;
    
}//自定义section的头部


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    if (section == 0) {
        return 0;
    }
    return 100;
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end