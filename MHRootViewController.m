#import "MHRootViewController.h"

@implementation MHRootViewController 
-(id)init {
	if ((self = [super init])) {
		_cellIdentifier = @"MHCell";
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.entries.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = self.entries[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
	}
	return cell;
}

-(void)setup {
	self.entries = [NSMutableArray arrayWithObjects:@"cummy",nil];
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	[self.view addSubview:self.tableView];

	/*MHSDKInstallerController *installerController = [[MHSDKInstallerController alloc] init];
	[self.navigationController pushViewController:installerController animated:YES];*/
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self setup];
}
@end
