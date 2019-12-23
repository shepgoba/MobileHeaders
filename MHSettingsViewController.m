#import "MHSettingsViewController.h"
#define ALERT(str) [[[UIAlertView alloc] initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show]
@implementation MHSettingsViewController
-(id)init {
    if ((self = [super init])) {
        _cellIdentifier = @"SettingsCell";
        _settingsCellCount = 3;
        self.title = @"Settings";
    }
    return self;
}

-(void) themeDidChange {
    [super themeDidChange];
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entries count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.row == 1) {
		MHSDKInstallerController *installerController = [[MHSDKInstallerController alloc] init];
		[self.navigationController pushViewController: installerController animated:YES];
    }
    if (indexPath.row == 2) {
        [MHUtils indexHeadersAndPresentAlertOn:self];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = self.entries[indexPath.row];
    if (self.darkTheme) {
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.row == 0) {
        cell.accessoryView = self.darkModeSwitch;
    } else if (indexPath.row == 1 || indexPath.row == 2) {
        cell.textLabel.textColor = self.view.tintColor;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
	}
    cell.backgroundColor = [UIColor clearColor];
	return cell;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.entries = [NSMutableArray arrayWithObjects: @"Dark Theme", @"Manage Installed SDKs", @"Index Headers", nil];

   
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.alwaysBounceVertical = NO;

    self.darkModeSwitch = [[UISwitch alloc] init];
    self.darkModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"];
    [self.darkModeSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    if (@available(iOS 11, *)) {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        [self.tableView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [self.tableView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [self.tableView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [self.tableView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    } else {
        UILayoutGuide *margins = self.view.layoutMarginsGuide;
        [self.tableView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
        [self.tableView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
        [self.tableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    }

}
- (void) switchValueChanged {
    [[NSUserDefaults standardUserDefaults] setBool:self.darkModeSwitch.isOn forKey:@"darkModeEnabled"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHThemeDidChange" object:nil];
    if (self.darkModeSwitch.isOn)
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    else
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];
}
@end