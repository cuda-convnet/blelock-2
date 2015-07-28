//
//  BLKeyViewController.m
//  blelock
//
//  Created by biliyuan on 15/7/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLKeyViewController.h"

@interface BLKeyViewController ()

@property (nonatomic, strong) UITableView *keyTableView;

@end

@implementation BLKeyViewController

{
    NSArray *tableData;
}

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor lightGrayColor];
    
    _keyTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _keyTableView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_keyTableView];
    
    // Initialize table data

    tableData = [NSArray arrayWithObjects:@"Egg Benedict",@"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"GreenTea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    
    
    self.view = view;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    
    CGRect rect = self.view.bounds;
    
    CGRect r1 = _keyTableView.frame;
    r1.size.width = rect.size.width;
    r1.size.height = rect.size.height;
    r1.origin.x = 0.0f;
    r1.origin.y = [self.topLayoutGuide length] + 30.0f;
    _keyTableView.frame = r1;
    
}


- (NSInteger)tableView:(UITableView *)tableViewnumberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row]; return cell;
}

- (void) openBLButtonAction : (id)sender
{
}
@end