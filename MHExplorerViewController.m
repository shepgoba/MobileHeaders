#import "MHExplorerViewController.h"

@implementation MHExplorerViewController 
-(id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_cellIdentifier = @"MHCell";
		if (!url) {
			self.title = @"Home";
			self.directoryURL = [NSURL URLWithString:[MHUtils URLForDocumentsResource:@"HeaderData"]];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SDKWasInstalled) name:@"MHSDKWasInstalled" object:nil];
			[[NSFileManager defaultManager] createDirectoryAtPath:[self.directoryURL absoluteString] withIntermediateDirectories:YES attributes:nil error:nil];
		} else {
			self.directoryURL = url;
			self.title = self.directoryURL.absoluteString.lastPathComponent;
		}
	}
	return self;
}

-(void)themeDidChange {
	[super themeDidChange];
	self.searchController.searchBar.barStyle = self.darkTheme ? UIBarStyleBlack : UIBarStyleDefault;
}

-(void)SDKWasInstalled {
	[self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.filteredEntries.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.searchController resignFirstResponder];
	MHTableEntry *currentObject = [self.filteredEntries objectAtIndex:indexPath.row];
	if (currentObject.isDirectory) {
		MHExplorerViewController *newViewController = [[MHExplorerViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: newViewController animated:YES];
	} else {
		MHHeaderViewController *headerViewController = [[MHHeaderViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: headerViewController animated:YES];
	}

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MHTableEntry *entry = self.filteredEntries[indexPath.row];
	cell.textLabel.text = entry.name;
	/*if ([entry.name.pathExtension isEqual: @"framework"]) {
		UIImage *frameworkImage = [UIImage imageWithContentsOfFile:[MHUtils URLForBundleResource:@"framework.png"]];
		cell.imageView.image = [UIImage imageWithCGImage:frameworkImage.CGImage scale:frameworkImage.size.width/40 orientation:frameworkImage.imageOrientation];
	} else {
		cell.imageView.image = nil;
	}*/
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
	NSMutableArray *entries = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSMutableArray *URLs = [[fileManager contentsOfDirectoryAtURL:self.directoryURL
								includingPropertiesForKeys:properties
                   				options:(NSDirectoryEnumerationSkipsPackageDescendants)
                   				error:&error] mutableCopy];
	for (NSURL *url in URLs) {
		MHTableEntry *fileObject = [[MHTableEntry alloc] initWithURL:url];
		if ([fileObject.name isEqual: @".DS_Store"] || [fileObject.name isEqual: @".gitignore"])
			continue;
		[entries addObject:fileObject];
	}
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	NSArray *entry = [entries sortedArrayUsingDescriptors:@[sortDescriptor]];
	self.entries = entry;
}
-(void)setup {
	[self loadEntries];
	self.filteredEntries = [self.entries mutableCopy];
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.indicatorStyle = self.darkTheme ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack;

	[self.view addSubview:self.tableView];

	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.delegate = self;
	self.searchController.searchBar.barStyle = self.darkTheme ? UIBarStyleBlack : UIBarStyleDefault;
	self.searchController.searchResultsUpdater = self;
	self.searchController.hidesNavigationBarDuringPresentation = NO;
	self.searchController.definesPresentationContext = YES;
	self.searchController.dimsBackgroundDuringPresentation = NO;
	self.searchController.searchBar.delegate = self;

	self.tableView.tableHeaderView = self.searchController.searchBar;
}
- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
	[self.searchController dismissViewControllerAnimated:YES completion:nil];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	NSString *searchText = searchController.searchBar.text;
	if (searchText && searchText.length > 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
		NSArray *newEntries = [self.entries filteredArrayUsingPredicate:predicate];
		self.filteredEntries = newEntries;
	} else {
        self.filteredEntries = self.entries;
    }
	[self.tableView reloadData];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:YES animated:YES];
	});
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchController setActive:NO];
    });
}

-(void)viewDidLoad {
	[super viewDidLoad];
	[self setup];
}
@end
