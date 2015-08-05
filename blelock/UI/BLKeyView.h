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
@property int state;
@property int keyState;

-(id)initWithCaller:(id<BLKeyViewDelegate>)_caller data:(NSArray*)_data;
- (void) changeForBLState;
- (void) changeForKeyState;

@end

