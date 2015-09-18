//
//  BLDfuService.h
//  blelock
//
//  Created by NetEase on 15/8/31.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// dfu相关的，约定好的OP CODE
#define OP_CODE_START_DFU                   1
#define OP_CODE_RECEIVE_INIT                2
#define OP_CODE_RECEIVE_FW                  3
#define OP_CODE_VALIDATE                    4
#define OP_CODE_ACTIVATE_N_RESET            5
#define OP_CODE_SYS_RESET                   6
#define OP_CODE_IMAGE_SIZE_REQ              7
#define OP_CODE_PKT_RCPT_NOTIF_REQ          8
#define OP_CODE_RESPONSE_IN_DFU_MODE        16
#define OP_CODE_PKT_RCPT_NOTIF_IN_DFU_MODE  17

// dfu mode
#define MODE_DFU_UPDATE_SD 0X01
#define MODE_DFU_UPDATE_BL 0X02
#define MODE_DFU_UPDATE_APP 0X04

// dfu init flag
#define INIT_RX 0x00
#define INIT_COMPLETE 0x01


// dfu response procedure
#define PROC_START 0X01
#define PROC_INIT 0X02
#define PROC_RECEIVE_IMAGE 0X03
#define PROC_VALIDATE 0X04
#define PROC_ACTIVATE 0X05 // 这个状态不会由芯片返回
#define PROC_PKT_RCPT_REQ 0X08

// dfu response state
#define RESPONSE_SUCCESS 0X01
#define RESPONSE_INVALID_STATE 0X02
#define RESPONSE_NOT_SUPPORTED 0X03
#define RESPONSE_DATA_SIZE_OVERFLOW 0X04
#define RESPONSE_CRC_ERROR 0X05
#define RESPONSE_OPERATION_FAIL 0X06


//命令状态
enum CommandState {
    CP_START_DFU,
    P_SEND_START_DATA,
    CP_INIT_BEGIN,
    P_SEND_INIT_DATA,
    CP_INIT_END,
    CP_PKT_NOTIFY,
    CP_DATA_COMMAND,
    P_DATA,
    CP_VALIDATE,
    CP_ACTIVATE
};


/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/
extern NSString *kDfuServiceUUIDString;                         // 00001530-1212-efde-1523-785feabcd123     Service UUID
extern NSString *kDfuControlPointCharacteristicUUIDString;      // 00001532-1212-efde-1523-785feabcd123
extern NSString *kDfuPacketCharacteristicUUIDString;            //00001531-1212-efde-1523-785feabcd123


/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class BLDfuService;

@protocol BLDfuServiceProtocol<NSObject>
@required
- (void) dfuService:(BLDfuService*)service changeForDfuCommandState:(enum CommandState)commandState;
@end


/****************************************************************************/
/*						Dfu service.                                        */
/****************************************************************************/
@interface BLDfuService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<BLDfuServiceProtocol>)controller;
- (void) start;

@property (readonly) CBPeripheral *peripheral;
@end
