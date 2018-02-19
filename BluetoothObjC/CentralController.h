//
//  CentralController.h
//  BluetoothObjC
//
//  Created by 佐藤俊一朗 on 2017/01/07.
//  Copyright © 2017年 佐藤俊一朗. All rights reserved.
//

#ifndef CentralController_h
#define CentralController_h

#import <Foundation/Foundation.h>
@interface CentralController : NSObject
-(void) initCentralController;
-(void) sendValue:(int)intSendValue;
-(NSString *) getPeripheralValue;
-(BOOL) getIsValueWrote;
-(void) scanNewDevice;
@end

#endif /* CentralController_h */
