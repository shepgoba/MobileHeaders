#import "MHSDKInstallEntry.h"

@class MHSDKInstallerController;

@interface MHSDKInstallableView : UIView
@property (nonatomic, strong) MHSDKInstallEntry *entry;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *installedLabel;
@property (nonatomic, strong) UISwitch *shouldInstallSwitch;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, weak) MHSDKInstallerController *controller;
-(id)initWithEntry:(MHSDKInstallEntry *)entry controller:(MHSDKInstallerController *)controller;
-(void)setupProgressBar;
-(void)switchValueChanged;
-(void)setup;
-(void)updateForDecompression;
-(void)installFinished;
-(void)setupInstalled;
-(void)uninstallFinished;
@end