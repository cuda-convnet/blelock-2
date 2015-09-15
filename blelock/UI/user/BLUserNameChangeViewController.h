//
//  BLUserNameChange.h
//  blelock
//
//  Created by NetEase on 15/8/20.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUserNameChangeViewControllerDelegate

- (void) changeUserName:(NSString *) newName;

@end

@interface BLUserNameChangeViewController : UIViewController

@property (nonatomic, assign)id<BLUserNameChangeViewControllerDelegate> delegate;

@end
