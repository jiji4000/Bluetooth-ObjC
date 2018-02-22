#import "CentralViewController.h"
#import "CentralController.h"

@interface CentralViewController ()
@property (strong, nonatomic) CentralController     *ctrCentral;
@property (strong, nonatomic) NSTimer               *tmrUpdateText;
@property (nonatomic) NSString                      *sendValue;

@end

@implementation CentralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ctrCentral = [[CentralController alloc] init];
    [_ctrCentral initCentralController];
    
    _inputField.delegate = self;
    [_inputField setPlaceholder:@"input message"];
    
    // タイマーの起動.
    [self startUpdateTextTimer];
    
    // add observer for keyboard show or hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardWillHideNotification object: nil];
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
    // Pereralから取得した値
    _periperalMessageLabel.text = [_ctrCentral getPeripheralValue];
}

- (void)stopUpdateLabelTimer
{
    if(_tmrUpdateText)
    {
        [_tmrUpdateText invalidate];
        _tmrUpdateText = nil;
    }
}

- (void)keyboardWillBeShown:(NSNotification*)notification {
    CGRect keyboardScreenEndFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize myBoundSize = [[UIScreen mainScreen]bounds].size;
    CGFloat txtLimit = _inputField.frame.origin.y + _inputField.frame.size.height;
    CGFloat kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height;
    if (txtLimit >= kbdLimit) {
        _scrollView.contentOffset = CGPointMake(0,txtLimit - kbdLimit);
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    _scrollView.contentOffset = CGPointMake(0,0);
}

- (IBAction)touchSend:(id)sender {
    _sendValue = [_inputField text];
    [_ctrCentral sendValue:_sendValue];
}

- (IBAction)search:(id)sender {
    [_ctrCentral scanNewDevice];
}


- (IBAction)editEnd:(id)sender {
}

# pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_inputField resignFirstResponder];
    return YES;
}

@end
