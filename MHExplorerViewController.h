#import "MHTableViewController.h"
#import "MHSDKInstallerController.h"
#import "MHTableEntry.h"
#import "MHHeaderViewController.h"
#import "MHUtils.h"

@interface MHExplorerViewController : MHTableViewController <UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSArray *filteredEntries;
@property (nonatomic, strong) NSURL *directoryURL;
@property (nonatomic, strong) UISearchController *searchController;
-(void)loadEntries;
-(void)SDKWasInstalled;
-(id)initWithURL:(NSURL *)url;
@end
