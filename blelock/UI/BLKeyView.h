//
//  BLKeyView.h
//  blelock
//
//  Created by biliyuan on 15/8/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLKeyViewDelegate

@optional
- (void) touchButtonAction;
@required
- (void) gotoBLUserView;

@end

@interface BLKeyView : UIView 

-(id)initWithCaller:(id<BLKeyViewDelegate>)_caller data:(NSArray*)_data;
-(void)prepare;


@end

