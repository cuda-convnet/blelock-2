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
#import "BLKey.h"

@interface BLHouseViewController () <BLHouseViewDelegate>

@property (nonatomic, strong) BLHouseView *blHouseView;
@property (nonatomic, strong) BLKey *blKey;

@end

@implementation BLHouseViewController

-(id)initWithKey:(BLKey *)houseKey
{
    self = [super init];
    if (self) {
        self.blKey = houseKey;
    }
    return self;
}

- (void) loadView
{
    self.blHouseView = [[BLHouseView alloc] initWithCaller:self];
    //userImage = [UIImage imageNamed:@"users.jpg"];
    //userInformation = [NSArray arrayWithObjects:@"人间四月天",@"151****4690", nil];
    //self.blUserView.img = userImage;
    //self.blUserView.info = userInformation;
    [self.navigationController setNavigationBarHidden:YES];
    [self.blHouseView addObserver:self forKeyPath:@"houseName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    self.view = self.blHouseView;
    
}

- (void) viewDidLoad
{
    //Called after the controller's view is loaded into memory.
    [super viewDidLoad];
}

- (void) goBackView
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) deleteAndGobackView: (NSString *)keyID;
{
    NSLog(@"删掉：%@",keyID);
}
//- (void) goToChangeView
//{
//    NSLog(@"hi");
//}
//////////////////////////////////////////////////////////////////////////////////////
//监听状态值的变化，执行一定的动作
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"houseName"]) {
        //修改钥匙对象中的房屋名
        NSLog(@"修改钥匙对象中的房屋名");
    }
}

- (void) dealloc
{
    //KVO释放
    [self removeObserver:self forKeyPath:@"houseName"];
}
@end
