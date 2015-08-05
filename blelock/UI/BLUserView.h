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
//@property int state;

-(id)initWithCaller:(id<BLUserViewDelegate>)_caller userImage:(UIImage *)_image userInformation:(NSArray *)_information;
//- (void) changeForBLState;

@end