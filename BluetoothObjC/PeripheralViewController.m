#import "PeripheralViewController.h"
#import "PeripheralController.h"

@interface PeripheralViewController ()
//@property (weak) IBOutlet NSWindow *window;
//@property (weak) IBOutlet NSTextField               *txtGotValue;
//@property (weak) IBOutlet NSTextField               *txtSendValue;
//@property (weak) IBOutlet NSButton                  *btnStop;
@property (strong, nonatomic) PeripheralController  *ctrPeripheral;
@property (strong, nonatomic) NSTimer               *tmrUpdateText;
@property (strong, nonatomic) NSTimer               *tmrSendValue;
@property (nonatomic) int                           intSendValue;
@end
@implementation PeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ctrPeripheral = [[PeripheralController alloc] init];
    // Bluetoothの使用準備. PeripheralManagerの初期化.
    [_ctrPeripheral initPeripheralController];
    
    // タイマーの起動.
    [self startUpdateTextTimer];
    [self startSendValueTimer];
}


- (void)startUpdateTextTimer
{
    // 0.05秒ごとにCentralから取得した値を更新.
    _tmrUpdateText = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateText:) userInfo:nil repeats:YES];
}
- (void)updateText:(NSTimer *)timer
{
    // Centralから取得した値をTextFieldに入れる.
    //.stringValue = [_ctrPeripheral getCentralValue];
    [_timeLabel setText:[_ctrPeripheral getCentralValue]];
}

- (void)stopUpdateLabelTimer
{
    if(_tmrUpdateText)
    {
        [_tmrUpdateText invalidate];
        _tmrUpdateText = nil;
    }
}
- (void)startSendValueTimer
{
    // Centralに送信する値の更新は1秒ごとに実行.
    _tmrSendValue = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendValue:) userInfo:nil repeats:YES];
}

- (void)sendValue:(NSTimer *)timer
{
    // 999までの乱数をCentralに送信する.
    _intSendValue = (int)arc4random_uniform(999);
    [_ctrPeripheral updatePeripheralValue:_intSendValue];
    
    [_sendVlewLabel setText:[NSString stringWithFormat:@"%d", _intSendValue]];
}
- (void)stopSendValueTimer
{
    if(_tmrSendValue)
    {
        [_tmrSendValue invalidate];
        _tmrSendValue = nil;
    }
}

- (IBAction)BtnAction:(id)sender {
    [self stopUpdateLabelTimer];
    [self stopSendValueTimer];
    [_ctrPeripheral close];
}
@end
