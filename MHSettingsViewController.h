#import "MHSDKInstallerController.h"
#import "MHTableViewController.h"

@interface MHSettingsViewController : MHTableViewController
@property (nonatomic, assign, readonly) int settingsCellCount;
@property (nonatomic, strong, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) UISwitch *darkModeSwitch;
-(void)switchValueChanged;
-(void)indexSDKHeaders;
@end