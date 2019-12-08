#import "MHViewController.h"
#import "MHSDKInstallableView.h"
#import "MHSDKInstallEntry.h"
#import "MHSDKConfirmInstallView.h"
#import "MHUtils.h"

@interface MHSDKInstallerController : MHViewController <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSDictionary *SDKList;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installContainerView;
@property (nonatomic, strong) UIScrollView *installScrollView;
@property (nonatomic, strong) UIView *confirmInstallButton;
@property (nonatomic, strong) NSMutableArray *installableSDKEntries;
@property (nonatomic, strong) NSMutableArray *installableSDKViews;
@property (nonatomic, strong) UIProgressView *progressBar;
-(NSArray *)allEntriesToDownload;
-(void)downloadSDKListIfNecessary;
-(void)downloadSDKList;
-(void)updateSDKViews;
-(void)installSelectedSDKs;
@end