#import <UIKit/UIKit.h>

@interface PeripheralViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *advertiseBtn;
- (IBAction)touchAdvertiseBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

-(void)setStateLabelText:(NSString*)text;

@end

