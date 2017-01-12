#ifndef PeripheralController_h
#define PeripheralController_h


#import <Foundation/Foundation.h>
@interface PeripheralController : NSObject
- (void) initPeripheralController;
- (void) close;
- (NSString *) getCentralValue;
- (BOOL) updatePeripheralValue:(int) intSendData;
@end

#endif /* PeripheralController_h */
