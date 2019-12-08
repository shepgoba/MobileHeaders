#import "MHSDKInstallEntry.h"
@interface MHSDKInstallableView : UIView
@property (nonatomic, strong) MHSDKInstallEntry *entry;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UISwitch *shouldInstallSwitch;
-(id)initWithEntry:(MHSDKInstallEntry *)entry;
-(void)switchValueChanged;
-(void)setup;
@end