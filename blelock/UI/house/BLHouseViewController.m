//
//  BLHouseViewController.m
//  blelock
//
//  Created by NetEase on 15/8/7.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "BLHouseViewController.h"
#import "BLHouseView.h"

@interface BLHouseViewController()<BLHouseViewDelegate>

@property (nonatomic, strong) BLHouseView *blHouseView;
@property (nonatomic, strong) BLKey *blKey;

@end

@implementation BLHouseViewController

- (id)initWithKey:(BLKey *)houseKey {
    self = [super init];
    if (self) {
        self.blKey = houseKey;
    }
    return self;
}
- (void)loadView {
    self.blHouseView = [[BLHouseView alloc] initWithCaller:self];
    //导航栏
    CGRect navframe = self.navigationController.navigationBar.frame;
    self.navigationItem.title = self.blKey.alias;
    //左边按钮
    [self.navigationItem setHidesBackButton:NO];
    //右边按钮：修改
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, navframe.size.height, navframe.size.height);
    [rightButton setBackgroundImage: [UIImage imageNamed : @"change.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(goToChange) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //删除按钮
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 520 ,350,44)];
    [deleteButton setTitle:@"删除这把钥匙" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor blueColor];
    [deleteButton addTarget:self action:@selector(goToDeleteTheKey) forControlEvents:UIControlEventTouchUpInside];
    [self.blHouseView addSubview:deleteButton];
    self.view = self.blHouseView;
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
        self.blKey.alias = tf.text;
        [self.navigationItem setTitle:self.blKey.alias];
    } else if ([alertView.title isEqualToString: @"确认删除"] && buttonIndex == 1) {
        //self.keyIDForDelete = self.blKey.alias;
        NSLog(@"进行删除操作");
    }
}
//////////////////////////////////////////////////////////////////////////////////////
//监听状态值的变化，执行一定的动作
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"houseName"]) {
        //修改钥匙对象中的房屋名
        NSLog(@"修改钥匙对象中的房屋名");
    }
}
- (void)dealloc {
    //KVO释放?????????????????????????????????????????????
    [self removeObserver:self forKeyPath:@"houseName"];
}

@end
