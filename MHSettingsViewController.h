#import "MHViewController.h"

@interface MHSettingsViewController : MHViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign, readonly) int settingsCellCount;
@property (nonatomic, strong, readonly) NSString *cellIdentifier;
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *darkModeSwitch;
-(void)switchValueChanged;
@end