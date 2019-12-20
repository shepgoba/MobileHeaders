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
        [self indexSDKHeaders];
    }
}
- (void)indexSDKHeaders {
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSString *urlString = [MHUtils URLForDocumentsResource:@"HeaderData"];
    NSDirectoryEnumerator *enumerator = [fileManager
        enumeratorAtURL:[NSURL URLWithString:urlString]
        includingPropertiesForKeys:keys
        options:0
        errorHandler:nil];

    for (NSURL *url in enumerator) { 
        NSError *error;
        NSNumber *isDirectory = nil;
        if (![url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
			UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Files could not be searched. Try again" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
			[errorAlert addAction:defaultAction];
			[self presentViewController:errorAlert animated:YES completion:nil];
        } else if (![isDirectory boolValue]) {
            //NSString *fileName = url.absoluteString.lastPathComponent;
            NSString *path = url.absoluteString;
            NSUInteger index = [path rangeOfString:@"HeaderData"].location;
            NSString *finalPath = [path substringFromIndex:index];
            [files addObject:finalPath];
        }
    }
    [files writeToFile:[MHUtils URLForDocumentsResource:@"indexedFiles.dat"] atomically:NO];
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
    if (self.darkModeSwitch.isOn)
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    else
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];
}
@end