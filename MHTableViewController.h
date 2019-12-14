#import "MHViewController.h"

@interface MHTableViewController : MHViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end