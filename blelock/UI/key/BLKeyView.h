//
//  BLKeyView.h
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLKeyViewDelegate <NSObject>

@required
- (void)openBluetoothView;
- (void)goToBLHouseView: (NSInteger) rowNumber;

@end

@interface BLKeyView : UIView

@property (nonatomic, assign) int blState;
@property (nonatomic, assign) int keyState;
@property (nonatomic, strong) NSArray *data;

- (id)initWithCaller:(id<BLKeyViewDelegate>)keyCaller;
- (void) changeForBLState;
- (void) changeForKeyState;

@end

