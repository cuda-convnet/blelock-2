//
//  BLHouseView.h
//  blelock
//
//  Created by NetEase on 15/8/6.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLHouseViewDelegate <NSObject>

@required
//- (void) gotoBLUserView;
//- (void) openBluetoothView;
@end

@interface BLHouseView : UIView
//public属性
//@property int blState;
//@property int keyState;
//@property (nonatomic, retain) NSArray *data;

-(id)initWithCaller:(id<BLHouseViewDelegate>)houseCaller;
//- (void) changeForBLState;
//- (void) changeForKeyState;

@end
