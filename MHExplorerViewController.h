#import "MHTableViewController.h"
#import "MHSDKInstallerController.h"
#import "MHTableEntry.h"
#import "MHHeaderViewController.h"
#import "MHUtils.h"

@interface MHExplorerViewController : MHTableViewController
@property (nonatomic, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSURL *directoryURL;
-(void)loadEntries;
-(void)SDKWasInstalled;
-(id)initWithURL:(NSURL *)url;
@end
