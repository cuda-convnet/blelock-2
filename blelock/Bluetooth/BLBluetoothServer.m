//
//  BLBluetoothServer.m
//  blelock
//
//  Created by NetEase on 15/8/26.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "BLBluetoothServer.h"

@implementation BLBluetoothServer

//+ (void)onLockStateChanged:(enum LockState)lockState {
//    switch (lockState) {
//        case LOCK_IS_OPEN:
//            //通知服务器修改已用次数
//            break;
//            
//        default:
//            break;
//    }
//        
//}
+ (void)onUnknownNotificationReceived:(NSData *)command{
    if(command == nil)
        return;
    NSString *commandString = [[NSString alloc] initWithData:command encoding:NSUTF8StringEncoding];
    NSLog(@"接受到一条不能理解的通知，内容是%@",commandString);
    // 异常情况要上报服务器
}
@end

