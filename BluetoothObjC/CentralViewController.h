#import <UIKit/UIKit.h>

@interface CentralViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)touchSend:(id)sender;

@end

