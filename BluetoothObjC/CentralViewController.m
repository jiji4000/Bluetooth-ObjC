#import "CentralViewController.h"
#import "CentralController.h"

@interface CentralViewController ()
@property (strong, nonatomic) CentralController     *ctrCentral;
@property (strong, nonatomic) NSTimer               *tmrUpdateText;
@property (nonatomic) int                           intSendValue;

@end

@implementation CentralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ctrCentral = [[CentralController alloc] init];
    [_ctrCentral initCentralController];
    
    // タイマーの起動.
    [self startUpdateTextTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)startUpdateTextTimer
{
    // 0.05秒ごとにPeripheralから取得した値を更新.
    _tmrUpdateText = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(updateText:) userInfo:nil repeats:YES];
}
- (void)updateText:(NSTimer *)timer
{
    // Centralから取得した値をTextFieldに入れる.
    //_periperalMessageLabel.text = [_ctrCentral getPeripheralValue];
    
    // 書き込みリクエストの結果.
    if([_ctrCentral getIsValueWrote])
    {
        NSLog(@"YES");
    }
    else
    {
        NSLog(@"NO");
    }
}
- (void)stopUpdateLabelTimer
{
    if(_tmrUpdateText)
    {
        [_tmrUpdateText invalidate];
        _tmrUpdateText = nil;
    }
}


- (IBAction)touchSend:(id)sender {
    // ボタン押下で乱数をPeripheralに送信する.
    _intSendValue = (int)arc4random_uniform(999);
    //_sendLabel.text = [NSString stringWithFormat:@"%d", _intSendValue];
    [_ctrCentral sendValue:_intSendValue];
}

- (IBAction)search:(id)sender {
}
- (IBAction)editEnd:(id)sender {
}
@end
