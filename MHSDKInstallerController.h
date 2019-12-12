#import "MHViewController.h"
#import "MHSDKInstallableView.h"
#import "MHSDKInstallEntry.h"
#import "MHSDKConfirmInstallView.h"
#import "MHSDKInstallTaskDelegate.h"
#import "MHUtils.h"

#import <LzmaSDKObjC/LzmaSDKObjCReader.h>

@interface MHSDKInstallerController : MHViewController
@property (nonatomic, strong) NSDictionary *SDKList;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installContainerView;
@property (nonatomic, strong) UIScrollView *installScrollView;
@property (nonatomic, strong) MHSDKConfirmInstallView *confirmInstallButton;
@property (nonatomic, strong) NSMutableArray *installableSDKEntries;
@property (nonatomic, strong) NSMutableArray *installableSDKViews;
@property (nonatomic, strong) NSArray *allEntriesToDownload;
@property (nonatomic, strong) NSMutableArray *installTasks;
-(void)decompressFiles;
-(void)findAllEntriesToDownload;
-(void)downloadSDKListIfNecessary;
-(void)downloadSDKList;
-(void)updateSDKViews;
-(void)confirmInstallSelectedSDKs;
-(void)installSelectedSDKs;
@end