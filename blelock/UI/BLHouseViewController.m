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

//- (void) goToChangeView
//{
//    NSLog(@"hi");
//}
@end
