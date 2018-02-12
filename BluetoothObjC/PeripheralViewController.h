#import <UIKit/UIKit.h>

@interface PeripheralViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *sendVlewLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *Btn;

- (IBAction)BtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

