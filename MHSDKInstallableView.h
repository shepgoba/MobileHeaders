#import "MHSDKInstallEntry.h"
@interface MHSDKInstallableView : UIView
@property (nonatomic, strong) MHSDKInstallEntry *entry;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UISwitch *shouldInstallSwitch;
@property (nonatomic, strong) UIProgressView *progressBar;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
-(void)setupProgressBar;
-(void)switchValueChanged;
-(void)setup;
-(void)updateForDecompression;
@end