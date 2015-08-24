//
//  BLUserGenderChangeViewController.h
//  blelock
//
//  Created by NetEase on 15/8/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLUserGenderChangeViewControllerDelegate

- (void) changeUserGender:(NSString *)newGender;

@end

@interface BLUserGenderChangeViewController : UIViewController

@property (nonatomic, strong) NSString *oldGenger;
@property (nonatomic, assign)id<BLUserGenderChangeViewControllerDelegate> delegate;

@end
