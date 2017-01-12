#import <UIKit/UIKit.h>

@interface PeripheralViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sendVlewLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *Btn;

- (IBAction)BtnAction:(id)sender;



@end

