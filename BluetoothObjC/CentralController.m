#import "CentralController.h"
@import CoreBluetooth;

#define CHARACTERISTIC_UUID @"c54e5502-0c99-11e8-ba89-0ed5f89f718b"
#define SERVICE_UUID @"bdb57744-0c99-11e8-ba89-0ed5f89f718b"

@interface CentralController()
@property (strong, nonatomic) CBCentralManager      *ccmCentralManager;
@property (strong, nonatomic) CBPeripheral          *peripheral;
@property (strong, nonatomic) CBCharacteristic      *chrDiscoveredChacteristic;
@property (strong, nonatomic) NSMutableData         *mdtSendValue;
@property (strong, nonatomic) NSString              *strGotValue;
@property (nonatomic) BOOL                          isValueWrote;
@end
@implementation CentralController
- (void) initCentralController
{
    // CentralManagerの初期化.
    _ccmCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    _strGotValue = @"";
    _isValueWrote = NO;
}

- (void)sendValue:(NSString*)sendValue
{
    // Peripheralへの書き込みリクエスト.
    _mdtSendValue = (NSMutableData *)[sendValue dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripheral writeValue:_mdtSendValue forCharacteristic:_chrDiscoveredChacteristic type:CBCharacteristicWriteWithResponse];
}

- (NSString *) getPeripheralValue
{
    // Peripheralから受け取った値を返す.
    return _strGotValue;
}
- (BOOL) getIsValueWrote
{
    // 書き込みに成功したかを返す.
    return _isValueWrote;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // BluetoothがOffならリターン.
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        return;
    }
}

- (void) scanNewDevice
{
    NSLog(@"call scanNewDevice");
    [_ccmCentralManager scanForPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:SERVICE_UUID], nil]
                                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
}

/**
 peripheralが見つかったら実行される
*/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"call didDiscoverPeriperal");
    // peripheralを発見したらscanを止める
    [_ccmCentralManager stopScan];
    // 未接続のPeripheralのみ追加.
    if (self.peripheral != peripheral)
    {
        self.peripheral = peripheral;
        // Peripheralに接続する.
        [_ccmCentralManager connectPeripheral:peripheral options:nil];
    }
}
/**
 Peripheralに接続されたら実行される
*/
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    // Serviceを探索する.
    [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
}

// 接続したPeripheralでServiceが見つかったら実行.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        // Errorならリターン.
        NSLog(@"Service Error: %@", [error localizedDescription]);
        return;
    }
    
    // Characteristicの探索.
    for (CBService *service in peripheral.services)
    {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHARACTERISTIC_UUID]] forService:service];
    }
}

/**
 見つかったServiceからCharacteristicが見つかったら実行.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        // Errorならリターン.
        NSLog(@"Characteristics Error: %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        // 見つかったCharacteristicからUUIDの合致しているものを検出.
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CHARACTERISTIC_UUID]])
        {
            _chrDiscoveredChacteristic = characteristic;
            // Peripheralで値が更新されたら、通知が届くようにする.
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

// 書き込みリクエストを送信して、返答があれば実行.
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    if (error)
    {
        NSLog(@"WriteValue Error: %@", [error localizedDescription]);
        _isValueWrote = NO;
    }
    else
    {
        _isValueWrote = YES;
    }
}

// Peripheralからデータ更新の通知が届いたら実行.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"UpdateValue Error: %@", [error localizedDescription]);
        return;
    }
    _strGotValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

// Peripheralとの接続が切れたら実行.
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // 接続したPeripheralを破棄してScanの再実行.
    self.peripheral = nil;
    [self scanNewDevice];
}
@end
