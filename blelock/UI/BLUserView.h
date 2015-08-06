//
//  BLUserView.h
//  blelock
//
//  Created by biliyuan on 15/8/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUserViewDelegate <NSObject>
@required
- (void) goBackView;
- (void) goToUserInformationView;
@end

@interface BLUserView : UIView

@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) NSArray *info;

-(id)initWithCaller:(id<BLUserViewDelegate>)userCaller;
//- (void) changeForBLState;

@end