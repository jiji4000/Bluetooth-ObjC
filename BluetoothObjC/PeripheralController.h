#ifndef PeripheralController_h
#define PeripheralController_h

#import <Foundation/Foundation.h>
#import "PeripheralViewController.h"

@interface PeripheralController : NSObject
- (void) initPeripheralController:(PeripheralViewController*)viewController;
- (void) close;
- (NSString *) getCentralValue;
- (NSMutableArray *) getCentralDevices;
- (BOOL) updatePeripheralValue:(int) intSendData;
@end

#endif /* PeripheralController_h */
