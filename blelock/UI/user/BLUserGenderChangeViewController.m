//
//  BLUserGenderChangeViewController.m
//  blelock
//
//  Created by NetEase on 15/8/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLUserGenderChangeViewController.h"
#import "UIViewController+Utils.h"

@interface BLUserGenderChangeViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *genderTable;
@property (nonatomic, assign) NSInteger oldRow;

@end

@implementation BLUserGenderChangeViewController

- (void) loadView {
    UIView *view = [UIViewController customView:CGRectZero andBackgroundColor:BLGray];
    self.title = @"修改性别";
    //导航栏
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = navLeftButton;
    _oldRow = 0;
    if ([_oldGenger isEqualToString:@"女"]) {
        _oldRow = 1;
    }
    _genderTable = [UIViewController customTableView:CGRectZero andDelegate:self];
    [view addSubview:_genderTable];
    
    self.view = view;

}

- (void)viewDidLoad {
    
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _genderTable.frame;
    r1.origin.x = 0.0f;
    r1.origin.y = 0.0f;
    r1.size.width = rect.size.width;
    r1.size.height = 172.0f;
    _genderTable.frame = r1;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

//列表需要的方法
//列表内容
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        switch (row) {
            case 0: {
                cell.textLabel.text = @"男";
                if (row == _oldRow) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            }
            case 1: {
                cell.textLabel.text = @"女";
                if (row == _oldRow) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
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
    [_genderTable deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_oldRow inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryCheckmark;
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                indexPath];
    if (_oldRow != indexPath.row) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _oldRow = indexPath.row;
        [self changeGender];
    }
}

- (void)changeGender{
    if (_oldRow == 0) {
        _oldGenger = @"男";
    } else {
        _oldGenger = @"女";
    }
    [_delegate changeUserGender:_oldGenger];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

