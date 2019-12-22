#import "MHSearchViewController.h"

@implementation MHSearchViewController
/*
-(NSMutableArray *)contentsOfDirectory:(NSURL *)url {
    NSMutableArray *entries = [NSMutableArray new];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey, nil];
	NSError *error = nil;
	NSMutableArray *URLs = [[fileManager contentsOfDirectoryAtURL:url
								includingPropertiesForKeys:properties
                   				options:(NSDirectoryEnumerationSkipsPackageDescendants)
                   				error:&error] mutableCopy];
	for (NSURL *url in URLs) {
		MHTableEntry *fileObject = [[MHTableEntry alloc] initWithURL:url];
		[entries addObject:fileObject];
	}
	//NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
	//NSArray *entry = [entries sortedArrayUsingDescriptors:@[sortDescriptor]];
	return entries;
}
*/
-(void)themeDidChange {
	[super themeDidChange];
	self.searchController.searchBar.barStyle = self.darkTheme ? UIBarStyleBlack : UIBarStyleDefault;
}

- (NSMutableArray *)searchForFilesInIndexedList:(NSString *)query {
	NSMutableArray *filteredEntries = [[NSMutableArray alloc] init];
	NSArray *entries = [NSArray arrayWithContentsOfFile:[MHUtils URLForDocumentsResource:@"indexedFiles.dat"]];

	for (NSString *file in entries) {
		NSString *fileName = file.lastPathComponent;
		if ([fileName.lowercaseString hasPrefix: query.lowercaseString]) {
				NSURL *fileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [MHUtils URLForDocumentsResource:@""], file]];
                MHTableEntry *entry = [[MHTableEntry alloc] initWithURL:fileURL];
                [filteredEntries addObject: entry];
        }
	}
	return filteredEntries;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.entries.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	MHTableEntry *entry = self.entries[indexPath.row];
	cell.textLabel.text = entry.name;
    cell.detailTextLabel.text = entry.extraInfo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
	if (!cell || !cell.detailTextLabel) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellIdentifier];
	}
	if (self.darkTheme) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    } else {
       cell.textLabel.textColor = [UIColor blackColor];
       cell.detailTextLabel.textColor = [UIColor blackColor];
	}
	cell.backgroundColor = [UIColor clearColor];
	return cell;
}
- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
	[self.searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString *searchText = searchBar.text;
	if (searchText && searchText.length > 0) {
		//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
		//NSArray *newEntries = [self.entries filteredArrayUsingPredicate:predicate];
		NSArray *entries = [self searchForFilesInIndexedList:searchText];
		NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
		self.entries = [entries sortedArrayUsingDescriptors:@[sortDescriptor]];
	} else {
        self.entries = nil;
    }
	[self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.searchController resignFirstResponder];
	MHTableEntry *currentObject = [self.entries objectAtIndex:indexPath.row];
	if (currentObject.isDirectory) {
		//MHExplorerViewController *newViewController = [[MHExplorerViewController alloc] initWithURL:currentObject.url];
		//[self.navigationController pushViewController: newViewController animated:YES];
	} else {
		MHHeaderViewController *headerViewController = [[MHHeaderViewController alloc] initWithURL:currentObject.url];
		[self.navigationController pushViewController: headerViewController animated:YES];
	}

}

- (void)didPresentSearchController:(UISearchController *)searchController {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:YES animated:YES];
	});
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.entries = nil;
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.searchController.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchController setActive:NO];
    });
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
    _cellIdentifier = @"SearchCells";

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.indicatorStyle = self.darkTheme ? UIScrollViewIndicatorStyleWhite : UIScrollViewIndicatorStyleBlack;
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;

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
@end