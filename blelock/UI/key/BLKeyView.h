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
- (void) goToBLHouseView: (NSInteger) rowNumber;
@end

@interface BLKeyView : UIView
//public属性
@property int blState;
@property int keyState;
@property (nonatomic, strong) NSArray *data;

-(id)initWithCaller:(id<BLKeyViewDelegate>)keyCaller;
- (void) changeForBLState;
- (void) changeForKeyState;

@end

