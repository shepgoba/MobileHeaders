#import "MHSettingsViewController.h"
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = self.entries[indexPath.row];
    if (self.darkTheme) {
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.row == 0) {
        cell.accessoryView = self.darkModeSwitch;
    } else if (indexPath.row == 1) {
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
    self.entries = [NSMutableArray arrayWithObjects: @"Dark Theme", @"Manage Installed SDKs", nil];

   
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.alwaysBounceVertical = NO;

    self.darkModeSwitch = [[UISwitch alloc] init];
    self.darkModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkModeEnabled"];
    [self.darkModeSwitch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.tableView];

    [self.tableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [NSLayoutConstraint constraintWithItem:self.tableView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self.view  
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1.f
                                        constant:100.f].active = YES;

    [NSLayoutConstraint constraintWithItem:self.tableView
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view  
                                    attribute:NSLayoutAttributeWidth
                                    multiplier:1.0f
                                    constant:0.f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.tableView
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self.view  
                                    attribute:NSLayoutAttributeHeight
                                    multiplier:0.33f
                                    constant:0.f].active = YES;
}
- (void) switchValueChanged {
    [[NSUserDefaults standardUserDefaults] setBool:self.darkModeSwitch.isOn forKey:@"darkModeEnabled"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MHThemeDidChange" object:nil];
}
@end