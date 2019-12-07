#import "MHViewController.h"

@interface MHSDKInstallerController : MHViewController
@property (nonatomic, strong) NSData *sdkList;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIView *installSDKs;
@property (nonatomic, strong) NSMutableArray *possibleSDKViews;
@property (nonatomic, strong) NSMutableArray *possibleSDKs;
-(void)downloadSDKList;
@end