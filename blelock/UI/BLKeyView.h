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
@property int state;

-(id)initWithCaller:(id<BLKeyViewDelegate>)_caller data:(NSArray*)_data;
- (void) changeForBLState;

@end

