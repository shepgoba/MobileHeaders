#import "MHViewController.h"
#import "MHSDKInstallerController.h"
#import "MHTableEntry.h"
#import "MHHeaderViewController.h"

@interface MHRootViewController : MHViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSURL *directoryURL;
-(void)loadEntries;
-(id)initWithURL:(NSURL *)url;
@end
