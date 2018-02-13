#import "PeripheralViewController.h"
#import "PeripheralController.h"

@interface PeripheralViewController ()
@property (strong, nonatomic) PeripheralController  *ctrPeripheral;
@property (strong, nonatomic) NSTimer               *tmrUpdateText;
@property (strong, nonatomic) NSTimer               *tmrSendValue;
@property (nonatomic) int                           intSendValue;
@end
@implementation PeripheralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ctrPeripheral = [[PeripheralController alloc] init];
}

- (void)startUpdateTextTimer
{
    // 0.05秒ごとにCentralから取得した値を更新.
    _tmrUpdateText = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateText:) userInfo:nil repeats:YES];
}

- (void)prepareBluetooth{
    [_ctrPeripheral initPeripheralController:self];
    // タイマーの起動.
    [self startUpdateTextTimer];
    [self startSendValueTimer];
}

-(void)setStateLabelText:(NSString*)text{
    [_stateLabel setText:text];
}

- (void)updateText:(NSTimer *)timer
{
    // Centralから取得した値をTextFieldに入れる.
    //.stringValue = [_ctrPeripheral getCentralValue];
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

#pragma UITableView

/**
    section number
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// cell size
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_ctrPeripheral getCentralDevices]count];
}

/**
    instanciate tableview cell
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // tableCell の ID で UITableViewCell のインスタンスを生成
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centralCell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"centralCell"];
    }
    // 
    UILabel *label1 = (UILabel *)[cell viewWithTag:1];
    label1.text = [NSString stringWithFormat:@"No.%d",(int)(indexPath.row+1)];
    
    return cell;
}

- (IBAction)touchAdvertiseBtn:(id)sender {
    [self prepareBluetooth];
}
@end
