#import "MHViewController.h"
#import "MHSDKInstallableView.h"
#import "MHSDKInstallEntry.h"
#import "MHSDKConfirmInstallView.h"
#import "MHUtils.h"

#import "src/LzmaSDKObjCReader.h"

@interface MHSDKInstallerController : MHViewController <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSDictionary *SDKList;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installContainerView;
@property (nonatomic, strong) UIScrollView *installScrollView;
@property (nonatomic, strong) MHSDKConfirmInstallView *confirmInstallButton;
@property (nonatomic, strong) NSMutableArray *installableSDKEntries;
@property (nonatomic, strong) NSMutableArray *installableSDKViews;
@property (nonatomic, strong) NSMutableArray *allFilesToDecompress;
@property (nonatomic, strong) NSArray *allEntriesToDownload;
-(void)decompressFiles;
-(void)findAllEntriesToDownload;
-(void)downloadSDKListIfNecessary;
-(void)downloadSDKList;
-(void)updateSDKViews;
-(void)confirmInstallSelectedSDKs;
-(void)installSelectedSDKs;
@end