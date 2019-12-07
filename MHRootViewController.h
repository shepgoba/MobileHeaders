#import "MHViewController.h"
#import "MHSDKInstallerController.h"

@interface MHRootViewController : MHViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *entries;
@end
