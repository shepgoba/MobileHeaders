#import "MHViewController.h"
#import "MHSDKInstallableView.h"
#import "MHSDKInstallEntry.h"
@interface MHSDKInstallerController : MHViewController
@property (nonatomic, strong) NSDictionary *SDKList;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installContainerView;
@property (nonatomic, strong) UIScrollView *installScrollView;
@property (nonatomic, strong) NSMutableArray *installableSDKEntries;
@property (nonatomic, strong) NSMutableArray *installableSDKViews;
-(void)downloadSDKListIfNecessary;
-(void)updateSDKViews;
@end