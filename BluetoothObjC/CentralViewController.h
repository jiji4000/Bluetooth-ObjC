#import <UIKit/UIKit.h>

@interface CentralViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *periperalMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)touchSend:(id)sender;
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *inputField;
- (IBAction)editEnd:(id)sender;

@end

