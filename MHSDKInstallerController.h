#import "MHViewController.h"

@interface MHSDKInstallerController : MHViewController
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installSDKs;
@property (nonatomic, strong) NSMutableArray *possibleSDKViews;
@property (nonatomic, strong) NSDictionary *SDKList;
-(void)downloadSDKList;
-(void)updateSDKViews;
@end