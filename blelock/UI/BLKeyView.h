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
- (void) gotoBLUserView;
- (void) openBluetoothView;
@end

@interface BLKeyView : UIView

//公开的属性state：蓝牙的状态，用于改变操作区状态
@property int blState;
@property int keyState;

@property (nonatomic, retain) NSArray *data;

-(id)initWithCaller:(id<BLKeyViewDelegate>)keyCaller;
- (void) changeForBLState;
- (void) changeForKeyState;

@end

