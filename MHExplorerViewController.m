#import "MHExplorerViewController.h"

@implementation MHExplorerViewController 
-(id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		self.title = @"Home";
		_cellIdentifier = @"MHCell";
		if (!url) {
			self.directoryURL = [NSURL URLWithString:[MHUtils URLForDocumentsResource:@"Data"]];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SDKWasInstalled) name:@"MHThemeDidChange" object:nil];
			[[NSFileManager defaultManager] createDirectoryAtPath:[self.directoryURL absoluteString] withIntermediateDirectories:YES attributes:nil error:nil];
		} else {
			self.directoryURL = url;
		}
	}
	return self;
}
-(void)SDKWasInstalled {
	[self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.entries.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	MHTableEntry *currentObject = [self.entries objectAtIndex:indexPath.row];
	if (currentObject.isDirectory) {
		MHExplorerViewController *newViewController = [[MHExplorerViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: newViewController animated:YES];
	} else {
		MHHeaderViewController *headerViewController = [[MHHeaderViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: headerViewController animated:YES];
	}

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MHTableEntry *entry = self.entries[indexPath.row];
	cell.textLabel.text = entry.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentifier];
	}
	if (self.darkTheme) {
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
       cell.textLabel.textColor = [UIColor blackColor];
	}
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}
-(void)loadEntries {
	self.entries = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSMutableArray *URLs = [[fileManager contentsOfDirectoryAtURL:self.directoryURL
								includingPropertiesForKeys:properties
                   				options:(NSDirectoryEnumerationSkipsPackageDescendants)
                   				error:&error] mutableCopy];
	for (NSURL *url in URLs) {
		MHTableEntry *fileObject = [[MHTableEntry alloc] initWithURL:url];
		[self.entries addObject:fileObject];
	}
}
-(void)setup {
	[self loadEntries];
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	[self.view addSubview:self.tableView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self setup];
}
@end
