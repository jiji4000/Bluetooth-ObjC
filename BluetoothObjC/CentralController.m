#import "CentralController.h"
@import CoreBluetooth;

#define CHARACTERISTIC_UUID @"7F855F82-9378-4508-A3D2-CD989104AF22"
#define SERVICE_UUID @"2B1DA6DE-9C29-4D6C-A930-B990EA2F12BB"

@interface CentralController()
@property (strong, nonatomic) CBCentralManager      *ccmCentralManager;
@property (strong, nonatomic) CBPeripheral          *prpDiscovered;
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
- (void)sendValue:(int)intSendValue
{
    // Peripheralへの書き込みリクエスト.
    _mdtSendValue = (NSMutableData *)[[NSString stringWithFormat:@"%d", intSendValue] dataUsingEncoding:NSUTF8StringEncoding];
    [_prpDiscovered writeValue:_mdtSendValue forCharacteristic:_chrDiscoveredChacteristic type:CBCharacteristicWriteWithResponse];
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
    [self scanNewDevice];
}
- (void) scanNewDevice
{
    // Scanの開始. 重複したAdvertisingを受け取らないようにする.
    //[_ccmCentralManager scanForPeripheralsWithServices:@CBUUID UUIDWithString:SERVICE_UUID
      //                                         options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];

    // clash I don't know why
//    [_ccmCentralManager scanForPeripheralsWithServices:[CBUUID UUIDWithNSUUID:SERVICE_UUID]
//                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];

    [_ccmCentralManager scanForPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:SERVICE_UUID], nil]
                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO}];
 
}
// Peripheralが見つかったら実行.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // 未接続のPeripheralのみ追加.
    if (_prpDiscovered != peripheral)
    {
        _prpDiscovered = peripheral;
        // Peripheralに接続する.
        [_ccmCentralManager connectPeripheral:peripheral options:nil];
    }
}
// Peripheralに接続されたら実行.
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    // 接続されたらScanをストップ.
    [_ccmCentralManager stopScan];
    
    peripheral.delegate = self;
    
    // Serviceを探索する.
    //[peripheral discoverServices:@CBUUID UUIDWithString:SERVICE_UUID];
    [peripheral discoverServices:[CBUUID UUIDWithString:SERVICE_UUID]];
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
        //[peripheral discoverCharacteristics:@CBUUID UUIDWithString:CHARACTERISTIC_UUID forService:service];
        [peripheral discoverCharacteristics:[CBUUID UUIDWithString:CHARACTERISTIC_UUID] forService:service];
    }
}
// 見つかったServiceからCharacteristicが見つかったら実行.
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
    _prpDiscovered = nil;
    [self scanNewDevice];
}
@end
